module test_fpmultiplier;

timeunit 1ns; timeprecision 10ps;

logic signed [31:0] product;
logic ready;
logic signed [31:0] a;
logic clock;
logic nreset;



fpmultiplier Fp ( product, ready, a, clock, nreset );

always
  begin
         clock = 0;
    #250 clock = 1;
    #500 clock = 0;
    #250 clock = 0;
  end

initial
    begin
	nreset = 0;
      #1000
	nreset = 0;
      #1000
	nreset = 1;
      #5000
	$finish;
    end

  initial
    begin
	a = '0;

      #2000
	a = 32'b1_10001001_00000000000000000000000;
      #1500
    a = 32'b0_01111010_10000000000000000000000;
    end
	endmodule