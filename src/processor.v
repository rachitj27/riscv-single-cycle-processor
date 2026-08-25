`timescale 1ns / 1ps

module processor
(
    input clk, reset,
    output [31:0] Result
);

// Internal wires
wire [6:0] opcode, funct7;
wire [2:0] funct3;
wire [1:0] ALUOp;
wire [3:0] ALU_CC;
wire       ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite;
wire [31:0] alu_result_wire;

// Register the output
reg [31:0] Result_reg;

always @(posedge clk or posedge reset) begin
    if (reset)
        Result_reg <= 32'b0;
    else
        Result_reg <= alu_result_wire;
end

assign Result = Result_reg;

// Instantiate Controller
Controller ctrl (
    .Opcode   (opcode),
    .ALUSrc   (ALUSrc),
    .MemtoReg (MemtoReg),
    .RegWrite (RegWrite),
    .MemRead  (MemRead),
    .MemWrite (MemWrite),
    .ALUOp    (ALUOp)
);

// Instantiate ALUController
ALUController alu_ctrl (
    .ALUOp     (ALUOp),
    .Funct7    (funct7),
    .Funct3    (funct3),
    .Operation (ALU_CC)
);

// Instantiate data_path
data_path dp (
    .clk       (clk),
    .reset     (reset),
    .alu_cc    (ALU_CC),
    .alu_src   (ALUSrc),
    .mem2reg   (MemtoReg),
    .reg_write (RegWrite),
    .mem_read  (MemRead),
    .mem_write (MemWrite),
    .opcode    (opcode),
    .funct3    (funct3),
    .funct7    (funct7),
    .alu_result (alu_result_wire)
);

endmodule