library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AND2_NBIT is
	generic(N : positive := 32);
	port(
		AND2_IN_A : in  std_logic_vector(N - 1 downto 0);
		AND2_IN_B : in  std_logic_vector(N - 1 downto 0);
		AND2_OUT  : out std_logic_vector(N - 1 downto 0)
	);
end AND2_NBIT;

architecture BEHAVIORAL of AND2_NBIT is

begin

	AND2_OUT <= AND2_IN_A and AND2_IN_B;

end BEHAVIORAL;

