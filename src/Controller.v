////////////////////////////////////////////////////////////////////////////////
// EECS 31L - S26 - Lab 5 Design
// File: Controller.v
// Author: <Rachit Jain>
// Comments: Controller for the processor design
////////////////////////////////////////////////////////////////////////////////

// TODO: Complete this file

`timescale 1ns / 1ps

module Controller (
    Opcode,
    ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
    ALUOp
);

input  [6:0] Opcode;

output       ALUSrc;
output       MemtoReg;
output       RegWrite;
output       MemRead;
output       MemWrite;
output [1:0] ALUOp;

// Define the Controller module's behavior
// Opcode constants
localparam R_TYPE = 7'b0110011;  // AND, OR, ADD, SUB, SLT, SLT, NOR
localparam I_TYPE = 7'b0010011;  // ANDI, ORI, ADDI, SLTI, NORI
localparam LW     = 7'b0000011;
localparam SW     = 7'b0100011;

assign MemtoReg = (Opcode == LW)     ? 1 : 0;
assign MemWrite = (Opcode == SW)     ? 1 : 0;
assign MemRead  = (Opcode == LW)     ? 1 : 0;
assign RegWrite = (Opcode == SW)     ? 0 : 1;
assign ALUSrc   = (Opcode == R_TYPE) ? 0 : 1;

assign ALUOp    = (Opcode == R_TYPE) ? 2'b10 :
                  (Opcode == I_TYPE) ? 2'b00 :
                                       2'b01;   // LW and SW


endmodule // Controller
