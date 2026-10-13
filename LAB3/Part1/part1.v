`timescale 1ns / 1ps
`default_nettype none

module part1 (
    input  wire Clk,
    input  wire R,
    input  wire S,
    output wire Qa,
    output wire Qb
);

    wire R_g, S_g;

    // Small gate delays prevent zero-delay oscillation in the feedback loop
    assign R_g = R & Clk;
    assign S_g = S & Clk;
    assign Qa  = ~(R_g | Qb);
    assign Qb  = ~(S_g | Qa);

endmodule

`default_nettype wire