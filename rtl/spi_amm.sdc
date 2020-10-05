set k 0
set instance_collection [get_registers {*|spi_amm:*|SCLK_reg}]
foreach_in_collection inst $instance_collection {
	set name [get_node_info -name $inst]
	create_generated_clock -name SCLK_slave_$k -source [get_pins -compatibility_mode $name|clk] [get_registers $name]
	incr k
}