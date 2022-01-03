library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
	port(
		PC_input  : in  std_logic_vector(31 downto 0);
		PC_in_clk : in  std_logic;
		PC_in_en  : in  std_logic;
		PC_in_rst : in  std_logic;
		PC_output : out std_logic_vector(31 downto 0)
	);
end entity PC;

architecture BEHAVIORAL of PC is

begin

	reg_process : process(PC_in_clk, PC_in_rst) is
	begin
		if PC_in_rst = '0' then
			PC_output <= (others => '0');
		elsif falling_edge(PC_in_clk) then
			if PC_in_en = '1' then
				PC_output <= PC_input;
			end if;
		end if;
	end process reg_process;

end architecture BEHAVIORAL;

