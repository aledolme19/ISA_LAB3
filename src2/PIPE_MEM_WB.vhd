library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PIPE_MEM_WB is
	port(
		PIPE_MEM_WB_clk                                : in  std_logic;
		PIPE_MEM_WB_rst                                : in  std_logic;
		PIPE_MEM_WB_ENABLE                             : in  std_logic;
		PIPE_MEM_WB_in_next_PC                         : in  std_logic_vector(31 downto 0);
		PIPE_MEM_WB_in_PCSrc                           : in  std_logic;
		PIPE_MEM_WB_in_ReadData                        : in  std_logic_vector(31 downto 0);
		PIPE_MEM_WB_in_ALUResult                       : in  std_logic_vector(31 downto 0);
		PIPE_MEM_WB_in_Jump, PIPE_MEM_WB_in_RegWrite   : in  std_logic;
		PIPE_MEM_WB_in_MemtoReg                        : in  std_logic_vector(1 downto 0);
		PIPE_MEM_WB_in_RD                              : in  std_logic_vector(4 downto 0);
		PIPE_MEM_WB_out_next_PC                        : out std_logic_vector(31 downto 0);
		PIPE_MEM_WB_out_ReadData                       : out std_logic_vector(31 downto 0);
		PIPE_MEM_WB_out_Jump, PIPE_MEM_WB_out_RegWrite : out std_logic;
		PIPE_MEM_WB_out_MemtoReg                       : out std_logic_vector(1 downto 0);
		PIPE_MEM_WB_out_RD                             : out std_logic_vector(4 downto 0);
		PIPE_MEM_WB_out_PCSrc                          : out std_logic;
		PIPE_MEM_WB_out_ALUResult                      : out std_logic_vector(31 downto 0)
	);
end entity PIPE_MEM_WB;

architecture BEHAVIORAL of PIPE_MEM_WB is

	------------COMPONONENTs--------------------------------------------------
	component reg_en_rst_n_falling_edge
		generic(N : positive := 32);
		port(
			D     : in  std_logic_vector(N - 1 downto 0);
			en    : in  std_logic;
			rst_n : in  std_logic;
			clk   : in  std_logic;
			Q     : out std_logic_vector(N - 1 downto 0)
		);
	end component reg_en_rst_n_falling_edge;

	component flipflop_en_rst_n_falling_edge
		port(
			D     : in  std_logic;
			clk   : in  std_logic;
			rst_n : in  std_logic;
			en    : in  std_logic;
			Q     : out std_logic
		);
	end component flipflop_en_rst_n_falling_edge;

	-----------SIGNALS--------------------------------------------------------

begin

	i_Reg_Next_PC : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_MEM_WB_in_next_PC,
			en    => PIPE_MEM_WB_ENABLE,
			rst_n => PIPE_MEM_WB_rst,
			clk   => PIPE_MEM_WB_clk,
			Q     => PIPE_MEM_WB_out_next_PC
		);

	i_Reg_ALUResult : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_MEM_WB_in_ALUResult,
			en    => PIPE_MEM_WB_ENABLE,
			rst_n => PIPE_MEM_WB_rst,
			clk   => PIPE_MEM_WB_clk,
			Q     => PIPE_MEM_WB_out_ALUResult
		);

	i_Reg_ReadData : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_MEM_WB_in_ReadData,
			en    => PIPE_MEM_WB_ENABLE,
			rst_n => PIPE_MEM_WB_rst,
			clk   => PIPE_MEM_WB_clk,
			Q     => PIPE_MEM_WB_out_ReadData
		);

	i_FF_Jump : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_MEM_WB_in_Jump,
			clk   => PIPE_MEM_WB_clk,
			rst_n => PIPE_MEM_WB_rst,
			en    => PIPE_MEM_WB_ENABLE,
			Q     => PIPE_MEM_WB_out_Jump
		);

	i_FF_RegWrite : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_MEM_WB_in_RegWrite,
			clk   => PIPE_MEM_WB_clk,
			rst_n => PIPE_MEM_WB_rst,
			en    => PIPE_MEM_WB_ENABLE,
			Q     => PIPE_MEM_WB_out_RegWrite
		);

	i_FF_PCScr : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_MEM_WB_in_PCSrc,
			clk   => PIPE_MEM_WB_clk,
			rst_n => PIPE_MEM_WB_rst,
			en    => PIPE_MEM_WB_ENABLE,
			Q     => PIPE_MEM_WB_out_PCSrc
		);

	i_Reg_MemtoReg : reg_en_rst_n_falling_edge
		generic map(
			N => 2
		)
		port map(
			D     => PIPE_MEM_WB_in_MemtoReg,
			en    => PIPE_MEM_WB_ENABLE,
			rst_n => PIPE_MEM_WB_rst,
			clk   => PIPE_MEM_WB_clk,
			Q     => PIPE_MEM_WB_out_MemtoReg
		);

	i_Reg_RD : reg_en_rst_n_falling_edge
		generic map(
			N => 5
		)
		port map(
			D     => PIPE_MEM_WB_in_RD,
			en    => PIPE_MEM_WB_ENABLE,
			rst_n => PIPE_MEM_WB_rst,
			clk   => PIPE_MEM_WB_clk,
			Q     => PIPE_MEM_WB_out_RD
		);

end architecture BEHAVIORAL;
