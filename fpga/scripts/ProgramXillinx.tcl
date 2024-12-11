# Open Hardware Manager
open_hw
connect_hw_server
open_hw_target

current_hw_device [lindex [get_hw_devices] 0] #Grab first hardware device
set_property PROGRAM.FILE {../bitstreams/top.bit} [current_hw_device] #Pass bitstreams
program_hw_devices #Program

# Close Hardware Manager
close_hw_target
disconnect_hw_server
exit
