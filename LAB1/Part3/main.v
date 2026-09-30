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
	
    wire [1:0]s = SW[9:8];
	 wire [1:0]U = SW[5:4];
	 wire [1:0]V = SW[3:2];
	 wire [1:0]W = SW[1:0];
	 wire [1:0]M;
	 wire [1:0]con;
	 
	 assign con[0] = (~s[0] & U[0]) | (s[0] & V[0]);
	 assign con[1] = (~s[0] & U[1]) | (s[0] & V[1]);
	 
	 assign M[0] = (~s[1] & con[0]) | (s[1] & W[0]);
	 assign M[1] = (~s[1] & con[1]) | (s[1] & W[1]);
	 
	 assign LEDR[1:0] = M[1:0];

endmodule