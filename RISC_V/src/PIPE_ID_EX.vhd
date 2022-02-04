library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PIPE_ID_EX is
	port(
		PIPE_ID_EX_clk                                                                                                                                                                        : in  std_logic;
		PIPE_ID_EX_rst                                                                                                                                                                        : in  std_logic;
		PIPE_ID_EX_ENABLE                                                                                                                                                                     : in  std_logic;
		PIPE_ID_EX_in_Adder2                                                                                                                                                                  : in  std_logic_vector(31 downto 0);
		PIPE_ID_EX_in_RS1, PIPE_ID_EX_in_RS2                                                                                                                                                  : in  std_logic_vector(4 downto 0);
		PIPE_ID_EX_in_next_PC, PIPE_ID_EX_in_current_PC                                                                                                                                       : in  std_logic_vector(31 downto 0);
		PIPE_ID_EX_in_read_data1, PIPE_ID_EX_in_read_data2                                                                                                                                    : in  std_logic_vector(31 downto 0);
		PIPE_ID_EX_in_LUI, PIPE_ID_EX_in_RegWrite, PIPE_ID_EX_in_MemRead, PIPE_ID_EX_in_AUIPC, PIPE_ID_EX_in_Branch, PIPE_ID_EX_in_ALUScr, PIPE_ID_EX_in_MemWrite, PIPE_ID_EX_in_Jump         : in  std_logic;
		PIPE_ID_EX_in_ALUOp, PIPE_ID_EX_in_MemtoReg                                                                                                                                           : in  std_logic_vector(1 downto 0);
		PIPE_ID_EX_in_Funct3                                                                                                                                                                  : in  std_logic_vector(2 downto 0);
		PIPE_ID_EX_in_Immediate                                                                                                                                                               : in  std_logic_vector(31 downto 0);
		PIPE_ID_EX_in_RD                                                                                                                                                                      : in  std_logic_vector(4 downto 0);
		PIPE_ID_EX_out_Adder2                                                                                                                                                                 : out std_logic_vector(31 downto 0);
		PIPE_ID_EX_out_RS1, PIPE_ID_EX_out_RS2                                                                                                                                                : out std_logic_vector(4 downto 0);
		PIPE_ID_EX_out_next_PC, PIPE_ID_EX_out_current_PC                                                                                                                                     : out std_logic_vector(31 downto 0);
		PIPE_ID_EX_out_read_data1, PIPE_ID_EX_out_read_data2                                                                                                                                  : out std_logic_vector(31 downto 0);
		PIPE_ID_EX_out_LUI, PIPE_ID_EX_out_RegWrite, PIPE_ID_EX_out_MemRead, PIPE_ID_EX_out_AUIPC, PIPE_ID_EX_out_Branch, PIPE_ID_EX_out_ALUScr, PIPE_ID_EX_out_MemWrite, PIPE_ID_EX_out_Jump : out std_logic;
		PIPE_ID_EX_out_ALUOp, PIPE_ID_EX_out_MemtoReg                                                                                                                                         : out std_logic_vector(1 downto 0);
		PIPE_ID_EX_out_Funct3                                                                                                                                                                 : out std_logic_vector(2 downto 0);
		PIPE_ID_EX_out_Immediate                                                                                                                                                              : out std_logic_vector(31 downto 0);
		PIPE_ID_EX_out_RD                                                                                                                                                                     : out std_logic_vector(4 downto 0)
	);
end entity PIPE_ID_EX;

architecture BEHAVIORAL of PIPE_ID_EX is

	----------------------------COMPONENT-------------------------------------------------

	component flipflop_en_rst_n_falling_edge
		port(
			D     : in  std_logic;
			clk   : in  std_logic;
			rst_n : in  std_logic;
			en    : in  std_logic;
			Q     : out std_logic
		);
	end component flipflop_en_rst_n_falling_edge;

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

