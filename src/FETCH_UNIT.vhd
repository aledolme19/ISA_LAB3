library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FETCH_UNIT is
	port(
		FETCH_UNIT_in_clk         : in std_logic;
		FETCH_UNIT_in_jump        : in std_logic;
		FETCH_UNIT_in_PCscr       : in std_logic;
		FETCH_UNIT_in_jump_value  : in std_logic_vector(31 downto 0);
		FETCH_UNIT_in_PCscr_value : in std_logic_vector(31 downto 0)
	);
end entity FETCH_UNIT;

architecture BEHAVIORAL of FETCH_UNIT is

	------COMPONENTS--------------------------------------------------------------------
	component PC
		port(
			PC_input  : in  std_logic_vector(31 downto 0);
			PC_in_clk : in  std_logic;
			PC_output : out std_logic_vector(31 downto 0)
		);
	end component PC;

	component bN_3to1mux
		generic(N : integer := 32);
		port(
			X, Y, Z : in  std_logic_vector(N - 1 downto 0);
			S       : in  std_logic_vector(1 downto 0);
			OUTPUT  : out std_logic_vector(N - 1 downto 0)
		);
	end component bN_3to1mux;

	--------SIGNALS------------------------------------------------------------------------
	signal PC_ADD       : std_logic_vector(31 downto 0);
	signal ADD_MUX_MEM  : std_logic_vector(31 downto 0);
	signal MUX_PC       : std_logic_vector(31 downto 0);
	signal MUX_selector : std_logic_vector(1 downto 0);

begin

	i_PC : PC
		port map(
			PC_input  => MUX_PC,
			PC_in_clk => FETCH_UNIT_in_clk,
			PC_output => PC_ADD
		);

	i_selector : MUX_selector <= FETCH_UNIT_in_PCscr & FETCH_UNIT_in_jump;

	ADDER HERE!!!

	i_MUX : bN_3to1mux
		generic map(
			N => 32
		)
		port map(
			X      => ADD_MUX_MEM,
			Y      => FETCH_UNIT_in_jump_value,
			Z      => FETCH_UNIT_in_PCscr_value,
			S      => MUX_selector,
			OUTPUT => MUX_PC
		);

end architecture BEHAVIORAL;
