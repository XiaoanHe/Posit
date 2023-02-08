/////////////////////////////////////////////////////////////////////
// Design unit: tb_Posit_Adder
//            :
// File name  : tbPositAdder.sv
//            :
// Description: Testbench for Posit Adder
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan He (Jasper)
//            : xh2g20@ecs.soton.ac.uk
//
// Revision   : Version 1.1 07/12/2022
/////////////////////////////////////////////////////////////////////

function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

module Test_Posit_Adder;
parameter N = 8, RS = log2(N), ES = 3;

// Input Logic
logic signed [N-1:0] In1, In2;

// Output Logic
logic signed [ES+RS:0] LE_O;
logic [ES-1:0] E_O;
logic signed [RS:0] R_O;

Posit_Adder #(.N(N), .ES(ES)) PA (.*);

initial
    begin
        // initial input is nothing
        #10ns In1 = 8'b0_0000000;
              In2 = 8'b0_0000000;
              
        #50ns In1 = 8'b0_01_000_01;  // R = -1, E = 000, M = 1.01
              In2 = 8'b0_001_010_0;  // R = -2, E = 010, M = 1.0

        #50ns In1 = 8'b0_10_001_10;  // R = 0, E = 100, M = 1.1
              In2 = 8'b0_110_011_1;  // R = 1, E = 100, M = 1.01

        //#50ns In = 8'b0_0001_100;   // R = -3, E = 100, M = 1.00
        #50ns In1 = 8'b0_1110_101;   // R = 2, E = 101, M = 1.00
              In2 = 8'b1_01_000_01;  // 10_111_11 R = 0 , E = 111, M = 1.11
        #50ns In1 = 8'b1_10_001_10;  // 001_110_10 R = -2, E = 110, M = 1.10
              In2 = 8'b1_001_010_0;  // 01_101_100 R = -1, E = 101, M = 1.10
        // #50ns In = 8'b1_110_011_1;  // R = -3, E = 100, M = 1.01
        // #50ns In = 8'b1_0001_100;   // R = -3, E = 100, M = 1.01
        // #50ns In = 8'b1_1110_101;   // R = -3, E = 100, M = 1.01


    end
endmodule