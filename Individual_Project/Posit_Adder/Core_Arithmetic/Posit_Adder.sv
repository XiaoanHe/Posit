/////////////////////////////////////////////////////////////////////
// Design unit: Posit Adder Arithmetic
//            :
// File name  : Posit_Adder_Arithmetic.sv
//            :
// Description: Mantissa addition and subtraction
//            : exponent and regime computation
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan(Jasper) He 
//            : xh2g20@soton.ac.uk
//
// Revision   : Version 2 21/02/2023
/////////////////////////////////////////////////////////////////////
timeunit 1ns; timeprecision 1ps;
module Posit_Adder #(parameter N = 8, parameter ES = 3, parameter RS = $clog2(N)) 
(
    input logic[N-1:0] IN1, IN2,
    output logic [N-1:0] OUT
);

logic Sign1, Sign2;
logic signed [N-2:0] InRemain1, InRemain2;
logic signed [RS:0] RegimeValue1,RegimeValue2;
logic [ES-1:0] Exponent1, Exponent2;
logic [N-ES+2:0] Mantissa1, Mantissa2;

Data_Extraction #(.N(N), .ES(ES)) Extract_IN1 (.In(IN1), .Sign(Sign1), .RegimeValue(RegimeValue1), .Exponent(Exponent1), .Mantissa(Mantissa1), .InRemain(InRemain1), .inf(inf1), .zero(zero1));
Data_Extraction #(.N(N), .ES(ES)) Extract_IN2 (.In(IN2), .Sign(Sign2), .RegimeValue(RegimeValue2), .Exponent(Exponent2), .Mantissa(Mantissa2), .InRemain(InRemain2), .inf(inf2), .zero(zero2));

logic inf, zero;
logic Operation;
// components to corresponding logic, L - Large S - Small
logic signed [N-2:0] LIn, SIn;
logic LS, SS;
logic [RS:0] LR, SR;
logic LRC, SRC;
logic [ES-1:0]LE, SE;
logic [N-1:0]LM, SM, SM_tmp;

logic [N-1:0] E_diff;
logic [N:0] Add_Mant;
logic [N-1:0] Add_Mant_sft, Add_Mant_N;
logic [N-1:0] LBD_in;
logic signed [ES+RS:0] LE_O;
logic [ES-1:0] E_O;
logic signed [RS:0] R_O;
logic Greater_Than;
logic signed [RS:0] R_diff;
logic Mant_Ovf;
logic signed [RS:0] shift;
logic [ES+RS:0] LE_ON;
logic [N-1:0] RegimeBits;

logic [(2*N-1)+3:0] tmp_o;
logic [(3*N-1)+3:0] sft_tmp_o;
logic L,G,R,S,ulp;
logic [N-1:0] rnd_ulp; 
logic [N:0] sft_tmp_o_rnd_ulp;
logic [N-1:0] sft_tmp_o_rnd;
logic [N-1:0] sft_tmp_oN;

Leading_Bit_Detector_8B #(.N(N), .ES(ES)) LBD_8B (.In(LBD_in), .EndPosition(shift));

