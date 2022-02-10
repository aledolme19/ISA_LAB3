
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_A_B is
	port(
		MUX_A_B_in_MEM_WB_Next_PC       : in  std_logic_vector(31 downto 0);
		MUX_A_B_in_read_data            : in  std_logic_vector(31 downto 0);
		MUX_A_B_in_EX_MEM_ALU_result    : in  std_logic_vector(31 downto 0);
		MUX_A_B_in_MEM_WB_MUX_WriteData : in  std_logic_vector(31 downto 0);
		MUX_A_B_in_sel                  : in  std_logic_vector(1 downto 0);
		MUX_A_B_out                     : out std_logic_vector(31 downto 0)
	);
end entity MUX_A_B;

architecture BEHAVIORAL of MUX_A_B is

begin

	i_MUX_A_B : process(MUX_A_B_in_sel, MUX_A_B_in_read_data, MUX_A_B_in_EX_MEM_ALU_result, MUX_A_B_in_MEM_WB_Next_PC, MUX_A_B_in_MEM_WB_MUX_WriteData)
	begin
		case MUX_A_B_in_sel is
			when "00" =>
				MUX_A_B_out <= MUX_A_B_in_read_data;
			when "01" =>
				MUX_A_B_out <= MUX_A_B_in_EX_MEM_ALU_result;
			when "10" =>
				MUX_A_B_out <= MUX_A_B_in_MEM_WB_MUX_WriteData;
			when "11" =>
				MUX_A_B_out <= MUX_A_B_in_MEM_WB_Next_PC;
			when others =>
				MUX_A_B_out <= (others => '0');
		end case;
	end process;

end architecture BEHAVIORAL;
