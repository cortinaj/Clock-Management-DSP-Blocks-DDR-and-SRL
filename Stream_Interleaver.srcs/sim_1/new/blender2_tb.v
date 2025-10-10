`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2025 07:56:47 PM
// Design Name: 
// Module Name: blender2_tb
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


module blender2_tb();
// Testbench signals
    reg clk_in1;
    reg rst;
    reg sel, sel2, mux_sel;
    reg [7:0] P0_tb, P1_tb, alpha_tb, one_minus_alpha_tb;
    wire [7:0] Pf_tb;

    // Clock generation
    initial begin
        clk_in1 = 0;
        forever #5 clk_in1 = ~clk_in1;  // 100 MHz clock
    end

    // Instantiate DUT (blender2)
    blender2 dut (
        .clk_in1(clk_in1),
        .rst(rst),
        .sel(sel),
        .sel2(sel2),
        .mux_sel(mux_sel),
        .P0(P0_tb),
        .P1(P1_tb),
        .alpha(alpha_tb),
        .one_minus_alpha(one_minus_alpha_tb),
        .Pf(Pf_tb)
    );

    // Test parameters
    real t;
    real freq = 10e6;
    real clk_period = 10e-9;
    real amplitude0 = 100.0;
    real amplitude1 = 80.0;
    integer n;

    initial begin
        // Initialize
        rst = 1;
        sel = 0;
        sel2 = 0;
        mux_sel = 1;
        P0_tb = 0;
        P1_tb = 0;
        alpha_tb = 0;
        one_minus_alpha_tb = 0;
        #20;
        rst = 0;

        $display("time(ns)\talpha\tP0\tP1\tPf");

        // Endpoint test 1: alpha = 0 (should output P1)
        alpha_tb = 0;
        one_minus_alpha_tb = 255 - alpha_tb;
        P0_tb = 200; P1_tb = 123;
        #20;
        $display("Endpoint test alpha=0: Pf=%0d (expected ~P1=%0d)", Pf_tb, P1_tb);

        // Endpoint test 2: alpha = 255 (should output P0)
        alpha_tb = 255;
        one_minus_alpha_tb = 255 - alpha_tb;
        P0_tb = 200; P1_tb = 123;
        #20;
        $display("Endpoint test alpha=255: Pf=%0d (expected ~P0=%0d)", Pf_tb, P0_tb);

        // Alpha sweep test
        for (alpha_tb = 0; alpha_tb <= 255; alpha_tb = alpha_tb + 51) begin
            one_minus_alpha_tb = 255 - alpha_tb;
            $display("=== Alpha = %0d ===", alpha_tb);

            // Generate waveforms
            for (n = 0; n < 20; n = n + 1) begin
                t = n * clk_period;
                P0_tb = 128 + $rtoi(amplitude0 * $sin(2*3.14159*freq*t));
                P1_tb = 128 + $rtoi(amplitude1 * $sin(2*3.14159*freq*t + 1.0));
                #10;
                $display("%0t\t%0d\t%0d\t%0d\t%0d", $time, alpha_tb, P0_tb, P1_tb, Pf_tb);
            end
        end

        $finish;
    end
endmodule