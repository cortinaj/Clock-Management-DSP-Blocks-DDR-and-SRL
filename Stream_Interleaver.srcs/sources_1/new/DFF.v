`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2025 10:38:45 PM
// Design Name: 
// Module Name: DFF
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


module DFF(
    input clk,
    input rst,
    input [7:0] d,
    output reg [7:0] q
    );
    
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            q <= 8'b0;
        end else begin
            q <= d;
        end
    end
endmodule
