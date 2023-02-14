module normalization #(parameter N = 8, parameter Bs = log2(N), parameter es = 4, parameter Rmax = N-1, parameter Rmin = -N)
(input logic signed [Bs+es:0] Eeff,
 input logic signed [N-es+3:0] C,
 input logic s1, s2,
 output logic ZF,
 output logic [N-es+1:0] M_normal,
 output logic signed [Bs+es:0] E_normal
);

function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

logic OF;
logic signed [Bs:0] w;
logic [N-1:0] LOP;
logic signed [es-1:0] e;
logic signed [Bs+es:es] p, temp_r;
logic [N-es+3:0] temp_m;

LOD #(.N(N),.Bs(Bs)) lod (.in(C),.out(LOP),.overflow(OF));

always_comb
  begin
    M_normal = '0;
	E_normal = '0;
	w = '0;
	e = '0;
	p = '0;
	temp_r = '0;
	temp_m = '0;
	ZF = '0;
	if (s1 ^ s2 == 0)
	  begin
	    if (OF == 1)
		  begin
		    e = Eeff[es-1:0] + 1'b1;
		    if (e == '0 && Eeff[es-1:0] == {1'b0,{(es-1){1'b1}}})
			begin
			  if (Eeff[es+Bs:es] == Rmax)
			    begin 
			      M_normal = '0;
				  E_normal = {Rmax,{4'b0}};
				end
			  else
			    begin 
			      p = Eeff[es+Bs:es] + 1'b1;
				  E_normal = {p,e};
				end 
			end 
			else
			begin
			  E_normal = {Eeff[Bs+es:es],e};
			end
		    if (C[0] == 1)
			 M_normal = C[N-es+2:1];
			else
			 M_normal = {C[N-es+2:2],1'b1};
	      end
		else
		  begin 
		    M_normal = C[N-es+1:0];
		    E_normal = Eeff;
		  end 
	      end
    else
	  begin
	    if (OF == 1)
		  begin
		    ZF = 1;
		    M_normal = '0;
	      end 
		else
		  begin
		    temp_m = C << LOP;
			M_normal = temp_m[N-es+1:0];
		  end 
		e = Eeff[es-1:0] - LOP[es-1:0];
		if (e[es-1] == 1)
          begin
            if (Eeff[es+Bs:es] == Rmin)
			  begin 
			    M_normal = '0;
			    E_normal = {Rmin,{4'b0}};
			  end 
			else
			  begin
			    temp_r = Eeff[Bs+es:es] - 1'b1;
				E_normal = {temp_r,e};
			  end 
		  end 
		else
		  begin
		    E_normal = {Eeff[Bs+es:es],e};
		  end 
		  w = E_normal[Bs+es:es] - LOP[Bs+es:es];
		  E_normal = {~w[Bs], w[Bs-1:0], E_normal[es-1:0]};
		  end 
	  end 
	  endmodule
