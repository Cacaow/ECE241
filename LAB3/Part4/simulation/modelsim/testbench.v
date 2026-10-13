`timescale 1ns / 1ps

module testbench ( );

	parameter CLOCK_PERIOD = 200;

	reg Clk, D;
    wire Qa, Qb, Qc;

	wire [1:0] SW;
	wire [3:0] KEY;
	wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [9:0] LEDR;
	wire [7:0] x;
	wire [6:0] y;
	wire [2:0] colour;
	wire plot, vga_resetn;

	assign SW = {Clk, D};
	assign Qa = LEDR[0];
	assign Qb = LEDR[1];
	assign Qc = LEDR[2];

	initial begin
		Clk <= 1'b0;
	end // initial
	always @ (*)
	begin : Clock_Generator
		#((CLOCK_PERIOD) / 2) Clk <= ~Clk;
	end
	
	initial begin
		D <= 0;
		#80 D	<= 1;
		#40 D	<= 0;
		#20 D	<= 1;
		#30 D	<= 0;
		#40 D	<= 1;
		#30 D	<= 0;
		#20 D	<= 1;
		#20 D	<= 0;
		#40 D	<= 1;
		#20 D	<= 0;
		#20 D	<= 1;
		#60 D	<= 0;
	end // initial

	part4 U1 (
		.CLOCK_50(1'b0),
		.SW(SW),
		.KEY(4'b1111),
		.HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
		.HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
		.LEDR(LEDR),
		.x(x), .y(y), .colour(colour),
		.plot(plot), .vga_resetn(vga_resetn)
	);

endmodule