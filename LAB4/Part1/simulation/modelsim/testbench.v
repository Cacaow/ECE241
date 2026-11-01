`timescale 1ns / 1ps

module testbench ( );

	parameter CLOCK_PERIOD = 10;

	reg [1:0] SW;
	reg [0:0] KEY;
	wire [6:0] HEX1, HEX0;

	initial begin
        KEY[0] <= 1'b0;
	end // initial
	always @ (*)
	begin : Clock_Generator
		#((CLOCK_PERIOD) / 2) KEY[0] <= ~KEY[0];
	end
	
	initial begin
		SW[0] <= 1'b0;
		SW[1] <= 1'b0;
		#10 SW[0] <= 1'b1;
		#10 SW[1] <= 1'b1;
	end // initial

	part1 U1 (
	.CLOCK_50(CLOCK_50),            
        .SW(SW),            
        .KEY(KEY),           
        .HEX0(HEX0),         
        .HEX1(HEX1),         
        .HEX2(HEX2),         
        .HEX3(HEX3),         
        .HEX4(HEX4),         
        .HEX5(HEX5),         
        .LEDR(LEDR),        
        .x(x),            
        .y(y),
        .colour(colour),       
        .plot(plot),               
        .vga_resetn(vga_resetn)       
);    


endmodule
