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
		28     => X"02080263",
		32     => X"00022403",
		36     => X"00047533",
		40     => X"00420213",
		44     => X"FFF80813",
		48     => X"00D525B3",
		52     => X"FE0584E3",
		56     => X"000506B3",
		60     => X"FE1FF0EF",
		64     => X"00D2A023",
		68     => X"000000EF",
		72     => X"00000013",
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
