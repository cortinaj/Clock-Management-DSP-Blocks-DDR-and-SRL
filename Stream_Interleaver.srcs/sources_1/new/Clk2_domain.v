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
    input [7:0] P_input,
    input [7:0] Alpha_input,
    output [7:0] Stream_output
    );
    
    wire [7:0] P_reg, alpha_reg, blender_reg;
    
    DFF P_dff(.clk(clk),
             .rst(rst),
             .d(P_input),
             .q(P_reg)
             );
             
    DFF A_dff(.clk(clk),
              .rst(rst),
              .d(Alpha_input),
              .q(alpha_reg)
              );
endmodule
