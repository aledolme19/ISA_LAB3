# analysis of vhdl files
analyze -f vhdl -lib WORK ../src/bN_2to1mux.vhd
analyze -f vhdl -lib WORK ../src/bN_3to1mux.vhd
analyze -f vhdl -lib WORK ../src/flipflop_en_rst_n.vhd
analyze -f vhdl -lib WORK ../src/flipflop_en_rst_n_falling_edge.vhd
analyze -f vhdl -lib WORK ../src/latch_en_rst_n.vhd
analyze -f vhdl -lib WORK ../src/reg_en_rst_n.vhd
analyze -f vhdl -lib WORK ../src/reg_en_rst_n_falling_edge.vhd
analyze -f vhdl -lib WORK ../src/reg_rst_n.vhd
analyze -f vhdl -lib WORK ../src/or_n_bit.vhd
analyze -f vhdl -lib WORK ../src/comparator_eq.vhd
analyze -f vhdl -lib WORK ../src/COMPARATOR_EQUAL_NBIT.vhd
analyze -f vhdl -lib WORK ../src/PC.vhd
analyze -f vhdl -lib WORK ../src/REGISTER_FILE.vhd
analyze -f vhdl -lib WORK ../src/ADDER2_NBIT.vhd
analyze -f vhdl -lib WORK ../src/IMM_GEN.vhd
analyze -f vhdl -lib WORK ../src/FORWARDING_UNIT.vhd
analyze -f vhdl -lib WORK ../src/HAZARD_UNIT.vhd
analyze -f vhdl -lib WORK ../src/MUX_AUIPC_LUI.vhd
analyze -f vhdl -lib WORK ../src/MUX_A_B.vhd
analyze -f vhdl -lib WORK ../src/MUX_PC.vhd
analyze -f vhdl -lib WORK ../src/AND2_NBIT.vhd
analyze -f vhdl -lib WORK ../src/XOR2_NBIT.vhd
analyze -f vhdl -lib WORK ../src/COMPARATOR_LESSTHAN_NBIT.vhd
analyze -f vhdl -lib WORK ../src/SHIFT_RIGHT_NBIT.vhd
analyze -f vhdl -lib WORK ../src/SUBTRACTOR2_NBIT.vhd
analyze -f vhdl -lib WORK ../src/ABSOLUTE_VALUE.vhd
analyze -f vhdl -lib WORK ../src/ALU.vhd
analyze -f vhdl -lib WORK ../src/ALU_CONTROL.vhd
analyze -f vhdl -lib WORK ../src/CONTROL_UNIT.vhd
analyze -f vhdl -lib WORK ../src/FETCH_UNIT.vhd
analyze -f vhdl -lib WORK ../src/DECODING_UNIT.vhd
analyze -f vhdl -lib WORK ../src/EXECUTION_UNIT.vhd
analyze -f vhdl -lib WORK ../src/MEMORY_UNIT.vhd
analyze -f vhdl -lib WORK ../src/WRITE_BACK_UNIT.vhd
analyze -f vhdl -lib WORK ../src/PIPE_IF_ID.vhd
analyze -f vhdl -lib WORK ../src/PIPE_ID_EX.vhd
analyze -f vhdl -lib WORK ../src/PIPE_EX_MEM.vhd
analyze -f vhdl -lib WORK ../src/PIPE_MEM_WB.vhd
analyze -f vhdl -lib WORK ../src/RISC_V.vhd

set power_preserve_rtl_hier_names true

# elaboration
elaborate RISC_V -arch BEHAVIORAL -lib WORK > output_elaborate.txt

# clock creation
create_clock -name MY_CLK -period 0 {RISC_V_clk}

set_dont_touch_network MY_CLK
set_fix_hold [get_clocks MY_CLK]
set_clock_uncertainty 0.07 [get_clocks MY_CLK]
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] RISC_V_clk]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

# compilation
compile -exact_map

# creating clock AFTER the synthesis
create_clock -name MY_CLK -period 1.45 {RISC_V_clk}

# ddc file saving
write -hierarchy -format ddc -output ../netlist/ddc_files/RISC_V.ddc

# verilog netlist generation
ungroup -all -flatten
change_names -hierarchy -rules verilog
write -f verilog -hierarchy -output ../netlist/syn/RISC_V.v
write_sdc ../netlist/syn/RISC_V.sdc

# report
report_power > ../netlist/results/power.txt
report_power -net > ../netlist/results/power_net.txt
report_power -hier > ../netlist/results/power_hier.txt
report_timing > ../netlist/results/timing.txt
report_area -hierarchy > ../netlist/results/area.txt



