module DBsR_left_N_Bs #(parameter N = 8, parameter Bs = log2(N))
(input [N-1:0] a,
 input [Bs-1:0] b,
 output [N-1:0]c);

function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

wire [N-1:0] tmp [Bs-1:0];
assign tmp[0]  = b[0] ? a << 7'd1 : a; 
genvar i;
generate
    for (i=1; i<Bs; i=i+1)begin:loop_blk
		assign tmp[i] = b[i] ? tmp[i-1] << 2**i : tmp[i-1];
	end
endgenerate
assign c = tmp[Bs-1];

endmodule