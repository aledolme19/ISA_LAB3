library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EXECUTION_UNIT is
	port(
		EXECUTION_UNIT_in_RS1, EXECUTION_UNIT_in_RS2                                                                                                                                                                  : in  std_logic_vector(4 downto 0);
		EXECUTION_UNIT_in_next_PC, EXECUTION_UNIT_in_current_PC                                                                                                                                                       : in  std_logic_vector(31 downto 0);
		EXECUTION_UNIT_in_Adder2                                                                                                                                                                                      : in  std_logic_vector(31 downto 0);
		EXECUTION_UNIT_in_read_data1, EXECUTION_UNIT_in_read_data2                                                                                                                                                    : in  std_logic_vector(31 downto 0);
		EXECUTION_UNIT_in_LUI, EXECUTION_UNIT_in_RegWrite, EXECUTION_UNIT_in_MemRead, EXECUTION_UNIT_in_AUIPC, EXECUTION_UNIT_in_Branch, EXECUTION_UNIT_in_ALUScr, EXECUTION_UNIT_in_MemWrite, EXECUTION_UNIT_in_Jump : in  std_logic;
		EXECUTION_UNIT_in_ALUOp, EXECUTION_UNIT_in_MemtoReg                                                                                                                                                           : in  std_logic_vector(1 downto 0);
		EXECUTION_UNIT_in_Funct3                                                                                                                                                                                      : in  std_logic_vector(2 downto 0);
		EXECUTION_UNIT_in_Immediate                                                                                                                                                                                   : in  std_logic_vector(31 downto 0);
		EXECUTION_UNIT_in_RD                                                                                                                                                                                          : in  std_logic_vector(4 downto 0);
		EXECUTION_UNIT_in_MEM_WB_MUX_WriteData                                                                                                                                                                        : in  std_logic_vector(31 downto 0);
		EXECUTION_UNIT_in_EX_MEM_ALU_result                                                                                                                                                                           : in  std_logic_vector(31 downto 0);
		--input of Fowarding Unit-----------------
		EXECUTION_UNIT_in_EX_MEM_RD                                                                                                                                                                                   : in  std_logic_vector(4 downto 0);
		EXECUTION_UNIT_in_MEM_WB_RD                                                                                                                                                                                   : in  std_logic_vector(4 downto 0);
		EXECUTION_UNIT_in_EX_MEM_RegWrite                                                                                                                                                                             : in  std_logic;
		EXECUTION_UNIT_in_MEM_WB_RegWrite                                                                                                                                                                             : in  std_logic;
		EXECUTION_UNIT_in_MEM_WB_Jump                                                                                                                                                                                 : in  std_logic;
		EXECUTION_UNIT_in_MEM_WB_Next_PC                                                                                                                                                                              : in  std_logic_vector(31 downto 0);
		---OUTPUT----------------------------------
		EXECUTION_UNIT_out_Adder2                                                                                                                                                                                     : out std_logic_vector(31 downto 0);
		EXECUTION_UNIT_out_next_PC                                                                                                                                                                                    : out std_logic_vector(31 downto 0);
		EXECUTION_UNIT_out_ALU_zero                                                                                                                                                                                   : out std_logic;
		EXECUTION_UNIT_out_ALU_result                                                                                                                                                                                 : out std_logic_vector(31 downto 0);
		EXECUTION_UNIT_out_RegWrite                                                                                                                                                                                   : out std_logic;
		EXECUTION_UNIT_out_Branch                                                                                                                                                                                     : out std_logic;
		EXECUTION_UNIT_out_MemWrite, EXECUTION_UNIT_out_Jump                                                                                                                                                          : out std_logic;
		EXECUTION_UNIT_out_MemRead                                                                                                                                                                                    : out std_logic;
		EXECUTION_UNIT_out_MemtoReg                                                                                                                                                                                   : out std_logic_vector(1 downto 0);
		EXECUTION_UNIT_out_RD                                                                                                                                                                                         : out std_logic_vector(4 downto 0);
		EXECUTION_UNIT_out_ReadData2                                                                                                                                                                                  : out std_logic_vector(31 downto 0)
	);
end entity EXECUTION_UNIT;

