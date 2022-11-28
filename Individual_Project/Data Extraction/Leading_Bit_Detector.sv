/////////////////////////////////////////////////////////////////////
// Design unit: Leading Bit Detector
//            :
// File name  : Leading_Bit_Detector.sv
//            :
// Description: Given the first bit of the regime bit
//              find the first bit different from it
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan He (Jasper)
//            : xh2g20@ecs.soton.ac.uk
//
// Revision   : Version 1.0 21/11/2022
/////////////////////////////////////////////////////////////////////

module Leading_Bit_Detector #( parameter N = 8, parameter ES = 3, parameter RS = log2(N))
(
    input logic signed [N-2:0] InRemain,
    output logic signed [RS:0] EndPosition,
    output logic RegimeCheck
);

function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

//logic RegimeCheck; 
int i;

always_comb
begin
    RegimeCheck = InRemain[N-2]; //the MSB of InRemain (In[6])is the number to be checked
    
    EndPosition = '0;
    EndPosition = EndPosition + 1'b1; // initial EP starts from InRemain[1] as InRemain[0] is RC

    for(i = 1; i < (N-2); i++) 
        begin
            /* 
            compareing MSB of InRemain to the follwing bits
            until the different bit turns up    
            */
            if (RegimeCheck == InRemain[((N-2)-i)])
                //begin
                EndPosition = EndPosition + 1'b1;
                //end
            else 
                break;
        end

end
endmodule