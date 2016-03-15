# TCL File Generated by Component Editor 12.1sp1
# Thu Mar 03 15:48:15 MST 2016
# DO NOT MODIFY


# 
# ci_draw_rect "ci_draw_rect" v1.0
# Stephen Just 2016.03.03.15:48:15
# 
# 

# 
# request TCL package from ACDS 12.1
# 
package require -exact qsys 12.1


# 
# module ci_draw_rect
# 
set_module_property NAME ci_draw_rect
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Custom Instructions"
set_module_property AUTHOR "Stephen Just"
set_module_property DISPLAY_NAME ci_draw_rect
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL ci_draw_rect
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file ci_draw_rect.vhd VHDL PATH HDL/ci_draw_rect.vhd
add_fileset_file geometry.vhd VHDL PATH ../common/geometry.vhd
add_fileset_file avalon.vhd VHDL PATH ../common/avalon.vhd
add_fileset_file avalon_write_sequential.vhd VHDL PATH ../common/avalon/avalon_write_sequential.vhd


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

add_interface_port reset reset reset Input 1


# 
# connection point ci
# 
add_interface ci nios_custom_instruction end
set_interface_property ci clockCycle 0
set_interface_property ci operands 0
set_interface_property ci ENABLED true

add_interface_port ci ncs_ci_clk clk Input 1
add_interface_port ci ncs_ci_clk_en clk_en Input 1
add_interface_port ci ncs_ci_reset reset Input 1
add_interface_port ci ncs_ci_start start Input 1
add_interface_port ci ncs_ci_done done Output 1


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

add_interface_port s0 avs_s0_write write Input 1
add_interface_port s0 avs_s0_writedata writedata Input 32
add_interface_port s0 avs_s0_address address Input 3
set_interface_assignment s0 embeddedsw.configuration.isFlash 0
set_interface_assignment s0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment s0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment s0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point m0
# 
add_interface m0 avalon start
set_interface_property m0 addressUnits SYMBOLS
set_interface_property m0 associatedClock clock
set_interface_property m0 associatedReset reset
set_interface_property m0 bitsPerSymbol 8
set_interface_property m0 burstOnBurstBoundariesOnly false
set_interface_property m0 burstcountUnits WORDS
set_interface_property m0 doStreamReads false
set_interface_property m0 doStreamWrites false
set_interface_property m0 holdTime 0
set_interface_property m0 linewrapBursts false
set_interface_property m0 maximumPendingReadTransactions 0
set_interface_property m0 readLatency 0
set_interface_property m0 readWaitTime 1
set_interface_property m0 setupTime 0
set_interface_property m0 timingUnits Cycles
set_interface_property m0 writeWaitTime 0
set_interface_property m0 ENABLED true

add_interface_port m0 avm_m0_write write Output 1
add_interface_port m0 avm_m0_writedata writedata Output 16
add_interface_port m0 avm_m0_burstcount burstcount Output 8
add_interface_port m0 avm_m0_address address Output 32
add_interface_port m0 avm_m0_waitrequest waitrequest Input 1
add_interface_port m0 avm_m0_byteenable byteenable Output 2

