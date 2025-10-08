`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2025 07:29:50 PM
// Design Name: 
// Module Name: blender2
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


module blender2(
   input clk_in1,
    input rst,
    input sel, sel2, mux_sel,
    input [7:0] P0, P1, alpha, one_minus_alpha,
    output reg [7:0] Pf
    );

   // ---------------------------------------------------------------------
    // Clocking Wizard Instantiation
    // ---------------------------------------------------------------------
    wire clk_out1, clk_out2;

    clk_wiz_0 clk_gen (
        .clk_out1(clk_out1),
        .clk_out2(clk_out2),
        .reset(rst),
        .clk_in1(clk_in1)
    );

    // ---------------------------------------------------------------------
    // Stage 1: Register Inputs (clk_out1 domain)
    // ---------------------------------------------------------------------
    reg [7:0] P0_reg, P1_reg, Alpha_reg;

    always @(posedge clk_out1 or posedge rst) begin
        if (rst) begin
            P0_reg <= 0;
            P1_reg <= 0;
            Alpha_reg <= 0;
        end else begin
            P0_reg <= P0;
            P1_reg <= P1;
            Alpha_reg <= alpha;
        end
    end

    // ---------------------------------------------------------------------
    // Stage 2: Blend Calculation (Combinational)
    // Formula: Pf = (P0 * alpha + P1 * (255 - alpha)) >> 8
    // ---------------------------------------------------------------------
    reg [15:0] mult0, mult1, sum;
    reg [7:0] blend_result;

    always @(*) begin
        mult0 = P0_reg * Alpha_reg;
        mult1 = P1_reg * (8'd255 - Alpha_reg);
        sum = mult0 + mult1;
        blend_result = sum[15:8];
    end

    // ---------------------------------------------------------------------
    // Stage 3: Optional Accumulator Output (clk_out2 domain)
    // ---------------------------------------------------------------------
    reg [7:0] accumulator;

    always @(posedge clk_out1 or posedge rst) begin
        if (rst) begin
            accumulator <= 0;
            Pf <= 0;
        end else begin
            accumulator <= accumulator + blend_result;
            Pf <= (mux_sel) ? blend_result : accumulator;
        end
    end
endmodule
