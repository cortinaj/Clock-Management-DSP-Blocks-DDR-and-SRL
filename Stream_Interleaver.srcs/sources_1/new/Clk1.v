`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2025 10:34:27 PM
// Design Name: 
// Module Name: Clk1
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


module Clk1(
    input clk,
    input rst,
    input locked,
    input [7:0] inp1, //P0
    input [7:0] inp2, //P1
    input [7:0] inp3, // alpha
    input [7:0] inp4, // 1 - alpha
    input sel, sel2,
    output reg [7:0] out1,
    output reg [7:0] out2
    );
    
    reg [7:0] P0_reg, P1_reg, Alpha_reg, One_minus_alpha_reg;
    
    //Infer DFFs
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            P0_reg <= 8'b0;
            P1_reg <= 8'b0;
            Alpha_reg <= 8'b0;
            One_minus_alpha_reg <= 8'b0;
        end else if(locked) begin
            P0_reg <= inp1;
            P1_reg <= inp2;
            Alpha_reg <= inp3;
            One_minus_alpha_reg <= inp4;
        end
    end
    
    //Infer Muxs
    always @(*) begin
        out1 = (sel) ? P0_reg : P1_reg;
        out2 = (sel2) ? Alpha_reg : One_minus_alpha_reg;
    end
    
endmodule
