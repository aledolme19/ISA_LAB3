library ieee;
use ieee.std_logic_1164.all;

entity flipflop_en_rst_n is
	port(
		D     : in  std_logic;
		clk   : in  std_logic;
		rst_n : in  std_logic;
		en    : in  std_logic;
		Q     : out std_logic
	);
end entity flipflop_en_rst_n;

architecture behaviour of flipflop_en_rst_n is
begin

	reg_process : process(clk, rst_n) is
	begin
		if rst_n = '0' then
			Q <= '0';
		elsif rising_edge(clk) then
			if en = '1' then
				Q <= D;
			end if;
		end if;
	end process reg_process;

end architecture behaviour;
