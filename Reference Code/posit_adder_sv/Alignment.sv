module alignment #(parameter N = 8, parameter Bs = log2(N), parameter es = 4)
(input logic [es-1:0] exp1, exp2,
 input logic signed [Bs+es:0] Eeff1, Eeff2,
 input logic signed [Bs:0] regime1, regime2, 
 input logic [N-es+2:0] mant1, mant2,
 input logic s1, s2,
 output logic signed [N-es+3:0] MB, MS,
 output logic signed [Bs+es:0] Eeff
);

function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

//finding difference of exponents
logic signed [es-1:0] exp_diff1;
logic signed [es-1:0] exp_diff2;
logic signed [es-1:0] exp_diff;

//finding difference of regimes
logic signed [Bs:0] r_diff;
logic a;
logic Sr1, Sr2;
logic [N-es+3:0] shift;
logic [N-es+3:0] max_shift;
logic [N-es+2:0] mantB, mantS, mantS1;
logic [N-es+2:0] mantS1_output;

sticky_bit_adjustor #(.N(N), .es(es)) sti1 (.A(mantS1),.shift(shift),.Z(mantS1_output));

always_comb
  begin
	    a = '0;
	    Eeff = '0;
	    mantB = '0;
	    mantS = '0;
		mantS1 = '0;
		MB = '0;
		MS = '0;
		shift = '0;
	    max_shift = '1;
		exp_diff1 = exp1 - exp2;
		exp_diff2 = ~exp_diff1 + 1'b1;
		exp_diff = exp_diff1;
        Sr1 = regime1[Bs];
        Sr2 = regime2[Bs];		
	    r_diff = regime1 - regime2;
		if (Sr1 ^ Sr2 == 1)
		  begin
		    if (Sr1 == 0)
		      begin
		        mantB = mant1;
			    mantS = mant2;
			    Eeff = Eeff1;
		      end
	        else
		      begin
		        mantB = mant2;
		        mantS = mant1;
			    Eeff = Eeff2;
			    a = 1;
				r_diff = ~r_diff + 1'b1;
		      end
		  end
	    else
		  begin
		    if (|r_diff[Bs:0] == 0)
			  if (exp_diff[es-1] == 0)
			    begin
			    mantB = mant1;
				mantS = mant2;
				Eeff = Eeff1;
				end
			  else
			    begin
			    mantB = mant2;
				mantS = mant1;
				Eeff = Eeff2;
				a = 1;
				r_diff = ~r_diff + 1'b1;
				end 
		    else
			  if (r_diff[Bs] == 0)
			    begin 
			    mantB = mant1;
				mantS = mant2;
				Eeff = Eeff1;
				end 
			  else
			    begin
			    mantB = mant2;
				mantS = mant1;
				Eeff = Eeff2;
				a = 1;
				r_diff = ~r_diff + 1'b1;
				end 
		  end
		if (a == 1)
		  exp_diff = exp_diff2;
		if (exp_diff[es-1] == 1)
		  begin
		    if (|r_diff == 1)
		      r_diff = r_diff - 1'b1;
		    else
			  exp_diff = exp_diff2;
		  end 
		shift = {r_diff[Bs:0],exp_diff[es-1:0]};
		if (shift >= max_shift)
		  begin
		    mantS = '0;
			shift = '0;
	      end
		else
		  begin
		    mantS1 = mantS;
		    mantS = mantS1_output;
		  end
		MB = {1'b0,mantB};
		MS = {1'b0,mantS};
	    if (s1 ^ s2 == 1)
	      if (s1 == 1)
	        if (a == 0)
		      MB = ~mantB + 1'b1;
		    else
		      MS = ~mantS + 1'b1;
	      else
	        if (a == 0)
		      MS = ~mantS + 1'b1;
		    else
		      MB = ~mantB + 1'b1;
  end
  endmodule