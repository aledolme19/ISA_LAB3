library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ABSOLUTE_VALUE is
	generic(N : positive := 32);
	port(
		ABSOLUTE_VALUE_IN  : in  std_logic_vector(N - 1 downto 0);
		ABSOLUTE_VALUE_OUT : out std_logic_vector(N - 1 downto 0)
	);
end ABSOLUTE_VALUE;

architecture BEHAVIORAL of ABSOLUTE_VALUE is

begin

	ABSOLUTE_VALUE_OUT <= std_logic_vector(abs (signed(ABSOLUTE_VALUE_IN)));

end BEHAVIORAL;
