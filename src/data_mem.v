`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2026 01:43:18 PM
// Design Name: 
// Module Name: DataMem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DataMem(MemRead, MemWrite, addr, write_data, read_data);
input MemRead; 
input MemWrite; 
input [8:0] addr;
input [31:0] write_data;
output [31:0] read_data;

reg [31:0] mem [0:127];

wire [6:0] word_index = addr[8:2];
always @(*) begin
        if (MemWrite)
            mem[word_index] = write_data;
    end
    assign read_data = MemRead ? mem[word_index] : 32'b0;
endmodule
