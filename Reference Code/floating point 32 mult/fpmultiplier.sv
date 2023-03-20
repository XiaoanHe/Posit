module fpmultiplier(
  output logic signed [31:0] product, output logic ready,
  input logic signed [31:0] a, input logic clock, nreset
  );

//timeunit 1ns; timeprecision 10ps;

logic sign_p;
logic sign_a;
logic sign_b;
logic [7:0] exponent_p;
logic [7:0] exponent_a;
logic [7:0] exponent_b;
logic [47:0] mantissa_c;
logic [22:0] mantissa_p;
logic [22:0] mantissa_a;
logic [22:0] mantissa_b;

// ----------- state declaration ----------
enum {R, A, B, C} state;

// ------- state + next state logic -------
always_ff @(posedge clock, negedge nreset)
  begin
    if (!nreset)
      begin
        product <= '0;
        ready <= '0;
        sign_a <= '0;
        sign_b <= '0;
        exponent_a <= '0;
        exponent_b <= '0;
        mantissa_a <= '0;
        mantissa_b <= '0;
      end
    else
      begin
        case (state)
        R:begin
            ready <= 0;
            state <= A;
          end    
        A:begin
            sign_a <= a [31];
            exponent_a <= a [30:23];
            mantissa_a <= a [22:0];
            state <= B;
          end
        B:begin
            sign_b <= a [31];
            exponent_b <= a [30:23];
            mantissa_b <= a [22:0];
            state <= C;
          end
        C:begin
            ready <= 1;
            product <= {sign_p, exponent_p, mantissa_p};
            state <= R;
          end
        endcase
      end
  end

//------ speacial case 0, +/- infinite, NaN--------
// a = 0
always_comb
  begin
  sign_p = '0;
  exponent_p = '0;
  mantissa_c = '0;
  mantissa_p = '0;
    if ({sign_a, exponent_a, mantissa_a} == '0)   
      begin
        if ({sign_b, exponent_b, mantissa_b} == '0)  // b = 0
          begin 
            sign_p = '0;
            exponent_p = '0;
            mantissa_p = '0;
          end
        else if ({sign_b, exponent_b, mantissa_b} == 32'b0_11111111_00000000000000000000000 || {sign_b, exponent_b, mantissa_b} == 32'b1_11111111_00000000000000000000000)                 // b = +/- infinite
          begin
            sign_p = '0;
            exponent_p = '1;
            mantissa_p = 23'b00000000100111101010100;
          end
        else if (exponent_b == '1 && mantissa_b !== '0) // b = NaN
          begin
            sign_p = '0;
            exponent_p = '1;
            mantissa_p = 23'b00000000100111101010100;
          end 
        else  // b = normal number
          begin
                sign_p = '0;
                exponent_p = '0;
                mantissa_p = '0;
          end 
      end
// a = +infinite
    else if ({sign_a, exponent_a, mantissa_a} == 32'b0_11111111_00000000000000000000000)
      begin
        if ({sign_b, exponent_b, mantissa_b} == '0)  // b = 0
          begin 
            sign_p = '0;
            exponent_p = '1;
            mantissa_p = 23'b00000000100111101010100;
          end
        else if ({sign_b, exponent_b, mantissa_b} == 32'b0_11111111_00000000000000000000000)   // b = +infinite           
          begin
            sign_p = '0;
            exponent_p = '1;
            mantissa_p = '0;
          end
        else if ({sign_b, exponent_b, mantissa_b} == 32'b1_11111111_00000000000000000000000)   // b = -infinite
          begin
            sign_p = '1;
            exponent_p = '1;
            mantissa_p = '0;
          end
        else if (exponent_b == '1 && mantissa_b !== '0)  // b = NaN
          begin
            sign_p = '0;
            exponent_p = '1;
            mantissa_p = 23'b00000000100111101010100;
          end
        else    // b = normal number
          begin
            if (sign_b == '0)
              begin
                sign_p = '0;
                exponent_p = '1;
                mantissa_p = '0;
              end 
            else
              begin
                sign_p = '1;
                exponent_p = '1;
                mantissa_p = '0;
              end
          end
      end
// a = -infinite
    else if ({sign_a, exponent_a, mantissa_a} == 32'b1_11111111_00000000000000000000000)
      begin
        if ({sign_b, exponent_b, mantissa_b} == '0)  // b = 0
          begin
            sign_p = '0;
            exponent_p = '1;
            mantissa_p = 23'b00000000100111101010100;
          end  
        else if ({sign_b, exponent_b, mantissa_b} == 32'b0_11111111_00000000000000000000000)  // b = +infinite
          begin
            sign_p = '1;
            exponent_p = '1;
            mantissa_p = '0;
          end
        else if ({sign_b, exponent_b, mantissa_b} == 32'b1_11111111_00000000000000000000000)  // b = -infinite
          begin
            sign_p = '0;
            exponent_p = '1;
            mantissa_p = '0;
          end
        else if (exponent_b == '1 && mantissa_b !== '0)  // b = NaN
          begin
            sign_p = '0;
            exponent_p = '1;
            mantissa_p = 23'b00000000100111101010100;
          end
        else // n = normal number
          begin
            if (sign_b == 0)
              begin
                sign_p = '1;
                exponent_p = '1;
                mantissa_p = '0;
              end 
            else
              begin
                sign_p = '0;
                exponent_p = '1;
                mantissa_p = '0;
              end
          end            
      end
// a = NaN
    else if (exponent_a == '1 && mantissa_a !== '0)   
      begin
        sign_p = '0;
        exponent_p = '1;
        mantissa_p = 23'b00000000100111101010100;
      end
// a = normal number
    else
      begin      
        if ({sign_b, exponent_b, mantissa_b} == '0)     // b = 0 
          begin 
            sign_p = '0;
            exponent_p = '0;
            mantissa_p = '0;
          end
        else if ({sign_b, exponent_b, mantissa_b} == 32'b0_11111111_00000000000000000000000)    // b = +infinite
          begin
            if(sign_a == '0)
              begin
                sign_p = '0;
                exponent_p = '1;
                mantissa_p = '0;
              end
            else
              begin
                sign_p = '1;
                exponent_p = '1;
                mantissa_p = '0;
              end
          end
        else if ({sign_b, exponent_b, mantissa_b} == 32'b1_11111111_00000000000000000000000)    // b = -infinite
          begin
            if(sign_a == '0)
              begin
                sign_p = '1;
                exponent_p = '1;
                mantissa_p = '0;
              end
            else
              begin
                sign_p = '0;
                exponent_p = '1;
                mantissa_p = '0;
              end
          end
        else if (exponent_b == '1 && mantissa_b !== '0)  // b = NaN
          begin
            sign_p = '0;
            exponent_p = '1;
            mantissa_p = 23'b00000000100111101010100;
          end
//------ normal case ---------
        else
          begin
            sign_p = sign_a ^ sign_b;
            mantissa_c = {1'b1, mantissa_a} * {1'b1, mantissa_b};
          if (mantissa_c [47:46] == 2'b01)
            begin
              mantissa_p = mantissa_c [45:23];
              exponent_p = (exponent_a - 127) + (exponent_b - 127) + 127;
            end
          else if (mantissa_c [47:46] == 2'b10 || mantissa_c [47:46] == 2'b11)
            begin
              mantissa_c = mantissa_c >> 1;
              mantissa_p = mantissa_c [45:23];
              exponent_p = (exponent_a - 127) + (exponent_b - 127) + 127 + 1;
            end
          end
      end
  end
endmodule
      
      
      
      