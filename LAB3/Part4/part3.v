`timescale 1ns / 1ps
`default_nettype none

module part4	(
	input wire CLOCK_50,            //On Board 50 MHz
	input wire [1:0] SW,            // On board Switches
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
	wire D = SW[0];
	wire Clock = SW[1];
	wire Qm, Qa, Qb, QX;
	assign LEDR[0] = Qa;
	
	
	D_flipflop master(.D(D), .Clk(~Clock), .Qa(Qm), .Qb(QX));
	D_flipflop slave(.D(Qm), .Clk(Clock), .Qa(Qa), .Qb(Qb));
	//no change state prevented from ~Clock
	//Clk = 0, Qm follows D, Qa hold
	//Clk = 1, Qm frozen, Qa follows Qm

endmodule

//if Clk low, no change
//D = 0; Qb high
//D = 1; Qa high
module D_flipflop(D, Clk, Qa, Qb);
	input wire D;
	input wire Clk;
	output wire Qa;
	output wire Qb;
	
	wire R_g, S_g;
	
	assign R_g = ~(~D & Clk);
	assign S_g = ~(D & Clk);
	assign Qa = ~(S_g & Qb);
	assign Qb = ~(R_g & Qa);

endmodule