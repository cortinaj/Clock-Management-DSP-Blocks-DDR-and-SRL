`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2025 07:51:02 PM
// Design Name: 
// Module Name: domain1_bram
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


module domain1_bram(
    input  wire clk,
    input  wire rst,
    input  wire sel,
    input  wire [7:0] inp1,  // P0
    input  wire [7:0] inp2,  // P1
    input  wire [7:0] inp3,  // alpha
    input  wire [7:0] inp4,  // 1-alpha
    output reg  [7:0] P_value,
    output reg  [7:0] A_value
);

    // ===================================================
    // Delay control logic
    // ===================================================
    parameter ADDR_WIDTH = 6;   // 64-depth
    parameter DELAY = 32;       // adjustable delay offset

    reg [ADDR_WIDTH-1:0] wr_addr = 0;
    reg [ADDR_WIDTH-1:0] rd_addr = 0;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            wr_addr <= 0;
            rd_addr <= DELAY;
        end else begin
            wr_addr <= wr_addr + 1'b1;
            rd_addr <= rd_addr + 1'b1;
        end
    end

    // ===================================================
    // Dual-port BRAM delay element
    // ===================================================
    wire [7:0] P0_delay_raw;
    reg  [7:0] P0_delay_reg; // pipeline aligner for BRAM latency

    blk_mem_gen_0 bram_inst (
        .clka(clk),
        .ena(1'b1),
        .wea(1'b1),
        .addra(wr_addr),
        .dina(inp1),          // write new P0 sample
        .clkb(clk),
        .enb(1'b1),
        .addrb(rd_addr),
        .doutb(P0_delay_raw)  // read delayed sample
    );

    // ===================================================
    // Pipeline register for BRAM output (critical!)
    // ===================================================
    always @(posedge clk or negedge rst) begin
        if (!rst)
            P0_delay_reg <= 8'd0;
        else
            P0_delay_reg <= P0_delay_raw; // absorb BRAM latency
    end

    // ===================================================
    // Output selection logic
    // ===================================================
    reg [7:0] P1_reg, A_reg, A_minus_reg;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            P1_reg      <= 8'd0;
            A_reg       <= 8'd0;
            A_minus_reg <= 8'd0;
        end else begin
            P1_reg      <= inp2;
            A_reg       <= inp3;
            A_minus_reg <= inp4;
        end
    end

    // Output selection (registered BRAM version)
    always @(*) begin
        P_value = sel ? P0_delay_reg : P1_reg;
        A_value = sel ? A_reg : A_minus_reg;
    end

endmodule
