library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_RISC_V is
end entity tb_RISC_V;

architecture test of tb_RISC_V is

	component RISC_V
		port(
			RISC_V_clk   : in std_logic;
			RISC_V_rst_n : in std_logic
		);
	end component RISC_V;

	signal CLK   : std_logic;
	signal RST_N : std_logic;

begin

	clock_driver : process
		constant period : time := 10 ns;
	begin
		CLK <= '0';
		wait for period / 2;
		CLK <= '1';
		wait for period / 2;
	end process clock_driver;

	i_RISC_V : component RISC_V
		port map(
			RISC_V_clk   => CLK,
			RISC_V_rst_n => RST_N
		);

	stimuli : process is
	begin
		RST_N <= '0';
		wait for 18 ns;

		RST_N <= '1';
		wait;
	end process stimuli;

end architecture test;
