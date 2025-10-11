`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2025 01:06:21 AM
// Design Name: 
// Module Name: blender3_tb
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


module blender3_tb();
  reg clk_in, rst, sel;
    reg [7:0] P0_tb, P1_tb, alpha_tb, one_minus_alpha_tb;
    wire [7:0] Pf_tb;

    // 16-cycle delayed version of P0
    reg [7:0] P0_delay_tb [0:15];
    integer i;
    wire [7:0] P0_delayed = P0_delay_tb[15];

    // Instantiate DUT
    blender3 dut (
        .clk(clk_in),
        .rst(rst),
        .sel(sel),
        .P0(P0_delayed), // << delayed version fed in
        .P1(P1_tb),
        .alpha(alpha_tb),
        .one_minus_alpha(one_minus_alpha_tb),
        .Pf(Pf_tb)
    );

    // 50 MHz clock
    initial clk_in = 0;
    always #10 clk_in = ~clk_in; // 20ns period

    // Sine generation
    integer count = 0;
    integer N = 64;
    real amplitude0 = 100.0;
    real amplitude1 = 80.0;
    real pi = 3.141592653589793;
    integer sample_div = 8;
    integer sample_count = 0;

    always @(posedge clk_in) begin
        if (!rst) begin
            P0_tb <= 8'd0;
            P1_tb <= 8'd0;
            count <= 0;
            sample_count <= 0;
        end else begin
            if (sample_count == sample_div) begin
                P0_tb <= 128 + $rtoi(amplitude0 * $sin(2 * pi * count / N));
                P1_tb <= 128 + $rtoi(amplitude1 * $sin(2 * pi * count / N + pi/2));
                count <= count + 1;
                sample_count <= 0;
                if (count % N == 0)
                    sel <= ~sel;
            end else begin
                sample_count <= sample_count + 1;
            end
        end
    end

    // emulate shift delay (16 cycles)
    always @(posedge clk_in or negedge rst) begin
        if (!rst) begin
            for (i = 0; i < 16; i = i + 1)
                P0_delay_tb[i] <= 8'd0;
        end else begin
            P0_delay_tb[0] <= P0_tb;
            for (i = 1; i < 16; i = i + 1)
                P0_delay_tb[i] <= P0_delay_tb[i - 1];
        end
    end

    initial begin
        rst = 0;
        sel = 1;
        alpha_tb = 8'd128;
        one_minus_alpha_tb = 8'd127;
        #100; rst = 1;
        #50000;
        $finish;
    end
endmodule
