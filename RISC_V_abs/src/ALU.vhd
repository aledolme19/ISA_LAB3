library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	generic(N : positive := 32);
	port(
		ALU_IN_A       : in  std_logic_vector(N - 1 downto 0);
		ALU_IN_B       : in  std_logic_vector(N - 1 downto 0);
		ALU_IN_CONTROL : in  std_logic_vector(3 downto 0);
		ALU_OUT        : out std_logic_vector(N - 1 downto 0);
		ALU_OUT_ZERO   : out std_logic
	);
end entity ALU;

architecture BEHAVIORAL of ALU is

	component ADDER2_NBIT
		generic(N : positive := 32);
		port(
			ADDER_IN_A     : in  std_logic_vector(N - 1 downto 0);
			ADDER_IN_B     : in  std_logic_vector(N - 1 downto 0);
			ADDER_IN_CARRY : in  std_logic;
			ADDER_OUT_S    : out std_logic_vector(N - 1 downto 0)
		);
	end component ADDER2_NBIT;

	component AND2_NBIT
		generic(N : positive := 32);
		port(
			AND2_IN_A : in  std_logic_vector(N - 1 downto 0);
			AND2_IN_B : in  std_logic_vector(N - 1 downto 0);
			AND2_OUT  : out std_logic_vector(N - 1 downto 0)
		);
	end component AND2_NBIT;

	component XOR2_NBIT
		generic(N : positive := 32);
		port(
			XOR2_IN_A : in  std_logic_vector(N - 1 downto 0);
			XOR2_IN_B : in  std_logic_vector(N - 1 downto 0);
			XOR2_OUT  : out std_logic_vector(N - 1 downto 0)
		);
	end component XOR2_NBIT;

	component COMPARATOR_LESSTHAN_NBIT
		generic(N : positive := 32);
		port(
			COMPARATOR_LT_IN_A : in  std_logic_vector(N - 1 downto 0);
			COMPARATOR_LT_IN_B : in  std_logic_vector(N - 1 downto 0);
			COMPARATOR_LT_OUT  : out std_logic_vector(N - 1 downto 0)
		);
	end component COMPARATOR_LESSTHAN_NBIT;

	component SHIFT_RIGHT_NBIT
		generic(N : positive := 32);
		port(
			SHIFT_IN_OPERAND      : in  std_logic_vector(N - 1 downto 0);
			SHIFT_IN_SHIFT_AMOUNT : in  std_logic_vector(N - 1 downto 0);
			SHIFT_OUT             : out std_logic_vector(N - 1 downto 0)
		);
	end component SHIFT_RIGHT_NBIT;

	component COMPARATOR_EQUAL_NBIT
		generic(N : positive := 32);
		port(
			COMPARATOR_EQ_IN_A : in  std_logic_vector(N - 1 downto 0);
			COMPARATOR_EQ_IN_B : in  std_logic_vector(N - 1 downto 0);
			COMPARATOR_EQ_OUT  : out std_logic
		);
	end component COMPARATOR_EQUAL_NBIT;

	component ABSOLUTE_VALUE
		generic(N : positive := 32);
		port(
			ABSOLUTE_VALUE_IN  : in  std_logic_vector(N - 1 downto 0);
			ABSOLUTE_VALUE_OUT : out std_logic_vector(N - 1 downto 0)
		);
	end component ABSOLUTE_VALUE;

	signal ADD_OUT  : std_logic_vector(N - 1 downto 0);
	signal AND_OUT  : std_logic_vector(N - 1 downto 0);
	signal XOR_OUT  : std_logic_vector(N - 1 downto 0);
	signal SLT_OUT  : std_logic_vector(N - 1 downto 0);
	signal SRAI_OUT : std_logic_vector(N - 1 downto 0);
	signal ABS_OUT  : std_logic_vector(N - 1 downto 0);

begin

	i_ADD : component ADDER2_NBIT
		generic map(
			N => N
		)
		port map(
			ADDER_IN_A     => ALU_IN_A,
			ADDER_IN_B     => ALU_IN_B,
			ADDER_IN_CARRY => '0',
			ADDER_OUT_S    => ADD_OUT
		);

	i_AND : component AND2_NBIT
		generic map(
			N => N
		)
		port map(
			AND2_IN_A => ALU_IN_A,
			AND2_IN_B => ALU_IN_B,
			AND2_OUT  => AND_OUT
		);

	i_XOR : component XOR2_NBIT
		generic map(
			N => N
		)
		port map(
			XOR2_IN_A => ALU_IN_A,
			XOR2_IN_B => ALU_IN_B,
			XOR2_OUT  => XOR_OUT
		);

	i_SLT : component COMPARATOR_LESSTHAN_NBIT
		generic map(
			N => N
		)
		port map(
			COMPARATOR_LT_IN_A => ALU_IN_A,
			COMPARATOR_LT_IN_B => ALU_IN_B,
			COMPARATOR_LT_OUT  => SLT_OUT
		);

	i_SRAI : component SHIFT_RIGHT_NBIT
		generic map(
			N => N
		)
		port map(
			SHIFT_IN_OPERAND      => ALU_IN_A,
			SHIFT_IN_SHIFT_AMOUNT => ALU_IN_B,
			SHIFT_OUT             => SRAI_OUT
		);

	i_ZERO : component COMPARATOR_EQUAL_NBIT
		generic map(
			N => N
		)
		port map(
			COMPARATOR_EQ_IN_A => ALU_IN_A,
			COMPARATOR_EQ_IN_B => ALU_IN_B,
			COMPARATOR_EQ_OUT  => ALU_OUT_ZERO
		);

	mux_3_1 : with ALU_IN_CONTROL select ALU_OUT <=
		ADD_OUT when "0010",
		AND_OUT when "0000",
		XOR_OUT when "0011",
		SLT_OUT when "0110",
		SRAI_OUT when "0100",
		ABS_OUT when "0101",
		(N - 1 downto 0 => '-') when others;

	i_absolute : component ABSOLUTE_VALUE
		generic map(
			N => N
		)
		port map(
			ABSOLUTE_VALUE_IN  => ALU_IN_A,
			ABSOLUTE_VALUE_OUT => ABS_OUT
		);

end architecture BEHAVIORAL;
