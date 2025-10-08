`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 11:55:15 PM
// Design Name: 
// Module Name: blender3
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


module blender3(
    input clk_in1,
    input rst,
    input sel, sel2,mux_sel,
    input [7:0] P0, P1, alpha, one_minus_alpha,
    output [7:0] Pf,
    output locked
    );
     //clock Signals
   wire clk_out1, clk_out2;
   
   //Wires between Clk1 domain and Clk2 domain
   wire [7:0] P_sync, Alpha_sync;
   
   //Output of clk2 domain
   wire [7:0] Stream_output;
   
   //Register to store for Pf
   reg [7:0] Pf_reg;
   
   clk_wiz_0 inst(.clk_out1(clk_out1),
                          .clk_out2(clk_out2),               
                          .reset(rst), 
                          .locked(locked),
                          .clk_in1(clk_in1)
                         );
                         
    Clk1_Mod domain1(.clk(clk_out1),
                 .rst(rst),
                 .locked(locked),
                 .inp1(P0),
                 .inp2(P1),
                 .inp3(alpha),
                 .inp4(one_minus_alpha),
                 .sel(sel),
                 .sel2(sel2),
                 .out1(P_sync),
                 .out2(Alpha_sync)
                );
                
    Clk2_domain domain2(.clk(clk_out2),
                        .rst(rst),
                        .locked(locked),
                        .mux_sel(mux_sel),
                        .P_input(P_sync),
                        .Alpha_input(Alpha_sync),
                        .Stream_output(Stream_output)
                        );
    
    always @(posedge clk_out1 or posedge rst) begin
        if(rst) begin
            Pf_reg <= 8'b0;
        end else if(locked)begin
            Pf_reg <= Stream_output;
        end
    end
    
    assign Pf = Pf_reg;
    
endmodule
