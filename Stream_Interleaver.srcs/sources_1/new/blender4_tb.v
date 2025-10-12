`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2025 07:58:55 PM
// Design Name: 
// Module Name: blender4_tb
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


module blender4_tb();

    reg clk_in, rst, sel;
    reg [7:0] P0_tb, P1_tb, alpha_tb, one_minus_alpha_tb;
    wire [7:0] Pf_tb;

    // Instantiate DUT (top-level Part IV)
    blender4 dut (
        .clk(clk_in),
        .rst(rst),
        .sel(sel),
        .P0(P0_tb),
        .P1(P1_tb),
        .alpha(alpha_tb),
        .one_minus_alpha(one_minus_alpha_tb),
        .Pf(Pf_tb)
    );

    // 50 MHz input clock
    initial clk_in = 0;
    always #10 clk_in = ~clk_in;  // 20 ns period

    // Sine generation parameters
    integer count = 0;
    integer N = 128;                // samples per sine wave (doubled from 64)
    real amplitude0 = 100.0;
    real amplitude1 = 80.0;
    real pi = 3.141592653589793;

    integer sample_div = 8;         // update rate divider
    integer sample_count = 0;

    // Generate sine wave input signals
    always @(posedge clk_in) begin
        if (!rst) begin
            P0_tb <= 8'd0;
            P1_tb <= 8'd0;
            count <= 0;
            sample_count <= 0;
        end else begin
            if (sample_count == sample_div) begin
                // Two sine waves (P? will be delayed by SRL in domain1_mod)
                P0_tb <= 128 + $rtoi(amplitude0 * $sin(2 * pi * count / N));
                P1_tb <= 128 + $rtoi(amplitude1 * $sin(2 * pi * count / N + pi/2));
                count <= count + 1;
                sample_count <= 0;

                // Toggle select every full sine period (N samples)
                if (count % N == 0)
                    sel <= ~sel;
            end else begin
                sample_count <= sample_count + 1;
            end
        end
    end

    // Initialization & reset
    initial begin
        rst = 0;
        sel = 1;
        alpha_tb = 8'd128;           // 0.5
        one_minus_alpha_tb = 8'd127; // 1 - alpha
        #100;
        rst = 1;                     // release reset

        // Run long enough to visualize full alignment pattern
        #400000;
        $finish;
    end

    // Display progress every few samples
    always @(posedge clk_in) begin
        if (rst && sample_count == 0) begin
            $display("T=%0t ns | sel=%b | P0=%d | P1=%d | Pf=%d | ?=%d | 1-?=%d",
                     $time, sel, P0_tb, P1_tb, Pf_tb, alpha_tb, one_minus_alpha_tb);
        end
    end

endmodule
