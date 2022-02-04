library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_RISC_V is
end entity tb_RISC_V;

architecture test of tb_RISC_V is

	component RISC_V
		port(
			RISC_V_clk                      : in  std_logic;
			RISC_V_rst_n                    : in  std_logic;
			RISC_V_instruction              : in  std_logic_vector(31 downto 0);
			RISC_V_ReadData                 : in  std_logic_vector(31 downto 0);
			RISC_V_add_instruction_memory   : out std_logic_vector(31 downto 0);
			RISC_V_add_data_memory          : out std_logic_vector(31 downto 0);
			RISC_V_MemRead, RISC_V_MemWrite : out std_logic;
			RISC_V_DATA_data_memory         : out std_logic_vector(31 downto 0)
		);
	end component RISC_V;

	component INSTRUCTION_MEMORY
		port(
			IM_IN_ADDRESS : in  std_logic_vector(6 downto 0);
			IM_OUT        : out std_logic_vector(31 downto 0)
		);
	end component INSTRUCTION_MEMORY;

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

	signal CLK                            : std_logic;
	signal RST_N                          : std_logic;
	signal address_instruction_memory     : std_logic_vector(31 downto 0);
	signal instruction                    : std_logic_vector(31 downto 0);
	signal MemRead, MemWrite              : std_logic;
	signal DATA_data_memory               : std_logic_vector(31 downto 0);
	signal address_data_memory, read_data : std_logic_vector(31 downto 0);

begin

	clock_driver : process
		constant period : time := 1.45 ns;
	begin
		CLK <= '0';
		wait for period / 2;
		CLK <= '1';
		wait for period / 2;
	end process clock_driver;

	i_INSTRUCTION_MEMORY : component INSTRUCTION_MEMORY
		port map(
			IM_IN_ADDRESS => address_instruction_memory(6 downto 0),
			IM_OUT        => instruction
		);

	i_DATA_MEMORY : component DATA_MEMORY
		generic map(
			data_length    => 32,
			address_length => 5
		)
		port map(
			DM_IN_CLK      => CLK,
			DM_IN_RST_N    => RST_N,
			DM_IN_MEMREAD  => MemRead,
			DM_IN_MEMWRITE => MemWrite,
			DM_IN_DATA     => DATA_data_memory,
			DM_IN_ADDRESS  => address_data_memory(4 downto 0),
			DM_OUT         => read_data
		);

	i_RISC_V : component RISC_V
		port map(
			RISC_V_clk                    => CLK,
			RISC_V_rst_n                  => RST_N,
			RISC_V_instruction            => instruction,
			RISC_V_ReadData               => read_data,
			RISC_V_add_instruction_memory => address_instruction_memory,
			RISC_V_add_data_memory        => address_data_memory,
			RISC_V_MemRead                => MemRead,
			RISC_V_MemWrite               => MemWrite,
			RISC_V_DATA_data_memory       => DATA_data_memory
		);

	stimuli : process is
		constant period : time := 1.45 ns;
	begin
		RST_N <= '0';
		wait for 2 * period - period / 4;

		RST_N <= '1';
		wait;
	end process stimuli;

end architecture test;
