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
// -------------------------------------------------------
    // DUT Inputs / Outputs
    // -------------------------------------------------------
    reg clk_in1;
    reg rst;
    reg sel, sel2, mux_sel;
    reg [7:0] P0_tb, P1_tb, alpha_tb, one_minus_alpha_tb;
    wire [7:0] Pf_tb;
    wire locked;

    // -------------------------------------------------------
    // Instantiate Device Under Test
    // -------------------------------------------------------
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
        .Pf(Pf_tb),
        .locked(locked)
    );

    // -------------------------------------------------------
    // Clock generation
    // -------------------------------------------------------
    localparam CLK_PERIOD = 10; // 100 MHz example
    initial begin
        clk_in1 = 0;
        forever #(CLK_PERIOD/2) clk_in1 = ~clk_in1;
    end

    // -------------------------------------------------------
    // Clock wizard lock emulation
    // -------------------------------------------------------
    reg locked_reg = 0;
    assign locked = locked_reg;  // manually simulate lock behavior

    // -------------------------------------------------------
    // Simulation variables
    // -------------------------------------------------------
    real t;
    real freq = 10e6;
    real clk_period = 10e-9;
    real amplitude0 = 100.0;
    real amplitude1 = 80.0;
    integer n;

    // -------------------------------------------------------
    // Stimulus
    // -------------------------------------------------------
    initial begin
        // Initialize
        rst = 1;
        sel = 1;        // Select P0 initially
        sel2 = 1;       // Select alpha initially
        mux_sel = 0;
        P0_tb = 0;
        P1_tb = 0;
        alpha_tb = 128;
        one_minus_alpha_tb = 255 - alpha_tb;

        $display("===============================================================");
        $display("Time(ns)\tAlpha\tP0\tP1\tMuxSel\tLocked\tPf");
        $display("===============================================================");

        // Hold reset for a few cycles
        #(2*CLK_PERIOD);
        rst = 0;

        // Simulate clock wizard locking after startup
        #(20*CLK_PERIOD);
        locked_reg = 1;
        $display("[%0t ns] Clock wizard locked!", $time);

        // Sweep alpha values and generate sine waves
        for (alpha_tb = 0; alpha_tb <= 255; alpha_tb = alpha_tb + 51) begin
            one_minus_alpha_tb = 255 - alpha_tb;
            $display("\n=== Alpha = %0d ===", alpha_tb);

            for (n = 0; n < 20; n = n + 1) begin
                t = n * clk_period;
                
                // Generate sine wave inputs for P0/P1
                P0_tb = 128 + $rtoi(amplitude0 * $sin(2*3.14159*freq*t));
                P1_tb = 128 + $rtoi(amplitude1 * $sin(2*3.14159*freq*t + 1.0));

                // Toggle mux_sel periodically
                mux_sel = (n % 5 == 0) ? ~mux_sel : mux_sel;

                #CLK_PERIOD;
                $display("%0t\t%0d\t%0d\t%0d\t%b\t%b\t%0d",
                         $time, alpha_tb, P0_tb, P1_tb, mux_sel, locked, Pf_tb);
            end
        end

        // Reset test
        $display("\n--- Reset Test ---");
        rst = 1;
        #(3*CLK_PERIOD);
        rst = 0;
        #(10*CLK_PERIOD);

        $display("===============================================================");
        $display("Simulation Finished at time %0t", $time);
        $display("===============================================================");

        $finish;
    end
endmodule
