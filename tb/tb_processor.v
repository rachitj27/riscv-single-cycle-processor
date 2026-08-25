////////////////////////////////////////////////////////////////////////////////
// EECS 31L - S26 - Lab 5 Design
// File: tb_processor.v
// Author: M. Elfar
// Comments: Testbench for the processor design
////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb_processor();

// Signals and instantiation of the processor under test
reg clk, rst; wire [31:0] tb_Result;
processor processor_inst(
  .clk    (clk),
  .reset  (rst),
  .Result (tb_Result)
);

// Testbench shenanigans
integer point = 0; // Points earned, almost missed that line
initial begin // Proper clock generation
  clk = 0; forever #10 clk = ~clk; end
  // CLK _____/-----\_____/-----\_____/-----\_____/-----\_____
initial begin // Proper reset sequence
  rst = 1; repeat (2) @(negedge clk); rst = 0; end
  // RST ------------------------\____________________________

// Interrogate the processor
initial begin
  @(negedge rst); // Wait for rst to be reset
  @(posedge clk); // Now wait for the first active clock edge
  @(negedge clk);  if (tb_Result == 32'h00000000) point = point + 1; 
  else $display("Oh no! AND  expected 0x00000000, got 32'h%08x", tb_Result); // and
  @(negedge clk);  if (tb_Result == 32'h00000001) point = point + 1; 
  else $display("Oh no! ADDI expected 0x00000001, got 32'h%08x", tb_Result); // addi
  @(negedge clk);  if (tb_Result == 32'h00000002) point = point + 1; 
  else $display("Oh no! ADDI expected 0x00000002, got 32'h%08x", tb_Result); // addi
  @(negedge clk);  if (tb_Result == 32'h00000004) point = point + 1; 
  else $display("Oh no! ADDI expected 0x00000004, got 32'h%08x", tb_Result); // addi
  @(negedge clk);  if (tb_Result == 32'h00000005) point = point + 1; 
  else $display("Oh no! ADDI expected 0x00000005, got 32'h%08x", tb_Result); // addi
  @(negedge clk);  if (tb_Result == 32'h00000007) point = point + 1; 
  else $display("Oh no! ADDI expected 0x00000007, got 32'h%08x", tb_Result); // addi
  @(negedge clk);  if (tb_Result == 32'h00000008) point = point + 1; 
  else $display("Oh no! ADDI expected 0x00000008, got 32'h%08x", tb_Result); // addi
  @(negedge clk);  if (tb_Result == 32'h0000000b) point = point + 1; 
  else $display("Oh no! ADDI expected 0x0000000b, got 32'h%08x", tb_Result); // addi
  @(negedge clk);  if (tb_Result == 32'h00000003) point = point + 1; 
  else $display("Oh no! ADD  expected 0x00000003, got 32'h%08x", tb_Result); // add
  @(negedge clk);  if (tb_Result == 32'hfffffffe) point = point + 1; 
  else $display("Oh no! SUB  expected 0xfffffffe, got 32'h%08x", tb_Result); // sub
  @(negedge clk);  if (tb_Result == 32'h00000000) point = point + 1; 
  else $display("Oh no! AND  expected 0x00000000, got 32'h%08x", tb_Result); // and
  @(negedge clk);  if (tb_Result == 32'h00000005) point = point + 1; 
  else $display("Oh no! OR   expected 0x00000005, got 32'h%08x", tb_Result); // or
  @(negedge clk);  if (tb_Result == 32'h00000001) point = point + 1; 
  else $display("Oh no! SLT  expected 0x00000001, got 32'h%08x", tb_Result); // slt
  @(negedge clk);  if (tb_Result == 32'hfffffff4) point = point + 1; 
  else $display("Oh no! NOR  expected 0xfffffff4, got 32'h%08x", tb_Result); // nor
  @(negedge clk);  if (tb_Result == 32'h000004D2) point = point + 1; 
  else $display("Oh no! ANDI expected 0x000004D2, got 32'h%08x", tb_Result); // andi
  @(negedge clk);  if (tb_Result == 32'hfffff8d7) point = point + 1; 
  else $display("Oh no! ORI  expected 0xfffff8d7, got 32'h%08x", tb_Result); // ori
  @(negedge clk);  if (tb_Result == 32'h00000001) point = point + 1; 
  else $display("Oh no! SLTI expected 0x00000001, got 32'h%08x", tb_Result); // slti
  @(negedge clk);  if (tb_Result == 32'hfffffb2c) point = point + 1; 
  else $display("Oh no! NORI expected 0xfffffb2c, got 32'h%08x", tb_Result); // nori
  @(negedge clk);  if (tb_Result == 32'h00000030) point = point + 1; 
  else $display("Oh no! SW   expected 0x00000030, got 32'h%08x", tb_Result); // sw
  @(negedge clk);  if (tb_Result == 32'h00000030) point = point + 1; 
  else $display("Oh no! LW   expected 0x00000030, got 32'h%08x", tb_Result); // lw
  if (point < 20) $display("Try harder...");
  $display("%s%0d", "Score: ", 4 * point);
  #10; $finish;
end

initial begin
  // $dumpfile("dump.vcd"); $dumpvars(0); // Dump all vars for plotting on EDA-PG
  #500; $finish; // Timeout, in case we somehow messed up
end

endmodule
////////////////////////////////////////////////////////////////////////////////