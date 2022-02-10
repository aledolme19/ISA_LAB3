library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity COMPARATOR_LESSTHAN_NBIT is
	generic(N : positive := 32);
	port(
		COMPARATOR_LT_IN_A : in  std_logic_vector(N - 1 downto 0);
		COMPARATOR_LT_IN_B : in  std_logic_vector(N - 1 downto 0);
		COMPARATOR_LT_OUT  : out std_logic_vector(N - 1 downto 0)
	);
end COMPARATOR_LESSTHAN_NBIT;

architecture BEHAVIORAL of COMPARATOR_LESSTHAN_NBIT is

begin

	comparator_process : process(COMPARATOR_LT_IN_A, COMPARATOR_LT_IN_B) is
	begin
		if signed(COMPARATOR_LT_IN_A) < signed(COMPARATOR_LT_IN_B) then
			COMPARATOR_LT_OUT <= (N - 1 downto 1 => '0') & '1';
		else
			COMPARATOR_LT_OUT <= (N - 1 downto 0 => '0');
		end if;
	end process comparator_process;

end BEHAVIORAL;

