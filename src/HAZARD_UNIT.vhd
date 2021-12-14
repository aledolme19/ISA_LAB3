library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HAZARD_UNIT is
	port(
		HU_IN_IF_ID_RS1     : in  std_logic_vector(4 downto 0);
		HU_IN_IF_ID_RS2     : in  std_logic_vector(4 downto 0);
		HU_IN_ID_EX_MEMREAD : in  std_logic;
		HU_IN_ID_EX_RD      : in  std_logic_vector(4 downto 0);
		HU_OUT_IF_ID_WRITE  : out std_logic;
		HU_OUT_PC_WRITE     : out std_logic
	);
end entity HAZARD_UNIT;

architecture BEHAVIORAL of HAZARD_UNIT is

begin

end architecture BEHAVIORAL;
