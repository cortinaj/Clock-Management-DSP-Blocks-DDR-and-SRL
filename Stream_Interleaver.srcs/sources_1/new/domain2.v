`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2025 11:03:16 PM
// Design Name: 
// Module Name: domain2
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
module domain2(
    input clk, rst, sel,
    input [7:0] P_value,
    input [7:0] A_value,
    output reg [15:0] Add_result
    );

  reg [15:0] mult_reg;
    reg [15:0] term_P0, term_P1;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            mult_reg   <= 16'd0;
            term_P0    <= 16'd0;
            term_P1    <= 16'd0;
            Add_result <= 16'd0;
        end else begin
            // Perform the current multiply
            mult_reg <= P_value * A_value;

            // Store result based on sel
            if (sel)
                term_P0 <= mult_reg;   // store P0 * ?
            else
                term_P1 <= mult_reg;   // store P1 * (1-?)

            // Once both halves are available, sum them
            Add_result <= term_P0 + term_P1;
        end
    end
endmodule
