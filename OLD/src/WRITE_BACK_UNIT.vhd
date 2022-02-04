library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WRITE_BACK_UNIT is
	port(
		WRITE_BACK_UNIT_in_next_PC    : in  std_logic_vector(31 downto 0);
		WRITE_BACK_UNIT_in_ReadData   : in  std_logic_vector(31 downto 0);
		WRITE_BACK_UNIT_in_MemtoReg   : in  std_logic_vector(1 downto 0);
		WRITE_BACK_UNIT_in_ALU_Result : in  std_logic_vector(31 downto 0);
		PIPE_MEM_WB_out_MUX           : out std_logic_vector(31 downto 0)
	);
end entity WRITE_BACK_UNIT;

architecture BEHAVIORAL of WRITE_BACK_UNIT is

begin

	i_MUX_WriteData : process(WRITE_BACK_UNIT_in_MemtoReg, WRITE_BACK_UNIT_in_next_PC, WRITE_BACK_UNIT_in_ReadData, WRITE_BACK_UNIT_in_ALU_Result)
	begin
		case WRITE_BACK_UNIT_in_MemtoReg is
			when "11" =>
				PIPE_MEM_WB_out_MUX <= WRITE_BACK_UNIT_in_next_PC;
			when "01" =>
				PIPE_MEM_WB_out_MUX <= WRITE_BACK_UNIT_in_ReadData;
			when "10" =>
				PIPE_MEM_WB_out_MUX <= WRITE_BACK_UNIT_in_ALU_Result;
			when others =>
				PIPE_MEM_WB_out_MUX <= (others => '0');
		end case;
	end process;

end architecture BEHAVIORAL;
