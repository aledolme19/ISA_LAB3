---------------------------------------------------------------------------------------------
-- File: IMM_UNIT.vhd
---------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IMM_GEN is
	port(
		IMM_GEN_IN_INSTR : in  std_logic_vector(31 downto 0);
		IMM_GEN_OUT      : out std_logic_vector(31 downto 0));
end entity IMM_GEN;

architecture BEHAVIORAL of IMM_GEN is

	signal OPCODE : std_logic_vector(6 downto 0);
	signal FUNCT3 : std_logic_vector(2 downto 0);

begin

	OPCODE <= IMM_GEN_IN_INSTR(6 downto 0);
	FUNCT3 <= IMM_GEN_IN_INSTR(14 downto 12);

	case_process : process(OPCODE, FUNCT3, IMM_GEN_IN_INSTR) is
	begin
		-- ADDI: sign extension
		if OPCODE = "0010011" and FUNCT3 = "000" then
			IMM_GEN_OUT <= (31 downto 12 => IMM_GEN_IN_INSTR(31)) & IMM_GEN_IN_INSTR(31 downto 20);
		-- ANDI: sign extension
		elsif OPCODE = "0010011" and FUNCT3 = "111" then
			IMM_GEN_OUT <= (31 downto 12 => IMM_GEN_IN_INSTR(31)) & IMM_GEN_IN_INSTR(31 downto 20);
		-- SRAI: 5 LSBs of the immediate, no sign extension
		elsif OPCODE = "0010011" and FUNCT3 = "101" then
			IMM_GEN_OUT <= (31 downto 5 => '0') & IMM_GEN_IN_INSTR(24 downto 20);
		-- BEQ: immediate has to be assembled in a particular way + sign extension
		elsif OPCODE = "1100011" and FUNCT3 = "000" then
			IMM_GEN_OUT <= (31 downto 13 => IMM_GEN_IN_INSTR(31)) & IMM_GEN_IN_INSTR(31) & IMM_GEN_IN_INSTR(7) & IMM_GEN_IN_INSTR(30 downto 25) & IMM_GEN_IN_INSTR(11 downto 8) & '0';
		-- LW: sign extension
		elsif OPCODE = "0000011" and FUNCT3 = "010" then
			IMM_GEN_OUT <= (31 downto 12 => IMM_GEN_IN_INSTR(31)) & IMM_GEN_IN_INSTR(31 downto 20);
		-- SW: immediate has to be assembled in a particular way + sign extension
		elsif OPCODE = "0100011" and FUNCT3 = "010" then
			IMM_GEN_OUT <= (31 downto 12 => IMM_GEN_IN_INSTR(31)) & IMM_GEN_IN_INSTR(31 downto 25) & IMM_GEN_IN_INSTR(11 downto 7);
		-- AUIPC: 20 upper bits of the instructions, zeros as LSBs
		elsif OPCODE = "0010111" then
			IMM_GEN_OUT <= IMM_GEN_IN_INSTR(31 downto 12) & (11 downto 0 => '0');
		-- LUI: 20 upper bits of the instructions, zeros as LSBs
		elsif OPCODE = "0110111" then
			IMM_GEN_OUT <= IMM_GEN_IN_INSTR(31 downto 12) & (11 downto 0 => '0');
		-- JAL: immediate has to be assembled in a particular way + sign extension
		elsif OPCODE = "1101111" then
			IMM_GEN_OUT <= (31 downto 21 => IMM_GEN_IN_INSTR(31)) & IMM_GEN_IN_INSTR(31) & IMM_GEN_IN_INSTR(19 downto 12) & IMM_GEN_IN_INSTR(20) & IMM_GEN_IN_INSTR(30 downto 21) & '0';
		else
			IMM_GEN_OUT <= (31 downto 0 => '-');
		end if;

	end process case_process;

end BEHAVIORAL;
