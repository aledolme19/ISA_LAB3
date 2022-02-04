library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SUBTRACTOR2_NBIT is
	generic(N : positive := 32);
	port(
		SUB_IN_A : in  std_logic_vector(N - 1 downto 0);
		SUB_IN_B : in  std_logic_vector(N - 1 downto 0);
		SUB_OUT  : out std_logic_vector(N - 1 downto 0)
	);
end SUBTRACTOR2_NBIT;

architecture BEHAVIORAL of SUBTRACTOR2_NBIT is

	component ADDER2_NBIT
		generic(N : positive := 32);
		port(
			ADDER_IN_A     : in  std_logic_vector(N - 1 downto 0);
			ADDER_IN_B     : in  std_logic_vector(N - 1 downto 0);
			ADDER_IN_CARRY : in  std_logic;
			ADDER_OUT_S    : out std_logic_vector(N - 1 downto 0)
		);
	end component ADDER2_NBIT;

	signal SUB_IN_B_NOT : std_logic_vector(N - 1 downto 0);

begin

	SUB_IN_B_NOT <= not (SUB_IN_B);

	i_ADDER : component ADDER2_NBIT
		generic map(
			N => N
		)
		port map(
			ADDER_IN_A     => SUB_IN_A,
			ADDER_IN_B     => SUB_IN_B_NOT,
			ADDER_IN_CARRY => '1',
			ADDER_OUT_S    => SUB_OUT
		);

end BEHAVIORAL;

