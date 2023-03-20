module data_extract #(parameter N=8, parameter Bs=log2(N), parameter es=4, parameter Rmax = N-1, parameter Rmin = -(N-1))
(input logic signed [N-1:0] in,
output logic Sin,
output logic [es-1:0] exp,
output logic signed [Bs:0] regime,
output logic signed [Bs+es:0] eff_e,
output logic [N-es+2:0] mant
);

function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

assign Sin = in[N-1];
logic signed [N-2:0] xin;
logic rc;
logic signed [N-2:0] xint; 
logic OF;
logic signed [Bs:0] LOP;
logic signed [N-2:0] regime_shift;

LOD1 #(.N(N),.es(es)) lod1 (.in(xint),.out(LOP),.overflow(OF));

always_comb
  begin
    xin = Sin ? (~in[N-2:0] + 1'b1) : in[N-2:0];
    rc = xin[N-2];
    xint = rc ? (~xin + 1'b1) : xin; 
    if (OF == 0)
      regime = rc ? (LOP - 1'b1) : (~LOP + 1'b1);
	else
	  begin
        regime = rc ? Rmax : Rmin;
	  end
    regime_shift = in << (LOP + 2'b1);
    exp = regime_shift[N-2:N-es-1];
    mant = {1'b1, regime_shift[N-es-2:0], 3'b0};
    eff_e = {regime,exp};
end
endmodule