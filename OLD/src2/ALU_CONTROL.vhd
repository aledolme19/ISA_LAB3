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

begin

	i_BRU_unit : process(ALU_CONTROL_IN_ALUOP, ALU_CONTROL_IN_FUNCT3)
	begin
		-- add
		if ALU_CONTROL_IN_ALUOP = "10" and ALU_CONTROL_IN_FUNCT3 = "000" then
			ALU_CONTROL_OUT <= "0010";
		-- addi
		elsif ALU_CONTROL_IN_ALUOP = "00" and ALU_CONTROL_IN_FUNCT3 = "000" then
			ALU_CONTROL_OUT <= "0010";
		-- andi
		elsif ALU_CONTROL_IN_ALUOP = "00" and ALU_CONTROL_IN_FUNCT3 = "111" then
			ALU_CONTROL_OUT <= "0000";
		-- xor
		elsif ALU_CONTROL_IN_ALUOP = "10" and ALU_CONTROL_IN_FUNCT3 = "100" then
			ALU_CONTROL_OUT <= "0011";
		-- srai
		elsif ALU_CONTROL_IN_ALUOP = "00" and ALU_CONTROL_IN_FUNCT3 = "101" then
			ALU_CONTROL_OUT <= "0100";
		-- beq
		elsif ALU_CONTROL_IN_ALUOP = "01" and ALU_CONTROL_IN_FUNCT3 = "000" then
			ALU_CONTROL_OUT <= "0110";
		-- slt
		elsif ALU_CONTROL_IN_ALUOP = "10" and ALU_CONTROL_IN_FUNCT3 = "010" then
			ALU_CONTROL_OUT <= "0110";
		-- lw & sw
		elsif ALU_CONTROL_IN_ALUOP = "00" and ALU_CONTROL_IN_FUNCT3 = "010" then
			ALU_CONTROL_OUT <= "0010";
		-- auipc & lui
		elsif ALU_CONTROL_IN_ALUOP = "11" then
			ALU_CONTROL_OUT <= "0010";
		--ABS
		elsif ALU_CONTROL_IN_ALUOP = "10" and ALU_CONTROL_IN_FUNCT3 = "111" then
			ALU_CONTROL_OUT <= "0101";
		else
			ALU_CONTROL_OUT <= "----";
		end if;
	end process;

end architecture BEHAVIORAL;
