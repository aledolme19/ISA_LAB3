---------------------------------------------------------------------------------------------
-- File: IMM_UNIT.vhd
---------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IMM_UNIT is
    port(
        IMM_UNIT_in_INSTR    : in  std_logic_vector(31 downto 0);
        IMM_UNIT_out    : out  std_logic_vector(63 downto 0));
end entity IMM_UNIT;

architecture BEHAVIORAL of IMM_UNIT is

begin



end BEHAVIORAL;