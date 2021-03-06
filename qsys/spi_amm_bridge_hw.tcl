# TCL File Generated by Component Editor 18.1
# Fri Oct 02 09:35:19 MSK 2020
# DO NOT MODIFY


# 
# spi_amm_bridge "SPI to Avalon-MM bridge" v1.0
# Bolnov Evgeniy 2020.10.02.09:35:19
# SPI to Avalon-MM bridge
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module spi_amm_bridge
# 
set_module_property DESCRIPTION "SPI to Avalon-MM bridge"
set_module_property NAME spi_amm_bridge
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Basic Functions/Bridges and Adaptors/Memory Mapped"
set_module_property AUTHOR "Bolnov Evgeniy"
set_module_property DISPLAY_NAME "SPI to Avalon-MM bridge"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL spi_amm
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file spi_amm.sv SYSTEM_VERILOG PATH ../rtl/spi_amm.sv TOP_LEVEL_FILE
add_fileset_file spi_amm.sdc SDC PATH ../rtl/spi_amm.sdc


# 
# parameters
# 
add_parameter AMM_ADDR_WIDTH INTEGER 32
set_parameter_property AMM_ADDR_WIDTH DEFAULT_VALUE 32
set_parameter_property AMM_ADDR_WIDTH DISPLAY_NAME "Разрядность адреса"
set_parameter_property AMM_ADDR_WIDTH TYPE INTEGER
set_parameter_property AMM_ADDR_WIDTH UNITS Bits
set_parameter_property AMM_ADDR_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property AMM_ADDR_WIDTH HDL_PARAMETER true
set_parameter_property AMM_ADDR_WIDTH SYSTEM_INFO_TYPE ADDRESS_WIDTH
set_parameter_property AMM_ADDR_WIDTH SYSTEM_INFO_ARG avalon_master


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock main_clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset main_reset reset Input 1


# 
# connection point avalon_master
# 
add_interface avalon_master avalon start
set_interface_property avalon_master addressUnits WORDS
set_interface_property avalon_master associatedClock clock
set_interface_property avalon_master associatedReset reset
set_interface_property avalon_master bitsPerSymbol 8
set_interface_property avalon_master burstOnBurstBoundariesOnly false
set_interface_property avalon_master burstcountUnits WORDS
set_interface_property avalon_master doStreamReads false
set_interface_property avalon_master doStreamWrites false
set_interface_property avalon_master holdTime 0
set_interface_property avalon_master linewrapBursts false
set_interface_property avalon_master maximumPendingReadTransactions 0
set_interface_property avalon_master maximumPendingWriteTransactions 0
set_interface_property avalon_master readLatency 0
set_interface_property avalon_master readWaitTime 1
set_interface_property avalon_master setupTime 0
set_interface_property avalon_master timingUnits Cycles
set_interface_property avalon_master writeWaitTime 0
set_interface_property avalon_master ENABLED true
set_interface_property avalon_master EXPORT_OF ""
set_interface_property avalon_master PORT_NAME_MAP ""
set_interface_property avalon_master CMSIS_SVD_VARIABLES ""
set_interface_property avalon_master SVD_ADDRESS_GROUP ""

add_interface_port avalon_master amm_address address Output AMM_ADDR_WIDTH
add_interface_port avalon_master amm_writedata writedata Output 32
add_interface_port avalon_master amm_readdata readdata Input 32
add_interface_port avalon_master amm_write write Output 1
add_interface_port avalon_master amm_read read Output 1
add_interface_port avalon_master amm_readdatavalid readdatavalid Input 1
add_interface_port avalon_master amm_waitrequest waitrequest Input 1


# 
# connection point SPI
# 
add_interface SPI conduit end
set_interface_property SPI associatedClock clock
set_interface_property SPI associatedReset reset
set_interface_property SPI ENABLED true
set_interface_property SPI EXPORT_OF ""
set_interface_property SPI PORT_NAME_MAP ""
set_interface_property SPI CMSIS_SVD_VARIABLES ""
set_interface_property SPI SVD_ADDRESS_GROUP ""

add_interface_port SPI MISO miso Output 1
add_interface_port SPI MOSI mosi Input 1
add_interface_port SPI SCLK sclk Input 1
add_interface_port SPI nSS nss Input 1

