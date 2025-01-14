#include "Vcpu.h" // Generated by Verilator from cpu.sv
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <verilated.h>
#include <verilated_vcd_c.h>

vluint64_t main_time = 0;

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);

  // Initialize Verilated modules
  Vcpu *top = new Vcpu;

  // Init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC *tfp = new VerilatedVcdC;
  top->trace(tfp, 99);
  tfp->open("cpu.vcd");

  // Parse command line arguments
  std::string signature_file;
  std::string elf_file;

  for (int i = 1; i < argc; i++) {
    std::string arg = argv[i];
    if (arg.substr(0, 10) == "+signature=") {
      signature_file = arg.substr(10);
    } else if (arg.substr(0, 10) == "+elf-file=") {
      elf_file = arg.substr(10);
    }
  }

  // Initialize inputs
  top->clk = 0;
  top->rst_n = 0;

  // Reset sequence
  for (int i = 0; i < 10; i++) {
    top->clk = !top->clk;
    top->eval();
    tfp->dump(main_time++);
  }

  top->rst_n = 1;

  // Main simulation loop
  while (!Verilated::gotFinish() && main_time < 1000000) {
    top->clk = !top->clk;
    top->eval();
    tfp->dump(main_time++);

    // Add your simulation logic here
    // This is where you would implement memory interface,
    // instruction fetch, and signature collection
  }

  // Cleanup
  tfp->close();
  delete top;
  delete tfp;

  return 0;
}
