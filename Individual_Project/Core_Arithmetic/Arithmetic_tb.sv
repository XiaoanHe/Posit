/////////////////////////////////////////////////////////////////////
// Design unit: Arithmetic Testbench
//            :
// File name  : Arithmetic_tb.sv
//            :
// Description: Test Posit Adder Arithmetic
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan He (Jasper)
//            : xh2g20@ecs.soton.ac.uk
//
// Revision   : Version 1.0 23/11/2022
/////////////////////////////////////////////////////////////////////
function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

module Arithmetic_tb;
parameter N = 8, RS = log2(N), ES = 3;

//input logic
logic signed [N-2:0] InRemain1, InRemain2;
logic Sign1, Sign2;
logic signed [RS:0] RegimeValue1, RegimeValue2;
logic [ES-1:0] Exponent1, Exponent2;
logic [N-ES+2:0] Mantissa1, Mantissa2;

//output logic
logic [N-1:0] E_diff;
logic [N:0] Add_Mant;
logic signed [ES+RS:0] LE_O;
logic [ES-1:0] E_O;
logic signed [RS:0] R_O;
logic signed [N-1:0] Result;
logic signed [N-1:0] out;

Alignment #(.N(N), .ES(ES)) alignment_tb (.*);

initial 
    begin
       #10ns 
       InRemain1 = 7'b0_0000000;
       InRemain2 = 7'b0_0000000;
       Sign1 = 0;
       Sign2 = 0;
       RegimeValue1 = '0;
       RegimeValue2 = '0;
       Exponent1 = '0;
       Exponent2 = '0;
       Mantissa1 = '0;
       Mantissa2 = '0;

       #50ns   // 1+0.625 ~= 1.5
       InRemain1 = 7'b10_000_00;
       InRemain2 = 7'b01_111_01;
       Sign1 = 0;
       Sign2 = 0;
       RegimeValue1 = 0;
       RegimeValue2 = -1;
       Exponent1 = 3'b000;
       Exponent2 = 3'b111;
       Mantissa1 = 8'b10000000;
       Mantissa2 = 8'b10100000;

       

       #50ns   // 1+ 0.875 ~= 2
       InRemain1 = 7'b10_000_00;
       InRemain2 = 7'b01_111_11;
       Sign1 = 0;
       Sign2 = 0;
       RegimeValue1 = 0;
       RegimeValue2 = -1;
       Exponent1 = 3'b000;
       Exponent2 = 3'b111;
       Mantissa1 = 8'b10000000;
       Mantissa2 = 8'b11100000;

       #50ns  // 524288 + 12288 ~= 524288
       InRemain1 = 7'b1110_011;
       InRemain2 = 7'b110_101_1;
       Sign1 = 0;
       Sign2 = 0;
       RegimeValue1 = 2;
       RegimeValue2 = 1;
       Exponent1 = 3'b011;
       Exponent2 = 3'b101;
       Mantissa1 = 8'b10000000;
       Mantissa2 = 8'b11000000;

       #50ns   // 1+(-0.25)
       InRemain1 = 7'b10_000_00;       
       InRemain2 = 7'b01_110_00;
       Sign1 = 0;
       Sign2 = 1;
       RegimeValue1 = 0;
       RegimeValue2 = -1;
       Exponent1 = 3'b000;
       Exponent2 = 3'b110;
       Mantissa1 = 8'b10000000;
       Mantissa2 = 8'b10000000;

       #50ns   // 32768-24576
       InRemain1 = 7'b110_111_0;       
       InRemain2 = 7'b110_110_1;
       Sign1 = 0;
       Sign2 = 1;
       RegimeValue1 = 1;
       RegimeValue2 = 1;
       Exponent1 = 3'b111;
       Exponent2 = 3'b110;
       Mantissa1 = 8'b10000000;
       Mantissa2 = 8'b11000000;


    end
endmodule