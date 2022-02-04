library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bN_2to1mux is
	generic(N : positive := 8);
	port(x, y   : in  std_logic_vector(N - 1 downto 0);
	     s      : in  std_logic;
	     output : out std_logic_vector(N - 1 downto 0)
	    );
end entity bN_2to1mux;

architecture Structure of bN_2to1mux is
begin
	G : for i in 0 to N - 1 generate
		output(i) <= (not (s) and x(i)) or (s and y(i));
	end generate;

end architecture Structure;

--architecture BEHAVIORAL of bN_2to1mux is

--begin

--	i_MUX_2to1 : process(x, y, s)
--	begin
--		case s is
--			when '0' =>
--				output <= x;
--			when '1' =>
--				output <= y;
--			when others =>
--				output <= (others => '0');
--		end case;
--	end process;

--end architecture BEHAVIORAL;
