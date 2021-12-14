library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port(
		ALU_IN_A       : in  std_logic_vector(63 downto 0);
		ALU_IN_B       : in  std_logic_vector(63 downto 0);
		ALU_IN_CONTROL : in  std_logic_vector(3 downto 0);
		ALU_OUT        : out std_logic_vector(63 downto 0);
		ALU_OUT_ZERO   : out std_logic
	);
end entity ALU;

architecture BEHAVIORAL of ALU is

begin

end architecture BEHAVIORAL;
