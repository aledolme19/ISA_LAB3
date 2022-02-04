library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity INSTRUCTION_MEMORY is
	port(
		IM_IN_ADDRESS : in  std_logic_vector(6 downto 0);
		IM_OUT        : out std_logic_vector(31 downto 0)
	);
end entity INSTRUCTION_MEMORY;

architecture BEHAVIORAL of INSTRUCTION_MEMORY is

	type matrix is array (0 to 127) of std_logic_vector(31 downto 0);
	constant rom : matrix := (
		0      => X"00700813",
		4      => X"0FC10217",
		8      => X"FFC20213",
		12     => X"0FC10297",
		16     => X"01028293",
		20     => X"400006B7",
		24     => X"FFF68693",
		28     => X"02080863",
		32     => X"00022403",
		36     => X"41F45493",
		40     => X"00944533",
		44     => X"0014F493",
		48     => X"00950533",
		52     => X"00420213",
		56     => X"FFF80813",
		60     => X"00D525B3",
		64     => X"FC058EE3",
		68     => X"000506B3",
		72     => X"FD5FF0EF",
		76     => X"00D2A023",
		80     => X"000000EF",
		84     => X"00000013",
		others => X"00000000"
	);

begin

	decoder : process(IM_IN_ADDRESS) is
		variable index : natural;
	begin
		index  := to_integer(unsigned(IM_IN_ADDRESS));
		IM_OUT <= rom(index);
	end process decoder;

end architecture BEHAVIORAL;
