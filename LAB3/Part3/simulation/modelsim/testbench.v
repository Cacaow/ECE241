`timescale 1ns / 1ps

module testbench ( );
	parameter CLOCK_PERIOD = 20;

	reg Clk, D;
	wire Q;

	reg  [1:0] SW;
	wire [3:0] KEY;
	wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [9:0] LEDR;
	wire [7:0] x;
	wire [6:0] y;
	wire [2:0] colour;
	wire plot, vga_resetn;

	initial begin
		SW[1] <= 1'b0;
	end // initial

	always @ (*)
	begin : Clock_Generator
		#((CLOCK_PERIOD) / 2) SW[1] <= ~SW[1];
	end
	
	initial begin
		SW[0] <= 1'b0;
		#100 SW[0] <= 1'b1;
		#100 SW[0] <= 1'b0;
		#15 SW[0] <= 1'b1;
		#20 SW[0] <= 1'b0;
		#50 SW[0] <= 1'b1;
		#50 SW[0] <= 1'b0;
		#50 SW[0] <= 1'b1;
	end // initial

	part3 U1 (
		.CLOCK_50(1'b0),
		.SW(SW),
		.KEY(KEY),
		.HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
		.HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
		.LEDR(LEDR),
		.x(x), .y(y), .colour(colour),
		.plot(plot), .vga_resetn(vga_resetn)
	);


endmodule