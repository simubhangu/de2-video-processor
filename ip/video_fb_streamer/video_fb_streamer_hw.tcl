# TCL File Generated by Component Editor 12.1sp1
# Sun Mar 20 13:20:58 MDT 2016
# DO NOT MODIFY


# 
# video_fb_streamer "video_fb_streamer" v1.0
# Stephen Just 2016.03.20.13:20:58
# 
# 

# 
# request TCL package from ACDS 12.1
# 
package require -exact qsys 12.1


# 
# module video_fb_streamer
# 
set_module_property NAME video_fb_streamer
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Video Pipeline"
set_module_property AUTHOR "Stephen Just"
set_module_property DISPLAY_NAME video_fb_streamer
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL video_fb_streamer
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file video_fb_streamer.vhd VHDL PATH HDL/video_fb_streamer.vhd
add_fileset_file video_fb_sdram_reader.vhd VHDL PATH HDL/video_fb_sdram_reader.vhd
add_fileset_file video_fb_fifo.vhd VHDL PATH HDL/video_fb_fifo.vhd
add_fileset_file video_fb_dma_manager.vhd VHDL PATH HDL/video_fb_dma_manager.vhd


# 
# parameters
# 
add_parameter SRAM_BUF_START_ADDRESS STD_LOGIC_VECTOR 0
set_parameter_property SRAM_BUF_START_ADDRESS DEFAULT_VALUE 0
set_parameter_property SRAM_BUF_START_ADDRESS DISPLAY_NAME SRAM_BUF_START_ADDRESS
set_parameter_property SRAM_BUF_START_ADDRESS TYPE STD_LOGIC_VECTOR
set_parameter_property SRAM_BUF_START_ADDRESS UNITS None
set_parameter_property SRAM_BUF_START_ADDRESS ALLOWED_RANGES 0:4294967295
set_parameter_property SRAM_BUF_START_ADDRESS HDL_PARAMETER true
add_parameter BITS_PER_PIXEL INTEGER 8
set_parameter_property BITS_PER_PIXEL DEFAULT_VALUE 8
set_parameter_property BITS_PER_PIXEL DISPLAY_NAME BITS_PER_PIXEL
set_parameter_property BITS_PER_PIXEL TYPE INTEGER
set_parameter_property BITS_PER_PIXEL UNITS None
set_parameter_property BITS_PER_PIXEL ALLOWED_RANGES -2147483648:2147483647
set_parameter_property BITS_PER_PIXEL HDL_PARAMETER true
add_parameter FRAME_WIDTH INTEGER 640
set_parameter_property FRAME_WIDTH DEFAULT_VALUE 640
set_parameter_property FRAME_WIDTH DISPLAY_NAME FRAME_WIDTH
set_parameter_property FRAME_WIDTH TYPE INTEGER
set_parameter_property FRAME_WIDTH UNITS None
set_parameter_property FRAME_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property FRAME_WIDTH HDL_PARAMETER true
add_parameter FRAME_HEIGHT INTEGER 480
set_parameter_property FRAME_HEIGHT DEFAULT_VALUE 480
set_parameter_property FRAME_HEIGHT DISPLAY_NAME FRAME_HEIGHT
set_parameter_property FRAME_HEIGHT TYPE INTEGER
set_parameter_property FRAME_HEIGHT UNITS None
set_parameter_property FRAME_HEIGHT ALLOWED_RANGES -2147483648:2147483647
set_parameter_property FRAME_HEIGHT HDL_PARAMETER true


# 
# display items
# 


# 
# connection point source
# 
add_interface source avalon_streaming start
set_interface_property source associatedClock pix_clk
set_interface_property source associatedReset reset
set_interface_property source dataBitsPerSymbol 8
set_interface_property source errorDescriptor ""
set_interface_property source firstSymbolInHighOrderBits true
set_interface_property source maxChannel 0
set_interface_property source readyLatency 0
set_interface_property source ENABLED true

