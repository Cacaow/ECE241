`timescale 1ns / 1ps

module testbench ( );

	parameter CLOCK_PERIOD = 20;

	reg Clk, D;
	wire Q;

	// part2 ports
	wire [1:0] SW;
	wire [3:0] KEY;
	wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [9:0] LEDR;
	wire [7:0] x;
	wire [6:0] y;
	wire [2:0] colour;
	wire plot, vga_resetn;

	// part2 uses SW[0] as D and SW[1] as Clk
	assign SW  = {Clk, D};
	assign KEY = 4'b1111;

	initial begin
		Clk <= 1'b0;
	end // initial
	always @ (*)
	begin : Clock_Generator
		#((CLOCK_PERIOD) / 2) Clk <= ~Clk;
	end

	initial begin
		D <= 0;
		#20 D <= 1;
		#20 D <= 0;
		#12 D <= 1;
		#5 D <= 0;
		#5 D <= 1;
		#5 D <= 0;
	end // initial

	part2 U1 (
		.CLOCK_50(1'b0),
		.SW(SW),
		.KEY(KEY),
		.HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
		.HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
		.LEDR(LEDR),
		.x(x), .y(y), .colour(colour),
		.plot(plot), .vga_resetn(vga_resetn)
	);

	// Probe the latch output inside part2
	assign Q = U1.Qa;

endmodule