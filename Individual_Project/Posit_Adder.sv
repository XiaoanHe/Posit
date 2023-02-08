/////////////////////////////////////////////////////////////////////
// Design unit: Posit Adder 
//            :
// File name  : Posit_Adder.sv
//            :
// Description: Posit Adder Top Level Module
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan He (Jasper)
//            : xh2g20@ecs.soton.ac.uk
//
// Revision   : Version 1.0 07/12/2022
/////////////////////////////////////////////////////////////////////

module Posit_Adder #(parameter N = 8, parameter RS = log2(N), parameter ES = 3) 
(
    input logic signed [N-1:0] In1, In2,
    output logic signed [ES+RS:0] LE_O,
    output logic [ES-1:0] E_O,
    output logic signed [RS:0] R_O
);

function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

// Data Extraction
logic Sign1, Sign2;
logic signed [RS:0] RegimeValue1, RegimeValue2;
logic [ES-1:0] Exponent1, Exponent2;
logic [N-ES+2:0] Mantissa1, Mantissa2;
logic signed [N-2:0] InRemain1, InRemain2;
Data_Extraction #(.N(N), .ES(ES)) DE1(.In(In1), .Sign(Sign1), .RegimeValue(RegimeValue1), .Exponent(Exponent1), .Mantissa(Mantissa1), .InRemain(InRemain1));
Data_Extraction #(.N(N), .ES(ES)) DE2(.In(Ini2), .Sign(Sign2), .RegimeValue(RegimeValue2), .Exponent(Exponent2), .Mantissa(Mantissa2), .InRemain(InRemain2));

//Arithmetic
logic [N-1:0] E_diff;
logic [N:0] Add_Mant;
Alignment #(.N(N), .ES(ES)) A (.InRemain1(InRemain1), .InRemain2(InRemain2), .Sign1(Sign1), .Sign2(Sign2), .RegimeValue1(RegimeValue1), .RegimeValue2(RegimeValue2), .Exponent1(Exponent1), .Exponent2(Exponent2),.Mantissa1(Mantissa1), .Mantissa2(Mantissa2), .E_diff(E_diff), .Add_Mant(Add_Mant), .LE_O(LE_O), .E_O(E_O), .R_O(R_O));
endmodule