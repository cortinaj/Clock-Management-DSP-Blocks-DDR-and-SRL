`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2025 01:20:03 PM
// Design Name: 
// Module Name: Clk2_domain
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


module Clk2_domain(
    input clk,
    input rst,
    input locked,
    input mux_sel,
    input [7:0] P_input,
    input [7:0] Alpha_input,
    output [7:0] Stream_output
    );
    
   // Synchronization registers
    reg [7:0] P_sync, Alpha_sync;
    reg [15:0] mult1_reg, mult2_reg, sum_reg;
    reg [7:0] Blended_reg, Accumulator_reg;

    wire [7:0] one_minus_alpha = 8'd255 - Alpha_sync;

    // Stage 1: Sync inputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            P_sync <= 8'd0;
            Alpha_sync <= 8'd0;
        end else if (locked) begin
            P_sync <= P_input;
            Alpha_sync <= Alpha_input;
        end
    end

    // Stage 2: Multiplication using DSPs
    (* use_dsp = "yes" *) wire [15:0] mult1 = P_sync * Alpha_sync;
    (* use_dsp = "yes" *) wire [15:0] mult2 = P_sync * one_minus_alpha;

    // Stage 3: Addition using DSPs
    (* use_dsp = "yes" *) wire [15:0] blended_full = mult1 + mult2;

    // Stage 4: Register the blended result
    always @(posedge clk or posedge rst) begin
        if (rst)
            Blended_reg <= 8'd0;
        else if (locked)
            Blended_reg <= blended_full[15:8]; // equivalent to >> 8
    end

    // Stage 5: Accumulate
    wire [7:0] mux_out = mux_sel ? 8'd0 : Accumulator_reg;

    (* use_dsp = "yes" *)
    always @(posedge clk or posedge rst) begin
        if (rst)
            Accumulator_reg <= 8'd0;
        else if (locked)
            Accumulator_reg <= mux_out + Blended_reg;
    end

    assign Stream_output = Accumulator_reg;

endmodule
