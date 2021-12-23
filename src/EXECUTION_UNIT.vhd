library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EXECUTION_UNIT is
    port(
        EXECUTION_UNIT_in_Adder2: in  std_logic_vector(31 downto 0);
        EXECUTION_UNIT_in_RS1, EXECUTION_UNIT_in_RS2: in  std_logic_vector(4 downto 0);
        EXECUTION_UNIT_in_next_PC, EXECUTION_UNIT_in_current_PC: in  std_logic_vector(31 downto 0);
        EXECUTION_UNIT_in_read_data1, EXECUTION_UNIT_in_read_data2: in  std_logic_vector(31 downto 0);
        EXECUTION_UNIT_in_LUI, EXECUTION_UNIT_in_RegWrite, EXECUTION_UNIT_in_MemRead, EXECUTION_UNIT_in_AUIPC,
 EXECUTION_UNIT_in_Branch, EXECUTION_UNIT_in_ALUScr, EXECUTION_UNIT_in_MemWrite , EXECUTION_UNIT_in_Jump : in  std_logic;
        EXECUTION_UNIT_in_ALUOp, EXECUTION_UNIT_in_MemtoReg: in  std_logic_vector(1 downto 0);
        EXECUTION_UNIT_in_Funct3 : in  std_logic_vector(2 downto 0);
        EXECUTION_UNIT_in_Immediate: in  std_logic_vector(31 downto 0);
        EXECUTION_UNIT_in_RD: in  std_logic_vector(4 downto 0);

        EXECUTION_UNIT_in_MEM_WB_Read_Data: in std_logic_vector(31 downto 0);
        EXECUTION_UNIT_in_EX_MEM_ALU_result: in std_logic_vector(31 downto 0);
        EXECUTION_UNIT_in_EX_MEM_Next_PC    : in  std_logic_vector(31 downto 0);
        EXECUTION_UNIT_in_MEM_WB_Next_PC    : in  std_logic_vector(31 downto 0);

        EXECUTION_UNIT_in_EX_MEM_RD: in std_logic_vector(4 downto 0);
        EXECUTION_UNIT_in_MEM_WB_RD: in std_logic_vector(4 downto 0);
        EXECUTION_UNIT_in_EX_MEM_RegWrite: in std_logic;
        EXECUTION_UNIT_in_MEM_WB_RegWrite: in std_logic;
        EXECUTION_UNIT_in_EX_MEM_Jump: in std_logic;
        EXECUTION_UNIT_in_MEM_WB_Jump: in std_logic;

        ---OUTPUT----------------------------------
        EXECUTION_UNIT_out_Adder2: out std_logic_vector(31 downto 0);
        EXECUTION_UNIT_out_next_PC: out std_logic_vector(31 downto 0);
        EXECUTION_UNIT_out_ALU_zero : out std_logic;
        EXECUTION_UNIT_out_ALU_result: out std_logic_vector(31 downto 0);
        EXECUTION_UNIT_out_RegWrite, EXECUTION_UNIT_out_Branch, EXECUTION_UNIT_out_MemWrite,EXECUTION_UNIT_out_Jump: out std_logic;
        EXECUTION_UNIT_out_MemtoReg: out std_logic_vector(1 downto 0);
        EXECUTION_UNIT_out_RD: out std_logic_vector(4 downto 0)

    );
end entity EXECUTION_UNIT;

architecture RTL of EXECUTION_UNIT is

    ---------------COMPONENTS---------------------------------------------------------    

    component MUX_A_B
        port(
            MUX_A_B_in_EX_MEM_Next_PC    : in  std_logic_vector(31 downto 0);
            MUX_A_B_in_MEM_WB_Next_PC    : in  std_logic_vector(31 downto 0);
            MUX_A_B_in_read_data         : in  std_logic_vector(31 downto 0);
            MUX_A_B_in_EX_MEM_ALU_result : in  std_logic_vector(31 downto 0);
            MUX_A_B_in_MEM_WB_Read_data  : in  std_logic_vector(31 downto 0);
            MUX_A_B_in_sel               : in  std_logic_vector(2 downto 0);
            MUX_A_B_out                  : out  std_logic_vector(31 downto 0)
        );
    end component MUX_A_B;

    component bN_2to1mux
        generic(N : positive := 8);
        port(
            x, y   : in  std_logic_vector(N - 1 downto 0);
            s      : in  std_logic;
            output : out std_logic_vector(N - 1 downto 0)
        );
    end component bN_2to1mux;
    
    component MUX_AUIPC_LUI
        port(
            MUX_AUIPC_LUI_in_zero          : in  std_logic_vector(31 downto 0);
            MUX_AUIPC_LUI_previous_mux_out : in  std_logic_vector(31 downto 0);
            MUX_AUIPC_LUI_current_PC       : in  std_logic_vector(31 downto 0);
            MUX_AUIPC_LUI_in_sel           : in  std_logic_vector(1 downto 0);
            MUX_AUIPC_LUI_out              : out std_logic_vector(31 downto 0)
        );
    end component MUX_AUIPC_LUI;


begin

end architecture RTL;