architecture RTL of EXECUTION_UNIT is

	---------------COMPONENTS---------------------------------------------------------    

	component MUX_A_B
		port(
			MUX_A_B_in_MEM_WB_Next_PC       : in  std_logic_vector(31 downto 0);
			MUX_A_B_in_read_data            : in  std_logic_vector(31 downto 0);
			MUX_A_B_in_EX_MEM_ALU_result    : in  std_logic_vector(31 downto 0);
			MUX_A_B_in_MEM_WB_MUX_WriteData : in  std_logic_vector(31 downto 0);
			MUX_A_B_in_sel                  : in  std_logic_vector(1 downto 0);
			MUX_A_B_out                     : out std_logic_vector(31 downto 0)
		);
	end component MUX_A_B;

	component bN_2to1mux
		generic(N : positive := 8);
		port(
			x, y   : in  std_logic_vector(N - 1 downto 0);
			s      : in  std_logic;
			output : out std_logic_vector(N - 1 downto 0)
		);
	end component bN_2to1mux;

	component MUX_AUIPC_LUI
		port(
			MUX_AUIPC_LUI_in_zero          : in  std_logic_vector(31 downto 0);
			MUX_AUIPC_LUI_previous_mux_out : in  std_logic_vector(31 downto 0);
			MUX_AUIPC_LUI_current_PC       : in  std_logic_vector(31 downto 0);
			MUX_AUIPC_LUI_in_sel           : in  std_logic_vector(1 downto 0);
			MUX_AUIPC_LUI_out              : out std_logic_vector(31 downto 0)
		);
	end component MUX_AUIPC_LUI;

	component FORWARDING_UNIT
		port(
			FU_IN_ID_EX_RS1       : in  std_logic_vector(4 downto 0);
			FU_IN_ID_EX_RS2       : in  std_logic_vector(4 downto 0);
			FU_IN_MEM_WB_RD       : in  std_logic_vector(4 downto 0);
			FU_IN_EX_MEM_RD       : in  std_logic_vector(4 downto 0);
			FU_IN_EX_MEM_REGWRITE : in  std_logic;
			FU_IN_MEM_WB_REGWRITE : in  std_logic;
			FU_IN_MEM_WB_JUMP     : in  std_logic;
			FU_OUT_FORWARD_A      : out std_logic_vector(1 downto 0);
			FU_OUT_FORWARD_B      : out std_logic_vector(1 downto 0)
		);
	end component FORWARDING_UNIT;

	component ALU_CONTROL
		port(
			ALU_CONTROL_IN_ALUOP  : in  std_logic_vector(1 downto 0);
			ALU_CONTROL_IN_FUNCT3 : in  std_logic_vector(2 downto 0);
			ALU_CONTROL_OUT       : out std_logic_vector(3 downto 0)
		);
	end component ALU_CONTROL;

	component ALU
		generic(N : positive := 32);
		port(
			ALU_IN_A       : in  std_logic_vector(N - 1 downto 0);
			ALU_IN_B       : in  std_logic_vector(N - 1 downto 0);
			ALU_IN_CONTROL : in  std_logic_vector(3 downto 0);
			ALU_OUT        : out std_logic_vector(N - 1 downto 0);
			ALU_OUT_ZERO   : out std_logic
		);
	end component ALU;

	-----------signals------------------------------------------------------------------
	signal ALU_control_signal         : std_logic_vector(3 downto 0);
	signal MuxA_control, MuxB_control : std_logic_vector(1 downto 0);
	signal MUXA_out, MUXB_out         : std_logic_vector(31 downto 0);
	signal MUX2_out                   : std_logic_vector(31 downto 0);
	signal MUX3_out                   : std_logic_vector(31 downto 0);
	signal MUX_2_selector             : std_logic_vector(1 downto 0);

