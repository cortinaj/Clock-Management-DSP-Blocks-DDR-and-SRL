`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2025 10:16:25 PM
// Design Name: 
// Module Name: blender
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


module blender(
    input wire [7:0] P0,
    input wire [7:0] P1,
    input wire [7:0] alpha,
    output wire [7:0] Pf
    );
    
    //Weighted average: Pf =  Pf = (P0*alpha + P1*(255-alpha)) / 256
    assign Pf = (P0 * alpha + P1 * ((1<<8) - alpha)) >> 8;
    
endmodule
