module rounding #(parameter N = 8, parameter Bs = log2(N) , parameter es = 4)
(input logic signed [Bs+es:0]E_normal,
 input logic sf, zero, inf, ZF,
 input logic [N-es+1:0]M_normal,
 output logic signed [N-1:0]r
);

function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

logic [Bs:0]shift;
logic signed [2*N+2:0]Tp;
logic signed [2*N+2:0]Tp1;
logic G, R, S, ulp;
logic Lb;
logic signed [N-2:0]Ip;

sticky_bit_adjustor1 #(.N(N), .es(es)) s2 (.A(Tp), .shift(shift + 1'b1), .Z(Tp1));

always_comb
  begin
	  shift = '0;
	  Tp = '0;
	  G = '0;
	  R = '0;
	  S = '0;
	  ulp = '0;
	  Lb = '0;
	  Ip = '0;
	  r = '0;
        if (E_normal[Bs+es])
	      shift = ~E_normal[Bs+es:es] + 1'b1;
	    else
		  begin
	        shift = E_normal[Bs+es:es] + 1'b1;
		  end 
	    Tp = {{N{~E_normal[Bs+es]}}, E_normal[Bs+es], E_normal[es-1:0], M_normal};
	    G = Tp1[2];
	    R = Tp1[1];
	    S = Tp1[0];
	    Lb = Tp1[3];
	    Ip = Tp1[N+1:3];
	    if (shift < N-1)
	      begin
	        ulp = (G&(R|S))|(Lb&G&(!(R|S)));
	        Ip = Ip + ulp;
	      end 
	    if (sf == 1)
	      Ip = ~Ip + 1'b1;
	    if (inf == 1)
		  r = {1'b1, {(N-1){1'b0}}};
		else if (zero == 1 || ZF == 1)
		  r = {N{1'b0}};
		else
		  r = {sf,Ip};	  
	  end 
  endmodule