begin

	i_FORWARDING_UNIT : FORWARDING_UNIT
		port map(
			FU_IN_ID_EX_RS1       => EXECUTION_UNIT_in_RS1,
			FU_IN_ID_EX_RS2       => EXECUTION_UNIT_in_RS2,
			FU_IN_MEM_WB_RD       => EXECUTION_UNIT_in_MEM_WB_RD,
			FU_IN_EX_MEM_RD       => EXECUTION_UNIT_in_EX_MEM_RD,
			FU_IN_EX_MEM_REGWRITE => EXECUTION_UNIT_in_EX_MEM_RegWrite,
			FU_IN_MEM_WB_REGWRITE => EXECUTION_UNIT_in_MEM_WB_RegWrite,
			FU_IN_MEM_WB_JUMP     => EXECUTION_UNIT_in_MEM_WB_Jump,
			FU_OUT_FORWARD_A      => MuxA_control,
			FU_OUT_FORWARD_B      => MuxB_control
		);

	i_MUX_A : MUX_A_B
		port map(
			MUX_A_B_in_MEM_WB_Next_PC       => EXECUTION_UNIT_in_MEM_WB_Next_PC,
			MUX_A_B_in_read_data            => EXECUTION_UNIT_in_read_data1,
			MUX_A_B_in_EX_MEM_ALU_result    => EXECUTION_UNIT_in_EX_MEM_ALU_result,
			MUX_A_B_in_MEM_WB_MUX_WriteData => EXECUTION_UNIT_in_MEM_WB_MUX_WriteData,
			MUX_A_B_in_sel                  => MuxA_control,
			MUX_A_B_out                     => MUXA_out
		);

	i_MUX_B : MUX_A_B
		port map(
			MUX_A_B_in_MEM_WB_Next_PC       => EXECUTION_UNIT_in_MEM_WB_Next_PC,
			MUX_A_B_in_read_data            => EXECUTION_UNIT_in_read_data2,
			MUX_A_B_in_EX_MEM_ALU_result    => EXECUTION_UNIT_in_EX_MEM_ALU_result,
			MUX_A_B_in_MEM_WB_MUX_WriteData => EXECUTION_UNIT_in_MEM_WB_MUX_WriteData,
			MUX_A_B_in_sel                  => MuxB_control,
			MUX_A_B_out                     => MUXB_out
		);

	MUX_2_selector <= EXECUTION_UNIT_in_AUIPC & EXECUTION_UNIT_in_LUI;

	i_MUX2 : MUX_AUIPC_LUI
		port map(
			MUX_AUIPC_LUI_in_zero          => (others => '0'),
			MUX_AUIPC_LUI_previous_mux_out => MUXA_out,
			MUX_AUIPC_LUI_current_PC       => EXECUTION_UNIT_in_current_PC,
			MUX_AUIPC_LUI_in_sel           => MUX_2_selector,
			MUX_AUIPC_LUI_out              => MUX2_out
		);

	i_MUX3 : bN_2to1mux
		generic map(
			N => 32
		)
		port map(
			x      => MUXB_out,
			y      => EXECUTION_UNIT_in_Immediate,
			s      => EXECUTION_UNIT_in_ALUScr,
			output => MUX3_out
		);

	i_ALU_CONTROL : ALU_CONTROL
		port map(
			ALU_CONTROL_IN_ALUOP  => EXECUTION_UNIT_in_ALUOp,
			ALU_CONTROL_IN_FUNCT3 => EXECUTION_UNIT_in_Funct3,
			ALU_CONTROL_OUT       => ALU_control_signal
		);

	i_ALU : ALU
		generic map(
			N => 32
		)
		port map(
			ALU_IN_A       => MUX2_out,
			ALU_IN_B       => MUX3_out,
			ALU_IN_CONTROL => ALU_control_signal,
			ALU_OUT        => EXECUTION_UNIT_out_ALU_result,
			ALU_OUT_ZERO   => EXECUTION_UNIT_out_ALU_zero
		);

	--------------OUTPUT lefts invariant with resecpt to the input-----------------------
	EXECUTION_UNIT_out_Adder2    <= EXECUTION_UNIT_in_Adder2;
	EXECUTION_UNIT_out_next_PC   <= EXECUTION_UNIT_in_next_PC;
	EXECUTION_UNIT_out_RegWrite  <= EXECUTION_UNIT_in_RegWrite;
	EXECUTION_UNIT_out_Branch    <= EXECUTION_UNIT_in_Branch;
	EXECUTION_UNIT_out_MemWrite  <= EXECUTION_UNIT_in_MemWrite;
	EXECUTION_UNIT_out_Jump      <= EXECUTION_UNIT_in_Jump;
	EXECUTION_UNIT_out_MemtoReg  <= EXECUTION_UNIT_in_MemtoReg;
	EXECUTION_UNIT_out_RD        <= EXECUTION_UNIT_in_RD;
	EXECUTION_UNIT_out_MemRead   <= EXECUTION_UNIT_in_MemRead;
	EXECUTION_UNIT_out_ReadData2 <= EXECUTION_UNIT_in_read_data2;

end architecture RTL;
