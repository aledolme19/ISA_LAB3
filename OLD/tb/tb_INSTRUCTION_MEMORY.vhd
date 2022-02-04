library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_INSTRUCTION_MEMORY is
end entity tb_INSTRUCTION_MEMORY;

architecture behavioral of tb_INSTRUCTION_MEMORY is

	component INSTRUCTION_MEMORY
		port(
			IM_IN_ADDRESS : in  std_logic_vector(6 downto 0);
			IM_OUT        : out std_logic_vector(31 downto 0)
		);
	end component INSTRUCTION_MEMORY;

	signal ADDRESS  : std_logic_vector(6 downto 0);
	signal DATA_OUT : std_logic_vector(31 downto 0); -- @suppress "signal DATA_OUT is never read"

begin

	i_IM : component INSTRUCTION_MEMORY
		port map(
			IM_IN_ADDRESS => ADDRESS,
			IM_OUT        => DATA_OUT
		);

	stimuli : process is
	begin
		for index in 0 to 127 loop
			ADDRESS <= std_logic_vector(to_unsigned(index, ADDRESS'length));
			wait for 10 ns;
		end loop;

		wait;

	end process stimuli;

end architecture behavioral;
