/////////////////////////////////////////////////////////////////////
// Design unit: Logarithm Base 2
//            :
// File name  : log_2.sv
//            :
// Description: Just be used to compute the Regime Size (RS)
//            : which is equal to log2(the number of total bits)
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan He (Jasper)
//            : xh2g20@ecs.soton.ac.uk
//
// Revision   : Version 1.0 19/11/2022
/////////////////////////////////////////////////////////////////////

#ifndef log_2
#define log_2

function [31:0] log2;
input logic [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction