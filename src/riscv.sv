// Global Macros
`define DEBUG            // Enable debugging features (e.g., debug messages)
`define SIMULATION       // Indicates the code is being run in simulation mode
`define SYNTHESIS        // Exclude testbench-related code during synthesis
`define FORMAL           // Enable formal verification features (e.g., assertions)

// Global Time Scale
`timescale 1 ns / 1 ps

// Project Constants
`define ADDR_WIDTH 32    // Address bus width
`define DATA_WIDTH 64    // Data bus width
`define SUCCESS 0        // Success return code
`define FAILURE 1        // Failure return code

// Debugging Macros
`ifdef DEBUG
  `define DEBUG_PRINT(msg) $display(msg) // Print debug messages when DEBUG is enabled
`else
  `define DEBUG_PRINT(msg)              // No-op when DEBUG is disabled
`endif

// Assertion Macro
`define ASSERT(condition, message) \
  if (`ASSERT_ON) assert(condition) else $fatal(1, message); // Unified assertion macro

// Formal Verification Macros
`ifdef FORMAL
  `define ASSERT(expr) assert(expr) // Enable assertions for formal verification
`else
  `define ASSERT(expr) // No-op for simulation or synthesis
`endif

// Synthesis Macros
`ifdef SYNTHESIS
  `define SYN_KEEP (* keep = "true" *) // Retain signals during synthesis to prevent optimization
`else
  `define SYN_KEEP // No-op for simulation or formal verification
`endif

// CPU Module Definition
module cpu (
  // Program Clocks
  input logic        clk, rst_n,

  // Memory Defintion
  output reg        mem_valid,
  output reg        mem_instr,
  input             mem_ready,

  output reg [31:0] mem_addr,
  output reg [31:0] mem_wdata,
  output reg [ 3:0] mem_wstrb,
  input      [31:0] mem_rdata,

  // Look-Ahead Interface
  output            mem_la_read,
  output            mem_la_write,
  output     [31:0] mem_la_addr,
  output reg [31:0] mem_la_wdata,
  output reg [ 3:0] mem_la_wstrb,

  // IRQ Interface
  input      [31:0] irq, // 32 interrupt lines
  output reg [31:0] eoi,
  output reg trap, // Traps not Interrupt

  // Trace Interface
  output reg        trace_valid,
  output reg [35:0] trace_data
);
  localparam integer NUM_GENERAL_REGS = 16; // 16 Registers in  this CPU

  // Interrupt-Specific Variables
  localparam integer irq_timer = 0; // Timer Interrupt
  localparam integer irq_ebreak = 1; // ebreak instruction interrupt
  localparam integer irq_buserror = 2; // bus error interrupt

  //
  localparam integer ENABLE_IRQ_QREGS = 1;

  localparam integer irqregs_offset = 16; // 16 Registers offset for IRQ
	localparam integer regfile_size = 20; // 4 quick registers (IRQ registers)
	localparam integer regindex_bits = 5;

  // Trace Codes
  localparam [35:0] TRACE_BRANCH = {4'b 0001, 32'b 0}; // Branch Trace
  localparam [35:0] TRACE_ADDR   = {4'b 0010, 32'b 0}; // Address Trace
  localparam [35:0] TRACE_IRQ    = {4'b 1000, 32'b 0}; // Interrupt Trace

  reg [63:0] count_cycle, count_instr;
	reg [31:0] reg_pc, reg_next_pc, reg_op1, reg_op2, reg_out;
	reg [4:0] reg_sh;

	reg [31:0] next_insn_opcode;
	reg [31:0] dbg_insn_opcode;
	reg [31:0] dbg_insn_addr;

	wire dbg_mem_valid = mem_valid;
	wire dbg_mem_instr = mem_instr;
	wire dbg_mem_ready = mem_ready;
	wire [31:0] dbg_mem_addr  = mem_addr;
	wire [31:0] dbg_mem_wdata = mem_wdata;
	wire [ 3:0] dbg_mem_wstrb = mem_wstrb;
	wire [31:0] dbg_mem_rdata = mem_rdata;

	assign pcpi_rs1 = reg_op1;
	assign pcpi_rs2 = reg_op2;

	wire [31:0] next_pc;

	reg irq_delay;
	reg irq_active;
	reg [31:0] irq_mask;
	reg [31:0] irq_pending;
	reg [31:0] timer;

  // Instruction Fetch (IF)
  if_stage if_stage_inst (
      .clk(clk),
      .rst_n(rst_n),
      .pc_in(pc),
      .pc_out(pc_next),
      .inst(inst)
  );

  // Instruction Decode (ID)
  id_stage id_stage_inst (
      .clk(clk),
      .inst(inst),
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .imm(imm)
  );

  // Execute (EX)
  ex_stage ex_stage_inst (
      .rs1_data(rs1_data),
      .rs2_data(rs2_data),
      .imm(imm),
      .alu_op(4'b0000), // Example: ADD operation
      .alu_result(alu_result)
  );

  // Memory Access (MEM)
  mem_stage mem_stage_inst (
      .alu_result(alu_result),
      .mem_read(mem_read),
      .mem_write(mem_write),
      .mem_wdata(rs2_data),
      .mem_rdata(mem_rdata)
  );

  // Write-Back (WB)
  wb_stage wb_stage_inst (
      .alu_result(alu_result),
      .mem_rdata(mem_rdata),
      .wb_select(wb_select),
      .wb_data(wb_data)
  );

  // Program Counter Update
  always @(posedge clk or negedge rst_n) begin
      if (!rst_n)
          pc <= 32'h0; // Reset PC
      else
          pc <= pc_next; // Update PC
  end
endmodule

