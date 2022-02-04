library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DATA_MEMORY is
	generic(
		data_length    : positive := 32; -- length of each row
		address_length : positive := 5  -- address bits = log2(number_of_rows)
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
end entity DATA_MEMORY;

--architecture BEHAVIORAL of DATA_MEMORY is
--
--	component reg_en_rst_n
--		generic(N : positive := 32);
--		port(
--			D     : in  std_logic_vector(N - 1 downto 0);
--			en    : in  std_logic;
--			rst_n : in  std_logic;
--			clk   : in  std_logic;
--			Q     : out std_logic_vector(N - 1 downto 0)
--		);
--	end component reg_en_rst_n;
--
--	component latch_en_rst_n
--		generic(N : positive := 32);
--		port(
--			D     : in  std_logic_vector(N - 1 downto 0);
--			en    : in  std_logic;
--			rst_n : in  std_logic;
--			Q     : out std_logic_vector(N - 1 downto 0)
--		);
--	end component latch_en_rst_n;
--
--	-- number of locations (rows)
--	constant locations : positive := 2 ** address_length;
--
--	type matrix is array (0 to locations - 1) of std_logic_vector(data_length - 1 downto 0);
--	signal REG_OUT      : matrix;
--	signal WRITE_EN_DEC : std_logic_vector(locations - 1 downto 0);
--	signal LATCH_EN     : std_logic;
--	signal LATCH_IN     : std_logic_vector(data_length - 1 downto 0);
--
--begin
--
--	write_en_decoder : process(DM_IN_MEMWRITE, DM_IN_ADDRESS) is
--		variable index_write : natural;
--	begin
--		if DM_IN_MEMWRITE = '1' then
--			index_write               := to_integer(unsigned(DM_IN_ADDRESS));
--			WRITE_EN_DEC              <= (locations - 1 downto 0 => '0');
--			WRITE_EN_DEC(index_write) <= '1';
--		else
--			WRITE_EN_DEC <= (locations - 1 downto 0 => '0');
--		end if;
--
--	end process write_en_decoder;
--
--	-- REGISTERS INSTANTIATION
--	register_file_gen : for i in 0 to locations - 1 generate
--		REG : component reg_en_rst_n
--			generic map(
--				N => data_length
--			)
--			port map(
--				D     => DM_IN_DATA,
--				en    => WRITE_EN_DEC(i),
--				rst_n => DM_IN_RST_N,
--				clk   => DM_IN_CLK,
--				Q     => REG_OUT(i)
--			);
--	end generate register_file_gen;
--
--	-- OUTPUT MUX + latch
--	-- In a real data memory, it is useful to avoid useless read because the power dissipated to perform a reading operation is very high (e.g. SRAM).
--	-- In this case there is not a big advantage because we should only change the MUX status to read since the memory is implemented through flip-flops,
--	-- but we prefer to use a latch in order to make the memory "more real", even though not in all the memories this is the behavior, but it depends
--	-- on the technology, specifications and so on.
--	-- For the same reason, we prefer to not allow a concurrent read/write, because in common memories it is usually not possible.
--	-- We give priority to the writing.
--	mux_read : process(DM_IN_ADDRESS, REG_OUT) is
--		variable index_read : natural;
--	begin
--		index_read := to_integer(unsigned(DM_IN_ADDRESS));
--		LATCH_IN   <= REG_OUT(index_read);
--	end process mux_read;
--
--	LATCH_EN <= DM_IN_MEMREAD and not (DM_IN_MEMWRITE);
--
--	output_latch : component latch_en_rst_n
--		generic map(
--			N => data_length
--		)
--		port map(
--			D     => LATCH_IN,
--			en    => LATCH_EN,
--			rst_n => DM_IN_RST_N,
--			Q     => DM_OUT
--		);
--
--end architecture BEHAVIORAL;

architecture BEHAVIORAL of DATA_MEMORY is

	type matrix is array (0 to 127) of std_logic_vector(data_length - 1 downto 0);
	constant rom : matrix := (
		0      => std_logic_vector(to_signed(10, 32)),
		4      => std_logic_vector(to_signed(-47, 32)),
		8      => std_logic_vector(to_signed(22, 32)),
		12     => std_logic_vector(to_signed(-3, 32)),
		16     => std_logic_vector(to_signed(15, 32)),
		20     => std_logic_vector(to_signed(27, 32)),
		24     => std_logic_vector(to_signed(-4, 32)),
		others => X"00000000"
	);

begin

	decoder : process(DM_IN_ADDRESS) is
		variable index : natural;
	begin
		index  := to_integer(unsigned(DM_IN_ADDRESS));
		DM_OUT <= rom(index);
	end process decoder;

end architecture BEHAVIORAL;

