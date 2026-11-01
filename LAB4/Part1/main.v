`timescale 1ns / 1ps
`default_nettype none

module part1	(
	input wire CLOCK_50,            //On Board 50 MHz
	input wire [9:0] SW,            // On board Switches
	input wire [3:0] KEY,           // On board push buttons
	output wire [6:0] HEX0,         // HEX displays
	output wire [6:0] HEX1,         
	output wire [6:0] HEX2,         
	output wire [6:0] HEX3,         
	output wire [6:0] HEX4,         
	output wire [6:0] HEX5,         
	output wire [9:0] LEDR,         // LEDs
	output wire [7:0] x,            // VGA pixel coordinates
	output wire [6:0] y,
	output wire [2:0] colour,       // VGA pixel colour (0-7)
	output wire plot,               // Pixel drawn when this is pulsed
	output wire vga_resetn          // VGA resets to black when this is pulsed (NOT CURRENTLY AVAILABLE)
);    

	//Write code in here!
	
    wire[7:0] count;

    counter8 cnt (.Enable(SW[1]), .Clock(KEY[0]), .Clear_n(SW[0]), .Q(count));

    hex7seg h0 (count[3:0], HEX0);
    hex7seg h1 (count[7:4], HEX1);

endmodule

module tflipflop (input T, Clk, Clear_n, output reg Q);
    always @(posedge Clk) begin
        if (!Clear_n)
            Q <= 1'b0;
        else if (T)
            Q <= ~Q;
    end
endmodule

// 8-bit synchronous counter built from eight T flip-flops (structure of Figure 1)
module counter8 (input Enable, Clock, Clear_n, output [7:0] Q);
    wire [7:0] T;

    assign T[0] = Enable;
    assign T[1] = T[0] & Q[0];
    assign T[2] = T[1] & Q[1];
    assign T[3] = T[2] & Q[2];
    assign T[4] = T[3] & Q[3];
    assign T[5] = T[4] & Q[4];
    assign T[6] = T[5] & Q[5];
    assign T[7] = T[6] & Q[6];

    tflipflop f0 (T[0], Clock, Clear_n, Q[0]);
    tflipflop f1 (T[1], Clock, Clear_n, Q[1]);
    tflipflop f2 (T[2], Clock, Clear_n, Q[2]);
    tflipflop f3 (T[3], Clock, Clear_n, Q[3]);
    tflipflop f4 (T[4], Clock, Clear_n, Q[4]);
    tflipflop f5 (T[5], Clock, Clear_n, Q[5]);
    tflipflop f6 (T[6], Clock, Clear_n, Q[6]);
    tflipflop f7 (T[7], Clock, Clear_n, Q[7]);
endmodule

// Hex digit to 7-segment decoder (DE1-SoC displays are active low, HEX[6:0] = {g,f,e,d,c,b,a})
module hex7seg (input [3:0] c, output reg [6:0] h);
    always @(*) begin
        case (c)
            4'h0: h = 7'b1000000;
            4'h1: h = 7'b1111001;
            4'h2: h = 7'b0100100;
            4'h3: h = 7'b0110000;
            4'h4: h = 7'b0011001;
            4'h5: h = 7'b0010010;
            4'h6: h = 7'b0000010;
            4'h7: h = 7'b1111000;
            4'h8: h = 7'b0000000;
            4'h9: h = 7'b0010000;
            4'hA: h = 7'b0001000;
            4'hB: h = 7'b0000011;
            4'hC: h = 7'b1000110;
            4'hD: h = 7'b0100001;
            4'hE: h = 7'b0000110;
            4'hF: h = 7'b0001110;
            default: h = 7'b1111111;
        endcase
    end
endmodule