add_interface_port source aso_source_data data Output bits_per_pixel
add_interface_port source aso_source_endofpacket endofpacket Output 1
add_interface_port source aso_source_startofpacket startofpacket Output 1
add_interface_port source aso_source_valid valid Output 1
add_interface_port source aso_source_ready ready Input 1


# 
# connection point clk
# 
add_interface clk clock end
set_interface_property clk clockRate 0
set_interface_property clk ENABLED true

add_interface_port clk clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true

add_interface_port reset reset reset Input 1


# 
# connection point pix_clk
# 
add_interface pix_clk clock end
set_interface_property pix_clk clockRate 0
set_interface_property pix_clk ENABLED true

add_interface_port pix_clk pix_clk clk Input 1


# 
# connection point dma0
# 
add_interface dma0 avalon start
set_interface_property dma0 addressUnits SYMBOLS
set_interface_property dma0 associatedClock clk
set_interface_property dma0 associatedReset reset
set_interface_property dma0 bitsPerSymbol 8
set_interface_property dma0 burstOnBurstBoundariesOnly false
set_interface_property dma0 burstcountUnits WORDS
set_interface_property dma0 doStreamReads false
set_interface_property dma0 doStreamWrites false
set_interface_property dma0 holdTime 0
set_interface_property dma0 linewrapBursts false
set_interface_property dma0 maximumPendingReadTransactions 0
set_interface_property dma0 readLatency 0
set_interface_property dma0 readWaitTime 1
set_interface_property dma0 setupTime 0
set_interface_property dma0 timingUnits Cycles
set_interface_property dma0 writeWaitTime 0
set_interface_property dma0 ENABLED true

add_interface_port dma0 avm_dma0_writedata writedata Output 16
add_interface_port dma0 avm_dma0_write write Output 1
add_interface_port dma0 avm_dma0_burstcount burstcount Output 8
add_interface_port dma0 avm_dma0_read read Output 1
add_interface_port dma0 avm_dma0_address address Output 32
add_interface_port dma0 avm_dma0_waitrequest waitrequest Input 1
add_interface_port dma0 avm_dma0_readdatavalid readdatavalid Input 1
add_interface_port dma0 avm_dma0_readdata readdata Input 16


# 
# connection point dma1
# 
add_interface dma1 avalon start
set_interface_property dma1 addressUnits SYMBOLS
set_interface_property dma1 associatedClock clk
set_interface_property dma1 associatedReset reset
set_interface_property dma1 bitsPerSymbol 8
set_interface_property dma1 burstOnBurstBoundariesOnly false
set_interface_property dma1 burstcountUnits WORDS
set_interface_property dma1 doStreamReads false
set_interface_property dma1 doStreamWrites false
set_interface_property dma1 holdTime 0
set_interface_property dma1 linewrapBursts false
set_interface_property dma1 maximumPendingReadTransactions 0
set_interface_property dma1 readLatency 0
set_interface_property dma1 readWaitTime 1
set_interface_property dma1 setupTime 0
set_interface_property dma1 timingUnits Cycles
set_interface_property dma1 writeWaitTime 0
set_interface_property dma1 ENABLED true

add_interface_port dma1 avm_dma1_readdata readdata Input 16
add_interface_port dma1 avm_dma1_read read Output 1
add_interface_port dma1 avm_dma1_readdatavalid readdatavalid Input 1
add_interface_port dma1 avm_dma1_waitrequest waitrequest Input 1
add_interface_port dma1 avm_dma1_address address Output 32
add_interface_port dma1 avm_dma1_burstcount burstcount Output 8


# 
# connection point ext
# 
add_interface ext conduit end
set_interface_property ext associatedClock clk
set_interface_property ext associatedReset reset
set_interface_property ext ENABLED true

add_interface_port ext coe_ext_trigger trigger Input 1
add_interface_port ext coe_ext_done done Output 1


# 
# connection point s0
# 
add_interface s0 avalon end
set_interface_property s0 addressUnits WORDS
set_interface_property s0 associatedClock clk
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
set_interface_assignment s0 embeddedsw.configuration.isFlash 0
set_interface_assignment s0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment s0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment s0 embeddedsw.configuration.isPrintableDevice 0

