module sticky_bit_adjustor1 #(parameter N = 8, parameter Bs = log2(N), parameter es = 4, parameter L = 1) 
(input logic signed [2*N+2:0] A,
 input logic [Bs:0] shift,
 output logic signed [2*N+2:0] Z
);

function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

logic sticky_bit;
logic signed [2*N+2+L:0] t;
logic signed [2*N+2+L:0] t1;



always_comb
  begin
    sticky_bit = 1;
	t = {A,{L{1'b0}}};
	t1 = t >> shift;
    if (t1[0] == 0)
        sticky_bit = 0;
	sticky_bit = sticky_bit | t1[1];
	Z = {t1[2*N+3+L-1:L+1],sticky_bit};	
  end

endmodule