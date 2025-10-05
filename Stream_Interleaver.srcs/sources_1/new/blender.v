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
    
//    // Intermediate 16-bit multiplication results
//    wire [15:0] mult0;
//    wire [15:0] mult1;

//    // Force multipliers to use DSP blocks
//    (* use_dsp = "yes" *) assign mult0 = P0 * alpha;
//    (* use_dsp = "yes" *) assign mult1 = P1 * (8'd255 - alpha);

//    // Add the two products and shift
//    wire [15:0] sum;
//    assign sum = mult0 + mult1;

//    assign Pf = sum[15:8];  // Divide by 256 (shift right 8)
    
endmodule
