/////////////////////////////////////////////////////////////////////
// Design unit: Posit Adder Testbench
//            :
// File name  : Posit_Adder_tb.sv
//            :
// Description: Test Posit Adder
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan(Jasper) He 
//            : xh2g20@ecs.soton.ac.uk
//
// Revision   : Version 1.0 08/02/2023
/////////////////////////////////////////////////////////////////////
timeunit 1ns; timeprecision 1ps;

module Posit_Adder_tb;
parameter N = 8, RS = $clog2(N), ES = 3;

//input logic
logic signed [N-1:0] IN1, IN2;

//output logic
logic signed [N-1:0] OUT;

Posit_Adder #(.N(N), .ES(ES)) PA_tb (.*);

reg clk;
integer outfile;

reg start;
reg [N-1:0] data1 [1:65536];
reg [N-1:0] data2 [1:65536];
initial $readmemb("Pin1_8bit.txt",data1);
initial $readmemb("Pin2_8bit.txt",data2);

reg [15:0] i;
	
	initial begin
		// Initialize Inputs
		IN1 = 0;
		IN2 = 0;
		clk = 0;
		start = 0;
	
		
		// Wait 100 ns for global reset to finish
		#100 i=0;
		#20 start = 1;
                #655500 start = 0;
		#100;
		
		$fclose(outfile);
		$finish;
	end

 always #5 clk=~clk;

  always @(posedge clk) begin			
 	IN1=data1[i];	
	IN2=data2[i];
	if(i==16'hffff)
  	      $finish;
	else i = i + 1;
 end

initial outfile = $fopen("error_8bit.txt", "wb");

reg [N-1:0] result [1:65536];
reg [N-1:0] show_result;
initial $readmemb("Pout_8bit_ES4.txt",result);
reg [N-1:0] diff;
always @(negedge clk) begin
	if(start)begin
        show_result = result[i-1];
     	diff = (result[i-1] > OUT) ? result[i-1]-OUT : OUT-result[i-1];
     	//$fwrite(outfile, "%h\t%h\t%h\t%h\t%d\n",in1, in2, out,result[i-1],diff);
     	$fwrite(outfile, "%d\n",diff);
     	end
end


// initial 
//     begin
//         #10ns 
//         IN1 = 8'b0_0000000;
//         IN2 = 8'b0_0000000;

//         IN1 = 8'b0_0000011;
//         IN2 = 8'b0_0000000;
//         #50ns   //  56-10
//         IN1 = 8'b01010111;
//         IN2 = 8'b10110011;

//         #50ns   //  1-0.875
//         IN1 = 8'b01000000 ;
//         IN2 = 8'b11000001;

//         #50ns   //  -0.5+1.75
//         IN1 = 8'b11000100;
//         IN2 = 8'b01000011;

//         #50ns   //  3-2
//         IN1 = 8'b01000110;
//         IN2 = 8'b10111100;

//         // #50ns   //  56-10
//         // IN1 = 8'b01010111;
//         // IN2 = 8'b10110011;

//         #50ns   //  65536+112
//         IN1 = 8'b0_1110_000;
//         IN2 = 8'b0_10_110_11;

//         #50ns   // 524288+1024
//         IN1 = 8'b0_1110_011;
//         IN2 = 8'b0_110_010_0;

//         #50ns   // 10+12
//         IN1 = 8'b0_10_011_01;
//         IN2 = 8'b0_10_011_10;
        
//         #50ns   // 40+24
//         IN1 = 8'b0_10_101_01;
//         IN2 = 8'b0_10_100_10;

//          #50ns   // 0.0234375+0.01953125
//         IN1 = 8'b0_01_010_10;
//         IN2 = 8'b0_01_010_01;

//          #50ns   // 0.125+0.15625
//         IN1 = 8'b0_01_101_00;
//         IN2 = 8'b0_01_101_01;
//     end



endmodule