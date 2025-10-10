`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2025 07:16:12 PM
// Design Name: 
// Module Name: blender2_test
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


module blender2_test(
    input  wire        clk,            // input reference clock into the clock wizard
    input  wire        rst,            // active-high async reset
    input  wire        P_sel,          // select pixel: 1 -> P0, 0 -> P1  (you requested sel=1 => P0*alpha)
    input  wire        A_sel,          // select alpha: 1 -> alpha, 0 -> one_minus_alpha
    input  wire        Add_sel,        // accumulator control: 1 -> load/start (accum=product), 0 -> accumulate (accum += product)
    input  wire [7:0]  P0,
    input  wire [7:0]  P1,
    input  wire [7:0]  alpha,
    input  wire [7:0]  one_minus_alpha,
    output wire [7:0]  Pf
    );
    
    
    wire clk_out1_wire; // clk1x (50 MHz)
    wire clk_out2_wire; // clk2x (100 MHz)

    clk_wiz_0 clk_gen (
        .clk_out1(clk_out1_wire),
        .clk_out2(clk_out2_wire),
        .reset(rst),
        .clk_in1(clk)
    );

    // ------------------------------------------------------------------
    // MUX selection (combinational) - these are selected BEFORE registration
    // P_sel == 1 -> choose P0 ; P_sel == 0 -> choose P1
    // A_sel == 1 -> choose alpha ; A_sel == 0 -> choose one_minus_alpha
    // ------------------------------------------------------------------
    
    
    reg[7:0] P0_reg, P1_reg, A_reg, A_minus_reg;

    always @(posedge clk_out1_wire or posedge rst) begin
        if(rst) begin
            P0_reg <= 8'b0;
            P1_reg <= 8'b0;
            A_reg <= 8'b0;
            A_minus_reg <= 8'b0;
        end else begin
            P0_reg <= P0;
            P1_reg <= P1;
            A_reg <= alpha;
            A_minus_reg <= one_minus_alpha;
        end
    end
    
    wire [7:0] P_mux = (P_sel) ? P0_reg : P1_reg;
    wire [7:0] A_mux = (A_sel) ? A_reg : A_minus_reg;
            

    // ------------------------------------------------------------------
    // CLK2x DOMAIN: sample the registered values, perform multiply and accumulate
    // (we synchronize by sampling the clk1x-registered values on clk2x)
    // ------------------------------------------------------------------
    reg [7:0] P_sync_clk2;
    reg [7:0] A_sync_clk2;

    always @(posedge clk_out2_wire or posedge rst) begin
        if (rst) begin
            P_sync_clk2 <= 8'd0;
            A_sync_clk2 <= 8'd0;
        end else begin
            // sample the clk1x-registered values into clk2x domain
            P_sync_clk2 <= P_mux;
            A_sync_clk2 <= A_mux;
        end
    end

    (* use_dsp = "yes" *) wire [15:0] mult_result = P_sync_clk2 * A_sync_clk2;

    // 16-bit accumulator in clk2x domain
    reg [15:0] accum_clk2;

    always @(posedge clk_out2_wire or posedge rst) begin
        if (rst) begin
            accum_clk2 <= 16'd0;
        end else begin
            if (Add_sel) begin
                // Load new product (start a new accumulation)
                accum_clk2 <= mult_result;
            end else begin
                // Accumulate product
                accum_clk2 <= accum_clk2 + mult_result;
            end
        end
    end

    // ------------------------------------------------------------------
    // CLK1x DOMAIN: sample the accumulator back into clk1x and present Pf (scaled)
    // We take the top 8 bits [15:8] as the blended 8-bit result (>>8)
    // ------------------------------------------------------------------
    reg [7:0] Pf_reg_clk1;
    always @(posedge clk_out1_wire or posedge rst) begin
        if (rst) begin
            Pf_reg_clk1 <= 8'd0;
        end else begin
            // sample accumulator produced in clk2x domain
            Pf_reg_clk1 <= accum_clk2[15:8];
        end
    end

    assign Pf = Pf_reg_clk1;
endmodule
