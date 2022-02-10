library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity OR_N_BIT is
	generic(N : positive := 32);
	port(
		OR_N_BIT_IN  : in  std_logic_vector(N - 1 downto 0);
		OR_N_BIT_OUT : out std_logic
	);
end OR_N_BIT;

architecture STRUCTURAL of OR_N_BIT is

begin

	-- OR between N bit
	or_nbit : process(OR_N_BIT_IN)
		variable TEMP_V : std_logic;
	begin
		TEMP_V       := OR_N_BIT_IN(0);
		for I in 1 to N - 1 loop
			TEMP_V := TEMP_V or OR_N_BIT_IN(I);
		end loop;
		OR_N_BIT_OUT <= TEMP_V;
	end process;

end STRUCTURAL;
