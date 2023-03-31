timeunit 1ns; timeprecision 1ps;
module Data_Extraction;
parameter N = 8, RS = $clog2(N), ES = 4;

//input logic
logic signed [N-1:0] In;

//output logic


logic [ES-1:0] Exponent;
// output logic [N-1:0] Mantissa,
logic [(N-1-2-ES):0] Mantissa;
logic signed [N-2:0] InRemain;
logic inf;
logic zero;
logic signed [RS+1:0] RegimeValue;
logic signed Sign;
//output logic

Data_Extraction #(.N(N), .ES(ES)) Extract (.*);

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
		In = 0;
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
 	In=data1[i];	
	if(i==16'hffff)
  	      $finish;
	else i <= i + 1;
 end

always @(negedge clk) begin
end

endmodule