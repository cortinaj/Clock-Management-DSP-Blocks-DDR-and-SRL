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
    input [7:0] inp1, //P0
    input [7:0] inp2, //P1
    input [7:0] inp3, // alpha
    input [7:0] inp4, // 1 - alpha
    input sel, sel2,
    output [7:0] out1,
    output [7:0] out2
    );
    
    wire [7:0] inp1_reg, inp2_reg, inp3_reg, inp4_reg;
    
    //Instantiate D FF
    DFF dff1(.clk(clk),
             .rst(rst),
             .d(inp1),
             .q(inp1_reg));
    
    DFF dff2(.clk(clk),
             .rst(rst),
             .d(inp2),
             .q(inp2_reg));
    
    DFF dff3(.clk(clk),
             .rst(rst),
             .d(inp3),
             .q(inp3_reg));
    
    DFF dff4(.clk(clk),
             .rst(rst),
             .d(inp4),
             .q(inp4_reg));
             
    //Mux instantiate
    Mux2_1 mux_top(.a(inp1_reg),
                   .b(inp2_reg),
                   .sel(sel1),
                   .y(out1)
                   );
    
    Mux2_1 mux_bot(.a(inp3_reg),
                   .b(inp4_reg),
                   .sel(sel2),
                   .y(out2)
                   );
                   
endmodule
