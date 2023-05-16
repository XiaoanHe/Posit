/////////////////////////////////////////////////////////////////////
// Design unit: Posit Adder Arithmetic
//            :
// File name  : Posit_Adder_Arithmetic.sv
//            :
// Description: Mantissa addition and subtraction
//            : exponent and regime computation
//            :
// Limitations: 
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan(Jasper) He 
//            : xh2g20@soton.ac.uk
//
// Revision   : Version 1.2 21/02/2023
/////////////////////////////////////////////////////////////////////
//timeunit 1ns; timeprecision 1ps;
module Rounding #(parameter N = 32, parameter ES = 4, parameter RS = $clog2(N)) 
(
    input  logic[N-1:0] IN1, IN2,
    input  logic signed [ES+RS:0] LE_O,
    input  logic [ES-1:0] E_O,
    input  logic [N:0] Add_Mant,
    input  logic [N-1:0] Add_Mant_N,
    input  logic signed [RS:0] R_O,
    input  logic LS,
    input  logic inf1, inf2,
    input  logic zero1, zero2,
    output logic [N-1:0] OUT
);

logic [(2*N-1)+3:0] tmp_o;
logic [(3*N-1)+3:0] sft_tmp_o;
logic L,G,R,S,ulp;
logic [N-1:0] rnd_ulp; 
logic [N:0] sft_tmp_o_rnd_ulp;
logic [N-1:0] sft_tmp_o_rnd;
logic [N-1:0] sft_tmp_oN;

always_comb
begin
    //////      ROUNDING        //////
    //  N bits 0 or 1, following a terminating bit, exponent bits, (N-ES-1) bits mantissa, 3 bits for rounding
    tmp_o = { {N{~LE_O[ES+RS]}}, LE_O[ES+RS], E_O, Add_Mant_N[N-2:ES], 3'b0 };
    sft_tmp_o = {tmp_o, {N{1'b0}}} ;
    sft_tmp_o = sft_tmp_o >> R_O;

    L = sft_tmp_o[N+3]; 
    G = sft_tmp_o[N+2]; // Guard bit
    R = sft_tmp_o[N+1]; // round bit
    S = |sft_tmp_o[N:0];  // sticky bit
    ulp = ((G & (R | S)) | (L & G & ~(R | S)));
    
    rnd_ulp= {{N-1{1'b0}},ulp};

    
    sft_tmp_o_rnd_ulp = sft_tmp_o[2*N-1+3:N+3] + rnd_ulp;

    
    sft_tmp_o_rnd = (R_O < N-ES-2) ? sft_tmp_o_rnd_ulp[N-1:0] : sft_tmp_o[2*N-1+3:N+3];


    //////      FINAL OUTPUT        //////
    
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