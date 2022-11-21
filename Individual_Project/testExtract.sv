/////////////////////////////////////////////////////////////////////
// Design unit: TestDataExtraction
//            :
// File name  : testExtract.sv
//            :
// Description: Testbench for extracting posit element 
//              from n bits binary number
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan He (Jasper)
//            : xh2g20@ecs.soton.ac.uk
//
// Revision   : Version 1.0 14/11/2022
/////////////////////////////////////////////////////////////////////

module testExtract;

function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

parameter N = 8, Bs = log2(N), es = 3;

//input logic
logic signed [N-1:0]In;
//output logic
logic Sign;
logic [ES-1:0]Exponent;
logic signed [Es-1:0]Regime;
logic [N-ES+2:0]Mantissa;

Data_Extraction extract1 (.*);

initial
    begin
        // initial input is nothing
        #10ns in = 8'b0_0000000;
        // sign=0 regime=10 exponent=1001,mant=1    
        #50ns in = 8'b1_01_1000_0;  
        // 0_10_1000_0
    end

endmodule