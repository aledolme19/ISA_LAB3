vlog -work work ../netlist/innovus/RISC_V.v
vcom -93 -work work ../tb/DATA_MEMORY.vhd
vcom -93 -work work ../tb/INSTRUCTION_MEMORY.vhd
vcom -93 -work work ../tb/tb_RISC_V.vhd

vsim -L /software/dk/nangate45/verilog/msim6.2g -t ps work.tb_RISC_V

add wave *

run 2 us
