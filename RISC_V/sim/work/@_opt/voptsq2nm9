library verilog;
use verilog.vl_types.all;
entity RISC_V is
    port(
        RISC_V_clk      : in     vl_logic;
        RISC_V_rst_n    : in     vl_logic;
        RISC_V_instruction: in     vl_logic_vector(31 downto 0);
        RISC_V_ReadData : in     vl_logic_vector(31 downto 0);
        RISC_V_add_instruction_memory: out    vl_logic_vector(31 downto 0);
        RISC_V_add_data_memory: out    vl_logic_vector(31 downto 0);
        RISC_V_MemRead  : out    vl_logic;
        RISC_V_MemWrite : out    vl_logic;
        RISC_V_DATA_data_memory: out    vl_logic_vector(31 downto 0)
    );
end RISC_V;
