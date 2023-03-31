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

module Posit_Adder_32Bit_ES4_tb;
parameter N = 32, RS = $clog2(N), ES = 4;

//input logic
logic signed [N-1:0] IN1, IN2;

//output logic
logic signed [N-1:0] OUT;
reg outfile;

Posit_Multiplier #(.N(N), .ES(ES)) Posit_Mult_32B_ES4 (.*);

initial 
    begin
        #10
        IN1 = '0;
        IN2 = '0;
        #90 // test action related to infinity
        IN1 = 32'b10000000000000000000000000000000; // inf
        IN2 = 32'b10101001001010101010010001010110; // random number
    //  OUT = 32'b10000000000000000000000000000000; // inf
    //     #50ns
    //     IN1 = 32'b00000010101100000101101101100111;
    //     IN2 = 32'b00000010101001000100010010001101;
        
    //     #50
    //     IN1 = 32'b01001001010101001010011100100010; // random number
    //     IN2 = 32'b10000000000000000000000000000000; // inf
    // //  OUT = 32'b10000000000000000000000000000000;
    //     #50 // test action related to zero
    //     IN1 = 32'b00000000000000000000000000000000; // 0
    //     IN2 = 32'b01010100101010101010010101000101; // random number
    // //  OUT = 32'b00000000000000000000000000000000;
    //     #50
    //     IN1 = 32'b01001001010101001010011100100010; // random number
    //     IN2 = 32'b00000000000000000000000000000000; // 0
    //  OUT = 32'b00000000000000000000000000000000;
    //     #50 // 3.402823669209385e+38 * 3.402823669209385e+38
    //     IN1 = 32'b01111111110000000000000000000000;
    //     IN2 = 32'b01111111110000000000000000000000;
    // //  OUT = 32'b01111111111111111100000000000000;

    //     #50 //  1.401298464324817e-45 * 1.401298464324817e-45
    //     IN1 = 32'b00000000000110110000000000000000;
    //     IN2 = 32'b00000000000110110000000000000000;
    // //  OUT = 32'b01111111111111111100000000000000;

    //     #50 // 0.1*0.2 
    //     IN1 = 32'b00111001001100110011001100110011;
    //     IN2 = 32'b00111011001100110011001100110011;

    //     #50 //  65536.1 * 65536.2
    //     IN1 = 32'b01100000000000000000000000011010;
    //     IN2 = 32'b01100000000000000000000000110011;

    //     #50 //  2.5360001004671242e-17 * 5.000001076526666e-39 
    //     IN1 = 32'b00000110001101001111001111001110;
    //     IN2 = 32'b00000000010000101100111000111111;

    //     #50 //  2.5360001004671242e-7 * 5.000001076526666e-39 
    //     IN1 = 32'b00011010000100000100110100001010;
    //     IN2 = 32'b00000000010000101100111000111111;

        // #50 //  0.7 * 0.1
        // IN1 = 32'b00111110110011001100110011001101;
        // IN2 = 32'b00111001001100110011001100110011;

        // #50 //  0.2 * 0.1
        // IN1 = 32'b00111011001100110011001100110011;
        // IN2 = 32'b00111001001100110011001100110011;

        // #50 //  0.1 * 0.9
        // IN1 = 32'b00111001001100110011001100110011;
        // IN2 = 32'b00111111100110011001100110011010;

        // #50 //  10000.7 * 10000.1 gets 100008000
        // IN1 = 32'b01011010011100010000101100110011;
        // IN2 = 32'b01011010011100010000000110011010;

        // #50 //  10000.2 * 10000.1 gets 100003000
        // IN1 = 32'b01011010011100010000001100110011;
        // IN2 = 32'b01011010011100010000000110011010;

        #50 //  20000.89990234375 * 10000.1 gets 200011000
        IN1 = 32'b01011100011100010000011100110011;
        IN2 = 32'b01011010011100010000000110011010;
    end



endmodule