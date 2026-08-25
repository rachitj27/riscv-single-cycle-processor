# RISC-V Single-Cycle Processor (Verilog)

A 32-bit single-cycle RISC-V processor implemented in Verilog and verified in Vivado
behavioral simulation. Every instruction completes in one clock cycle: fetch, decode,
register read, execute, memory access, and write-back all happen within a single period.

Built for UC Irvine EECS 31L (Digital Systems Lab), Spring 2026.

## Architecture

```
        +--------+     +---------+     +----------+
  PC -->| InstMem|---->|Controller|--->| ALUCtrl  |
   ^    +--------+     +---------+     +----------+
   |         |              | control        | ALU op
   |         v              v                v
   |    +---------+    +--------+       +--------+     +---------+
   +----| PC + 4  |    |RegFile |--A--->|  ALU   |---->| DataMem |
        +---------+    +--------+       +--------+     +---------+
                            ^   |  ImmGen  ^                |
                            |   +----------+                |
                            +------- write-back mux --------+
```

The controller decodes the opcode into datapath control signals; the ALU controller
combines `ALUOp` with `funct3`/`funct7` to select the ALU operation. The datapath wires
the program counter, instruction memory, register file, immediate generator, ALU, and
data memory together.

## Modules

| File | Module | Role |
|---|---|---|
| `src/processor.v` | `processor` | Top level; wires controller, ALU controller, and datapath |
| `src/Controller.v` | `Controller` | Opcode to control signals (`ALUSrc`, `MemtoReg`, `RegWrite`, `MemRead`, `MemWrite`, `ALUOp`) |
| `src/ALUController.v` | `ALUController` | `ALUOp` + `funct3` + `funct7` to 4-bit ALU operation |
| `src/data_path.v` | `data_path` | Datapath connecting all functional units |
| `src/alu32.v` | `alu32` | 32-bit ALU with carry-out, overflow, and zero flags |
| `src/reg_file.v` | `RegFile` | 32 x 32-bit register file, two read ports, one write port |
| `src/inst_mem.v` | `InstMem` | Word-addressed instruction memory, byte-addressable interface |
| `src/data_mem.v` | `DataMem` | Data memory for load and store |
| `src/imm_gen.v` | `ImmGen` | Sign-extending immediate generator for I-type, S-type, and U-type |
| `src/mux_32.v` | `mux_32` | 32-bit 2-to-1 multiplexer |
| `src/flip_flop.v` | `FlipFlop` | 8-bit program counter register with synchronous reset |
| `tb/tb_processor.v` | `tb_processor` | Course-provided testbench (author: M. Elfar) |

## Supported instructions

**R-type:** `add`, `sub`, `and`, `or`, `slt`, `nor`
**I-type:** `addi`, `andi`, `ori`, `slti`, `nori`, `lw`
**S-type:** `sw`

## ALU operations

| `Op` | Operation | | `Op` | Operation |
|---|---|---|---|---|
| `0000` | AND | | `0111` | SLT (signed) |
| `0001` | OR  | | `1100` | NOR |
| `0010` | ADD | | `1111` | EQ |
| `0110` | SUB | | | |

`ADD` and `SUB` produce signed-overflow and carry-out flags; `SLT` uses `$signed`
comparison.

## Running the simulation

Vivado (xsim):

1. Create a project and add all files under `src/` as design sources.
2. Add `tb/tb_processor.v` as a simulation source and set `tb_processor` as the top.
3. Run behavioral simulation.

Icarus Verilog:

```sh
iverilog -o processor_tb src/*.v tb/tb_processor.v
vvp processor_tb
```

The testbench walks a 20-instruction program through the processor and checks the ALU
result on each cycle, printing a score out of 80.

## Verification

The design was verified against the course testbench in Vivado 2025.2 behavioral
simulation, passing all 20 instruction checks.

Note that `processor.v` registers the ALU result on the output. This pairs with an
instruction memory whose first instruction sits at address `0x00`, so the registered
output presents each instruction's result on the cycle the testbench samples it.

## License

Coursework, published for portfolio purposes. `tb/tb_processor.v` is course-provided
material and retains its original attribution.
