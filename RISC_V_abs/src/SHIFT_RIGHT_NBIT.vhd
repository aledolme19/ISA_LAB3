library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SHIFT_RIGHT_NBIT is
	generic(N : positive := 32);
	port(
		SHIFT_IN_OPERAND      : in  std_logic_vector(N - 1 downto 0);
		SHIFT_IN_SHIFT_AMOUNT : in  std_logic_vector(N - 1 downto 0);
		SHIFT_OUT             : out std_logic_vector(N - 1 downto 0)
	);
end SHIFT_RIGHT_NBIT;

architecture BEHAVIORAL of SHIFT_RIGHT_NBIT is

begin

	--	shift_process : process(SHIFT_IN_OPERAND, SHIFT_IN_SHIFT_AMOUNT) is
	--	begin
	--		SHIFT_OUT <= std_logic_vector(shift_right(signed(SHIFT_IN_OPERAND), to_integer(unsigned(SHIFT_IN_SHIFT_AMOUNT))));
	--	end process shift_process;

	SHIFT_OUT <= std_logic_vector(unsigned(to_stdlogicvector(to_bitvector(std_logic_vector(SHIFT_IN_OPERAND)) sra to_integer(unsigned(SHIFT_IN_SHIFT_AMOUNT)))));

end BEHAVIORAL;

