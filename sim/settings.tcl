# Simulator options
set vsim_opt {-voptargs=+acc}

# Compiler options
set vlog_opt {-work work -vlog01compat +incdir+../../../hdl/utils +define+MODELSIM}
set svlog_opt {-work work -sv +incdir+../../../hdl/utils +define+MODELSIM}
set vcom_opt {}

# Top level module
puts "Select module for test:"
puts "1) SPI to AMM"
puts "2) AMM to SPI"
gets stdin c
if { $c == "2" } {
    set top_module ams_spi_tb
    set wave_files {wave2.do}
} else {
    set top_module spi_mm_tb
    set wave_files {wave.do}
}

# Wave format files

set modelsim_edition altera

# for modelsim altera edition library format is simple list
# set altera_library {altera altera_mf cycloneii_ver}

# for modelsim other edition you should to set path to
# compiled altera libraries
# set altera_library {{lib1_path {lib11 lib12}} {lib2_path {lib21 lib22 }}} 

set altera_library {altera_ver altera_mf_ver cyclonev_ver altera_lnsim_ver cyclonev_ver}

#
# Design files
# set design_library { {path1 {file1_1 file1_2}} {path2 {file2_1 file2_2}} }
#

set design_library {
    {
        ../qsys/synthesis/submodules
        {
            altera_avalon_sc_fifo.v                                       
            altera_avalon_st_pipeline_base.v                              
            altera_error_response_slave.sv                                
            altera_error_response_slave_reg_fifo.sv                       
            altera_error_response_slave_resp_logic.sv                     
            altera_merlin_address_alignment.sv                            
            altera_merlin_arbitrator.sv                                   
            altera_merlin_axi_slave_ni.sv                                 
            altera_merlin_burst_uncompressor.sv                           
            altera_merlin_master_agent.sv                                 
            altera_merlin_master_translator.sv                            
            altera_merlin_reorder_memory.sv                               
            altera_merlin_slave_agent.sv                                  
            altera_merlin_slave_translator.sv                             
            altera_merlin_traffic_limiter.sv                              
            altera_reset_controller.v                                     
            altera_reset_synchronizer.v                                     
            i2c_m_irq_mapper.sv                                           
            i2c_m_jtag_uart_0.v                                           
            i2c_m_mm_interconnect_0.v                                     
            i2c_m_mm_interconnect_0_avalon_st_adapter.v                   
            i2c_m_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv  
            i2c_m_mm_interconnect_0_cmd_demux.sv                          
            i2c_m_mm_interconnect_0_cmd_mux.sv                            
            i2c_m_mm_interconnect_0_router.sv                             
            i2c_m_mm_interconnect_0_router_001.sv                         
            i2c_m_mm_interconnect_0_rsp_demux.sv                          
            i2c_m_mm_interconnect_0_rsp_mux.sv                            
            i2c_m_mm_interconnect_1.v                                     
            i2c_m_mm_interconnect_1_avalon_st_adapter.v                   
            i2c_m_mm_interconnect_1_avalon_st_adapter_error_adapter_0.sv  
            i2c_m_mm_interconnect_1_cmd_demux.sv                          
            i2c_m_mm_interconnect_1_cmd_demux_001.sv                      
            i2c_m_mm_interconnect_1_cmd_mux.sv                            
            i2c_m_mm_interconnect_1_cmd_mux_001.sv                        
            i2c_m_mm_interconnect_1_cmd_mux_002.sv                        
            i2c_m_mm_interconnect_1_router.sv                             
            i2c_m_mm_interconnect_1_router_001.sv                         
            i2c_m_mm_interconnect_1_router_002.sv                         
            i2c_m_mm_interconnect_1_router_003.sv                         
            i2c_m_mm_interconnect_1_router_004.sv                         
            i2c_m_mm_interconnect_1_rsp_demux.sv                          
            i2c_m_mm_interconnect_1_rsp_demux_002.sv                      
            i2c_m_mm_interconnect_1_rsp_mux.sv                            
            i2c_m_mm_interconnect_1_rsp_mux_001.sv                        
            i2c_m_nios2_gen2_0.v                                           
            i2c_m_nios2_gen2_0_cpu.v                                      
            i2c_m_nios2_gen2_0_cpu_debug_slave_sysclk.v                   
            i2c_m_nios2_gen2_0_cpu_debug_slave_tck.v                      
            i2c_m_nios2_gen2_0_cpu_debug_slave_wrapper.v                       
            i2c_m_nios2_gen2_0_cpu_test_bench.v                           
            i2c_m_onchip_memory2_0.v                                      
            i2c_m_onchip_memory2_1.v  
        }
    }
    {
        ../rtl
        {
            spi_amm.sv
            ams_spi.sv
        }
    }
    {
        ../sim
        {
            spi_mm_tb.sv  
            ams_spi_tb.sv  
        }
    }
}