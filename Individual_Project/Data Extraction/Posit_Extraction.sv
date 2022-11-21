/////////////////////////////////////////////////////////////////////
// Design unit: DataExtraction
//            :
// File name  : Posit_Extraction.sv
//            :
// Description: Extracting posit element from n bits binary number
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

// `ifndef log_2
// `define log_2
// `include "log_2.sv"

function [31:0] log2;
    input reg [31:0] value;
        begin
            value = value-1;
            for (log2=0; value>0; log2=log2+1)
                value = value>>1;
        end
endfunction

module Data_Extraction #( parameter N = 8, parameter ES = 3, parameter RS = log2(N))
(
    input logic signed [N-1:0] In,
    output logic Sign,
    output logic signed [RS-1:0] RegimeValue,
    output logic [ES-1:0] Exponent,
    output logic [N-ES+2:0] Mantissa
);

logic signed [N-2:0] InRemain;
logic RegimeCheck; 
logic [RS:0] EndPosition;
logic signed [N-2:0] ShiftedRemain;
int i;
Leading_Bit_Detector #(.N(N), .ES(ES)) LBD1 (.*);

always_comb
begin
    // Sign Bit Extraction
    Sign = In[N-1];
    // if sign bit is true, then 2's compliment
    InRemain = Sign ? (~In[N-2:0] + 1'b1) : In[N-2:0];

    // Regime Bits Extraction
    

    if(RegimeCheck == 1'b1)
        RegimeValue = EndPosition - 1;
    else if (RegimeCheck == 0)
        RegimeValue = -EndPosition;

    //Exponent Bits Extraction
    ShiftedRemain = InRemain << (EndPosition + 1 );
    Exponent = ShiftedRemain[N-1:((N-1)-ES)];

    //Mantissa Bits Extraction
    Mantissa = {1'b1, ShiftedRemain[N-ES-2]};
end
endmodule