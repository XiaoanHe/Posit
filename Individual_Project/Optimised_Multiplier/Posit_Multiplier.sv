/////////////////////////////////////////////////////////////////////
// Design unit: Posit Multiplier
//            :
// File name  : Posit_Multiplier.sv
//            :
// Description: 
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan(Jasper) He 
//            : xh2g20@soton.ac.uk
//
// Revision   : Version 1.1 21/02/2023
/////////////////////////////////////////////////////////////////////
timeunit 1ns; timeprecision 1ps;
module Posit_Multiplier #(parameter N = 8, parameter ES = 3, parameter RS = $clog2(N)) 
(
    input logic signed[N-1:0] IN1, IN2,
    output logic signed[N-1:0] OUT
);
logic inf1, inf2, zero1, zero2, inf, zero;
logic Sign1, Sign2;
logic signed [N-2:0] InRemain1, InRemain2;
logic signed [RS+1:0] RegimeValue1,RegimeValue2;
logic [ES-1:0] Exponent1, Exponent2;
logic [N-1:0] Mantissa1, Mantissa2;

Data_Extraction #(.N(N), .ES(ES)) Extract_IN1 (.In(IN1), .Sign(Sign1), .RegimeValue(RegimeValue1), .Exponent(Exponent1), .Mantissa(Mantissa1), .InRemain(InRemain1), .inf(inf1), .zero(zero1));
Data_Extraction #(.N(N), .ES(ES)) Extract_IN2 (.In(IN2), .Sign(Sign2), .RegimeValue(RegimeValue2), .Exponent(Exponent2), .Mantissa(Mantissa2), .InRemain(InRemain2), .inf(inf2), .zero(zero2));

/*  the output of multipilcation between 2 N-bit inputs is 2N bit long
    '+1' is used for overflow check
*/
logic Operation;
logic [2*N-1:0] Mult_Mant;
logic [2*N-1:0] Mult_Mant_N;
logic Mant_mult_Ovf;

logic [RS+ES+1:0]Total_EO, Total_EON;
logic [ES-1:0] E_O;
logic signed [RS:0] R_O;

// logic [(2*N-1)+3:0] tmp_o;
logic [(N+ES+2*N+3)-1:0] tmp_o;
// logic [(3*N-1)+3:0] sft_tmp_o;
logic [(N+N+ES+2*N+3)-1:0] sft_tmp_o;

logic L,G,R,S,ulp;

logic [N-1:0] rnd_ulp; 
logic [N:0] sft_tmp_o_rnd_ulp;
logic [N-1:0] sft_tmp_o_rnd;
logic [N-1:0] sft_tmp_oN;

always_comb
begin
    //  check infinity and zero
    inf = inf1 | inf2;
	zero = zero1 | zero2;

    Operation = Sign1 ^ Sign2;
    //  Mantissa Multiplication Handling
    Mult_Mant = Mantissa1 * Mantissa2;
    Mant_mult_Ovf = Mult_Mant[2*N-1];
    Mult_Mant_N = Mant_mult_Ovf ? Mult_Mant : (Mult_Mant << 1);

    //  Exponent Handling

    /*
        for multiplication, the total exponent is the sum of 
        the respective total exponent of each input
    */

    Total_EO = {RegimeValue1,Exponent1} + {RegimeValue2, Exponent2} + Mant_mult_Ovf; 

    Total_EON =  Total_EO[RS+ES+1] ? (-Total_EO) : Total_EO;

    E_O = Total_EO[ES-1:0];

    R_O = (~Total_EO[ES+RS+1'b1] || |(Total_EON[ES-1:0])) ? Total_EON[ES+RS:ES] + 1'b1 : Total_EON[ES+RS:ES];

    tmp_o = {{N{~Total_EO[ES+RS+1]}}, Total_EO[ES+RS+1], E_O, Mult_Mant_N[2*N-2:0], 3'b0};
    sft_tmp_o = {tmp_o, {N{1'b0}}};
    
    if (R_O[RS])
        sft_tmp_o = sft_tmp_o >> {RS{1'b1}};
    else
        sft_tmp_o = sft_tmp_o >> R_O; 

    L = sft_tmp_o[N+4 + (N+4)]; 
    G = sft_tmp_o[N+3 + (N+4)]; 
    R = sft_tmp_o[N+2 + (N+4)]; 
    S = |sft_tmp_o[N+1 + (N+4) :0];
    ulp = ((G & (R | S)) | (L & G & ~(R | S)));

    rnd_ulp= {{N-1{1'b0}},ulp};

    
    sft_tmp_o_rnd_ulp = sft_tmp_o[2*N-1+3 + (N+4):N+3+(N+4)] + rnd_ulp;

    
    sft_tmp_o_rnd = (R_O < N-ES-2) ? sft_tmp_o_rnd_ulp[N-1:0] : sft_tmp_o[2*N-1+3+(N+4):N+3+(N+4)];


    //Final Output
    
    sft_tmp_oN = Operation ? -sft_tmp_o_rnd : sft_tmp_o_rnd;
    OUT = inf|zero ? {inf,{N-1{1'b0}}} : {Operation, sft_tmp_oN[N-1:1]};
    //OUT = {Operation, sft_tmp_oN[N-1:1]};
end
endmodule