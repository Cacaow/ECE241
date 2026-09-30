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
	assign LEDR = SW;
	// declare any wires needed
	wire conHEX0[1:0];
	wire conHEX1[1:0];
	wire conHEX2[1:0];
	
	// instantiate module mux_2bit_3to1 (S, U, V, W, M);
	module mux_2bit_3to1 M0 (SW[9:8], SW[5:4], SW[3:2], SW[1:0], conHEX0[1:0]);
	module mux_2bit_3to1 M1 (SW[9:8], SW[5:4], SW[3:2], SW[1:0], conHEX1[1:0]);
	module mux_2bit_3to1 M2 (SW[9:8], SW[5:4], SW[3:2], SW[1:0], conHEX2[1:0]);
	 
	// instantiate module char_7seg (C, Display);
	char_7seg H0 (conHEX0[1:0], HEX0);
	char_7seg H1 (conHEX1[1:0], HEX1);
	char_7seg H2 (conHEX2[1:0], HEX2);
	
endmodule

	// implements a 2-bit wide 3-to-1 multiplexer
	module mux_2bit_3to1 (S, U, V, W, M);
		input [1:0] S, U, V, W;
		output [1:0] M;

		wire [1:0]s = SW[9:8];
		wire [1:0]U = SW[5:4];
		wire [1:0]V = SW[3:2];
		wire [1:0]W = SW[1:0];
		wire [1:0]con;

		assign con[0] = (~s[0] & U[0]) | (s[0] & V[0]);
		assign con[1] = (~s[0] & U[1]) | (s[0] & V[1]);

		assign M[0] = (~s[1] & con[0]) | (s[1] & W[0]);
		assign M[1] = (~s[1] & con[1]) | (s[1] & W[1]);

		assign LEDR[1:0] = M[1:0];
		
	endmodule
	
	// implements a 7-segment decoder for d, E, 1 and ‘blank’
	module char_7seg (C, Display)
		input [1:0] C; // input code
		output [6:0] Display; // output 7-se

		assign Display[0] = C[1] || ~C[0];
		assign Display[1] = ~C[1] && C[0] || C[1] && C[0];
		assign Display[2] = ~C[1] && C[0] || C[1] && C[0];
		assign Display[3] = C[1];
		assign Display[4] = C[1];
		assign Display[5] = C[1] || ~C[0];
		assign Display[6] = C[1];
 

	endmodule