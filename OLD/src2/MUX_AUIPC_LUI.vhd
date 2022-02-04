
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_AUIPC_LUI is
	port(
		MUX_AUIPC_LUI_in_zero          : in  std_logic_vector(31 downto 0);
		MUX_AUIPC_LUI_previous_mux_out : in  std_logic_vector(31 downto 0);
		MUX_AUIPC_LUI_current_PC       : in  std_logic_vector(31 downto 0);
		MUX_AUIPC_LUI_in_sel           : in  std_logic_vector(1 downto 0);
		MUX_AUIPC_LUI_out              : out std_logic_vector(31 downto 0)
	);
end entity MUX_AUIPC_LUI;

architecture BEHAVIORAL of MUX_AUIPC_LUI is

begin

	i_MUX_AUIPC_LUI : process(MUX_AUIPC_LUI_in_sel, MUX_AUIPC_LUI_current_PC, MUX_AUIPC_LUI_previous_mux_out, MUX_AUIPC_LUI_in_zero)
	begin
		case MUX_AUIPC_LUI_in_sel is
			when "00" =>
				MUX_AUIPC_LUI_out <= MUX_AUIPC_LUI_previous_mux_out;
			when "01" =>
				MUX_AUIPC_LUI_out <= MUX_AUIPC_LUI_in_zero;
			when "10" =>
				MUX_AUIPC_LUI_out <= MUX_AUIPC_LUI_current_PC;
			when others =>
				MUX_AUIPC_LUI_out <= (others => '0');
		end case;
	end process;

end architecture BEHAVIORAL;
