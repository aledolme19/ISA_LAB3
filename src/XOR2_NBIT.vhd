library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XOR2_NBIT is
	generic(N : positive := 32);
	port(
		XOR2_IN_A : in  std_logic_vector(N - 1 downto 0);
		XOR2_IN_B : in  std_logic_vector(N - 1 downto 0);
		XOR2_OUT  : out std_logic_vector(N - 1 downto 0)
	);
end XOR2_NBIT;

architecture BEHAVIORAL of XOR2_NBIT is

begin

	XOR2_OUT <= XOR2_IN_A xor XOR2_IN_B;

end BEHAVIORAL;

