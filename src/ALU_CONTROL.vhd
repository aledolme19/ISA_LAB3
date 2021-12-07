library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_CONTROL is
    port(
        ALU_CONTROL_in_ALUOp  : in  std_logic_vector(1 downto 0);
        ALU_CONTROL_in_Funct3 : in  std_logic_vector(2 downto 0);
        ALU_CONTROL_out       : out std_logic_vector(3 downto 0));
end entity ALU_CONTROL;

architecture RTL of ALU_CONTROL is

    signal input_concatenation : std_logic_vector(4 downto 0);

begin

    input_concatenation <= ALU_CONTROL_in_ALUOp & ALU_CONTROL_in_Funct3;

    i_BRU_unit : process(input_concatenation)
    begin
        case input_concatenation is

            --ANDI
            when "00111" =>
                ALU_CONTROL_out <= "0000";
            --SRAI
            when "00101" =>
                ALU_CONTROL_out <= "0001";
            --ADDI
            when "00000" =>
                ALU_CONTROL_out <= "0010";
            --LW
            when "00010" =>
                ALU_CONTROL_out <= "0010";
            --ADD
            when "10000" =>
                ALU_CONTROL_out <= "0010";
            --SW
            when "00010" =>
                ALU_CONTROL_out <= "0010";
            --XOR
            when "10100" =>
                ALU_CONTROL_out <= "0011";
            --SLT
            when "10010" =>
                ALU_CONTROL_out <= "0110";
            --BEQ
            when "01000" =>
                ALU_CONTROL_out <= "0111";
            --AIUPC
            when ??? =>
            ALU_CONTROL_out <= "1010";
            --LUI
            when ??? =>
            ALU_CONTROL_out <= "1011";
        when others =>
            
            
        
                   

        end case;
    end process;

end architecture RTL;
