library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PIPE_IF_ID is
	port(
		PIPE_IF_ID_clk              : in  std_logic;
		PIPE_IF_ID_rst              : in  std_logic;
		PIPE_IF_ID_ENABLE           : in  std_logic;
		PIPE_IF_ID_in_next_PC       : in  std_logic_vector(31 downto 0);
		PIPE_IF_ID_in_current_PC    : in  std_logic_vector(31 downto 0);
		PIPE_IF_ID_in_instructions  : in  std_logic_vector(31 downto 0);
		PIPE_IF_ID_out_next_PC      : out std_logic_vector(31 downto 0);
		PIPE_IF_ID_out_current_PC   : out std_logic_vector(31 downto 0);
		PIPE_IF_ID_out_instructions : out std_logic_vector(31 downto 0)
	);
end entity PIPE_IF_ID;

architecture BEHAVIORAL of PIPE_IF_ID is

	------------COMPONONENTs--------------------------------------------------
	component reg_en_rst_n_falling_edge
		generic(N : positive := 32);
		port(
			D     : in  std_logic_vector(N - 1 downto 0);
			en    : in  std_logic;
			rst_n : in  std_logic;
			clk   : in  std_logic;
			Q     : out std_logic_vector(N - 1 downto 0)
		);
	end component reg_en_rst_n_falling_edge;

	-----------SIGNALS--------------------------------------------------------

begin

	i_PIPE_next_PC : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_IF_ID_in_next_PC,
			en    => PIPE_IF_ID_ENABLE,
			rst_n => PIPE_IF_ID_rst,
			clk   => PIPE_IF_ID_clk,
			Q     => PIPE_IF_ID_out_next_PC
		);

	i_PIPE_current_PC : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_IF_ID_in_current_PC,
			en    => PIPE_IF_ID_ENABLE,
			rst_n => PIPE_IF_ID_rst,
			clk   => PIPE_IF_ID_clk,
			Q     => PIPE_IF_ID_out_current_PC
		);

	i_PIPE_instructions : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_IF_ID_in_instructions,
			en    => PIPE_IF_ID_ENABLE,
			rst_n => PIPE_IF_ID_rst,
			clk   => PIPE_IF_ID_clk,
			Q     => PIPE_IF_ID_out_instructions
		);

end architecture BEHAVIORAL;
