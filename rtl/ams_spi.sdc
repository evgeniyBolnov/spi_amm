proc find { name } {    
    foreach_in_collection node_id [get_registers $name] {
        return [get_node_info -name $node_id]
    }       
    return -1
}

set k 0

foreach_in_collection name_id [get_names -filter {*ams_spi_bridge_?} -node_type hierarchy] {
	set inst [get_name_info -info short_full_path $name_id]
	if {[find *ams_spi_bridge_$k|SCLK_reg*] != -1} {
		create_generated_clock -name SCLK_master_$k -source [get_pins -compatibility_mode $inst|SCLK_reg|clk] -divide_by 2 [get_registers $inst|SCLK_reg]
	}
	incr k
}