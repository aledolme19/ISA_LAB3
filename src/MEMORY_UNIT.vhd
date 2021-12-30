library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEMORY_UNIT is
    port(
        MEMORY_UNIT_in_next_PC: in std_logic_vector(31 downto 0);
        MEMORY_UNIT_in_ADDRESS :in std_logic_vector(31 downto 0);
        MEMORY_UNIT_in_CLK, MEMORY_UNIT_in_rst: in std_logic;
        MEMORY_UNIT_in_MemRead, MEMORY_UNIT_in_MemWrite, MEMORY_UNIT_in_Jump, MEMORY_UNIT_in_RegWrite: in std_logic;
        MEMORY_UNIT_in_MemtoReg: in std_logic_vector(1 downto 0);
        MEMORY_UNIT_in_RD: in std_logic_vector(4 downto 0);
        MEMORY_UNIT_in_DATA: std_logic_vector(31 downto 0);
        --output---------------
        MEMORY_UNIT_out_next_PC: out std_logic_vector(31 downto 0);
        MEMORY_UNIT_out_ReadData: out std_logic_vector(31 downto 0);
        MEMORY_UNIT_out_Jump,  MEMORY_UNIT_out_RegWrite: out std_logic;
        MEMORY_UNIT_out_MemtoReg: out std_logic_vector(1 downto 0);
        MEMORY_UNIT_out_RD: out std_logic_vector(4 downto 0);
        MEMORY_UNIT_out_ALUResult: out std_logic_vector(31 downto 0)
    );
end entity MEMORY_UNIT;

architecture RTL of MEMORY_UNIT is


    component DATA_MEMORY
        generic(
            data_length        : positive := 32;
            address_length : positive := 5
        );
        port(
            DM_IN_CLK      : in  std_logic;
            DM_IN_RST_N    : in  std_logic;
            DM_IN_MEMREAD  : in  std_logic;
            DM_IN_MEMWRITE : in  std_logic;
            DM_IN_DATA     : in  std_logic_vector(data_length - 1 downto 0);
            DM_IN_ADDRESS  : in  std_logic_vector(address_length - 1 downto 0);
            DM_OUT         : out std_logic_vector(data_length - 1 downto 0)
        );
    end component DATA_MEMORY;



begin


    i_DATA_MEMORY: DATA_MEMORY
        generic map(
            data_length        => 32,
            address_length => 5
        )
        port map(
            DM_IN_CLK      => MEMORY_UNIT_in_CLK,
            DM_IN_RST_N    => MEMORY_UNIT_in_rst,
            DM_IN_MEMREAD  => MEMORY_UNIT_in_MemRead,
            DM_IN_MEMWRITE => MEMORY_UNIT_in_MemWrite,
            DM_IN_DATA     => MEMORY_UNIT_in_DATA,
            DM_IN_ADDRESS  => MEMORY_UNIT_in_ADDRESS(4 downto 0),
            DM_OUT         => MEMORY_UNIT_out_ReadData
        );



    ---output-------------------
    MEMORY_UNIT_out_next_PC <= MEMORY_UNIT_in_next_PC;
    MEMORY_UNIT_out_Jump <= MEMORY_UNIT_in_Jump;
    MEMORY_UNIT_out_MemtoReg<= MEMORY_UNIT_in_MemtoReg;
    MEMORY_UNIT_out_RD <= MEMORY_UNIT_in_RD;
    MEMORY_UNIT_out_RegWrite <= MEMORY_UNIT_in_RegWrite;
    MEMORY_UNIT_out_ALUResult <= MEMORY_UNIT_in_ADDRESS;

end architecture RTL;
