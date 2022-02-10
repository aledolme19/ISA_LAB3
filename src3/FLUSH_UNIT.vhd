library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FLUSH_UNIT is
    port(
          FLUSH_UNIT_PCSrc: in std_logic;
          FLUSH_UNIT_rst_n: out std_logic
    );
end entity FLUSH_UNIT;

architecture RTL of FLUSH_UNIT is


begin
    

    rst_generate: process(FLUSH_UNIT_PCSrc)
    begin 
        if FLUSH_UNIT_PCSrc='1' then
            FLUSH_UNIT_rst_n <= '0';
            end if;
        
    end process;

end architecture RTL;
