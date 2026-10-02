`timescale 1ns / 1ps
`default_nettype none

module part4	(
	input wire CLOCK_50,            //On Board 50 MHz
	input wire [9:0] SW,            // On board Aitches
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
	
	wire [3:0]X = SW[7:4];
	wire [3:0]Y = SW[3:0];
	wire Cin = SW[8];
	
	
	
	//ripple carry adder
	wire [3:0] sum;
	wire cout;
	top_module U1 (
		.a(X),
		.b(Y),
		.cin(Cin),
		.cout(cout),
		.sum(sum)
	);
	
	wire [4:0]T = {cout, sum};
	
	assign LEDR[4:0] = T[4:0];
	
	//X > 9 or Y > 9
	//example: SW8 off, SW[7:4] = 1100, SW[3:0] = 0011
	wire errX = X[3] & (X[2] | X[1]);
	wire errY = Y[3] & (Y[2] | Y[1]);
	assign LEDR[9] = errX | errY;
	
	//comparator -> z = 1 when T > 9 when 1010+
	wire z = T[4] | (T[3] & (T[2] | T[1]));
	
	//Circuit A -> A = V - 10 when V > 9
	wire [3:0] A;
	assign A[0] = T[0];
	assign A[1] = ~T[1];
	assign A[2] = ~(T[2] ^ T[1]);
	assign A[3] = T[3] ^ (T[2] | T[1]);
	
	//multiplexer 2 to 1
	wire [3:0] M;
	assign M[0] = (~z & T[0]) | (z & A[0]);
	assign M[1] = (~z & T[1]) | (z & A[1]);
	assign M[2] = (~z & T[2]) | (z & A[2]);
	assign M[3] = (~z & T[3]) | (z & A[3]);
	
	//
	wire [3:0]d1, d0;
	//concatinate into 000z to make 4 bit input (z is 1 bit)
	assign d1 = {3'b000, z};
	assign d0 = M;
	
	
	seg7 H0 (d0, HEX0);
	seg7 H1 (d1, HEX1);
	
	seg7 H3 (Y, HEX3);
	seg7 H5 (X, HEX5);
	
	assign HEX2 = 7'b0000000;
	assign HEX4 = 7'b0000000;
	
endmodule

module seg7 (
	input wire [3:0]A,
	output wire [6:0]Display
	);

	assign Display[0] = (~A[3] && ~A[1]) && ((A[2] && ~A[0]) || (A[0] && ~A[2]));
	assign Display[1] = (A[2] && ~A[3]) && ((A[0] && ~A[1]) || (~A[0] && A[1]));
	assign Display[2] = ~A[3] && ~A[2] && A[1] && ~A[0];
	assign Display[3] = ((~A[3] && ~A[1]) && ((A[2] && ~A[0]) || (A[0] && ~A[2]))) || (~A[3] && A[2] && A[1] && A[0]);
	assign Display[4] = A[0] || (~A[3] && A[2] && ~A[1]);
	assign Display[5] = ~A[3] && ((~A[2] && (A[1] || A[0])) || (A[2] && A[1] && A[0]));
	assign Display[6] = ~A[3] && ((~A[2] && ~A[1]) || (A[2] && A[1] && A[0]));

endmodule

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
    output wire [3:0]sum
);
    wire c1, c2,c3;
    wire s0, s1, s2, s3;

    full_adder F1 (
      .a(a[0]),
      .b(b[0]),
      .cin(cin),
      .sum(s0),
      .cout(c1)
    );

    full_adder F2 (
      .a(a[1]),
      .b(b[1]),
      .cin(c1),
      .sum(s1),
      .cout(c2)
    );

    full_adder F3 (
      .a(a[2]),
      .b(b[2]),
      .cin(c2),
      .sum(s2),
      .cout(c3)
    );

    full_adder F4 (
      .a(a[3]),
      .b(b[3]),
      .cin(c3),
      .sum(s3),
      .cout(cout)
    );

    assign sum = {s3, s2, s1, s0};

endmodule