`timescale 1ns / 1ps
`default_nettype none

module part5 (
	input wire CLOCK_50,            // On Board 50 MHz
	input wire [7:0] SW,            // On board Switches
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
	output wire vga_resetn          // VGA resets to black when this is pulsed
);

	assign LEDR[9:1] = 9'b0;
	wire Clock  = KEY[1];           // manual clock
	wire resetn = KEY[0];           // active-low synchronous reset

	// A is stored in a register; B is the switches
	reg  [7:0] A;
	wire [7:0] B = SW[7:0];

	//Register to switch from setting A
	always @(posedge Clock) begin
		if (!resetn) 
			A <= 8'b0;
		else         
			A <= SW[7:0];
	end

	// 8-bit adder (two 4 bit carry adders)
	wire [7:0] S;
	wire c4, cout;
	top_module U1 (.a(A[3:0]), .b(B[3:0]), .cin(1'b0), .cout(c4),   .sum(S[3:0]));
	top_module U2 (.a(A[7:4]), .b(B[7:4]), .cin(c4),   .cout(cout), .sum(S[7:4]));

	assign LEDR[0]   = cout;

	// B on HEX1-0, A on HEX3-2, sum on HEX5-4
	seg7 H0 (B[3:0], HEX0);
	seg7 H1 (B[7:4], HEX1);
	seg7 H2 (A[3:0], HEX2);
	seg7 H3 (A[7:4], HEX3);
	seg7 H4 (S[3:0], HEX4);
	seg7 H5 (S[7:4], HEX5);

endmodule

module seg7 (
	input  wire [3:0] A,
	output reg  [6:0] Display
);
	always @(*) begin
		case (A)
		//hexadecimal A
			4'h0: Display = 7'b1000000;
			4'h1: Display = 7'b1111001;
			4'h2: Display = 7'b0100100;
			4'h3: Display = 7'b0110000;
			4'h4: Display = 7'b0011001;
			4'h5: Display = 7'b0010010;
			4'h6: Display = 7'b0000010;
			4'h7: Display = 7'b1111000;
			4'h8: Display = 7'b0000000;
			4'h9: Display = 7'b0010000;
			4'hA: Display = 7'b0001000;
			4'hB: Display = 7'b0000011;
			4'hC: Display = 7'b1000110;
			4'hD: Display = 7'b0100001;
			4'hE: Display = 7'b0000110;
			4'hF: Display = 7'b0001110;
		endcase
	end
endmodule

//from Part 4
module full_adder(
	input wire a, b, cin,
	output wire sum, cout
);
	assign sum  = a ^ b ^ cin;
	assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module top_module(
	input wire [3:0] a, b,
	input wire cin,
	output wire cout,
	output wire [3:0] sum
);
	wire c1, c2, c3;
	wire s0, s1, s2, s3;

	full_adder F1 (.a(a[0]), .b(b[0]), .cin(cin), .sum(s0), .cout(c1));
	full_adder F2 (.a(a[1]), .b(b[1]), .cin(c1),  .sum(s1), .cout(c2));
	full_adder F3 (.a(a[2]), .b(b[2]), .cin(c2),  .sum(s2), .cout(c3));
	full_adder F4 (.a(a[3]), .b(b[3]), .cin(c3),  .sum(s3), .cout(cout));

	assign sum = {s3, s2, s1, s0};
endmodule