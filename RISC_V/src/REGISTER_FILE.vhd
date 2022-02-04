library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REGISTER_FILE is
	generic(
		data_length    : positive := 32; -- length of each row
		address_length : positive := 5  -- address bits = log2(number_of_rows)
	);
	port(
		RF_IN_CLK        : in  std_logic;
		RF_IN_RST_N      : in  std_logic;
		RF_IN_REGWRITE   : in  std_logic;
		RF_IN_WRITE_RD   : in  std_logic_vector(address_length - 1 downto 0); -- pointer to RD
		RF_IN_WRITE_DATA : in  std_logic_vector(data_length - 1 downto 0); -- data to be written to RD
		RF_IN_READ_RS1   : in  std_logic_vector(address_length - 1 downto 0); -- pointer to RS1
		RF_IN_READ_RS2   : in  std_logic_vector(address_length - 1 downto 0); -- pointer to RS2
		RF_OUT_RS1       : out std_logic_vector(data_length - 1 downto 0); -- data to be read from RS1
		RF_OUT_RS2       : out std_logic_vector(data_length - 1 downto 0) -- data to be read from RS2
	);
end entity REGISTER_FILE;

architecture behavioral of REGISTER_FILE is

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
	constant locations : positive := 2 ** address_length;

	type matrix is array (0 to locations - 1) of std_logic_vector(data_length - 1 downto 0);
	signal REG_OUT      : matrix;
	signal WRITE_EN_DEC : std_logic_vector(locations - 1 downto 0);

begin

	write_en_decoder : process(RF_IN_REGWRITE, RF_IN_WRITE_RD) is
		variable index_write : natural;
	begin
		if RF_IN_REGWRITE = '1' then
			index_write               := to_integer(unsigned(RF_IN_WRITE_RD));
			WRITE_EN_DEC              <= (locations - 1 downto 0 => '0');
			WRITE_EN_DEC(index_write) <= '1';
		else
			WRITE_EN_DEC <= (locations - 1 downto 0 => '0');
		end if;

	end process write_en_decoder;

	-- THE FIRST REGISTER IS READ-ONLY FIXED AT 0
	REG_OUT(0) <= (others => '0');
	-- REGISTERS INSTANTIATION
	register_file_gen : for i in 1 to locations - 1 generate
		REG : component reg_en_rst_n
			generic map(
				N => data_length
			)
			port map(
				D     => RF_IN_WRITE_DATA,
				en    => WRITE_EN_DEC(i),
				rst_n => RF_IN_RST_N,
				clk   => RF_IN_CLK,
				Q     => REG_OUT(i)
			);
	end generate register_file_gen;

	-- OUTPUT MUXES
	mux_RS1 : process(RF_IN_READ_RS1, REG_OUT) is
		variable index_read : natural;
	begin
		index_read := to_integer(unsigned(RF_IN_READ_RS1));
		RF_OUT_RS1 <= REG_OUT(index_read);
	end process mux_RS1;

	mux_RS2 : process(RF_IN_READ_RS2, REG_OUT) is
		variable index_read : natural;
	begin
		index_read := to_integer(unsigned(RF_IN_READ_RS2));
		RF_OUT_RS2 <= REG_OUT(index_read);
	end process mux_RS2;

end architecture behavioral;
