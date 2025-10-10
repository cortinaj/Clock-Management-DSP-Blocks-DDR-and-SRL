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
    output wire [7:0] Add_result
    );
    
    reg [7:0] P_reg, A_reg;
    reg [15:0] Mult_reg, Add_reg;
    wire [7:0] mux_value;
    
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            P_reg <= 8'b0;
            A_reg <= 8'b0;
            Mult_reg <= 8'b0;
            Add_reg <= 8'b0;
        end else begin
            P_reg <= P_value;
            A_reg <= A_value;
            Mult_reg <= P_reg * A_reg;
            Add_reg <= Mult_reg + mux_value;
        end
    end
    
    assign Add_result = Add_reg;
    assign mux_value = sel ? 8'd0 : Add_result;
    
     
   
   
    
endmodule
