`timescale 1ns / 1ps

module data_path #(
    parameter PC_W = 8,       // Program Counter
    parameter INS_W = 32,     // Instruction Width
    parameter RF_ADDRESS = 5, // Register File Address
    parameter DATA_W = 32,    // Data WriteData
    parameter DM_ADDRESS = 9, // Data Memory Address
    parameter ALU_CC_W = 4    // ALU Control Code Width
 )(
    input                  clk ,  
    input                  reset,      
    input                  reg_write,
    input                  mem2reg,    
    input                  alu_src,      
    input                  mem_write,      
    input                  mem_read,                
    input  [ALU_CC_W-1:0]  alu_cc,
    output          [6:0]  opcode,
    output          [6:0]  funct7,
    output          [2:0]  funct3,
    output   [DATA_W-1:0]  alu_result
 );

    // Wire declarations
    wire [PC_W-1:0]   pc_out;
    wire [PC_W-1:0]   pc_plus4;
    wire [INS_W-1:0]  instruction;
    wire [DATA_W-1:0] rg_rd_data1;
    wire [DATA_W-1:0] rg_rd_data2;
    wire [DATA_W-1:0] imm_out;
    wire [DATA_W-1:0] alu_b;
    wire [DATA_W-1:0] alu_out;
    wire              zero;
    wire              overflow;
    wire              carry_out;
    wire [DATA_W-1:0] dm_read_data;
    wire [DATA_W-1:0] wb_data;
   
    // Windows-safe instruction field slices
    wire [RF_ADDRESS-1:0] rg_wrt_addr_wire;
    wire [RF_ADDRESS-1:0] rg_rd_addr1_wire;
    wire [RF_ADDRESS-1:0] rg_rd_addr2_wire;
   
    assign rg_wrt_addr_wire  = instruction[11:7];
    assign rg_rd_addr1_wire  = instruction[19:15];
    assign rg_rd_addr2_wire  = instruction[24:20];

    // Next PC adder
    assign pc_plus4 = pc_out + 8'd4;

    // Program counter register
    FlipFlop fetch (
        .clk   (clk),
        .reset (reset),
        .d     (pc_plus4),
        .q     (pc_out)
    );

    // Instruction memory
    InstMem instant (
        .addr        (pc_out),
        .instruction (instruction)
    );

    // Register file
    RegFile register (
        .clk         (clk),
        .reset       (reset),
        .rg_wrt_en   (reg_write),
        .rg_wrt_addr (rg_wrt_addr_wire),
        .rg_rd_addr1 (rg_rd_addr1_wire),
        .rg_rd_addr2 (rg_rd_addr2_wire),
        .rg_wrt_data (wb_data),
        .rg_rd_data1 (rg_rd_data1),
        .rg_rd_data2 (rg_rd_data2)
    );

    // Immediate generator
    ImmGen imm (
        .InstCode (instruction),
        .ImmOut   (imm_out)
    );

    // ALU source mux
    mux_32 alusrc (
        .s  (alu_src),
        .d0 (rg_rd_data2),
        .d1 (imm_out),
        .y  (alu_b)
    );

    // ALU
    alu32 result (
        .A        (rg_rd_data1),
        .B        (alu_b),
        .Op       (alu_cc),
        .Result   (alu_out),
        .CarryOut (carry_out),
        .Overflow (overflow),
        .Zero     (zero)
    );

    // Data memory
    DataMem data (
        .MemRead    (mem_read),
        .MemWrite   (mem_write),
        .addr       (alu_out[DM_ADDRESS-1:0]),
        .write_data (rg_rd_data2),
        .read_data  (dm_read_data)
    );

    // Writeback mux
    mux_32 memtoreg (
        .s  (mem2reg),
        .d0 (alu_out),
        .d1 (dm_read_data),
        .y  (wb_data)
    );

    // Module output assignments
    assign opcode     = instruction[6:0];
    assign funct3     = instruction[14:12];
    assign funct7     = instruction[31:25];
    assign alu_result = alu_out;

endmodule