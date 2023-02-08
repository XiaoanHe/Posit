`timescale 1ns / 1ps
module posit_adder_8bit_tb_v;

function [31:0] log2;
input reg [31:0] value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
        	value = value>>1;
      	end
endfunction

parameter N=8;
parameter Bs=log2(N);
parameter es=3;

reg [N-1:0] in1, in2;
 
wire [N-1:0] out;

	reg clk;
	integer outfile;


// Instantiate the Unit Under Test (UUT)
posit_adder #(.N(N), .es(es)) uut (.in1(in1), .in2(in2), .out(out));
// 65536 since es = 4 => useed=2^(2^4)=65536
reg [N-1:0] data1 [1:65536];
reg [N-1:0] data2 [1:65536];
initial $readmemb("Pin1_8bit.txt",data1);
initial $readmemb("Pin2_8bit.txt",data2);

reg [15:0] i;
	
	initial begin
		// Initialize Inputs
		in1 = 0;
		in2 = 0;
        clk = 0;

		
		// Wait 100 ns for global reset to finish
		#100 i=0; 
        #655500;
		#100;
		
		$fclose(outfile);
		$finish;
	end
	
 always #5 clk=~clk;

  always @(posedge clk) begin			
 	in1=data1[i];	
	in2=data2[i];
	if(i==16'hffff)
  	      $finish;
	else i = i + 1;
 end

initial outfile = $fopen("error_8bit.txt", "wb");

reg [N-1:0] result [1:65536];
initial $readmemb("Pout_8bit_ES4.txt",result);

endmodule

