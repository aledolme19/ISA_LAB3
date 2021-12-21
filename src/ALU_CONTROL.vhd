library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_CONTROL is
	port(
		ALU_CONTROL_IN_ALUOP  : in  std_logic_vector(1 downto 0);
		ALU_CONTROL_IN_FUNCT3 : in  std_logic_vector(2 downto 0);
		ALU_CONTROL_OUT       : out std_logic_vector(3 downto 0));
end entity ALU_CONTROL;

architecture BEHAVIORAL of ALU_CONTROL is

	signal input_concatenation : std_logic_vector(4 downto 0);

begin

	input_concatenation <= ALU_CONTROL_IN_ALUOP & ALU_CONTROL_IN_FUNCT3;

	i_BRU_unit : process(input_concatenation)
	begin
		case input_concatenation is
			--ADD
			when "10000" =>
				ALU_CONTROL_OUT <= "0010";
			--ADDI
			when "00000" =>
				ALU_CONTROL_OUT <= "0010";
			--ANDI
			when "00111" =>
				ALU_CONTROL_OUT <= "0000";
			--XOR
			when "10100" =>
				ALU_CONTROL_OUT <= "0011";
			--SRAI
			when "00101" =>
				ALU_CONTROL_OUT <= "0001";
			--BEQ
			when "01000" =>
				ALU_CONTROL_OUT <= "0111";
			--SLT
			when "10010" =>
				ALU_CONTROL_OUT <= "0110";
			--LW & SW
			when "00010" =>
				ALU_CONTROL_OUT <= "0010";
			--AUIPC & LUI
			when "11---" =>
				ALU_CONTROL_OUT <= "0010";
			when others =>
				ALU_CONTROL_OUT <= "----";
		end case;
	end process;

end architecture BEHAVIORAL;
