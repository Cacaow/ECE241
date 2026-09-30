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
	wire s = SW[9];
	wire [3:0]X = SW[3:0];
	wire [3:0]Y = SW[7:4];
	wire [3:0]M;
    
    assign M[0] = (~s & X[0]) | (s & Y[0]);
	 assign M[1] = (~s & X[1]) | (s & Y[1]);
	 assign M[2] = (~s & X[2]) | (s & Y[2]);
	 assign M[3] = (~s & X[3]) | (s & Y[3]);
	 
	 assign LEDR[9] = s;
	 assign LEDR[3:0] = M[3:0];

endmodule