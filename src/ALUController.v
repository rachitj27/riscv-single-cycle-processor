`timescale 1ns / 1ps

module ALUController (
    ALUOp, Funct7, Funct3, Operation
);

input  [1:0] ALUOp;
input  [6:0] Funct7;
input  [2:0] Funct3;
output [3:0] Operation;

// OR, ORI | SLT, SLTI
assign Operation[0] =
    (Funct3 == 3'b110) ||
    (Funct3 == 3'b010 && ALUOp[0] == 1'b0);

// ADD, ADDI, LW, SW | SUB | SLT, SLTI
assign Operation[1] =
    (Funct3 == 3'b000) ||
    (Funct7 == 7'b0100000) ||
    (ALUOp  == 2'b01) ||
    (Funct3 == 3'b010 && ALUOp != 2'b01);

// SUB | SLT, SLTI (not LW/SW) | NOR, NORI
assign Operation[2] =
    (Funct7 == 7'b0100000) ||
    (Funct3 == 3'b010 && ALUOp != 2'b01) ||
    (Funct3 == 3'b100);

// NOR, NORI
assign Operation[3] =
    (Funct3 == 3'b100);

endmodule