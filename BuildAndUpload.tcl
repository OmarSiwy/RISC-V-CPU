puts "Starting Synthesis and Bitstream Generation..."
source synth/scripts/Bitstreams.tcl
puts "Generating Power Report..."
source synth/scripts/GeneratePowerReport.tcl
puts "Generating Netlist..."
source synth/scripts/Netlist.tcl
puts "Uploading..."
source fpga/scripts/ProgramXillinx.tcl
puts "All tasks completed successfully."
exit
