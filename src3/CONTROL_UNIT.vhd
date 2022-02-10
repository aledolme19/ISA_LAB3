library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CONTROL_UNIT is
	port(
		CU_IN_OPCODE    : in  std_logic_vector(6 downto 0);
		CU_OUT_Branch   : out std_logic;
		CU_OUT_MemRead  : out std_logic;
		CU_OUT_ALUOp    : out std_logic_vector(1 downto 0);
		CU_OUT_MemWrite : out std_logic;
		CU_OUT_ALUSrc   : out std_logic;
		CU_OUT_RegWrite : out std_logic;
		CU_OUT_Jump     : out std_logic;
		CU_OUT_MemToReg : out std_logic_vector(1 downto 0);
		CU_OUT_Lui      : out std_logic;
		CU_OUT_Auipc    : out std_logic);
end entity CONTROL_UNIT;

architecture BEHAVIORAL of CONTROL_UNIT is

begin

	i_BRU_unit : process(CU_IN_OPCODE)
	begin
		case CU_IN_OPCODE is
			--ADD / XOR / SLT / ABS
			when "0110011" =>
				CU_OUT_Branch   <= '0';
				CU_OUT_MemRead  <= '0';
				CU_OUT_ALUOp    <= "10";
				CU_OUT_MemWrite <= '0';
				CU_OUT_ALUSrc   <= '0';
				CU_OUT_RegWrite <= '1';
				CU_OUT_Jump     <= '0';
				CU_OUT_MemToReg <= "10";
				CU_OUT_Lui      <= '0';
				CU_OUT_Auipc    <= '0';
			--ADDI / ANDI / SRAI
			when "0010011" =>
				CU_OUT_Branch   <= '0';
				CU_OUT_MemRead  <= '0';
				CU_OUT_ALUOp    <= "00";
				CU_OUT_MemWrite <= '0';
				CU_OUT_ALUSrc   <= '1';
				CU_OUT_RegWrite <= '1';
				CU_OUT_Jump     <= '0';
				CU_OUT_MemToReg <= "10";
				CU_OUT_Lui      <= '0';
				CU_OUT_Auipc    <= '0';
			--BEQ
			when "1100011" =>
				CU_OUT_Branch   <= '1';
				CU_OUT_MemRead  <= '0';
				CU_OUT_ALUOp    <= "01";
				CU_OUT_MemWrite <= '0';
				CU_OUT_ALUSrc   <= '0';
				CU_OUT_RegWrite <= '0';
				CU_OUT_Jump     <= '0';
				CU_OUT_MemToReg <= "--";
				CU_OUT_Lui      <= '0';
				CU_OUT_Auipc    <= '0';
			--LW
			when "0000011" =>
				CU_OUT_Branch   <= '0';
				CU_OUT_MemRead  <= '1';
				CU_OUT_ALUOp    <= "00";
				CU_OUT_MemWrite <= '0';
				CU_OUT_ALUSrc   <= '1';
				CU_OUT_RegWrite <= '1';
				CU_OUT_Jump     <= '0';
				CU_OUT_MemToReg <= "01";
				CU_OUT_Lui      <= '0';
				CU_OUT_Auipc    <= '0';
			--SW
			when "0100011" =>
				CU_OUT_Branch   <= '0';
				CU_OUT_MemRead  <= '0';
				CU_OUT_ALUOp    <= "00";
				CU_OUT_MemWrite <= '1';
				CU_OUT_ALUSrc   <= '1';
				CU_OUT_RegWrite <= '0';
				CU_OUT_Jump     <= '0';
				CU_OUT_MemToReg <= "--";
				CU_OUT_Lui      <= '0';
				CU_OUT_Auipc    <= '0';
			--AUIPC
			when "0010111" =>
				CU_OUT_Branch   <= '0';
				CU_OUT_MemRead  <= '0';
				CU_OUT_ALUOp    <= "11";
				CU_OUT_MemWrite <= '0';
				CU_OUT_ALUSrc   <= '1';
				CU_OUT_RegWrite <= '1';
				CU_OUT_Jump     <= '0';
				CU_OUT_MemToReg <= "10";
				CU_OUT_Lui      <= '0';
				CU_OUT_Auipc    <= '1';
			--LUI
			when "0110111" =>
				CU_OUT_Branch   <= '0';
				CU_OUT_MemRead  <= '0';
				CU_OUT_ALUOp    <= "11";
				CU_OUT_MemWrite <= '0';
				CU_OUT_ALUSrc   <= '1';
				CU_OUT_RegWrite <= '1';
				CU_OUT_Jump     <= '0';
				CU_OUT_MemToReg <= "10";
				CU_OUT_Lui      <= '1';
				CU_OUT_Auipc    <= '0';
			--JAL
			when "1101111" =>
				CU_OUT_Branch   <= '0';
				CU_OUT_MemRead  <= '0';
				CU_OUT_ALUOp    <= "--";
				CU_OUT_MemWrite <= '0';
				CU_OUT_ALUSrc   <= '-';
				CU_OUT_RegWrite <= '1';
				CU_OUT_Jump     <= '1';
				CU_OUT_MemToReg <= "11";
				CU_OUT_Lui      <= '0';
				CU_OUT_Auipc    <= '0';
			when others =>
				CU_OUT_Branch   <= '0';
				CU_OUT_MemRead  <= '0';
				CU_OUT_ALUOp    <= "00";
				CU_OUT_MemWrite <= '0';
				CU_OUT_ALUSrc   <= '0';
				CU_OUT_RegWrite <= '0';
				CU_OUT_Jump     <= '0';
				CU_OUT_MemToReg <= "00";
				CU_OUT_Lui      <= '0';
				CU_OUT_Auipc    <= '0';
		end case;
	end process;

end BEHAVIORAL;
