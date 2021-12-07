library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        PC_input : in std_logic_vector(31 downto 0);
        PC_in_clk: in std_logic;
        PC_output : out std_logic_vector(31 downto 0)
    );
end entity PC;

architecture BEHAVIORAL of PC is
    
begin



end architecture BEHAVIORAL;
