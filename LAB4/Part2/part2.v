`timescale 1ns / 1ps
`default_nettype none

module part2	(
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
	
    wire [15:0] count;

    counter16 cnt (
        .Enable(SW[1]),
        .Clock(KEY[0]),
        .Clear_n(SW[0]),
        .Q(count)
    );

    hex7seg h0 (count[3:0], HEX0);
    hex7seg h1 (count[7:4], HEX1);
    hex7seg h2 (count[11:8], HEX2);
    hex7seg h3 (count[15:12], HEX3);

endmodule

// 8-bit synchronous counter built from eight T flip-flops (structure of Figure 1)
module counter16 (
    input wire Enable,
    input wire Clock,
    input wire Clear_n,
    output reg [15:0] Q
);

    always @(posedge Clock) begin
        if (!Clear_n)
            Q <= 16'b0;
        else if (Enable)
            Q <= Q + 1'b1;
    end

endmodule

// Hex digit to 7-segment decoder (DE1-SoC displays are active low, HEX[6:0] = {g,f,e,d,c,b,a})
module hex7seg (input wire [3:0] c, output reg [6:0] h);
    always @(*) begin
        case (c)
            4'h0: h = 7'b1000000;
            4'h1: h = 7'b1111001;
            4'h2: h = 7'b0100100;
            4'h3: h = 7'b0110000;
            4'h4: h = 7'b0011001;
            4'h5: h = 7'b0010010;
            4'h6: h = 7'b0000010;
            4'h7: h = 7'b1111000;
            4'h8: h = 7'b0000000;
            4'h9: h = 7'b0010000;
            4'hA: h = 7'b0001000;
            4'hB: h = 7'b0000011;
            4'hC: h = 7'b1000110;
            4'hD: h = 7'b0100001;
            4'hE: h = 7'b0000110;
            4'hF: h = 7'b0001110;
            default: h = 7'b1111111;
        endcase
    end
endmodule

