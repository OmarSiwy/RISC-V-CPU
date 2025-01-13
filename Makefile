VENV_PATH = venv/bin
PYTHON = $(VENV_PATH)/python3
BUILD_DIR = build
SRC_DIR = src
TB_DIR = tb
TEST_DIR = tests/riscv-arch-test
SPIKE_REF_DIR = scripts

# RISC-V toolchain configuration
RISCV_PREFIX = riscv64-unknown-elf-
RISCV_GCC = $(RISCV_PREFIX)gcc
RISCV_OBJDUMP = $(RISCV_PREFIX)objdump
RISCV_OBJCOPY = $(RISCV_PREFIX)objcopy
RISCV_AS = $(RISCV_PREFIX)as

# RISC-V compilation flags
RISCV_FLAGS = -march=rv32imafd -mabi=ilp32 -static -mcmodel=medany \
              -fvisibility=hidden -nostdlib -nostartfiles

# Your existing variables
SPIKE_FILES = $(SPIKE_REF_DIR)/spike_model.py \
             $(SPIKE_REF_DIR)/env/spike_isa.yaml \
             $(SPIKE_REF_DIR)/env/spike_platform.yaml
SRCS = $(SRC_DIR)/cpu.sv $(SRC_DIR)/alu.sv $(SRC_DIR)/decoder.v $(SRC_DIR)/regfile.sv
TB = $(TB_DIR)/tb.sv

# Test parameters
TEST ?= rv32i_m/I/add-01

# Compilation flags
IVERILOG_FLAGS = -g2005-sv -I$(SRC_DIR) \
    -DRISCV_E=1 \
    -DRISCV_I=1 \
    -DRISCV_M=1 \
    -DRISCV_F=1 \
    -DRISCV_D=1 \
    -DRISCV_A=1 \
    -DRISCV_C=1 \
    -DRISCV_ZICSR=1 \
    -DRISCV_ZIFENCEI=1

.PHONY: all clean test setup env compile-tests

all: env setup compile-tests test

env:
	@if [ ! -d "venv" ]; then \
		python3 -m venv venv; \
		. venv/bin/activate; \
		pip install -r requirements.txt; \
	fi

setup: env
	@mkdir -p $(BUILD_DIR)
	@if [ ! -d "$(TEST_DIR)" ]; then \
		git clone https://github.com/riscv-non-isa/riscv-arch-test.git $(TEST_DIR); \
	fi

# New target to compile RISC-V tests
compile-tests:
	@echo "Compiling RISC-V tests..."
	@for suite in I M F D A C Zicsr Zifencei; do \
		if [ -d "$(TEST_DIR)/riscv-test-suite/rv32i_m/$$suite" ]; then \
			for test in $(TEST_DIR)/riscv-test-suite/rv32i_m/$$suite/*.S; do \
				if [ -f "$$test" ]; then \
					mkdir -p $$(dirname "$(BUILD_DIR)/$${test\#$(TEST_DIR)/}"); \
					$(RISCV_GCC) $(RISCV_FLAGS) -I$(TEST_DIR)/riscv-test-suite/env \
						-I$(TEST_DIR)/riscv-test-suite/rv32i_m/$$suite \
						-Iscripts/env \
						$$test -o "$(BUILD_DIR)/$${test\#$(TEST_DIR)/}.elf"; \
					echo "Compiled $$test"; \
				fi \
			done \
		fi \
	done

compile: $(SRCS) $(TB)
	iverilog $(IVERILOG_FLAGS) -o $(BUILD_DIR)/tb.vvp $(TB) $(SRCS)

simulate: compile
	vvp $(BUILD_DIR)/tb.vvp +TEST=$(TEST)

test: setup compile-tests
	riscof run --config=config.ini --suite=$(TEST_DIR)/riscv-test-suite/rv32i_m/I --env=scripts/env/ \
		--suite=$(TEST_DIR)/riscv-test-suite/rv32i_m/M \
		--suite=$(TEST_DIR)/riscv-test-suite/rv32i_m/F \
		--suite=$(TEST_DIR)/riscv-test-suite/rv32i_m/D \
		--suite=$(TEST_DIR)/riscv-test-suite/rv32i_m/A \
		--suite=$(TEST_DIR)/riscv-test-suite/rv32i_m/C \
		--suite=$(TEST_DIR)/riscv-test-suite/rv32i_m/Zicsr \
		--suite=$(TEST_DIR)/riscv-test-suite/rv32i_m/Zifencei

clean:
	rm -rf $(BUILD_DIR)/*
	rm -f *.log
	rm -f *.vcd
	rm -rf riscof_work

deep-clean: clean
	rm -rf venv
	rm -rf $(TEST_DIR)
	rm -rf my_core/riscof_core.pyc
