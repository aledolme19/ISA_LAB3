library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DATA_MEMORY is
	generic(
		width        : positive := 32;  -- length of each row
		address_bits : positive := 5    -- address bits = log2(number_of_rows)
	);
	port(
		DM_IN_CLK      : in  std_logic;
		DM_IN_RST_N    : in  std_logic;
		DM_IN_MEMREAD  : in  std_logic;
		DM_IN_MEMWRITE : in  std_logic;
		DM_IN_DATA     : in  std_logic_vector(width - 1 downto 0);
		DM_IN_ADDRESS  : in  std_logic_vector(address_bits - 1 downto 0);
		DM_OUT_DATA    : out std_logic_vector(width - 1 downto 0)
	);
end entity DATA_MEMORY;

architecture BEHAVIORAL of DATA_MEMORY is

	component reg_en_rst_n
		generic(N : positive := 32);
		port(
			D     : in  std_logic_vector(N - 1 downto 0);
			en    : in  std_logic;
			rst_n : in  std_logic;
			clk   : in  std_logic;
			Q     : out std_logic_vector(N - 1 downto 0)
		);
	end component reg_en_rst_n;

	-- number of locations (rows)
	constant locations : positive := 2 ** address_bits;

	type matrix is array (locations - 1 downto 0) of std_logic_vector(width - 1 downto 0);
	signal REG_OUT      : matrix;
	signal WRITE_EN_DEC : std_logic_vector(locations - 1 downto 0);

begin

	write_en_decoder : process(DM_IN_MEMWRITE, DM_IN_ADDRESS) is
		variable index_write : natural;
	begin
		if DM_IN_MEMWRITE = '1' then
			index_write               := to_integer(unsigned(DM_IN_ADDRESS));
			WRITE_EN_DEC              <= ((locations - 1 downto 0) => '0');
			WRITE_EN_DEC(index_write) <= '1';
		else
			WRITE_EN_DEC <= (locations - 1 downto 0 => '0');
		end if;

	end process write_en_decoder;

	-- REGISTERS INSTANTIATION
	register_file_gen : for i in 0 to locations - 1 generate
		REG : component reg_en_rst_n
			generic map(
				N => width
			)
			port map(
				D     => DM_IN_DATA,
				en    => WRITE_EN_DEC(i),
				rst_n => DM_IN_RST_N,
				clk   => DM_IN_CLK,
				Q     => REG_OUT(i)
			);
	end generate register_file_gen;

	-- OUTPUT MUXES
	-- A latch will be synthesized here because if MEMREAD=0 the previous value of DM_OUT_DATA is preserved.
	-- In a real data memory, it is useful to avoid useless read because the power dissipated to perform a reading operation is very high (e.g. SRAM).
	-- In this case there is not a big advantage because we should only change the MUX status to read since the memory is implemented through flip-flops,
	-- but we prefer to do in this way in order to simulate the behavior of a real memory. 
	mux_read : process(DM_IN_MEMREAD, DM_IN_ADDRESS, REG_OUT) is
		variable index_read : natural;
	begin
		if DM_IN_MEMREAD = '1' then
			index_read  := to_integer(unsigned(DM_IN_ADDRESS));
			DM_OUT_DATA <= REG_OUT(index_read);
		end if;
	end process mux_read;

end architecture BEHAVIORAL;
