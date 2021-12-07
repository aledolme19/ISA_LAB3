---------------------------------------------------------------------------------------------
-- Project: IIR filter
-- Author: Group 04
-- Date: October 2021
-- File: reg_rst_n.vhd
-- Design: IIR
---------------------------------------------------------------------------------------------
-- Description: N bit register with low active reset signal
----------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REG_RST_N is
    generic(
        N : positive := 32
    );
    port(
        D     : in  std_logic_vector(N - 1 downto 0);
        RST_N : in  std_logic;
        CLK   : in  std_logic;
        Q     : out std_logic_vector(N - 1 downto 0)
    );
end entity REG_RST_N;

architecture RTL of REG_RST_N is

begin

    reg : process(RST_N, CLK)
    begin
        if RST_N = '0' then
            Q <= (others => '0');
        elsif CLK'event and CLK = '1' then
            Q <= D;
        end if;
    end process;

end RTL;
