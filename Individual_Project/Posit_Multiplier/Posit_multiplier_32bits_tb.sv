/////////////////////////////////////////////////////////////////////
// Design unit: Posit Multiplier Testbench
//            :
// File name  : Posit_multiplier_32bits_tb.sv
//            :
// Description: Test 32-bit Posit Multiplier
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Xiaoan(Jasper) He 
//            : xh2g20@ecs.soton.ac.uk
//
// Revision   : Version 1.0 20/02/2023
/////////////////////////////////////////////////////////////////////

timeunit 1ns; timeprecision 1ps;

module Posit_Adder_32Bit_tb;
parameter N = 32, RS = $clog2(N), ES = 4;

//input logic
logic signed [N-1:0] IN1, IN2;

//output logic
logic signed [N-1:0] OUT;
reg outfile;

Posit_Multiplier #(.N(N), .ES(ES)) Posit_Mult (.*);

initial 
    begin
        outfile = $fopen("32bit_out.txt", "wb");
        #10
        IN1 = '0;
        IN2 = '0;
        #90 // test action related to infinity
        IN1 = 32'b10000000000000000000000000000000; // inf
        IN2 = 32'b10101001001010101010010001010110; // random number
    //  OUT = 32'b10000000000000000000000000000000; // inf
        $fwrite(outfile, "%d\n",OUT);
        #50
        IN1 = 32'b01001001010101001010011100100010; // random number
        IN2 = 32'b10000000000000000000000000000000; // inf
    //  OUT = 32'b10000000000000000000000000000000;
        $fwrite(outfile, "%d\n",OUT);
        #50 // test action related to zero
        IN1 = 32'b00000000000000000000000000000000; // 0
        IN2 = 32'b01010100101010101010010101000101; // random number
    //  OUT = 32'b00000000000000000000000000000000;
        $fwrite(outfile, "%d\n",OUT);
        #50
        IN1 = 32'b01001001010101001010011100100010; // random number
        IN2 = 32'b00000000000000000000000000000000; // 0
    //  OUT = 32'b00000000000000000000000000000000;
        $fwrite(outfile, "%d\n",OUT);
        #50 // pos_max_float_real x pos_max_float_real
        IN1 = 32'b01111111110000000000000000000000;
        IN2 = 32'b01111111110000000000000000000000;
    //  OUT = 32'b01111111111111111100000000000000;
        $fwrite(outfile, "%d\n",OUT);
        #50 //  neg_max_float_real x neg_max_float_real
        IN1 = 32'b10000000010000000000000000000000;
        IN2 = 32'b10000000010000000000000000000000;
    //  OUT = 32'b01111111111111111100000000000000;
        $fwrite(outfile, "%d\n",OUT);
        #50 // pos_max_float_real x neg_max_float_real
        IN1 = 32'b01111111110000000000000000000000;
        IN2 = 32'b10000000010000000000000000000000;
    //  OUT = 32'b10000000000000000100000000000000;
        $fwrite(outfile, "%d\n",OUT);
        // #50
        // IN1 = 32'b0_10_0000_0000000000000000000000000;
        // IN2 = 32'b1_10_0000_0000000000000000000000000;
        // #50ns
        // IN1 = 32'b0_10_0000_0000000000000000000000000;
        // IN2 = 32'b1_10_0000_1000000000000000000000000;
        $fclose(outfile);
    end



endmodule