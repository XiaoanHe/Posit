/////////////////////////////////////////////////////////////////////
// Design unit: Posit Adder Testbench
//            :
// File name  : Posit_Adder_tb.sv
//            :
// Description: Test Posit Adder
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan(Jasper) He 
//            : xh2g20@ecs.soton.ac.uk
//
// Revision   : Version 1.0 08/02/2023
/////////////////////////////////////////////////////////////////////
function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

module Posit_Adder_tb;
parameter N = 8, RS = log2(N), ES = 3;

//input logic
logic signed [N-1:0] IN1, IN2;

//output logic
logic signed [N-1:0] OUT;

Posit_Adder #(.N(N), .ES(ES)) Posit_Adder_testing (.*);

initial 
    begin
        #10ns 
        IN1 = 8'b0_0000000;
        IN2 = 8'b0_0000000;
        OUT = 8'b0_0000000;

        #50ns   //  65536+112
        IN1 = 8'b0_1110_000;
        IN2 = 8'b0_10_110_11;

        #50ns   // 524288+1024
        IN1 = 8'b0_1110_011;
        IN2 = 8'b0_110_010_0;

        #50ns   // 10+12
        IN1 = 8'b0_10_011_01;
        IN2 = 8'b0_10_011_10;
        
        #50ns   // 40+24
        IN1 = 8'b0_10_101_01;
        IN2 = 8'b0_10_100_10;

         #50ns   // 0.0234375+0.01953125
        IN1 = 8'b0_01_010_10;
        IN2 = 8'b0_01_010_01;

         #50ns   // 0.125+0.15625
        IN1 = 8'b0_01_101_00;
        IN2 = 8'b0_01_101_01;
       
    end



endmodule