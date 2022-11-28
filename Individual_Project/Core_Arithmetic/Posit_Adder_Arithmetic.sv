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

module Arithmetic #(parameter N = 8, parameter ES = 3, parameter RS = log2(N)) 
(
    input logic signed [N-2:0] InRemain1, InRemain2,
    input logic Sign1, Sign2,
    input logic signed [RS:0] RegimeValue1, RegimeValue2,
    input logic [ES-1:0] Exponent1, Exponent2,
    input logic [N-ES+2:0] Mantissa1, Mantissa2,
    output logic [N-1:0] Add_Mant
);

// Confirm the operation (s1 xor s2)
logic Operation = Sign1 ^ Sign2 ;

// Find the greater input
logic Greater_Than = (InRemain1[N-2:0] >  InRemain2[N-2:0])? 1'b1 : 1'b0;

// Assign components to corresponding logic, L - Large S - Small
logic LS = Greater_Than ? Sign1 : Sign2;
logic LR = Greater_Than ? RegimeValue1 : RegimeValue2;
logic LRC = Greater_Than? InRemain1[N-2] : InRemain2[N-2];
logic LE = Greater_Than ? Exponent1 : Exponent2;
logic LM = Greater_Than ? Mantissa1 : Mantissa2;

logic SS = Greater_Than ? Sign2 : Sign1;
logic SR = Greater_Than ? RegimeValue2 : RegimeValue1;
logic SRC = Greater_Than? InRemain2[N-2] : InRemain1[N-2];
logic SE = Greater_Than ? Exponent2 : Exponent1;
logic SM = Greater_Than ? Mantissa2 : Mantissa1;

// Mantissa Addition

logic sign [RS:0] R_diff;
/*
find regime difference, 
when both of them are +ve, the difference is RV1 - RV2
when RV1 +ve but RV2 -ve, the difference is RV1 + RV2
when RV1 -ve => RV2 also -ve, still RV1 - RV2
*/
if (RegimeValue1 >= 0 || RegimeValue2 >= 0)
    R_diff = RegimeValue1 - RegimeValue2;
else if (RegimeValue1 >= 0 || RegimeValue2 < 0)
    R_diff = RegimeValue1 + RegimeValue2;
else if (RegimeValue1 < 0)
    R_diff = RegimeValue1 - RegimeValue2;

logic E_diff;
/*
after the R_diff found, remember that the regime contributes into the exponent
as (Useed ^ RegimeValue) where Useed = 2^(2^ES) 
so the E_diff is (R_diff x log2(useed) + LE - SE)
the reason why it is R_diff x log2(useed) is
the exponent (2 ^ what)is what we want to find
for exponent bits, it is the difference
for regime bits, they are log2(Useed ^ RegimeValue) which is RegimeValue x (2^ES)
*/
E_diff = (R_diff*log2(2**(2**(ES)))) + (LE - SE); 

logic SM_tmp = SM >> E_diff;
logic Add_Mant = Operation ?  LM + SM_tmp : LM - SM_tmp;
endmodule