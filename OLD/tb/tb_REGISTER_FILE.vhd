library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_REGISTER_FILE is
end entity tb_REGISTER_FILE;

architecture testbench of tb_REGISTER_FILE is

	component REGISTER_FILE
		generic(
			data_length    : positive := 32;
			address_length : positive := 5
		);
		port(
			RF_IN_CLK        : in  std_logic;
			RF_IN_RST_N      : in  std_logic;
			RF_IN_REGWRITE   : in  std_logic;
			RF_IN_WRITE_RD   : in  std_logic_vector(address_length - 1 downto 0);
			RF_IN_WRITE_DATA : in  std_logic_vector(data_length - 1 downto 0);
			RF_IN_READ_RS1   : in  std_logic_vector(address_length - 1 downto 0);
			RF_IN_READ_RS2   : in  std_logic_vector(address_length - 1 downto 0);
			RF_OUT_RS1       : out std_logic_vector(data_length - 1 downto 0);
			RF_OUT_RS2       : out std_logic_vector(data_length - 1 downto 0)
		);
	end component REGISTER_FILE;

	signal CLK         : std_logic;
	signal RST_N       : std_logic;
	signal REGWRITE    : std_logic;
	signal POINTER_RD  : std_logic_vector(4 downto 0);
	signal DATA_WRITE  : std_logic_vector(31 downto 0);
	signal POINTER_RS1 : std_logic_vector(4 downto 0);
	signal POINTER_RS2 : std_logic_vector(4 downto 0);
	signal DATA_RS1    : std_logic_vector(31 downto 0); -- @suppress "signal DATA_RS1 is never read"
	signal DATA_RS2    : std_logic_vector(31 downto 0); -- @suppress "signal DATA_RS2 is never read"

begin

	clock_driver : process
		constant period : time := 10 ns;
	begin
		CLK <= '0';
		wait for period / 2;
		CLK <= '1';
		wait for period / 2;
	end process clock_driver;

	i_RF : component REGISTER_FILE
		generic map(
			data_length    => 32,
			address_length => 5
		)
		port map(
			RF_IN_CLK        => CLK,
			RF_IN_RST_N      => RST_N,
			RF_IN_REGWRITE   => REGWRITE,
			RF_IN_WRITE_RD   => POINTER_RD,
			RF_IN_WRITE_DATA => DATA_WRITE,
			RF_IN_READ_RS1   => POINTER_RS1,
			RF_IN_READ_RS2   => POINTER_RS2,
			RF_OUT_RS1       => DATA_RS1,
			RF_OUT_RS2       => DATA_RS2
		);

	stimuli : process is
	begin
		RST_N       <= '0';
		REGWRITE    <= '0';
		POINTER_RD  <= (others => '0');
		DATA_WRITE  <= (others => '0');
		POINTER_RS1 <= (others => '0');
		POINTER_RS2 <= (others => '0');
		wait for 20 ns;
		RST_N       <= '1';

		-- WRITE IN ALL THE 31 REGS (THE REG(0) CAN NOT BE WRITTEN)
		REGWRITE <= '1';
		for i in 0 to 31 loop
			POINTER_RD <= std_logic_vector(to_unsigned(i, POINTER_RD'length));
			DATA_WRITE <= std_logic_vector(to_unsigned(100 - i, DATA_WRITE'length));
			wait for 10 ns;
		end loop;

		-- READ FROM THE 32 REGS
		REGWRITE <= '0';
		for i in 0 to 30 loop
			POINTER_RS1 <= std_logic_vector(to_unsigned(i, POINTER_RS1'length));
			POINTER_RS2 <= std_logic_vector(to_unsigned(i + 1, POINTER_RS2'length));
			wait for 10 ns;
		end loop;

		wait;
	end process stimuli;

end architecture testbench;
