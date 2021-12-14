library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DATA_MEMORY is
	port(
		DM_IN_DATA     : in std_logic_vector(63 downto 0);
		DM_IN_MEMREAD  : in std_logic;
		DM_IN_MEMWRITE : in std_logic;
		DM_OUT_DATA    : in std_logic_vector(63 downto 0)
	);
end entity DATA_MEMORY;

architecture BEHAVIORAL of DATA_MEMORY is

begin

end architecture BEHAVIORAL;
