# TCL File Generated by Component Editor 12.1sp1
# Sat Feb 06 12:58:11 MST 2016
# DO NOT MODIFY


# 
# genesis_controller "genesis_controller" v1.0
# null 2016.02.06.12:58:11
# 
# 

# 
# request TCL package from ACDS 12.1
# 
package require -exact qsys 12.1


# 
# module genesis_controller
# 
set_module_property NAME genesis_controller
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property DISPLAY_NAME genesis_controller
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL genesis_controller_interface
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file controller.vhd VHDL PATH controller.vhd


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true

add_interface_port reset reset_n reset_n Input 1


# 
# connection point s0
# 
add_interface s0 avalon end
set_interface_property s0 addressUnits WORDS
set_interface_property s0 associatedClock clock
set_interface_property s0 associatedReset reset
set_interface_property s0 bitsPerSymbol 8
set_interface_property s0 burstOnBurstBoundariesOnly false
set_interface_property s0 burstcountUnits WORDS
set_interface_property s0 explicitAddressSpan 0
set_interface_property s0 holdTime 0
set_interface_property s0 linewrapBursts false
set_interface_property s0 maximumPendingReadTransactions 0
set_interface_property s0 readLatency 0
set_interface_property s0 readWaitTime 1
set_interface_property s0 setupTime 0
set_interface_property s0 timingUnits Cycles
set_interface_property s0 writeWaitTime 0
set_interface_property s0 ENABLED true

add_interface_port s0 avs_s0_read_n read_n Input 1
add_interface_port s0 avs_s0_readdata readdata Output 32
set_interface_assignment s0 embeddedsw.configuration.isFlash 0
set_interface_assignment s0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment s0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment s0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock clock
set_interface_property conduit_end associatedReset reset
set_interface_property conduit_end ENABLED true

add_interface_port conduit_end dpad_up_input1 export Input 1
add_interface_port conduit_end dpad_down_input1 export Input 1
add_interface_port conduit_end dpad_left_input1 export Input 1
add_interface_port conduit_end dpad_right_input1 export Input 1
add_interface_port conduit_end select_input1 export Input 1
add_interface_port conduit_end start_c_input1 export Input 1
add_interface_port conduit_end ab_input1 export Input 1
add_interface_port conduit_end dpad_up_input2 export Input 1
add_interface_port conduit_end dpad_down_input2 export Input 1
add_interface_port conduit_end dpad_left_input2 export Input 1
add_interface_port conduit_end dpad_right_input2 export Input 1
add_interface_port conduit_end select_input2 export Input 1
add_interface_port conduit_end start_c_input2 export Input 1
add_interface_port conduit_end ab_input2 export Input 1

