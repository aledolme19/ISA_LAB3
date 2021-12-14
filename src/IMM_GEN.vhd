---------------------------------------------------------------------------------------------
-- File: IMM_UNIT.vhd
---------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IMM_GEN is
	port(
		IMM_UNIT_IN_INSTR : in  std_logic_vector(31 downto 0);
		IMM_UNIT_OUT      : out std_logic_vector(63 downto 0));
end entity IMM_GEN;

architecture BEHAVIORAL of IMM_GEN is

begin

end BEHAVIORAL;
