`timescale 1ns /1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2025 07:56:47 PM
// Design Name: 
// Module Name: blender2_tb
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


//module blender2_tb();
//   reg clk;
//    reg rst;
//    reg sel;
//    reg [7:0] P0, P1, alpha, one_minus_alpha;
//    wire [7:0] Pf;

//    // Instantiate the DUT
//    blender2 dut (
//        .clk(clk),
//        .rst(rst),
//        .sel(sel),
//        .P0(P0),
//        .P1(P1),
//        .alpha(alpha),
//        .one_minus_alpha(one_minus_alpha),
//        .Pf(Pf)
//    );

//    // Clock generation: 100 MHz
//    initial clk = 0;
//    always #5 clk = ~clk;

//    // Parameters for sine generation
//    real pi = 3.14159265359;
//    integer i;
//    real sine_val;

//    initial begin
//        // Initialize
//        rst = 1'b0;
//        sel = 1'b0;
//        P0 = 8'd0;
//        P1 = 8'd0;
//        alpha = 8'd128;           // 0.5 in Q8
//        one_minus_alpha = 8'd127; // 1-alpha
//        #20;

//        // Release reset
//        rst = 1'b1;
//        #20;

//        // Generate sinusoidal inputs
//        for (i = 0; i < 256; i = i + 1) begin
//            // P0: sine from 0 to 255
//            sine_val = 127.5 + 127.5 * $sin(2.0 * pi * i / 64); // 64-sample period
//            P0 = $rtoi(sine_val);

//            // P1: sine with phase shift
//            sine_val = 127.5 + 127.5 * $sin(2.0 * pi * i / 64 + pi/2);
//            P1 = $rtoi(sine_val);

//            // Blend factor
//            alpha = 8'd128;           // 0.5
//            one_minus_alpha = 8'd127; // 1-alpha

//            // Alternate sel every 32 cycles
//            if (i % 32 == 0)
//                sel = ~sel;

//            #10; // 1 clock cycle (10ns)
//        end

//        $stop;
//    end

//    // Monitor outputs
//    initial begin
//        $monitor("Time=%0t | sel=%b | P0=%d | P1=%d | alpha=%d | one_minus_alpha=%d | Pf=%d",
//                 $time, sel, P0, P1, alpha, one_minus_alpha, Pf);
//    end
module blender2_tb();

    reg clk_in, rst, sel;
    reg [7:0] P0_tb, P1_tb, alpha_tb, one_minus_alpha_tb;
    wire [7:0] Pf_tb;

    // Instantiate DUT
    blender2 dut (
        .clk(clk_in),
        .rst(rst),
        .sel(sel),
        .P0(P0_tb),
        .P1(P1_tb),
        .alpha(alpha_tb),
        .one_minus_alpha(one_minus_alpha_tb),
        .Pf(Pf_tb)
    );

   // 50 MHz clock
    initial clk_in = 0;
    always #10 clk_in = ~clk_in; // 20ns period

    // Parameters for sine generation
    integer count = 0;
    integer N = 64;  // samples per sine period
    real amplitude0 = 100.0;
    real amplitude1 = 80.0;
    real pi = 3.141592653589793;

    integer sample_div = 8;     // control how often sine updates
    integer sample_count = 0;

    // Stable sine generators (update every few cycles)
    always @(posedge clk_in) begin
        if (!rst) begin
            P0_tb <= 8'd0;
            P1_tb <= 8'd0;
            count <= 0;
            sample_count <= 0;
        end else begin
            if (sample_count == sample_div) begin
                // Generate next sine values
                P0_tb <= 128 + $rtoi(amplitude0 * $sin(2 * pi * count / N));
                P1_tb <= 128 + $rtoi(amplitude1 * $sin(2 * pi * count / N + pi/2));
                count <= count + 1;
                sample_count <= 0;

                // Toggle sel every full sine period (for clarity)
                if (count % N == 0)
                    sel <= ~sel;
            end else begin
                sample_count <= sample_count + 1;
            end
        end
    end

    // Stimulus control
    initial begin
        rst = 0;
        sel = 1;
        alpha_tb = 8'd64;          // 0.5
        one_minus_alpha_tb = 8'd191; // 1 - alpha
        #100; rst = 1;              // Release reset

        // Run long enough to see multiple blend transitions
        #50000;
        $finish;
    end

endmodule