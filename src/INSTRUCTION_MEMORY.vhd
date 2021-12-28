library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity INSTRUCTION_MEMORY is
	port(
		IM_IN_ADDRESS : in  std_logic_vector(4 downto 0);
		IM_OUT        : out std_logic_vector(31 downto 0)
	);
end entity INSTRUCTION_MEMORY;

architecture BEHAVIORAL of INSTRUCTION_MEMORY is

	type matrix is array (0 to 31) of std_logic_vector(31 downto 0);
	constant rom : matrix := (
		0        => X"00700813",
		1        => X"0FC10217",
		2        => X"FFC20213",
		3        => X"0FC10297",
		4        => X"01028293",
		5        => X"400006B7",
		6        => X"FFF68693",
		7        => X"02080863",
		8        => X"00022403",
		9        => X"41F45493",
		10       => X"00944533",
		11       => X"0014F493",
		12       => X"00950533",
		13       => X"00420213",
		14       => X"FFF80813",
		15       => X"00D525B3",
		16       => X"FC058EE3",
		17       => X"000506B3",
		18       => X"FD5FF0EF",
		19       => X"00D2A023",
		20       => X"000000EF",
		21       => X"00000013",
		22 to 31 => X"00000000"
	);

begin

	decoder : process(IM_IN_ADDRESS) is
		variable index : natural;
	begin
		index  := to_integer(unsigned(IM_IN_ADDRESS));
		IM_OUT <= rom(index);
	end process decoder;

end architecture BEHAVIORAL;
