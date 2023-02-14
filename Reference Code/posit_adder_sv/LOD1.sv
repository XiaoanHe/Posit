module LOD1 #(parameter N = 8, parameter Bs = log2(N), parameter es = 4) 
(input logic signed [N-es+2:0]in,
 output logic signed [Bs:0]out, 
 output logic overflow);
 
function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

logic found;
logic t;
assign overflow = ~(|in);


integer i;
always_comb
  begin
  t = 0; 
  found = 0;
  out = '0;
	  for(i=0;i<N-es+3;i=i+1)
         begin
	      if (in[N-es+3-i-1] == 1)
		    begin
	          found = 1;
			end 
	      t = t|found;
	      if (t == 0)
	        out = out + 1'b1;
         end 
  end
endmodule