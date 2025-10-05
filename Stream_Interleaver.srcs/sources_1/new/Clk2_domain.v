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
    
    reg [7:0] P_sync, Alpha_sync, Blended_reg;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            P_sync <= 8'b0;
            Alpha_sync <= 8'b0;
        end else begin
            P_sync <= P_input;
            Alpha_sync <= Alpha_input;
        end
    end
    
    
    

endmodule
