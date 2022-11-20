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

Module Data_Extraction #( parameter N = 8, parameter ES = 3, parameter RS = log2(N))
(
    input logic signed [N-1:0] In,
    output logic Sign,
    output logic signed [RS-1:0] Regime,
    output logic [ES-1:0] Exponent,
    output logic [N-ES+2:0] Mantissa
)

// Sign Bit Extraction
logic signed [N-2:0] InRemain;

Sign = In[N-1];
if(Sign = 1)    // if sign bit is 1, then 2's compliment
    InRemain = ~In[N-2:0] + 1'b1;
else
    InRemain = In[N-2:0];

// Regime Bits Extraction
logic RegimeCheck = InRemain{N-2}; //the MSB of InRemain is the number to be checked

logic [RS-1:0] EndPosition = 1; // initial EP starts from 2nd element

for(int i = 1; i < N-2; i++)
    begin
        /* 
        compareing MSB of InRemain to the follwing bits
        until the different bit turns up    
        */
        if(RegimeCheck == InRemain[((N-2)-i)])
            EndPosition = EndPositon + 1;
        else 
            break;
    end

// logic RegimeValue;

// if(RegimeCheck = 1)
//     RegimeValue = EndPosition - 1;
// else
//     RegimeValue = -EndPositon;

// Exponent Bits Extraction
logic signed [N-2:0] ShiftedRemain;
ShiftedRemain = InRemain << (EndPosition + )
endmodule