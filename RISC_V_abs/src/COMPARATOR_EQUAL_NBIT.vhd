library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity COMPARATOR_EQUAL_NBIT is
	generic(N : positive := 32);
	port(
		COMPARATOR_EQ_IN_A : in  std_logic_vector(N - 1 downto 0);
		COMPARATOR_EQ_IN_B : in  std_logic_vector(N - 1 downto 0);
		COMPARATOR_EQ_OUT  : out std_logic
	);
end COMPARATOR_EQUAL_NBIT;

architecture BEHAVIORAL of COMPARATOR_EQUAL_NBIT is

begin

	comparator_process : process(COMPARATOR_EQ_IN_A, COMPARATOR_EQ_IN_B) is
	begin
		if signed(COMPARATOR_EQ_IN_A) = signed(COMPARATOR_EQ_IN_B) then
			COMPARATOR_EQ_OUT <= '1';
		else
			COMPARATOR_EQ_OUT <= '0';
		end if;
	end process comparator_process;

end BEHAVIORAL;

