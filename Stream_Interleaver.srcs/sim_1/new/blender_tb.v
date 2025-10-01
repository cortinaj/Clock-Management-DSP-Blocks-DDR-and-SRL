`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2025 10:21:05 PM
// Design Name: 
// Module Name: blender_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module blender_tb();

    //Inputs to DUT
    reg [7:0] P0_tb, P1_tb, alpha_tb;
    wire [7:0] Pf_tb;
    
    //Instantiate DUT
    blender dut (.P0(P0_tb),
                 .P1(P1_tb),
                 .alpha(alpha_tb),
                 .Pf(Pf_tb)
                 );
                 
    real t;
    real freq = 10e6;
    real clk_period = 10e-9;
    real amplitude0 = 100.0;
    real amplitude1 = 80.0;
    
    integer n;
    initial begin
    $display("time(ns)\talpha\tP0\tP1\tPf");
    // Explicit endpoint test: alpha=0 -> Pf = P1
    alpha_tb = 0;
    P0_tb = 200; P1_tb = 123;
    #10;
    $display("Endpoint test ?=0: Pf=%0d (should equal P1=%0d)", Pf_tb, P1_tb);

    // Explicit endpoint test: alpha=255 -> Pf ? P0
    alpha_tb = 255;
    P0_tb = 200; P1_tb = 123;
    #10;
    $display("Endpoint test ?=255: Pf=%0d (should equal P0=%0d)", Pf_tb, P0_tb);
    // Sweep alpha from 0 to 255 in steps
    for (alpha_tb = 0; alpha_tb <= 255; alpha_tb = alpha_tb + 51) begin
      $display("=== Alpha = %0d ===", alpha_tb);

      // Generate 20 sine samples for each alpha value
      for (n = 0; n < 20; n = n + 1) begin
        t = n * clk_period;

        // Two different sine waves (scaled to 8 bits)
        P0_tb = 128 + $rtoi(amplitude0 * $sin(2*3.14159*freq*t));
        P1_tb = 128 + $rtoi(amplitude1 * $sin(2*3.14159*freq*t + 1.0)); // phase shift

        #10; // wait 10 ns (system clock tick)

        $display("%0t\t%0d\t%0d\t%0d\t%0d", $time, alpha_tb, P0_tb, P1_tb, Pf_tb);
      end
    end

    $finish;
  end
endmodule
