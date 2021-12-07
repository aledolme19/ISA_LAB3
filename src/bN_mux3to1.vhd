-- bN_mux3to1 is a generic multiplexer with 3 inputs and 1 output. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bN_3to1mux is
	generic ( N : integer := 8);
	port (  X, Y, Z : in std_logic_vector (N-1 downto 0);
	          S   : in std_logic_vector (1 downto 0);
	       OUTPUT: out std_logic_vector (N-1 downto 0));
end entity bN_3to1mux;

architecture Structure of bN_3to1mux is
	component bN_2to1mux is
		generic ( N : integer := 8);
		port (  X, Y : in std_logic_vector (N-1 downto 0);
				 S   : in std_logic;
				 OUTPUT: out std_logic_vector (N-1 downto 0));
	end component;
	signal U1 : std_logic_vector (N-1 downto 0);
	signal S1, S2 : std_logic;
begin
	S1 <= S(0);
	S2 <= S(1);
	mux1: bN_2to1mux 
		generic map (N => N)
		port map(X => X, Y => Y, S => S1, OUTPUT => U1);
	mux2: bN_2to1mux
		generic map(N => N)
		port map(X => U1, Y => Z, S => S2, OUTPUT => OUTPUT);

end architecture Structure;