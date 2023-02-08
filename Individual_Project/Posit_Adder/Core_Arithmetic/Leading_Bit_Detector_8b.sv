/////////////////////////////////////////////////////////////////////
// Design unit: 8 bits Leading Bit Detector
//            :
// File name  : 8b_Leading_Bit_Detector.sv
//            :
// Description: Given the first bit of the regime bit
//              find the first bit different from it
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan(Jasper) He 
//            : xh2g20@soton.ac.uk
//
// Revision   : Version 1.0 01/12/2022
/////////////////////////////////////////////////////////////////////

module Leading_Bit_Detector_8b #( parameter N = 8, parameter ES = 3, parameter RS = log2(N))
(
    input logic signed [N-1:0] Add_Mant,
    output logic signed [RS:0] shift
    //output logic shift
);

function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

logic shft; 
int i;

always_comb
begin
    shft = Add_Mant[N-1]; //the MSB of InRemain (In[6])is the number to be shifted
    
    shift = '0;
    shift = shift + 1'b1; // initial EP starts from InRemain[1] as InRemain[0] is RC

    for(i = 1; i < (N-1); i++) 
        begin
            /* 
            compareing MSB of Add_Mant to the follwing bits
            until the different bit turns up    
            */
            if (shft == Add_Mant[((N-1)-i)])
                //begin
                shift = shift + 1'b1;
                //end
            else 
                break;
        end

end
endmodule