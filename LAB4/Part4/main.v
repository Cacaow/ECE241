`timescale 1ns / 1ps
`default_nettype none

module main	(
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

    reg [25:0] slow_count;

    //s0 -> HEX0 ... s5 -> HEX5
    reg [3:0] s0, s1, s2, s3, s4, s5;

    wire reset_n = KEY[0];

    wire tick = (slow_count == 26'd49999999);

    always @(posedge CLOCK_50) begin
        if (!reset_n)
            slow_count <= 26'd0;
        else if (tick)
            slow_count <= 26'd0;
        else
            slow_count <= slow_count + 1'b1;
    end

    // Rotate the six characters
    always @(posedge CLOCK_50) begin
        if (!reset_n) begin
            // Clock cycle 0: "dE1" on HEX2, HEX1, HEX0
            s0 <= 4'd1;
            s1 <= 4'd11;
            s2 <= 4'd10;
            s3 <= 4'd15;
            s4 <= 4'd15;
            s5 <= 4'd15;
        end
        else if (tick) begin
            s5 <= s4;
            s4 <= s3;
            s3 <= s2;
            s2 <= s1;
            s1 <= s0;
            s0 <= s5;   // wrap around from HEX5 to HEX0
        end
    end

    hex7seg h0 (.c(s0), .h(HEX0));
    hex7seg h1 (.c(s1), .h(HEX1));
    hex7seg h2 (.c(s2), .h(HEX2));
    hex7seg h3 (.c(s3), .h(HEX3));
    hex7seg h4 (.c(s4), .h(HEX4));
    hex7seg h5 (.c(s5), .h(HEX5));

endmodule


module hex7seg (
    input wire [3:0] c,
    output reg [6:0] h
);

    always @(*) begin
        case (c)
            4'd0:  h = 7'b1000000;
            4'd1:  h = 7'b1111001;
            4'd2:  h = 7'b0100100;
            4'd3:  h = 7'b0110000;
            4'd4:  h = 7'b0011001;
            4'd5:  h = 7'b0010010;
            4'd6:  h = 7'b0000010;
            4'd7:  h = 7'b1111000;
            4'd8:  h = 7'b0000000;
            4'd9:  h = 7'b0010000;
            4'd10: h = 7'b0100001;   // d
            4'd11: h = 7'b0000110;   // E
            default: h = 7'b1111111; // blank
        endcase
    end

endmodule