# RISC-V CPU (Embedded 32-bit)

## Block Diagram of ASIC

### Electrical Properties

- **Power Supply:**
  - 5V input via(J10) or 7V–15V via (J12) or Pin 8 of Header J7
  - Select power source using jumper JP13 ("5V SELECT")

- **I/O Voltage Levels:**
  - 3.3V logic levels

- **Power Consumption:**
  - Refer to the synth/reports/ folder for more

---

## How I Built This Project on Linux

### Requirements

Install necessary tools:

```bash
# Icarus Verilog
sudo pacman -S iverilog
# GTKWave
sudo pacman -S gtkwave
# Vivado
yay -S vitis fxload digilent.adept.runtime digilent.adept.utilities

```

### Build and Test

```Bash
make # to build projects
make wave # to view waveforms
make clean # to clean up
```

### Upload to Digilent Xillinx support FPGA

```Bash
vivado -mode batch -source synth/scripts/Bitstreams.tcl
vivado -mode batch -source synth/scripts/GeneratePowerReport.tcl
vivado -mode batch -source synth/scripts/Netlist.tcl
vivado -mode batch -source fpga/scripts/ProgramXillinx.tcl

# Alternative to batch all of this: (If you have an xillinx)
vivado -mode batch -source BuildAndUpload.tcl
```
