library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PIPE_EX_MEM is
	port(
		PIPE_EX_MEM_clk                                                                                                           : in  std_logic;
		PIPE_EX_MEM_rst                                                                                                           : in  std_logic;
		PIPE_EX_MEM_ENABLE                                                                                                        : in  std_logic;
		PIPE_EX_MEM_in_Adder2                                                                                                     : in  std_logic_vector(31 downto 0);
		PIPE_EX_MEM_in_next_PC                                                                                                    : in  std_logic_vector(31 downto 0);
		PIPE_EX_MEM_in_ALU_zero                                                                                                   : in  std_logic;
		PIPE_EX_MEM_in_ALU_result                                                                                                 : in  std_logic_vector(31 downto 0);
		PIPE_EX_MEM_in_ReadData2                                                                                                  : in  std_logic_vector(31 downto 0);
		PIPE_EX_MEM_in_RegWrite, PIPE_EX_MEM_in_Branch, PIPE_EX_MEM_in_MemWrite, PIPE_EX_MEM_in_Jump, PIPE_EX_MEM_in_MemRead      : in  std_logic;
		PIPE_EX_MEM_in_MemtoReg                                                                                                   : in  std_logic_vector(1 downto 0);
		PIPE_EX_MEM_in_RD                                                                                                         : in  std_logic_vector(4 downto 0);
		--output--------------
		PIPE_EX_MEM_out_Adder2                                                                                                    : out std_logic_vector(31 downto 0);
		PIPE_EX_MEM_out_next_PC                                                                                                   : out std_logic_vector(31 downto 0);
		PIPE_EX_MEM_out_ALU_zero                                                                                                  : out std_logic;
		PIPE_EX_MEM_out_ALU_result                                                                                                : out std_logic_vector(31 downto 0);
		PIPE_EX_MEM_out_ReadData2                                                                                                 : out std_logic_vector(31 downto 0);
		PIPE_EX_MEM_out_RegWrite, PIPE_EX_MEM_out_Branch, PIPE_EX_MEM_out_MemWrite, PIPE_EX_MEM_out_Jump, PIPE_EX_MEM_out_MemRead : out std_logic;
		PIPE_EX_MEM_out_MemtoReg                                                                                                  : out std_logic_vector(1 downto 0);
		PIPE_EX_MEM_out_RD                                                                                                        : out std_logic_vector(4 downto 0)
	);
end entity PIPE_EX_MEM;

architecture BEHAVIORAL of PIPE_EX_MEM is

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

	i_Reg_ADDER_2 : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_EX_MEM_in_Adder2,
			en    => PIPE_EX_MEM_ENABLE,
			rst_n => PIPE_EX_MEM_rst,
			clk   => PIPE_EX_MEM_clk,
			Q     => PIPE_EX_MEM_out_Adder2
		);

	i_Reg_NextPC : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_EX_MEM_in_next_PC,
			en    => PIPE_EX_MEM_ENABLE,
			rst_n => PIPE_EX_MEM_rst,
			clk   => PIPE_EX_MEM_clk,
			Q     => PIPE_EX_MEM_out_next_PC
		);

	i_FF_ALU_Zero : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_EX_MEM_in_ALU_zero,
			clk   => PIPE_EX_MEM_clk,
			rst_n => PIPE_EX_MEM_rst,
			en    => PIPE_EX_MEM_ENABLE,
			Q     => PIPE_EX_MEM_out_ALU_zero
		);

	i_Reg_ALU_Result : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_EX_MEM_in_ALU_result,
			en    => PIPE_EX_MEM_ENABLE,
			rst_n => PIPE_EX_MEM_rst,
			clk   => PIPE_EX_MEM_clk,
			Q     => PIPE_EX_MEM_out_ALU_result
		);

	i_Reg_ReadData2_out : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_EX_MEM_in_ReadData2,
			en    => PIPE_EX_MEM_ENABLE,
			rst_n => PIPE_EX_MEM_rst,
			clk   => PIPE_EX_MEM_clk,
			Q     => PIPE_EX_MEM_out_ReadData2
		);

	i_FF_RegWrite : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_EX_MEM_in_RegWrite,
			clk   => PIPE_EX_MEM_clk,
			rst_n => PIPE_EX_MEM_rst,
			en    => PIPE_EX_MEM_ENABLE,
			Q     => PIPE_EX_MEM_out_RegWrite
		);

	i_FF_Branch : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_EX_MEM_in_Branch,
			clk   => PIPE_EX_MEM_clk,
			rst_n => PIPE_EX_MEM_rst,
			en    => PIPE_EX_MEM_ENABLE,
			Q     => PIPE_EX_MEM_out_Branch
		);

	i_FF_MemWrite : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_EX_MEM_in_MemWrite,
			clk   => PIPE_EX_MEM_clk,
			rst_n => PIPE_EX_MEM_rst,
			en    => PIPE_EX_MEM_ENABLE,
			Q     => PIPE_EX_MEM_out_MemWrite
		);

	i_FF_Jump : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_EX_MEM_in_Jump,
			clk   => PIPE_EX_MEM_clk,
			rst_n => PIPE_EX_MEM_rst,
			en    => PIPE_EX_MEM_ENABLE,
			Q     => PIPE_EX_MEM_out_Jump
		);

	i_FF_MemRead : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_EX_MEM_in_MemRead,
			clk   => PIPE_EX_MEM_clk,
			rst_n => PIPE_EX_MEM_rst,
			en    => PIPE_EX_MEM_ENABLE,
			Q     => PIPE_EX_MEM_out_MemRead
		);

	i_Reg_MemToReg : reg_en_rst_n_falling_edge
		generic map(
			N => 2
		)
		port map(
			D     => PIPE_EX_MEM_in_MemtoReg,
			en    => PIPE_EX_MEM_ENABLE,
			rst_n => PIPE_EX_MEM_rst,
			clk   => PIPE_EX_MEM_clk,
			Q     => PIPE_EX_MEM_out_MemtoReg
		);

	i_Reg_RD : reg_en_rst_n_falling_edge
		generic map(
			N => 5
		)
		port map(
			D     => PIPE_EX_MEM_in_RD,
			en    => PIPE_EX_MEM_ENABLE,
			rst_n => PIPE_EX_MEM_rst,
			clk   => PIPE_EX_MEM_clk,
			Q     => PIPE_EX_MEM_out_RD
		);

end architecture BEHAVIORAL;
