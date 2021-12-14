library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FORWARDING_UNIT is
	port(
		FU_IN_ID_EX_RS1       : in  std_logic_vector(4 downto 0);
		FU_IN_ID_EX_RS2       : in  std_logic_vector(4 downto 0);
		FU_IN_MEM_WB_RD       : in  std_logic_vector(4 downto 0);
		FU_IN_EX_MEM_RD       : in  std_logic_vector(4 downto 0);
		FU_IN_EX_MEM_REGWRITE : in  std_logic;
		FU_IN_MEM_WB_REGWRITE : in  std_logic;
		FU_OUT_FORWARD_A      : out std_logic_vector(1 downto 0);
		FU_OUT_FORWARD_B      : out std_logic_vector(1 downto 0)
	);
end entity FORWARDING_UNIT;

architecture BEHAVIORAL of FORWARDING_UNIT is

begin

end architecture BEHAVIORAL;
