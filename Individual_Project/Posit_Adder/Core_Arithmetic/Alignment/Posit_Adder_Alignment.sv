/////////////////////////////////////////////////////////////////////
// Design unit: Alignment in Posit Adder Arithmetic
//            :
// File name  : Posit_Adder_Alignment.sv
//            :
// Description: For two Posit Inputs, check which one is greater
//            : shift the smaller one to the same exponent
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan He (Jasper)
//            : xh2g20@ecs.soton.ac.uk
//
// Revision   : Version 1.0 29/11/2022
/////////////////////////////////////////////////////////////////////

function [31:0] log2;
    input reg [31:0] value;
        begin
            value = value-1;
            for (log2=0; value>0; log2=log2+1)
                value = value>>1;
        end
endfunction

module Alignment #(parameter N = 8, parameter ES = 3, parameter RS = log2(N)) 
(
    input logic signed [N-2:0] InRemain1, InRemain2,
    input logic Sign1, Sign2,
    input logic signed [RS:0] RegimeValue1, RegimeValue2,
    input logic [ES-1:0] Exponent1, Exponent2,
    input logic [N-ES+2:0] Mantissa1, Mantissa2,
    output logic [N-1:0] E_diff,
    output logic [N-1:0] Add_Mant
);
    logic Operation;
    // components to corresponding logic, L - Large S - Small
    logic LS, SS;
    logic [RS:0] LR, SR;
    logic LRC, SRC;
    logic [ES-1:0]LE, SE;
    logic [N-ES+2:0]LM, SM, SM_tmp;
    // logic SS;
    // logic [RS:0]SR;
    // logic SRC;
    // logic [ES-1:0]SE;
    // logic [N-ES+2:0]SM, SM_tmp;

    logic Greater_Than;
    logic signed [RS:0] R_diff;

always_comb
begin
    // Confirm the operation (s1 xor s2)
    Operation = Sign1 ^ Sign2 ;

    // Find the greater input
    Greater_Than = (InRemain1[N-2:0] >  InRemain2[N-2:0])? 1'b1 : 1'b0;

    // Assign components to corresponding logic, L - Large S - Small
    LS = Greater_Than ? Sign1 : Sign2;
    LR = Greater_Than ? RegimeValue1 : RegimeValue2;
    LRC = Greater_Than? InRemain1[N-2] : InRemain2[N-2];
    LE = Greater_Than ? Exponent1 : Exponent2;
    LM = Greater_Than ? Mantissa1 : Mantissa2;

    SS = Greater_Than ? Sign2 : Sign1;
    SR = Greater_Than ? RegimeValue2 : RegimeValue1;
    SE = Greater_Than ? Exponent2 : Exponent1;
    SM = Greater_Than ? Mantissa2 : Mantissa1;

    // Mantissa Addition
    /*
    find regime difference, 
    when both of them are +ve, the difference is RV1 - RV2
    when RV1 +ve but RV2 -ve, the difference is RV1 + RV2
    when RV1 -ve and RV2 also -ve, still RV1 - RV2
    */

    // if (RegimeValue1 >= 0 && RegimeValue2 >= 0)
    //     R_diff = RegimeValue1 - RegimeValue2;
    // else if (RegimeValue1 >= 0 && RegimeValue2 < 0)
    //     R_diff = RegimeValue1 - RegimeValue2;
    // else if (RegimeValue1 < 0 && RegimeValue2 < 0)
    //     R_diff = RegimeValue1 - RegimeValue2;
    R_diff = RegimeValue1 - RegimeValue2;

    /*
    after the R_diff found, remember that the regime contributes into the exponent
    as (Useed ^ RegimeValue) where Useed = 2^(2^ES) 
    so the E_diff is (R_diff x log2(useed) + LE - SE)
    the reason why it is R_diff x log2(useed) is
    the exponent (2 ^ what)is what we want to find
    for exponent bits, it is the difference
    for regime bits, they are log2(Useed ^ RegimeValue) which is RegimeValue x (2^ES)
    */
    E_diff = (R_diff*(2**(ES))) + (LE - SE); 

    SM_tmp = SM >> E_diff;
    Add_Mant = Operation ?  LM - SM_tmp : LM + SM_tmp;
end
endmodule