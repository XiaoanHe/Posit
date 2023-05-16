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
    input  logic signed [ES+RS+1:0] Total_EO,
    input  logic [ES-1:0] E_O,
    input  logic [2*N:0] Mult_Mant,
    input  logic [2*N-1:0] Mult_Mant_N,
    input  logic signed [RS:0] R_O,
    input  logic Sign_o,
    input  logic inf, zero,
    output logic signed[N-1:0] OUT
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
tmp_o = { {N{~Total_EO[ES+RS+1]}}, Total_EO[ES+RS+1], E_O, Mult_Mant_N[(2*N-1)-1:(((2*N-1)-1)-(N-1-ES))+1], Mult_Mant_N[(((2*N-1)-1)-(N-1-ES)):(((2*N-1)-1)-(N-1-ES))-1], |Mult_Mant_N[(((2*N-1)-1)-(N-1-ES))-2:0]};
    sft_tmp_o = {tmp_o, {N{1'b0}}};
    if (R_O[RS])
        sft_tmp_o = sft_tmp_o >> {RS{1'b1}};
    else
        sft_tmp_o = sft_tmp_o >> R_O; 

    L = sft_tmp_o[N+4]; 
    G = sft_tmp_o[N+3]; 
    R = sft_tmp_o[N+2]; 
    S = |sft_tmp_o[N+1:0];
    ulp = ((G & (R | S)) | (L & G & ~(R | S)));

    rnd_ulp= {{N-1{1'b0}},ulp};

    
    sft_tmp_o_rnd_ulp = sft_tmp_o[2*N-1+3:N+3] + rnd_ulp;

    
    sft_tmp_o_rnd = (R_O < N-ES-2) ? sft_tmp_o_rnd_ulp[N-1:0] : sft_tmp_o[2*N-1+3:N+3];


    //////      FINAL OUTPUT        //////
    
    sft_tmp_oN = Sign_o ? -sft_tmp_o_rnd : sft_tmp_o_rnd;
    OUT = inf|zero ? {inf,{N-1{1'b0}}} : {Sign_o, sft_tmp_oN[N-1:1]};
end
endmodule