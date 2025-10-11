`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2025 10:41:20 PM
// Design Name: 
// Module Name: domain1_mod
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


module domain1_mod(
    input clk, rst,sel,
    input [7:0] inp1, //P0
    input [7:0] inp2, //P1
    input [7:0] inp3, // alpha
    input [7:0] inp4, //1 - alpha
    output reg [7:0] P_value, //Either has P0 or P1
    output reg [7:0] A_value //Either has Alpha or one minus alpha
    );
    
    wire [7:0] P0_delay;
    c_shift_ram_0 shift_gen(.CLK(clk),
                          .D(inp1),
                          .Q(P0_delay)
                          );
    
    reg [7:0] P0_reg, P1_reg, A_reg, A_minus_reg;
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            P0_reg <= 8'b0;
            P1_reg <= 8'b0;
            A_reg <= 8'b0;
            A_minus_reg <= 8'b0;
        end else begin
            P0_reg <= P0_delay;
            P1_reg <= inp2;
            A_reg <= inp3;
            A_minus_reg <= inp4;
        end
    end
    
    always @(*) begin
        P_value = sel ? P0_reg : P1_reg; //T = P0_reg, F = P1_reg
        A_value = sel ? A_reg : A_minus_reg; //T = A_reg, F = A_minus_reg
    end
    
endmodule
