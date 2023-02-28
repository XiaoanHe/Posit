module posit_adder #(parameter N = 8, parameter Bs = log2(N), parameter es = 4, parameter Rmax = N-1, parameter Rmin = -N)
(input logic signed [N-1:0] in1, in2, 
 output logic signed [N-1:0] out
);

function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

// addition and subtraction
//check for infinity
logic inf1;
logic inf2;
logic inf;
assign inf1 = in1[N-1] & ~(|in1[N-2:0]);
assign inf2 = in2[N-1] & ~(|in2[N-2:0]);
assign inf = inf1 | inf2;
//check for zero
logic Zin1;
logic Zin2;
logic zero;
assign Zin1 = ~(|in1);
assign Zin2 = ~(|in2);
assign zero = Zin1 & Zin2;
//data extraction
wire s1, s2;
wire signed [Bs+es:0] Eeff1, Eeff2;
wire signed [Bs:0] regime1, regime2;
wire [N-es+2:0] mant1, mant2;
wire [es-1:0] exp1, exp2;
data_extract #(.N(N),.es(es)) data1(.in(in1),.Sin(s1),.exp(exp1),.regime(regime1),.eff_e(Eeff1),.mant(mant1));
data_extract #(.N(N),.es(es)) data2(.in(in2),.Sin(s2),.exp(exp2),.regime(regime2),.eff_e(Eeff2),.mant(mant2));
//Alignment
wire signed [Bs+es:0] Eeff;
wire signed [N-es+3:0] MB, MS;
alignment #(.N(N),.es(es)) a1(.exp1(exp1),.exp2(exp2),.Eeff1(Eeff1),.Eeff2(Eeff2),.regime1(regime1),.regime2(regime2),.mant1(mant1),.mant2(mant2),.s1(s1),.s2(s2),.MB(MB),.MS(MS),.Eeff(Eeff));
//adder
wire signed [N-es+3:0] MI;
add_N #(.N(N)) add1 (.a(MB), .b(MS), .c(MI)); // adding mantissa
// final sign
wire sf;
wire signed [N-es+3:0] C;
assign sf = (s1 ^ s2) ? MI[N-es+3] : s1;
assign C = ((s1 ^ s2) && sf) ? (~MI + 1'b1) : MI;
// normalization
wire ZF;
wire [N-es+1:0]M_normal;
wire signed [Bs+es:0]E_normal;
normalization #(.N(N),.es(es)) N1 (.Eeff(Eeff),.C(C),.s1(s1),.s2(s2),.ZF(ZF),.M_normal(M_normal),.E_normal(E_normal));
//rounding
rounding #(.N(N),.es(es)) r1 (.E_normal(E_normal),.sf(sf),.zero(zero),.inf(inf),.ZF(ZF),.M_normal(M_normal),.r(out));
endmodule