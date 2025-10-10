`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2025 07:29:50 PM
// Design Name: 
// Module Name: blender2
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


module blender2(
    input clk,
    input rst,
    input sel,
    input [7:0] P0, P1, alpha, one_minus_alpha,
    output reg [7:0] Pf
    );


    wire clk_out1, clk_out2;
    wire [7:0] P_value, A_value;
    wire [7:0] Add_result;

    clk_wiz_0 clk_gen (
        .clk_out1(clk_out1),
        .clk_out2(clk_out2),
        .reset(rst),
        .clk_in1(clk)
    );
    
    domain1 dut (.clk(clk_out1),
                 .rst(rst),
                 .sel(sel),
                 .inp1(P0),
                 .inp2(P1),
                 .inp3(alpha),
                 .inp4(one_minus_alpha),
                 .P_value(P_value),
                 .A_value(A_value)
                 );
                 
    domain2 dut2 (.clk(clk_out2),
                  .rst(rst),
                  .sel(sel),
                  .P_value(P_value),
                  .A_value(A_value),
                  .Add_result(Add_result)
                 );
                 
    always@(posedge clk_out1 or negedge rst) begin
        if(!rst) begin
            Pf <= 8'b0;
        end else begin
            Pf <= Add_result;
        end
    end
               
endmodule