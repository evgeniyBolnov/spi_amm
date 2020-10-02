onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ams_spi_tb/ams_spi_inst/main_clk
add wave -noupdate /ams_spi_tb/ams_spi_inst/main_reset
add wave -noupdate -divider SPI
add wave -noupdate /ams_spi_tb/MISO
add wave -noupdate /ams_spi_tb/MOSI
add wave -noupdate /ams_spi_tb/SCLK
add wave -noupdate /ams_spi_tb/nSS
add wave -noupdate -divider {Avalon-MM slave}
add wave -noupdate -radix hexadecimal /ams_spi_tb/ams_address
add wave -noupdate /ams_spi_tb/ams_read
add wave -noupdate -radix hexadecimal /ams_spi_tb/ams_readdata
add wave -noupdate /ams_spi_tb/ams_readdatavalid
add wave -noupdate /ams_spi_tb/ams_waitrequest
add wave -noupdate /ams_spi_tb/ams_write
add wave -noupdate -radix hexadecimal /ams_spi_tb/ams_writedata
add wave -noupdate -divider {Avalon-MM master}
add wave -noupdate -radix hexadecimal /ams_spi_tb/spi_amm_inst/amm_address
add wave -noupdate /ams_spi_tb/spi_amm_inst/amm_read
add wave -noupdate -radix hexadecimal /ams_spi_tb/spi_amm_inst/amm_readdata
add wave -noupdate /ams_spi_tb/spi_amm_inst/amm_readdatavalid
add wave -noupdate /ams_spi_tb/spi_amm_inst/amm_waitrequest
add wave -noupdate /ams_spi_tb/spi_amm_inst/amm_write
add wave -noupdate -radix hexadecimal /ams_spi_tb/spi_amm_inst/amm_writedata
add wave -noupdate -divider debug
add wave -noupdate /ams_spi_tb/ams_spi_inst/ams_state
add wave -noupdate /ams_spi_tb/ams_spi_inst/spi_state
add wave -noupdate -radix hexadecimal /ams_spi_tb/ams_spi_inst/crc
add wave -noupdate -radix hexadecimal /ams_spi_tb/ams_spi_inst/readdata
add wave -noupdate /ams_spi_tb/ams_spi_inst/SCLK_reg
add wave -noupdate -radix hexadecimal -childformat {{{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[31]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[30]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[29]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[28]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[27]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[26]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[25]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[24]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[23]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[22]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[21]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[20]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[19]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[18]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[17]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[16]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[15]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[14]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[13]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[12]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[11]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[10]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[9]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[8]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[7]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[6]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[5]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[4]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[3]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[2]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[1]} -radix hexadecimal} {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[0]} -radix hexadecimal}} -expand -subitemconfig {{/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[31]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[30]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[29]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[28]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[27]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[26]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[25]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[24]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[23]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[22]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[21]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[20]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[19]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[18]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[17]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[16]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[15]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[14]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[13]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[12]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[11]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[10]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[9]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[8]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[7]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[6]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[5]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[4]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[3]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[2]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[1]} {-radix hexadecimal} {/ams_spi_tb/ams_spi_inst/spi_read_shiftreg[0]} {-radix hexadecimal}} /ams_spi_tb/ams_spi_inst/spi_read_shiftreg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {39140 ps} 0} {{Cursor 2} {5344650 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {5149217 ps} {5828633 ps}
