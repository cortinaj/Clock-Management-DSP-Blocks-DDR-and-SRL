`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2025 07:56:37 PM
// Design Name: 
// Module Name: domain2_bram
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

(* use_dsp = "yes" *)
module domain2_bram (
    input clk, rst, sel,
    input [7:0] P_value,
    input [7:0] A_value,
    output reg [15:0] Add_result
    );

    // Internal registers
    reg [15:0] mult_P0, mult_P1;
    reg [15:0] term_P0, term_P1;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            mult_P0   <= 16'd0;
            mult_P1   <= 16'd0;
            term_P0   <= 16'd0;
            term_P1   <= 16'd0;
            Add_result <= 16'd0;
        end else begin
            // Compute product depending on sel
            if (sel) begin
                mult_P0 <= P_value * A_value;   // compute P0 × ?
                term_P0 <= P_value * A_value;
            end else begin
                mult_P1 <= P_value * A_value;   // compute P1 × (1-?)
                term_P1 <= P_value * A_value;
            end

            // Blend the two results together every clock
            Add_result <= term_P0 + term_P1;
        end
    end
endmodule
