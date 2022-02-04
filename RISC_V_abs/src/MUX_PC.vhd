library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_PC is
	port(
		MUX_PC_in_PC_new    : in  std_logic_vector(31 downto 0);
		MUX_PC_in_PC_Branch : in  std_logic_vector(31 downto 0);
		MUX_PC_in_PC_Jump   : in  std_logic_vector(31 downto 0);
		MUX_PC_in_sel       : in  std_logic_vector(1 downto 0);
		MUX_PC_out          : out std_logic_vector(31 downto 0)
	);
end entity MUX_PC;

architecture BEHAVIORAL of MUX_PC is

begin

	i_MUX_PC : process(MUX_PC_in_sel, MUX_PC_in_PC_new, MUX_PC_in_PC_Jump, MUX_PC_in_PC_Branch)
	begin
		case MUX_PC_in_sel is
			when "00" =>
				MUX_PC_out <= MUX_PC_in_PC_new;
			when "01" =>
				MUX_PC_out <= MUX_PC_in_PC_Jump;
			when "10" =>
				MUX_PC_out <= MUX_PC_in_PC_Branch;
			when others =>
				MUX_PC_out <= (others => '0');
		end case;
	end process;

end architecture BEHAVIORAL;
