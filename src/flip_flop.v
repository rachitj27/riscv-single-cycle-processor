`timescale 1ns / 1ps
module FlipFlop(
input clk,
input reset,
input [7:0] d,
output reg [7:0] q
);
always @(posedge clk) begin
// TODO:
// Implement a D Flip-Flop with synchronous reset.
// When reset is high at the rising edge of clk, q should become 8'b00000000.
// Otherwise, q should store d.
        if (reset)
            q <= 8'b00000000;
        else
            q <= d;
end
endmodule