library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_HAZARD_UNIT is
end TB_HAZARD_UNIT;

architecture TEST of TB_HAZARD_UNIT is

    component HAZARD_UNIT
        port(
            HU_IN_IF_ID_RS1          : in  std_logic_vector(4 downto 0);
            HU_IN_IF_ID_RS2          : in  std_logic_vector(4 downto 0);
            HU_IN_ID_EX_MEMREAD      : in  std_logic;
            HU_IN_ID_EX_RD           : in  std_logic_vector(4 downto 0);
            HU_IN_IF_ID_BRANCH       : in  std_logic;
            HU_IN_ID_EX_BRANCH       : in  std_logic;
            HU_IN_EX_MEM_BRANCH      : in  std_logic;
            HU_IN_ID_EX_JUMP         : in  std_logic;
            HU_IN_MEM_WB_BRANCHTAKEN : in  std_logic;
            HU_OUT_IF_ID_PC_WRITE    : out std_logic;
            HU_OUT_NOP_SEL           : out std_logic
        );
    end component HAZARD_UNIT;
    
    signal IF_ID_RS1, IF_ID_RS2                    : std_logic_vector(4 downto 0);
    signal ID_EX_RD                                : std_logic_vector(4 downto 0);
    signal IF_ID_BRANCH                            : std_logic;
    signal ID_EX_MEMREAD, ID_EX_BRANCH, ID_EX_JUMP : std_logic;
    signal EX_MEM_BRANCH                           : std_logic;
    signal MEM_WB_BRANCHTAKEN                      : std_logic;
    signal IF_ID_PC_WRITE, NOP_SEL                 : std_logic;
    signal CLK: std_logic;
    
begin
    
    DUT: HAZARD_UNIT
        port map(
            HU_IN_IF_ID_RS1          => IF_ID_RS1,
            HU_IN_IF_ID_RS2          => IF_ID_RS2,
            HU_IN_ID_EX_MEMREAD      => ID_EX_MEMREAD,
            HU_IN_ID_EX_RD           => ID_EX_RD,
            HU_IN_IF_ID_BRANCH       => IF_ID_BRANCH,
            HU_IN_ID_EX_BRANCH       => ID_EX_BRANCH,
            HU_IN_EX_MEM_BRANCH      => EX_MEM_BRANCH,
            HU_IN_ID_EX_JUMP         => ID_EX_JUMP,
            HU_IN_MEM_WB_BRANCHTAKEN => MEM_WB_BRANCHTAKEN,
            HU_OUT_IF_ID_PC_WRITE    => IF_ID_PC_WRITE,
            HU_OUT_NOP_SEL           => NOP_SEL
        );
        
    CLK_gen: process
    begin
        CLK <= '0';
        wait for 5 ns;
        CLK <= '1';
        wait for 5 ns;
    end process;
        
    stimuli_gen: process
    begin
        -- Consecutive jumps
        IF_ID_RS1 <= std_logic_vector(to_unsigned(10, 5));
        IF_ID_RS1 <= std_logic_vector(to_unsigned(10, 5));
    end process;

end TEST;
