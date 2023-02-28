module add_N #(parameter N=8)
(input signed [N-1:0]a,b,
 output signed [N-1:0] c);

assign c = a + b;
endmodule
