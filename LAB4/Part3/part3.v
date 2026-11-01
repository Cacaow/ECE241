`timescale 1ns / 1ps
`default_nettype none

module part3	(
	input wire CLOCK_50,            //On Board 50 MHz
	input wire [9:0] SW,            // On board Switches
	input wire [0:0] KEY,           // On board push buttons
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
	
    reg [25:0] slow_count;

    // 4-bit counter to display digits 0 to 9
    reg [3:0] digit;

    // Active-low synchronous reset
    wire reset_n = KEY[0];

    always @(posedge CLOCK_50) begin
        if (!reset_n)
            slow_count <= 26'd0;
		  else if (slow_count == 26'd49) //used for modelsim
        //else if (slow_count == 26'd49999999)
            slow_count <= 26'd0;
        else
            slow_count <= slow_count + 1'b1;
    end

    // Digit counter: increments every second
    always @(posedge CLOCK_50) begin
        if (!reset_n)
            digit <= 4'd0;
        else if (slow_count == 26'd49) begin //for modelsim
		  //else if (slow_count == 26'd49999999) begin
            if (digit == 4'd9)
                digit <= 4'd0;
            else
                digit <= digit + 1'b1;
        end
    end

    // HEX0 seven-segment display decoder
    hex7seg h0 (.c(digit), .h(HEX0));

endmodule


module hex7seg (
    input wire [3:0] c,
    output reg [6:0] h
);

    always @(*) begin
        case (c)
            4'd0: h = 7'b1000000;
            4'd1: h = 7'b1111001;
            4'd2: h = 7'b0100100;
            4'd3: h = 7'b0110000;
            4'd4: h = 7'b0011001;
            4'd5: h = 7'b0010010;
            4'd6: h = 7'b0000010;
            4'd7: h = 7'b1111000;
            4'd8: h = 7'b0000000;
            4'd9: h = 7'b0010000;
            default: h = 7'b1111111;
        endcase
    end

endmodule