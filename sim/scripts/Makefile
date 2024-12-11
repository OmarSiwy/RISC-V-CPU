# Tools
IVERILOG   = iverilog
VVP        = vvp
GTKWAVE    = gtkwave

# Directories
HDL_DIR    = ../../hdl/rtl
TB_DIR     = ../../sim/tb
WAVE_DIR   = ../../sim/waves

# Source files
RTL_SRCS   = $(HDL_DIR)/top.sv
TB_SRCS    = $(TB_DIR)/tb_top.sv

# Output files
SIM_OUT    = $(WAVE_DIR)/simv
VCD_OUT    = $(WAVE_DIR)/tb_top.vcd

# Default target
all: simulate

# Compile
$(SIM_OUT): $(RTL_SRCS) $(TB_SRCS)
	@mkdir -p $(WAVE_DIR)
	$(IVERILOG) -g2012 -o $(SIM_OUT) -I $(HDL_DIR) -I $(TB_DIR) $(RTL_SRCS) $(TB_SRCS)

# Simulate
simulate: $(SIM_OUT)
	$(VVP) $(SIM_OUT)

# View waveforms
wave: $(VCD_OUT)
	$(GTKWAVE) $(VCD_OUT)

# Clean
clean:
	rm -rf $(SIM_OUT) $(VCD_OUT) $(WAVE_DIR)
