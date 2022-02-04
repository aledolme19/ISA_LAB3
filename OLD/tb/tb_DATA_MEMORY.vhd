library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_DATA_MEMORY is
end entity tb_DATA_MEMORY;

architecture testbench of tb_DATA_MEMORY is

	component DATA_MEMORY
		generic(
			data_length    : positive := 32;
			address_length : positive := 5
		);
		port(
			DM_IN_CLK      : in  std_logic;
			DM_IN_RST_N    : in  std_logic;
			DM_IN_MEMREAD  : in  std_logic;
			DM_IN_MEMWRITE : in  std_logic;
			DM_IN_DATA     : in  std_logic_vector(data_length - 1 downto 0);
			DM_IN_ADDRESS  : in  std_logic_vector(address_length - 1 downto 0);
			DM_OUT         : out std_logic_vector(data_length - 1 downto 0)
		);
	end component DATA_MEMORY;

	constant width        : positive := 47;
	constant address_bits : positive := 6;
	constant locations    : positive := 2 ** address_bits;

	signal CLK        : std_logic;
	signal RST_N      : std_logic;
	signal MEMREAD    : std_logic;
	signal MEMWRITE   : std_logic;
	signal ADDRESS    : std_logic_vector(address_bits - 1 downto 0);
	signal DATA_WRITE : std_logic_vector(width - 1 downto 0);
	signal DATA_OUT   : std_logic_vector(width - 1 downto 0); -- @suppress "signal DATA_OUT is never read"

begin

	clock_driver : process
		constant period : time := 10 ns;
	begin
		CLK <= '0';
		wait for period / 2;
		CLK <= '1';
		wait for period / 2;
	end process clock_driver;

	i_DM : component DATA_MEMORY
		generic map(
			data_length    => width,
			address_length => address_bits
		)
		port map(
			DM_IN_CLK      => CLK,
			DM_IN_RST_N    => RST_N,
			DM_IN_MEMREAD  => MEMREAD,
			DM_IN_MEMWRITE => MEMWRITE,
			DM_IN_DATA     => DATA_WRITE,
			DM_IN_ADDRESS  => ADDRESS,
			DM_OUT         => DATA_OUT
		);

	stimuli : process is
	begin
		RST_N      <= '0';
		MEMREAD    <= '0';
		MEMWRITE   <= '0';
		DATA_WRITE <= (others => '0');
		ADDRESS    <= (others => '0');
		wait for 20 ns;
		RST_N      <= '1';

		-- WRITE IN ALL THE MEMORY
		MEMREAD  <= '0';
		MEMWRITE <= '1';
		for i in 0 to (locations / 2 - 1) loop
			ADDRESS    <= std_logic_vector(to_unsigned(i, ADDRESS'length));
			DATA_WRITE <= std_logic_vector(to_unsigned(3 * locations - i, DATA_WRITE'length));
			wait for 10 ns;
		end loop;
		-- TRY A CONCURRENT WRITE AND READ (EVEN THOUGH NON NEEDED BY THE RISC)
		MEMREAD  <= '1';
		MEMWRITE <= '1';
		for i in locations / 2 to (locations - 1) loop
			ADDRESS    <= std_logic_vector(to_unsigned(i, ADDRESS'length));
			DATA_WRITE <= std_logic_vector(to_unsigned(3 * locations - i, DATA_WRITE'length));
			wait for 10 ns;
		end loop;

		-- READ FROM THE MEMORY
		MEMREAD  <= '1';
		MEMWRITE <= '0';
		for i in 0 to (locations - 1) loop
			ADDRESS <= std_logic_vector(to_unsigned(i, ADDRESS'length));
			wait for 10 ns;
		end loop;

		wait;
	end process stimuli;

end architecture testbench;
