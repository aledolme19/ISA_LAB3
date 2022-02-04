library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity COMPARATOR_EQ is
	generic(N : positive := 32);
	port(
		COMPARATOR_EQ_IN0 : in  std_logic_vector(N - 1 downto 0);
		COMPARATOR_EQ_IN1 : in  std_logic_vector(N - 1 downto 0);
		COMPARATOR_EQ_OUT : out std_logic
	);
end COMPARATOR_EQ;

--architecture STRUCTURAL of COMPARATOR_EQ is
--
--    component OR_N_BIT
--        generic(N : positive := 32);
--        port(
--            OR_N_BIT_IN  : in  std_logic_vector(N - 1 downto 0);
--            OR_N_BIT_OUT : out std_logic
--        );
--    end component OR_N_BIT;
--
--    signal DIFF_BITS           : std_logic_vector(N - 1 downto 0); -- DIFF_BITS(I) = '1' -> input bits in position I are different 
--                                                                   -- DIFF_BITS(I) = '0' -> input bits in position I are equal
--    signal COMPARATOR_EQ_OUT_N : std_logic;
--
--begin
--
--    -- check if bits at the same position of two input binary string are equal or not
--    compare_bits : process(COMPARATOR_EQ_IN0, COMPARATOR_EQ_IN1)
--    begin
--        for I in 0 to N - 1 loop
--            DIFF_BITS(I) <= COMPARATOR_EQ_IN0(I) xor COMPARATOR_EQ_IN1(I);
--        end loop;
--    end process;
--
--    -- COMPARATOR_EQ_OUT goes to '1' if all bits of DIFF_BITS are '0' (inputs are equal)
--    or_bits : OR_N_BIT
--        generic map(N => N)
--        port map(
--            OR_N_BIT_IN  => DIFF_BITS,
--            OR_N_BIT_OUT => COMPARATOR_EQ_OUT_N
--        );
--
--    COMPARATOR_EQ_OUT <= not (COMPARATOR_EQ_OUT_N);
--
--end STRUCTURAL;

architecture BEHAVIORAL of COMPARATOR_EQ is

begin

	comp : process(COMPARATOR_EQ_IN0, COMPARATOR_EQ_IN1) is
	begin
		if (COMPARATOR_EQ_IN0 = COMPARATOR_EQ_IN1) then
			COMPARATOR_EQ_OUT <= '1';
		else
			COMPARATOR_EQ_OUT <= '0';
		end if;
	end process comp;

end BEHAVIORAL;