always_comb
begin
    // check infinity and zero
    inf = inf1 | inf2;
	zero = zero1 & zero2;

    // Confirm the operation (s1 XNOR s2)
    Operation = Sign1 ~^ Sign2 ;

    // Find the greater InRemain
    Greater_Than = (InRemain1[N-2:0] >  InRemain2[N-2:0])? 1'b1 : 1'b0;

    // Assign components to corresponding logic, L - Large S - Small
    LIn = Greater_Than ? InRemain1 : InRemain2;
    LS = Greater_Than ? Sign1 : Sign2;
    LR = Greater_Than ? RegimeValue1 : RegimeValue2;
    LRC = Greater_Than? InRemain1[N-2] : InRemain2[N-2];
    LE = Greater_Than ? Exponent1 : Exponent2;
    LM = Greater_Than ? Mantissa1 : Mantissa2; // the first bit (0) is reserved for overflow detection
    
    SIn = Greater_Than ? InRemain2 : InRemain1;
    SS = Greater_Than ? Sign2 : Sign1;
    SR = Greater_Than ? RegimeValue2 : RegimeValue1;
    LRC = Greater_Than? InRemain2[N-2] : InRemain1[N-2];
    SE = Greater_Than ? Exponent2 : Exponent1;
    SM = Greater_Than ? Mantissa2 : Mantissa1;


    // Mantissa Addition
    R_diff = LR - SR;

    /*
    after the R_diff found, remember that the regime contributes into the exponent
    as (Useed ^ RegimeValue) where Useed = 2^(2^ES) 
    so the E_diff is (R_diff x log2(useed) + LE - SE)
    the reason why it is R_diff x log2(useed) is
    the exponent (2 ^ what)is what we want to find
    for exponent bits, it is the difference
    for regime bits, they are log2(Useed ^ RegimeValue) which is RegimeValue x (2^ES)
    */
    E_diff = (R_diff*(2**(ES))) + (LE - SE); 

    SM_tmp = SM >> E_diff;
    Add_Mant = Operation ?  LM + SM_tmp : LM - SM_tmp;
    
    // check for Mantissa Overflow
    Mant_Ovf = Add_Mant[N];
    //Add_Mant = Mant_Ovf ? Add_Mant : (Add_Mant << 1);

    /*
     In the case of subtraction between two close numbers
     some MSBs may lost, it is useful to detect the 
     Leading ONE and left shift accordingly
    */
    
        LBD_in = {{(Add_Mant[N] | Add_Mant[N-1]), Add_Mant[N-2:0]}};
        Add_Mant_sft = Add_Mant[N:1] << shift;
        Add_Mant_N = Add_Mant_sft[N-1] ? Add_Mant_sft[N-1:0] : {Add_Mant_sft[N-2:0],1'b0};

    // Compute regime and exponent of final result
    
    /* 
    The exponent is mainly based on the larger input
    taking overflow and left shift into account
    */
    LE_O = {LR, LE} + Mant_Ovf - shift;
    //LE_O = {LR, LE} + Mant_Ovf;
    LE_ON =  LE_O[RS+ES] ? (-LE_O) : LE_O;

    E_O = LE_O[ES-1:0];

    R_O = (~LE_O[ES+RS] || |(LE_ON[ES-1:0])) ? LE_ON[ES+RS-1:ES] + 1'b1 : LE_ON[ES+RS-1:ES];

 
    tmp_o = { {N{~LE_O[ES+RS]}}, LE_O[ES+RS], E_O, Add_Mant_N[N-2:ES], 3'b0 };
    sft_tmp_o = {tmp_o, {N{1'b0}}} ;
    sft_tmp_o = sft_tmp_o >> R_O;

    L = sft_tmp_o[N+4]; 
    G = sft_tmp_o[N+3]; 
    R = sft_tmp_o[N+2]; 
    S = |sft_tmp_o[N+1:0];
    ulp = ((G & (R | S)) | (L & G & ~(R | S)));
    
    rnd_ulp= {{N-1{1'b0}},ulp};

    
    sft_tmp_o_rnd_ulp = sft_tmp_o[2*N-1+3:N+3] + rnd_ulp;

    
    sft_tmp_o_rnd = (R_O < N-ES-2) ? sft_tmp_o_rnd_ulp[N-1:0] : sft_tmp_o[2*N-1+3:N+3];


    //Final Output
    
    sft_tmp_oN = LS ? -sft_tmp_o_rnd : sft_tmp_o_rnd;
    if (zero1)
        OUT = IN2;
    else if (zero2) 
        OUT = IN1;
    else if (inf1)          
        OUT = IN1;
    else if (inf2)             
        OUT = IN2;
    else if (IN1 == -IN2)
        OUT = {(N-1){1'b0}};
    else
        OUT = {LS, sft_tmp_oN[N-1:1]};

end
endmodule