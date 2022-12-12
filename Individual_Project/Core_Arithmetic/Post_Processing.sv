/////////////////////////////////////////////////////////////////////
// Design unit: Post Processing
//            :
// File name  : Post_Processing.sv
//            :
// Description: 
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan He (Jasper)
//            : xh2g20@ecs.soton.ac.uk
//
// Revision   : Version 1.0 12/12/2022
/////////////////////////////////////////////////////////////////////

module Post_Processing #(parameter N = 8, parameter ES = 3, parameter RS = log2(N)) 
(
    input logic [ES-1:0] E_O,
    input logic signed [RS:0] R_O,
    output logic [N-1:0]RegimeBits,
    output logic [ES-1:0]ExponentBits,
);

function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

int i;
logic [N-1:0] ONEs;

always_comb
begin
ONEs = '1;
RegimeBits = R_O[RS]? ONEs << (R_O-1'b1) : ONEs >> R_O
end
endmodule