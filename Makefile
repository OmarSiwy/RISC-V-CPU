.PHONY: all clean wave

# Build all targets by calling the sub-Makefile
all:
	@echo "Building the project..."
	$(MAKE) -C sim/scripts

# Clean all generated files by calling the sub-Makefile
clean:
	@echo "Cleaning the project..."
	$(MAKE) -C sim/scripts clean

# View waveforms by calling the sub-Makefile's wave target
wave:
	@echo "Opening waveforms..."
	$(MAKE) -C sim/scripts wave
