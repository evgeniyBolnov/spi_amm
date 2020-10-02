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
add wave -noupdate -radix hexadecimal /ams_spi_tb/ams_spi_inst/writedata
add wave -noupdate -radix hexadecimal /ams_spi_tb/ams_spi_inst/address
add wave -noupdate -radix hexadecimal /ams_spi_tb/ams_spi_inst/spi_shiftreg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {96570 ps} 0} {{Cursor 2} {7610993 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {13625861 ps}
