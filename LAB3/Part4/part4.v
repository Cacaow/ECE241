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
	wire Qa1, Qa2, Qb1, Qb2, Qc1, Qc2;
	assign LEDR[0] = Qa1;
	assign LEDR[1] = Qb1;
	assign LEDR[2] = Qc1;
	
	
	D_latch A(.D(D), .Clk(Clock), .Qa(Qa1), .Qb(Qa2));
	posD_latch B(.D(D), .Clk(Clock), .Qa(Qb1), .Qb(Qb2));
	negD_latch C(.D(D), .Clk(~Clock), .Qa(Qc1), .Qb(Qc2));

endmodule

//if Clk low, no change
//Clk high, Qa follows D
module D_latch(D, Clk, Qa, Qb);
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

//follows D when clock is high
module posD_latch(D, Clk, Qa, Qb);
	input wire D;
	input wire Clk;
	output wire Qa;
	output wire Qb;
	wire Qm, Qm_n;
	
	D_latch master (.D(D),  .Clk(~Clk), .Qa(Qm), .Qb(Qm_n));
	D_latch slave  (.D(Qm), .Clk(Clk),  .Qa(Qa), .Qb(Qb));

endmodule

//follows D when clock is low
module negD_latch(D, Clk, Qa, Qb);
	input wire D;
	input wire Clk;
	output wire Qa;
	output wire Qb;
	wire Qm, Qm_n;
 
	D_latch master (.D(D),  .Clk(~Clk), .Qa(Qm), .Qb(Qm_n));
	D_latch slave  (.D(Qm), .Clk(Clk),  .Qa(Qa), .Qb(Qb));

endmodule