`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2025 08:25:31 PM
// Design Name: 
// Module Name: blender2_test_tb
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

module blender2_test_tb();

  // DUT Inputs
    reg clk;
    reg rst;
    reg P_sel;
    reg A_sel;
    reg Add_sel;
    reg [7:0] P0_tb, P1_tb, alpha_tb, one_minus_alpha_tb;
    wire [7:0] Pf_tb;

    // Instantiate DUT
    blender2_test dut (
        .clk(clk),
        .rst(rst),
        .P_sel(P_sel),
        .A_sel(A_sel),
        .Add_sel(Add_sel),
        .P0(P0_tb),
        .P1(P1_tb),
        .alpha(alpha_tb),
        .one_minus_alpha(one_minus_alpha_tb),
        .Pf(Pf_tb)
    );

    // 50 MHz clock (20 ns period)
    always #10 clk = ~clk;

    // Task for 3-cycle blend test
    task run_blend_cycle(
        input [7:0] P0_val,
        input [7:0] P1_val,
        input [7:0] alpha_val
    );
        begin
            P0_tb = P0_val;
            P1_tb = P1_val;
            alpha_tb = alpha_val;
            one_minus_alpha_tb = 8'd255 - alpha_val;

            $display("\n=== Testing Alpha = %0d (P0=%0d, P1=%0d) ===", alpha_val, P0_val, P1_val);

            // --- Cycle 1: P0 * alpha ---
            P_sel = 1; A_sel = 1; Add_sel = 1;
            #40; // Wait two clock periods
            $display("[%0t ns] Cycle 1: P_sel=%b A_sel=%b Add_sel=%b => Pf=%0d", 
                     $time, P_sel, A_sel, Add_sel, Pf_tb);

            // --- Cycle 2: P1 * (1 - alpha) ---
            P_sel = 0; A_sel = 0; Add_sel = 0;
            #40;
            $display("[%0t ns] Cycle 2: P_sel=%b A_sel=%b Add_sel=%b => Pf=%0d", 
                     $time, P_sel, A_sel, Add_sel, Pf_tb);

            // --- Cycle 3: Output final blend ---
            #40;
            $display("[%0t ns] Cycle 3: Final Pf=%0d", $time, Pf_tb);
        end
    endtask

    // Test sequence
    initial begin
        clk = 0;
        rst = 1;
        P_sel = 0;
        A_sel = 0;
        Add_sel = 0;
        P0_tb = 0;
        P1_tb = 0;
        alpha_tb = 0;
        one_minus_alpha_tb = 0;

        // Reset
        #100;
        rst = 0;

        $display("Starting 3-cycle blend tests...");

        // 4 test alpha values
        run_blend_cycle(8'd220, 8'd100, 8'd0);    // alpha = 0   ? expect ~P1
        run_blend_cycle(8'd220, 8'd100, 8'd85);   // alpha ? 1/3
        run_blend_cycle(8'd220, 8'd100, 8'd170);  // alpha ? 2/3
        run_blend_cycle(8'd220, 8'd100, 8'd255);  // alpha = 255 ? expect ~P0

        $display("\nAll alpha tests complete.");
        #100;
        $finish;
    end
endmodule
