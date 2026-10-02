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
	
	assign LEDR[7:0] = SW[7:0];
	/* 
		0000 -> 0
		0001 -> 1
		0010 -> 2
		0011 -> 3
		0100 -> 4
		0101 -> 5
		0110 -> 6
		0111 -> 7
		1000 -> 8
		1001 -> 9
	*/
	
	 //SW[3:0]
	assign HEX0[0] = (~SW[3] && ~SW[1]) && ((SW[2] && ~SW[0]) || (SW[0] && ~SW[2]));
	assign HEX0[1] = (SW[2] && ~SW[3]) && ((SW[0] && ~SW[1]) || (~SW[0] && SW[1]));
	assign HEX0[2] = ~SW[3] && ~SW[2] && SW[1] && ~SW[0];
	assign HEX0[3] = ((~SW[3] && ~SW[1]) && ((SW[2] && ~SW[0]) || (SW[0] && ~SW[2]))) || (~SW[3] && SW[2] && SW[1] && SW[0]);
	assign HEX0[4] = SW[0] || (~SW[3] && SW[2] && ~SW[1]);
	assign HEX0[5] = ~SW[3] && ((~SW[2] && (SW[1] || SW[0])) || (SW[2] && SW[1] && SW[0]));
	assign HEX0[6] = ~SW[3] && ((~SW[2] && ~SW[1]) || (SW[2] && SW[1] && SW[0]));

	// SW[7:4]
	assign HEX1[0] = (~SW[7] && ~SW[5]) && ((SW[6] && ~SW[4]) || (SW[4] && ~SW[6]));
	assign HEX1[1] = (SW[6] && ~SW[7]) && ((SW[4] && ~SW[5]) || (~SW[4] && SW[5]));
	assign HEX1[2] = ~SW[7] && ~SW[6] && SW[5] && ~SW[4];
	assign HEX1[3] = ((~SW[7] && ~SW[5]) && ((SW[6] && ~SW[4]) || (SW[4] && ~SW[6]))) || (~SW[7] && SW[6] && SW[5] && SW[4]);
	assign HEX1[4] = SW[4] || (~SW[7] && SW[6] && ~SW[5]);
	assign HEX1[5] = ~SW[7] && ((~SW[6] && (SW[5] || SW[4])) || (SW[6] && SW[5] && SW[4]));
	assign HEX1[6] = ~SW[7] && ((~SW[6] && ~SW[5]) || (SW[6] && SW[5] && SW[4]));

endmodule