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

	//Write code in here!
	//cout = 1 when a + b + cin >= 16
	top_module U1(
		.a(SW[7:4]), 
		.b(SW[3:0]), 
		.cin(SW[8]), 
		.cout(LEDR[5]), 
		.sum(LEDR[3:0])
	);

endmodule

module full_adder(
	input wire a, b, cin, 
	output wire sum, cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
	 
endmodule

module top_module(
    input wire [3:0] a, b,
    input wire cin,
    output wire cout,
    output wire [3:0]sum
);
	wire c1, c2,c3;
	wire s0, s1, s2, s3;
	
	
	full_adder F1 (
	  .a(a[0]),
	  .b(b[0]),
	  .cin(cin),
	  .sum(s0),
	  .cout(c1)
	);

	full_adder F2 (
	  .a(a[1]),
	  .b(b[1]),
	  .cin(c1),
	  .sum(s1),
	  .cout(c2)
	);
	
	full_adder F3 (
	  .a(a[2]),
	  .b(b[2]),
	  .cin(c2),
	  .sum(s2),
	  .cout(c3)
	);
	
	full_adder F4 (
	  .a(a[3]),
	  .b(b[3]),
	  .cin(c3),
	  .sum(s3),
	  .cout(cout)
	);
	
	assign sum = {s3, s2, s1, s0};
	
endmodule

