library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FETCH_UNIT is
	port(
		FETCH_UNIT_in_clk            : in  std_logic;
		FETCH_UNIT_in_rst_n          : in  std_logic;
		FETCH_UNIT_in_jump           : in  std_logic;
		FETCH_UNIT_in_PCscr          : in  std_logic;
		FETCH_UNIT_in_jump_value     : in  std_logic_vector(31 downto 0);
		FETCH_UNIT_in_PCscr_value    : in  std_logic_vector(31 downto 0);
		FETCH_UNIT_in_Hazard_control : in  std_logic;
		FETCH_UNIT_out_next_PC       : out std_logic_vector(31 downto 0);
		FETCH_UNIT_out_current_PC    : out std_logic_vector(31 downto 0)
	);
end entity FETCH_UNIT;

architecture BEHAVIORAL of FETCH_UNIT is

	------COMPONENTS--------------------------------------------------------------------
	component PC
		port(
			PC_input  : in  std_logic_vector(31 downto 0);
			PC_in_clk : in  std_logic;
			PC_in_en  : in  std_logic;
			PC_in_rst : in  std_logic;
			PC_output : out std_logic_vector(31 downto 0)
		);
	end component PC;

	component ADDER2_NBIT
		generic(N : positive := 32);
		port(
			ADDER_IN_A     : in  std_logic_vector(N - 1 downto 0);
			ADDER_IN_B     : in  std_logic_vector(N - 1 downto 0);
			ADDER_IN_CARRY : in  std_logic;
			ADDER_OUT_S    : out std_logic_vector(N - 1 downto 0)
		);
	end component ADDER2_NBIT;

	component MUX_PC
		port(
			MUX_PC_in_PC_new    : in  std_logic_vector(31 downto 0);
			MUX_PC_in_PC_Branch : in  std_logic_vector(31 downto 0);
			MUX_PC_in_PC_Jump   : in  std_logic_vector(31 downto 0);
			MUX_PC_in_sel       : in  std_logic_vector(1 downto 0);
			MUX_PC_out          : out std_logic_vector(31 downto 0)
		);
	end component MUX_PC;

	--------SIGNALS------------------------------------------------------------------------
	signal PC_ADD_MEM   : std_logic_vector(31 downto 0); --OUTPUT OF PC
	signal MUXPC_PC     : std_logic_vector(31 downto 0);
	signal MUX_selector : std_logic_vector(1 downto 0);
	signal ADD_MUX      : std_logic_vector(31 downto 0);

begin

	i_PC : PC
		port map(
			PC_input  => MUXPC_PC,
			PC_in_clk => FETCH_UNIT_in_clk,
			PC_in_en  => FETCH_UNIT_in_Hazard_control,
			PC_in_rst => FETCH_UNIT_in_rst_n,
			PC_output => PC_ADD_MEM
		);

	i_ADDER1 : ADDER2_NBIT
		generic map(N => 32)
		port map(
			ADDER_IN_A     => PC_ADD_MEM,
			ADDER_IN_B     => "00000000000000000000000000000100",
			ADDER_IN_CARRY => '0',
			ADDER_OUT_S    => ADD_MUX
		);

	MUX_selector <= FETCH_UNIT_in_PCscr & FETCH_UNIT_in_jump;

	i_MUXPC : MUX_PC
		port map(
			MUX_PC_in_PC_new    => ADD_MUX,
			MUX_PC_in_PC_Branch => FETCH_UNIT_in_PCscr_value,
			MUX_PC_in_PC_Jump   => FETCH_UNIT_in_jump_value,
			MUX_PC_in_sel       => MUX_selector,
			MUX_PC_out          => MUXPC_PC
		);

	-----------------------OUTPUT-------------------------------------
	FETCH_UNIT_out_current_PC <= PC_ADD_MEM;
	FETCH_UNIT_out_next_PC    <= ADD_MUX;

end architecture BEHAVIORAL;
