---------------------------------------------------------------------------------------------
-- File: IMM_UNIT.vhd
---------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CONTROL_UNIT is
    port(
        CU_in_OPCODE    : in  std_logic_vector(5 downto 0);
        CU_out_Branch   : out std_logic;
        CU_out_MemRead  : out std_logic;
        CU_out_ALUOp    : out std_logic_vector(1 downto 0);
        CU_out_MemWrite : out std_logic;
        CU_out_ALUSrc   : out std_logic;
        CU_out_RegWrite : out std_logic;
        CU_out_Jump     : out std_logic;
        CU_out_WB_Dir   : out std_logic_vector(1 downto 0));
end entity CONTROL_UNIT;

architecture BEHAVIORAL of CONTROL_UNIT is

begin

    i_BRU_unit : process(CU_in_OPCODE)
    begin
        case CU_in_OPCODE is

            --LUI
            when "0110111" =>
                CU_out_Branch   <= '0';
                CU_out_MemRead  <= '0';
                CU_out_ALUOp    <= "11";
                CU_out_MemWrite <= '0';
                CU_out_ALUSrc   <= '1';
                CU_out_RegWrite <= '1';
                CU_out_Jump     <= '0';
                CU_out_WB_Dir   <= "10";

            --AUIPC
            when "0010111" =>
                CU_out_Branch   <= '0';
                CU_out_MemRead  <= '0';
                CU_out_ALUOp    <= "11";
                CU_out_MemWrite <= '0';
                CU_out_ALUSrc   <= '1';
                CU_out_RegWrite <= '1';
                CU_out_Jump     <= '0';
                CU_out_WB_Dir   <= "00";

            --JAL
            when "1101111" =>
                CU_out_Branch   <= '1';
                CU_out_MemRead  <= '0';
                CU_out_ALUOp    <= "11";
                CU_out_MemWrite <= '0';
                CU_out_ALUSrc   <= '1';
                CU_out_RegWrite <= '1';
                CU_out_Jump     <= '1';
                CU_out_WB_Dir   <= "01";

            --BEQ
            when "1100011" =>
                CU_out_Branch   <= '1';
                CU_out_MemRead  <= '0';
                CU_out_ALUOp    <= "01";
                CU_out_MemWrite <= '0';
                CU_out_ALUSrc   <= '0';
                CU_out_RegWrite <= '0';
                CU_out_Jump     <= '0';
                CU_out_WB_Dir   <= "10";

            --LW
            when "0000011" =>
                CU_out_Branch   <= '0';
                CU_out_MemRead  <= '1';
                CU_out_ALUOp    <= "00";
                CU_out_MemWrite <= '0';
                CU_out_ALUSrc   <= '1';
                CU_out_RegWrite <= '1';
                CU_out_Jump     <= '0';
                CU_out_WB_Dir   <= "11";

            --SW
            when "0100011" =>
                CU_out_Branch   <= '0';
                CU_out_MemRead  <= '0';
                CU_out_ALUOp    <= "00";
                CU_out_MemWrite <= '1';
                CU_out_ALUSrc   <= '1';
                CU_out_RegWrite <= '0';
                CU_out_Jump     <= '0';
                CU_out_WB_Dir   <= "10";

            --ADDI
            when "0010011" =>
                CU_out_Branch   <= '0';
                CU_out_MemRead  <= '0';
                CU_out_ALUOp    <= "00";
                CU_out_MemWrite <= '0';
                CU_out_ALUSrc   <= '1';
                CU_out_RegWrite <= '1';
                CU_out_Jump     <= '0';
                CU_out_WB_Dir   <= "10";

            --ANDI
            when "0010011" =>
                CU_out_Branch   <= '0';
                CU_out_MemRead  <= '0';
                CU_out_ALUOp    <= "00";
                CU_out_MemWrite <= '0';
                CU_out_ALUSrc   <= '1';
                CU_out_RegWrite <= '1';
                CU_out_Jump     <= '0';
                CU_out_WB_Dir   <= "10";

            --SRAI
            when "0010011" =>
                CU_out_Branch   <= '0';
                CU_out_MemRead  <= '0';
                CU_out_ALUOp    <= "00";
                CU_out_MemWrite <= '0';
                CU_out_ALUSrc   <= '1';
                CU_out_RegWrite <= '1';
                CU_out_Jump     <= '0';
                CU_out_WB_Dir   <= "10";

            --ADD
            when "0110011" =>
                CU_out_Branch   <= '0';
                CU_out_MemRead  <= '0';
                CU_out_ALUOp    <= "10";
                CU_out_MemWrite <= '0';
                CU_out_ALUSrc   <= '0';
                CU_out_RegWrite <= '1';
                CU_out_Jump     <= '0';
                CU_out_WB_Dir   <= "10";

            --SLT
            when "0110011" =>
                CU_out_Branch   <= '0';
                CU_out_MemRead  <= '0';
                CU_out_ALUOp    <= "10";
                CU_out_MemWrite <= '0';
                CU_out_ALUSrc   <= '0';
                CU_out_RegWrite <= '1';
                CU_out_Jump     <= '0';
                CU_out_WB_Dir   <= "10";

            --XOR
            when "0110011" =>
                CU_out_Branch   <= '0';
                CU_out_MemRead  <= '0';
                CU_out_ALUOp    <= "10";
                CU_out_MemWrite <= '0';
                CU_out_ALUSrc   <= '0';
                CU_out_RegWrite <= '1';
                CU_out_Jump     <= '0';
                CU_out_WB_Dir   <= "10";

            when others =>
                CU_out_Branch   <= '0';
                CU_out_MemRead  <= '0';
                CU_out_ALUOp    <= "00";
                CU_out_MemWrite <= '0';
                CU_out_ALUSrc   <= '0';
                CU_out_RegWrite <= '0';
                CU_out_Jump     <= '0';
                CU_out_WB_Dir   <= "00";

        end case;
    end process;

end BEHAVIORAL;
