set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports i_clk]
create_clock -period 40.000 -name i_clk -waveform {0.000 20.000} -add [get_ports i_clk]
#create_clock -period 20.000 -name sys_clk_pin -waveform {0.000 10.000} -add [get_ports i_clk]

#set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports i_rst]
#set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33} [get_ports i_rx]
#set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports o_tx]

set_property PACKAGE_PIN G19 [get_ports o_pulse]
set_property IOSTANDARD LVCMOS33 [get_ports o_pulse]

#set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {o_state[0]}]
#set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {o_state[1]}]
#set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {o_state[2]}]
#set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports {o_state[3]}]

#set_property BITSTREAM.STARTUP.STARTUPCLK JTAGCLK [current_design]

set_property CFGBVS VCCO [current_design]

set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]


