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

	signal OPCODE        : std_logic_vector(6 downto 0);
	signal FUNCT3        : std_logic_vector(2 downto 0);
	signal CONCATENATION : std_logic_vector(9 downto 0);

begin

	OPCODE <= IMM_GEN_IN_INSTR(6 downto 0);
	FUNCT3 <= IMM_GEN_IN_INSTR(14 downto 12);

	CONCATENATION <= OPCODE & FUNCT3;

	case_process : process(CONCATENATION, IMM_GEN_IN_INSTR) is
	begin
		case CONCATENATION is
			-- ADDI: sign extension
			when "0010011" & "000" =>
				IMM_GEN_OUT <= (31 downto 12 => IMM_GEN_IN_INSTR(31)) & IMM_GEN_IN_INSTR(31 downto 20);
			-- ANDI: sign extension
			when "0010011" & "111" =>
				IMM_GEN_OUT <= (31 downto 12 => IMM_GEN_IN_INSTR(31)) & IMM_GEN_IN_INSTR(31 downto 20);
			-- SRAI: 5 LSBs of the immediate, no sign extension
			when "0010011" & "101" =>
				IMM_GEN_OUT <= (31 downto 5 => '0') & IMM_GEN_IN_INSTR(24 downto 20);
			-- BEQ: immediate has to be assembled in a particular way + sign extension
			when "1100011" & "000" =>
				IMM_GEN_OUT <= (31 downto 13 => IMM_GEN_IN_INSTR(31)) & IMM_GEN_IN_INSTR(31) & IMM_GEN_IN_INSTR(7) & IMM_GEN_IN_INSTR(30 downto 25) & IMM_GEN_IN_INSTR(11 downto 8) & '0';
			-- LW: sign extension
			when "0000011" & "010" =>
				IMM_GEN_OUT <= (31 downto 12 => IMM_GEN_IN_INSTR(31)) & IMM_GEN_IN_INSTR(31 downto 20);
			-- SW: immediate has to be assembled in a particular way + sign extension
			when "0100011" & "010" =>
				IMM_GEN_OUT <= (31 downto 12 => IMM_GEN_IN_INSTR(31)) & IMM_GEN_IN_INSTR(31 downto 25) & IMM_GEN_IN_INSTR(11 downto 7);
			-- AUIPC
			when "0010111" & "---" =>
				IMM_GEN_OUT <= IMM_GEN_IN_INSTR(31 downto 12) & (11 downto 0 => '0');
			-- LUI
			when "0110111" & "---" =>
				IMM_GEN_OUT <= IMM_GEN_IN_INSTR(31 downto 12) & (11 downto 0 => '0');
			-- JAL
			when "1101111" & "---" =>
				IMM_GEN_OUT <= (31 downto 21 => IMM_GEN_IN_INSTR(31)) & IMM_GEN_IN_INSTR(31) & IMM_GEN_IN_INSTR(19 downto 12) & IMM_GEN_IN_INSTR(20) & IMM_GEN_IN_INSTR(30 downto 21) & '0';
			when others =>
				IMM_GEN_OUT <= (31 downto 0 => '-');
		end case;
	end process case_process;

end BEHAVIORAL;