begin

	i_Reg_RS1 : reg_en_rst_n_falling_edge
		generic map(
			N => 5
		)
		port map(
			D     => PIPE_ID_EX_in_RS1,
			en    => PIPE_ID_EX_ENABLE,
			rst_n => PIPE_ID_EX_rst,
			clk   => PIPE_ID_EX_clk,
			Q     => PIPE_ID_EX_out_RS1
		);

	i_Reg_RS2 : reg_en_rst_n_falling_edge
		generic map(
			N => 5
		)
		port map(
			D     => PIPE_ID_EX_in_RS2,
			en    => PIPE_ID_EX_ENABLE,
			rst_n => PIPE_ID_EX_rst,
			clk   => PIPE_ID_EX_clk,
			Q     => PIPE_ID_EX_out_RS2
		);

	i_Reg_Next_PC : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_ID_EX_in_next_PC,
			en    => PIPE_ID_EX_ENABLE,
			rst_n => PIPE_ID_EX_rst,
			clk   => PIPE_ID_EX_clk,
			Q     => PIPE_ID_EX_out_next_PC
		);

	i_Reg_ADDER_2 : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_ID_EX_in_Adder2,
			en    => PIPE_ID_EX_ENABLE,
			rst_n => PIPE_ID_EX_rst,
			clk   => PIPE_ID_EX_clk,
			Q     => PIPE_ID_EX_out_Adder2
		);

	i_Reg_Current_PC : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_ID_EX_in_current_PC,
			en    => PIPE_ID_EX_ENABLE,
			rst_n => PIPE_ID_EX_rst,
			clk   => PIPE_ID_EX_clk,
			Q     => PIPE_ID_EX_out_current_PC
		);

	i_Reg_Read_Data1 : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_ID_EX_in_read_data1,
			en    => PIPE_ID_EX_ENABLE,
			rst_n => PIPE_ID_EX_rst,
			clk   => PIPE_ID_EX_clk,
			Q     => PIPE_ID_EX_out_read_data1
		);

	i_reg_Read_Data2 : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_ID_EX_in_read_data2,
			en    => PIPE_ID_EX_ENABLE,
			rst_n => PIPE_ID_EX_rst,
			clk   => PIPE_ID_EX_clk,
			Q     => PIPE_ID_EX_out_read_data2
		);

	i_FF_LUI : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_ID_EX_in_LUI,
			clk   => PIPE_ID_EX_clk,
			rst_n => PIPE_ID_EX_rst,
			en    => PIPE_ID_EX_ENABLE,
			Q     => PIPE_ID_EX_out_LUI
		);

	i_FF_RegWrite : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_ID_EX_in_RegWrite,
			clk   => PIPE_ID_EX_clk,
			rst_n => PIPE_ID_EX_rst,
			en    => PIPE_ID_EX_ENABLE,
			Q     => PIPE_ID_EX_out_RegWrite
		);

	i_FF_MemRead : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_ID_EX_in_MemRead,
			clk   => PIPE_ID_EX_clk,
			rst_n => PIPE_ID_EX_rst,
			en    => PIPE_ID_EX_ENABLE,
			Q     => PIPE_ID_EX_out_MemRead
		);

	i_FF_AUIP : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_ID_EX_in_AUIPC,
			clk   => PIPE_ID_EX_clk,
			rst_n => PIPE_ID_EX_rst,
			en    => PIPE_ID_EX_ENABLE,
			Q     => PIPE_ID_EX_out_AUIPC
		);

	i_FF_Branch : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_ID_EX_in_Branch,
			clk   => PIPE_ID_EX_clk,
			rst_n => PIPE_ID_EX_rst,
			en    => PIPE_ID_EX_ENABLE,
			Q     => PIPE_ID_EX_out_Branch
		);

	i_FF_ALUScr : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_ID_EX_in_ALUScr,
			clk   => PIPE_ID_EX_clk,
			rst_n => PIPE_ID_EX_rst,
			en    => PIPE_ID_EX_ENABLE,
			Q     => PIPE_ID_EX_out_ALUScr
		);

	i_FF_MemWrite : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_ID_EX_in_MemWrite,
			clk   => PIPE_ID_EX_clk,
			rst_n => PIPE_ID_EX_rst,
			en    => PIPE_ID_EX_ENABLE,
			Q     => PIPE_ID_EX_out_MemWrite
		);

	i_FF_Jump : flipflop_en_rst_n_falling_edge
		port map(
			D     => PIPE_ID_EX_in_Jump,
			clk   => PIPE_ID_EX_clk,
			rst_n => PIPE_ID_EX_rst,
			en    => PIPE_ID_EX_ENABLE,
			Q     => PIPE_ID_EX_out_Jump
		);

	i_reg_ALUOp : reg_en_rst_n_falling_edge
		generic map(
			N => 2
		)
		port map(
			D     => PIPE_ID_EX_in_ALUOp,
			en    => PIPE_ID_EX_ENABLE,
			rst_n => PIPE_ID_EX_rst,
			clk   => PIPE_ID_EX_clk,
			Q     => PIPE_ID_EX_out_ALUOp
		);

	i_reg_MemtoReg : reg_en_rst_n_falling_edge
		generic map(
			N => 2
		)
		port map(
			D     => PIPE_ID_EX_in_MemtoReg,
			en    => PIPE_ID_EX_ENABLE,
			rst_n => PIPE_ID_EX_rst,
			clk   => PIPE_ID_EX_clk,
			Q     => PIPE_ID_EX_out_MemtoReg
		);

	i_reg_Funct3 : reg_en_rst_n_falling_edge
		generic map(
			N => 3
		)
		port map(
			D     => PIPE_ID_EX_in_Funct3,
			en    => PIPE_ID_EX_ENABLE,
			rst_n => PIPE_ID_EX_rst,
			clk   => PIPE_ID_EX_clk,
			Q     => PIPE_ID_EX_out_Funct3
		);

	i_reg_Immediate : reg_en_rst_n_falling_edge
		generic map(
			N => 32
		)
		port map(
			D     => PIPE_ID_EX_in_Immediate(31 downto 0),
			en    => PIPE_ID_EX_ENABLE,
			rst_n => PIPE_ID_EX_rst,
			clk   => PIPE_ID_EX_clk,
			Q     => PIPE_ID_EX_out_Immediate(31 downto 0)
		);

	i_reg_RD : reg_en_rst_n_falling_edge
		generic map(
			N => 5
		)
		port map(
			D     => PIPE_ID_EX_in_RD,
			en    => PIPE_ID_EX_ENABLE,
			rst_n => PIPE_ID_EX_rst,
			clk   => PIPE_ID_EX_clk,
			Q     => PIPE_ID_EX_out_RD
		);

end architecture BEHAVIORAL;
