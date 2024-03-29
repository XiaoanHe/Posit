/////////////////////////////////////////////////////////////////////
// Design unit: Posit Adder Testbench
//            :
// File name  : Posit_Adder_32bits_tb-4.sv
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
// Revision   : Version 1.0 20/02/2023
/////////////////////////////////////////////////////////////////////

timeunit 1ns; timeprecision 1ps;

module Posit_Adder_32Bit_es4_tb;
parameter N = 32, RS = $clog2(N), ES = 4;

//input logic
logic signed [N-1:0] IN1, IN2, tmp_in1, tmp_in2;

//output logic
logic signed [N-1:0] OUT;

Posit_Adder #(.N(N), .ES(ES)) PA_tb (.*);

initial 
    begin
        #10
        IN1 = '0;
        IN2 = '0;

        #90
        IN1 = 32'b01111111000111001001111100101101;
        IN2 = 32'b10000000111000110110000011010011;
        tmp_in1 = OUT;
        #50
        IN1 = 32'b10000000111000110110000011010011;
        IN2 = 32'b01000000000000000000000000000000;
        #5
        tmp_in2 = OUT;
        #50
        IN1 = tmp_in1;
        IN2 = 32'b01000000000000000000000000000000;
        #50
        IN1 = 32'b01111111000111001001111100101101;
        IN2 = tmp_in2;
    //     #90 // test action related to infinity
    //     IN1 = 32'b10000000000000000000000000000000; // inf
    //     IN2 = 32'b10101001001010101010010001010110; // random number
    // //  OUT = 32'b10000000000000000000000000000000; // inf

    //     #50
    //     IN1 = 32'b01001001010101001010011100100010; // random number
    //     IN2 = 32'b10000000000000000000000000000000; // inf
    // //  OUT = 32'b10000000000000000000000000000000;

    //     #50 // test action related to zero
    //     IN1 = 32'b00000000000000000000000000000000; // 0
    //     IN2 = 32'b01010100101010101010010101000101; // random number
    // //  OUT = 32'b01010100101010101010010101000101;

    //     #50
    //     IN1 = 32'b01001001010101001010011100100010; // random number
    //     IN2 = 32'b00000000000000000000000000000000; // 0
    // //  OUT = 32'b01001001010101001010011100100010;

    //     #50 // +max_float_real + +max_float_real
    //     IN1 = 32'b01111111110000000000000000000000;
    //     IN2 = 32'b01111111110000000000000000000000;
    // //  OUT = 32'b01111111110000100000000000000000;

    //     #50 // (-) max_float_real + (-) max_float_real
    //     IN1 = 32'b10000000010000000000000000000000;
    //     IN2 = 32'b10000000010000000000000000000000;
    // //  OUT = 32'b10000000001111100000000000000000;

    //     #50 // +max_float_real + (-)max_float_real
    //     IN1 = 32'b01111111110000000000000000000000;
    //     IN2 = 32'b10000000010000000000000000000000;
    // //  OUT = 32'b00000000000000000000000000000000;

    //     #50 //  0.1 + 0.2
    //     IN1 = 32'b0_01_1100_1001100110011001100110011;
    //     IN2 = 32'b0_01_1101_1001100110011001100110011;

    //     #50 //  0.3 - 0.2
    //     IN1 = 32'b00111000110011001100110011001101;
    //     IN2 = 32'b11000100110011001100110011001101;

        // #50
        // IN1 = 32'b0_10_0000_0000000000000000000000000;
        // IN2 = 32'b1_10_0000_0000000000000000000000000;
        // #50ns
        // IN1 = 32'b0_10_0000_0000000000000000000000000;
        // IN2 = 32'b1_10_0000_1000000000000000000000000;
    end



endmodule