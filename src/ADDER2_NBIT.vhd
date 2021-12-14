---------------------------------------------------------------------------------------------
-- Project: IIR filter
-- Author: Group 04
-- Date: October 2021
-- File: adder_Nbit.vhd
-- Design: IIR
---------------------------------------------------------------------------------------------
-- Description: N bit adder (behavioral)
----------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADDER2_NBIT is
	generic(N : positive := 32);
	port(
		ADDER_IN_A  : in  std_logic_vector(N - 1 downto 0);
		ADDER_IN_B  : in  std_logic_vector(N - 1 downto 0);
		ADDER_OUT_S : out std_logic_vector(N - 1 downto 0)
	);
end ADDER2_NBIT;

architecture BEHAVIORAL of ADDER2_NBIT is

begin

	ADDER_OUT_S <= std_logic_vector(signed(ADDER_IN_A) + signed(ADDER_IN_B));

end BEHAVIORAL;

