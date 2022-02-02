---------------------------------------------------------------------------------------------
-- File: RISC_V.vhd
---------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISC_V is
	port(
		RISC_V_clk                      : in  std_logic;
		RISC_V_rst_n                    : in  std_logic;
		RISC_V_instruction              : in  std_logic_vector(31 downto 0);
		RISC_V_ReadData                 : in  std_logic_vector(31 downto 0);
		----output----------------------
		RISC_V_add_instruction_memory   : out std_logic_vector(31 downto 0);
		RISC_V_add_data_memory          : out std_logic_vector(31 downto 0);
		RISC_V_MemRead, RISC_V_MemWrite : out std_logic;
		RISC_V_DATA_data_memory         : out std_logic_vector(31 downto 0)
	);
end entity RISC_V;

architecture BEHAVIORAL of RISC_V is

	----------------COMPONENTS-------------------------------------------------------------
	component FETCH_UNIT
		port(
			FETCH_UNIT_in_clk            : in  std_logic;
			FETCH_UNIT_in_rst_n          : in  std_logic;
			FETCH_UNIT_in_jump           : in  std_logic;
			FETCH_UNIT_in_PCscr          : in  std_logic;
			FETCH_UNIT_in_jump_value     : in  std_logic_vector(31 downto 0);
			FETCH_UNIT_in_PCscr_value    : in  std_logic_vector(31 downto 0);
			FETCH_UNIT_in_Hazard_control : in  std_logic;
			FETCH_UNIT_out_next_PC       : out std_logic_vector(31 downto 0);
			FETCH_UNIT_out_current_PC    : out std_logic_vector(31 downto 0)
		);
	end component FETCH_UNIT;

	component PIPE_IF_ID
		port(
			PIPE_IF_ID_clk              : in  std_logic;
			PIPE_IF_ID_rst              : in  std_logic;
			PIPE_IF_ID_ENABLE           : in  std_logic;
			PIPE_IF_ID_in_next_PC       : in  std_logic_vector(31 downto 0);
			PIPE_IF_ID_in_current_PC    : in  std_logic_vector(31 downto 0);
			PIPE_IF_ID_in_instructions  : in  std_logic_vector(31 downto 0);
			PIPE_IF_ID_out_next_PC      : out std_logic_vector(31 downto 0);
			PIPE_IF_ID_out_current_PC   : out std_logic_vector(31 downto 0);
			PIPE_IF_ID_out_instructions : out std_logic_vector(31 downto 0)
		);
	end component PIPE_IF_ID;

	component DECODING_UNIT
		port(
			DECODING_UNIT_in_CLK                                                                                                                                                                                          : in  std_logic;
			DECODING_UNIT_in_rst_n                                                                                                                                                                                        : in  std_logic;
			DECODING_UNIT_in_MEM_WB_RegWrite                                                                                                                                                                              : in  std_logic;
			DECODING_UNIT_in_MEM_WB_WriteData                                                                                                                                                                             : in  std_logic_vector(31 downto 0);
			DECODING_UNIT_in_MEM_WB_RD                                                                                                                                                                                    : in  std_logic_vector(4 downto 0);
			DECODING_UNIT_in_EX_MEM_Branch                                                                                                                                                                                : in  std_logic;
			DECODING_UNIT_in_ID_EX_Branch                                                                                                                                                                                 : in  std_logic;
			DECODING_UNIT_in_ID_EX_RD                                                                                                                                                                                     : in  std_logic_vector(4 downto 0);
			DECODING_UNIT_in_ID_EX_MemRead                                                                                                                                                                                : in  std_logic;
			DECODING_UNIT_in_ID_EX_Jump                                                                                                                                                                                   : in  std_logic;
			DECODING_UNIT_in_MEM_WB_PCSrc                                                                                                                                                                                 : in  std_logic;
			DECODING_UNIT_in_INSTR                                                                                                                                                                                        : in  std_logic_vector(31 downto 0);
			DECODING_UNIT_in_next_PC                                                                                                                                                                                      : in  std_logic_vector(31 downto 0);
			DECODING_UNIT_in_current_PC                                                                                                                                                                                   : in  std_logic_vector(31 downto 0);
			DECODING_UNIT_out_Adder2                                                                                                                                                                                      : out std_logic_vector(31 downto 0);
			DECODING_UNIT_out_RS1, DECODING_UNIT_out_RS2                                                                                                                                                                  : out std_logic_vector(4 downto 0);
			DECODING_UNIT_out_next_PC, DECODING_UNIT_out_current_PC                                                                                                                                                       : out std_logic_vector(31 downto 0);
			DECODING_UNIT_out_read_data1, DECODING_UNIT_out_read_data2                                                                                                                                                    : out std_logic_vector(31 downto 0);
			DECODING_UNIT_out_LUI, DECODING_UNIT_out_RegWrite, DECODING_UNIT_out_MemRead, DECODING_UNIT_out_AUIPC, DECODING_UNIT_out_Branch, DECODING_UNIT_out_ALUScr, DECODING_UNIT_out_MemWrite, DECODING_UNIT_out_Jump : out std_logic;
			DECODING_UNIT_out_ALUOp, DECODING_UNIT_out_MemtoReg                                                                                                                                                           : out std_logic_vector(1 downto 0);
			DECODING_UNIT_out_Funct3                                                                                                                                                                                      : out std_logic_vector(2 downto 0);
			DECODING_UNIT_out_Immediate                                                                                                                                                                                   : out std_logic_vector(31 downto 0);
			DECODING_UNIT_out_RD                                                                                                                                                                                          : out std_logic_vector(4 downto 0);
			DECODING_UNIT_out_Hazard_Control                                                                                                                                                                              : out std_logic
		);
	end component DECODING_UNIT;

	component PIPE_ID_EX
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
	end component PIPE_ID_EX;

	component EXECUTION_UNIT
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
			EXECUTION_UNIT_in_EX_MEM_RD                                                                                                                                                                                   : in  std_logic_vector(4 downto 0);
			EXECUTION_UNIT_in_MEM_WB_RD                                                                                                                                                                                   : in  std_logic_vector(4 downto 0);
			EXECUTION_UNIT_in_EX_MEM_RegWrite                                                                                                                                                                             : in  std_logic;
			EXECUTION_UNIT_in_MEM_WB_RegWrite                                                                                                                                                                             : in  std_logic;
			EXECUTION_UNIT_in_MEM_WB_Jump                                                                                                                                                                                 : in  std_logic;
			EXECUTION_UNIT_in_MEM_WB_Next_PC                                                                                                                                                                              : in  std_logic_vector(31 downto 0);
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
	end component EXECUTION_UNIT;

	component PIPE_EX_MEM
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
			PIPE_EX_MEM_out_Adder2                                                                                                    : out std_logic_vector(31 downto 0);
			PIPE_EX_MEM_out_next_PC                                                                                                   : out std_logic_vector(31 downto 0);
			PIPE_EX_MEM_out_ALU_zero                                                                                                  : out std_logic;
			PIPE_EX_MEM_out_ALU_result                                                                                                : out std_logic_vector(31 downto 0);
			PIPE_EX_MEM_out_ReadData2                                                                                                 : out std_logic_vector(31 downto 0);
			PIPE_EX_MEM_out_RegWrite, PIPE_EX_MEM_out_Branch, PIPE_EX_MEM_out_MemWrite, PIPE_EX_MEM_out_Jump, PIPE_EX_MEM_out_MemRead : out std_logic;
			PIPE_EX_MEM_out_MemtoReg                                                                                                  : out std_logic_vector(1 downto 0);
			PIPE_EX_MEM_out_RD                                                                                                        : out std_logic_vector(4 downto 0)
		);
	end component PIPE_EX_MEM;

	component MEMORY_UNIT
		port(
			MEMORY_UNIT_in_next_PC                         : in  std_logic_vector(31 downto 0);
			MEMORY_UNIT_in_ADDRESS                         : in  std_logic_vector(31 downto 0);
			MEMORY_UNIT_in_Jump, MEMORY_UNIT_in_RegWrite   : in  std_logic;
			MEMORY_UNIT_in_MemtoReg                        : in  std_logic_vector(1 downto 0);
			MEMORY_UNIT_in_RD                              : in  std_logic_vector(4 downto 0);
			MEMORY_UNIT_out_next_PC                        : out std_logic_vector(31 downto 0);
			MEMORY_UNIT_out_Jump, MEMORY_UNIT_out_RegWrite : out std_logic;
			MEMORY_UNIT_out_MemtoReg                       : out std_logic_vector(1 downto 0);
			MEMORY_UNIT_out_RD                             : out std_logic_vector(4 downto 0);
			MEMORY_UNIT_out_ALUResult                      : out std_logic_vector(31 downto 0)
		);
	end component MEMORY_UNIT;

	component PIPE_MEM_WB
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
	end component PIPE_MEM_WB;

	component WRITE_BACK_UNIT
		port(
			WRITE_BACK_UNIT_in_next_PC    : in  std_logic_vector(31 downto 0);
			WRITE_BACK_UNIT_in_ReadData   : in  std_logic_vector(31 downto 0);
			WRITE_BACK_UNIT_in_MemtoReg   : in  std_logic_vector(1 downto 0);
			WRITE_BACK_UNIT_in_ALU_Result : in  std_logic_vector(31 downto 0);
			PIPE_MEM_WB_out_MUX           : out std_logic_vector(31 downto 0)
		);
	end component WRITE_BACK_UNIT;

	----------------SIGNALS--------------------------------------------------------------

	--I SEGNALI DI ENABLE E RESET DEI DIVERSI STADI DI PIPE SONO STATI CREATI. VEDERE SE TENERLI FISSI, SE TOGLIERLI, E COME GESTIRLI

	---Fetch Unit Signals-----------------------------------------------------------------
	-- signal PCSrc_address_ID_MEM                                           : std_logic_vector(31 downto 0);
	signal IF_next_PC_PIPE_I, IF_current_PC_PIPE_I : std_logic_vector(31 downto 0);

	--PIPE_IF_ID Signals-----------------------------------------------------------------
	signal PIPE_I_next_PC, PIPE_I_current_PC, PIPE_I_instruction : std_logic_vector(31 downto 0);
	signal Hazard_Control_PC_ID_IF                               : std_logic;

	--Decoding Unit Signals---------------------------------------------------------------
	-- signal MEM_WB_RegWrite                                                                                                               : std_logic;
	-- signal MEM_WB_WriteData                                                                                                              : std_logic_vector(31 downto 0);
	-- signal MEM_WB_RD                                                                                                                     : std_logic_vector(4 downto 0);
	-- signal ID_EX_RD                                                                                                                      : std_logic_vector(4 downto 0);
	-- signal ID_EX_MemRead                                                                                                                 : std_logic;
	signal Adder2_PIPE_II                                                                                                                : std_logic_vector(31 downto 0);
	signal RS1_PIPE_II, RS2_PIPE_II                                                                                                      : std_logic_vector(4 downto 0);
	signal next_PC_PIPE_II, current_PC_PIPE_II                                                                                           : std_logic_vector(31 downto 0);
	signal read_data1_PIPE_II, read_data2_PIPE_II                                                                                        : std_logic_vector(31 downto 0);
	signal LUI_PIPE_II, RegWrite_PIPE_II, MemRead_PIPE_II, AUIPC_PIPE_II, Branch_PIPE_II, ALUScr_PIPE_II, MemWrite_PIPE_II, Jump_PIPE_II : std_logic;
	signal ALUOp_PIPE_II, MemtoReg_PIPE_II                                                                                               : std_logic_vector(1 downto 0);
	signal Funct3_PIPE_II                                                                                                                : std_logic_vector(2 downto 0);
	signal Immediate_PIPE_II                                                                                                             : std_logic_vector(31 downto 0);
	signal RD_PIPE_II                                                                                                                    : std_logic_vector(4 downto 0);
	-- signal DECODING_UNIT_OUT_HAZARD_CONTROL                                                                                              : std_logic;

	--PIPE_ID_EX Signals-----------------------------------------------------------------
	signal PIPE_II_en                                                                                                                    : std_logic; --coming from the HAZARD UNIT
	signal PIPE_II_Adder2, PIPE_II_next_PC, PIPE_II_current_PC, PIPE_II_read_data1, PIPE_II_read_data2                                   : std_logic_vector(31 downto 0);
	signal PIPE_II_RS1, PIPE_II_RS2, PIPE_II_RD                                                                                          : std_logic_vector(4 downto 0);
	signal PIPE_II_LUI, PIPE_II_RegWrite, PIPE_II_MemRead, PIPE_II_AUIPC, PIPE_II_Branch, PIPE_II_ALUScr, PIPE_II_MemWrite, PIPE_II_Jump : std_logic;
	signal PIPE_II_ALUOp, PIPE_II_MemtoReg                                                                                               : std_logic_vector(1 downto 0);
	signal PIPE_II_Funct3                                                                                                                : std_logic_vector(2 downto 0);
	signal PIPE_II_Immediate                                                                                                             : std_logic_vector(31 downto 0);

	--Execution Unit signals------------------------------------------------------------
	signal Adder_PIPE_III, next_PC_PIPE_III, ReadData2_PIPE_III                                   : std_logic_vector(31 downto 0);
	signal ALU_zero_PIPE_III                                                                      : std_logic;
	signal ALU_result_PIPE_III                                                                    : std_logic_vector(31 downto 0);
	signal RegWrite_PIPE_III, Branch_PIPE_III, MemWrite_PIPE_III, Jump_PIPE_III, MemRead_PIPE_III : std_logic;
	signal MemtoReg_PIPE_III                                                                      : std_logic_vector(1 downto 0);
	signal RD_PIPE_III                                                                            : std_logic_vector(4 downto 0);

	--PIPE_ID_EX Signals-----------------------------------------------------------------
	signal PIPE_III_en                                                                                               : std_logic;
	signal PIPE_III_Adder2, PIPE_III_next_PC, PIPE_III_ALU_result, PIPE_III_MUX3                                     : std_logic_vector(31 downto 0);
	signal PIPE_III_ALU_zero, PIPE_III_RegWrite, PIPE_III_Branch, PIPE_III_MemWrite, PIPE_III_Jump, PIPE_III_MemRead : std_logic;
	signal PIPE_III_MemtoReg                                                                                         : std_logic_vector(1 downto 0);
	signal PIPE_III_RD                                                                                               : std_logic_vector(4 downto 0);

	signal PCSrc : std_logic;

	--Memory Unit signals----------------------------------------------------------------
	signal next_PC_PIPE_IV, ALUResult_PIPE_IV : std_logic_vector(31 downto 0);
	signal Jump_PIPE_IV, RegWrite_PIPE_IV     : std_logic;
	signal MemtoReg_PIPE_IV                   : std_logic_vector(1 downto 0);
	signal RD_PIPE_IV                         : std_logic_vector(4 downto 0);

	--PIPE_MEM_WB Signals----------------------------------------------------------------------
	signal PIPE_IV_en                                           : std_logic;
	signal PIPE_IV_next_PC, PIPE_IV_ReadData, PIPE_IV_ALUResult : std_logic_vector(31 downto 0);
	signal PIPE_IV_Jump, PIPE_IV_RegWrite, PIPE_IV_PCSrc        : std_logic;
	signal PIPE_IV_MemtoReg                                     : std_logic_vector(1 downto 0);
	signal PIPE_IV_RD                                           : std_logic_vector(4 downto 0);

	--Write Back Unit---------------------------------------------------------------------------
	signal WB_WriteData : std_logic_vector(31 downto 0);

begin

	PIPE_II_en  <= '1';
	PIPE_III_en <= '1';
	PIPE_IV_en  <= '1';

	i_FETCH_UNIT : FETCH_UNIT
		port map(
			FETCH_UNIT_in_clk            => RISC_V_clk,
			FETCH_UNIT_in_rst_n          => RISC_V_rst_n,
			FETCH_UNIT_in_jump           => Jump_PIPE_II,
			FETCH_UNIT_in_PCscr          => PCSrc,
			FETCH_UNIT_in_jump_value     => Adder2_PIPE_II,
			FETCH_UNIT_in_PCscr_value    => PIPE_III_Adder2,
			FETCH_UNIT_in_Hazard_control => Hazard_Control_PC_ID_IF,
			FETCH_UNIT_out_next_PC       => IF_next_PC_PIPE_I,
			FETCH_UNIT_out_current_PC    => IF_current_PC_PIPE_I
		);

	RISC_V_add_instruction_memory <= IF_current_PC_PIPE_I;

	i_PIPE_I_IF_ID : PIPE_IF_ID
		port map(
			PIPE_IF_ID_clk              => RISC_V_clk,
			PIPE_IF_ID_rst              => RISC_V_rst_n,
			PIPE_IF_ID_ENABLE           => Hazard_Control_PC_ID_IF,
			PIPE_IF_ID_in_next_PC       => IF_next_PC_PIPE_I,
			PIPE_IF_ID_in_current_PC    => IF_current_PC_PIPE_I,
			PIPE_IF_ID_in_instructions  => RISC_V_instruction,
			PIPE_IF_ID_out_next_PC      => PIPE_I_next_PC,
			PIPE_IF_ID_out_current_PC   => PIPE_I_current_PC,
			PIPE_IF_ID_out_instructions => PIPE_I_instruction
		);

	i_DECODING_UNIT : DECODING_UNIT
		port map(
			DECODING_UNIT_in_CLK              => RISC_V_clk,
			DECODING_UNIT_in_rst_n            => RISC_V_rst_n,
			DECODING_UNIT_in_MEM_WB_RegWrite  => PIPE_IV_RegWrite,
			DECODING_UNIT_in_MEM_WB_WriteData => WB_WriteData,
			DECODING_UNIT_in_MEM_WB_RD        => PIPE_IV_RD,
			DECODING_UNIT_in_EX_MEM_Branch    => PIPE_III_Branch,
			DECODING_UNIT_in_ID_EX_Branch     => PIPE_II_Branch,
			DECODING_UNIT_in_ID_EX_RD         => PIPE_II_RD,
			DECODING_UNIT_in_ID_EX_MemRead    => PIPE_II_MemRead,
			DECODING_UNIT_in_ID_EX_Jump       => PIPE_II_Jump,
			DECODING_UNIT_in_MEM_WB_PCSrc     => PIPE_IV_PCSrc,
			DECODING_UNIT_in_INSTR            => PIPE_I_instruction,
			DECODING_UNIT_in_next_PC          => PIPE_I_next_PC,
			DECODING_UNIT_in_current_PC       => PIPE_I_current_PC,
			DECODING_UNIT_out_Adder2          => Adder2_PIPE_II,
			DECODING_UNIT_out_RS1             => RS1_PIPE_II,
			DECODING_UNIT_out_RS2             => RS2_PIPE_II,
			DECODING_UNIT_out_next_PC         => next_PC_PIPE_II,
			DECODING_UNIT_out_current_PC      => current_PC_PIPE_II,
			DECODING_UNIT_out_read_data1      => read_data1_PIPE_II,
			DECODING_UNIT_out_read_data2      => read_data2_PIPE_II,
			DECODING_UNIT_out_LUI             => LUI_PIPE_II,
			DECODING_UNIT_out_RegWrite        => RegWrite_PIPE_II,
			DECODING_UNIT_out_MemRead         => MemRead_PIPE_II,
			DECODING_UNIT_out_AUIPC           => AUIPC_PIPE_II,
			DECODING_UNIT_out_Branch          => Branch_PIPE_II,
			DECODING_UNIT_out_ALUScr          => ALUScr_PIPE_II,
			DECODING_UNIT_out_MemWrite        => MemWrite_PIPE_II,
			DECODING_UNIT_out_Jump            => Jump_PIPE_II,
			DECODING_UNIT_out_ALUOp           => ALUOp_PIPE_II,
			DECODING_UNIT_out_MemtoReg        => MemtoReg_PIPE_II,
			DECODING_UNIT_out_Funct3          => Funct3_PIPE_II,
			DECODING_UNIT_out_Immediate       => Immediate_PIPE_II,
			DECODING_UNIT_out_RD              => RD_PIPE_II,
			DECODING_UNIT_out_Hazard_Control  => Hazard_Control_PC_ID_IF
		);

	i_PIPE_II_ID_EX : PIPE_ID_EX
		port map(
			PIPE_ID_EX_clk            => RISC_V_clk,
			PIPE_ID_EX_rst            => RISC_V_rst_n,
			PIPE_ID_EX_ENABLE         => PIPE_II_en,
			PIPE_ID_EX_in_Adder2      => Adder2_PIPE_II,
			PIPE_ID_EX_in_RS1         => RS1_PIPE_II,
			PIPE_ID_EX_in_RS2         => RS2_PIPE_II,
			PIPE_ID_EX_in_next_PC     => next_PC_PIPE_II,
			PIPE_ID_EX_in_current_PC  => current_PC_PIPE_II,
			PIPE_ID_EX_in_read_data1  => read_data1_PIPE_II,
			PIPE_ID_EX_in_read_data2  => read_data2_PIPE_II,
			PIPE_ID_EX_in_LUI         => LUI_PIPE_II,
			PIPE_ID_EX_in_RegWrite    => RegWrite_PIPE_II,
			PIPE_ID_EX_in_MemRead     => MemRead_PIPE_II,
			PIPE_ID_EX_in_AUIPC       => AUIPC_PIPE_II,
			PIPE_ID_EX_in_Branch      => Branch_PIPE_II,
			PIPE_ID_EX_in_ALUScr      => ALUScr_PIPE_II,
			PIPE_ID_EX_in_MemWrite    => MemWrite_PIPE_II,
			PIPE_ID_EX_in_Jump        => Jump_PIPE_II,
			PIPE_ID_EX_in_ALUOp       => ALUOp_PIPE_II,
			PIPE_ID_EX_in_MemtoReg    => MemtoReg_PIPE_II,
			PIPE_ID_EX_in_Funct3      => Funct3_PIPE_II,
			PIPE_ID_EX_in_Immediate   => Immediate_PIPE_II,
			PIPE_ID_EX_in_RD          => RD_PIPE_II,
			PIPE_ID_EX_out_Adder2     => PIPE_II_Adder2,
			PIPE_ID_EX_out_RS1        => PIPE_II_RS1,
			PIPE_ID_EX_out_RS2        => PIPE_II_RS2,
			PIPE_ID_EX_out_next_PC    => PIPE_II_next_PC,
			PIPE_ID_EX_out_current_PC => PIPE_II_current_PC,
			PIPE_ID_EX_out_read_data1 => PIPE_II_read_data1,
			PIPE_ID_EX_out_read_data2 => PIPE_II_read_data2,
			PIPE_ID_EX_out_LUI        => PIPE_II_LUI,
			PIPE_ID_EX_out_RegWrite   => PIPE_II_RegWrite,
			PIPE_ID_EX_out_MemRead    => PIPE_II_MemRead,
			PIPE_ID_EX_out_AUIPC      => PIPE_II_AUIPC,
			PIPE_ID_EX_out_Branch     => PIPE_II_Branch,
			PIPE_ID_EX_out_ALUScr     => PIPE_II_ALUScr,
			PIPE_ID_EX_out_MemWrite   => PIPE_II_MemWrite,
			PIPE_ID_EX_out_Jump       => PIPE_II_Jump,
			PIPE_ID_EX_out_ALUOp      => PIPE_II_ALUOp,
			PIPE_ID_EX_out_MemtoReg   => PIPE_II_MemtoReg,
			PIPE_ID_EX_out_Funct3     => PIPE_II_Funct3,
			PIPE_ID_EX_out_Immediate  => PIPE_II_Immediate,
			PIPE_ID_EX_out_RD         => PIPE_II_RD
		);

	i_EXECUTION_UNIT : EXECUTION_UNIT
		port map(
			EXECUTION_UNIT_in_RS1                  => PIPE_II_RS1,
			EXECUTION_UNIT_in_RS2                  => PIPE_II_RS2,
			EXECUTION_UNIT_in_next_PC              => PIPE_II_next_PC,
			EXECUTION_UNIT_in_current_PC           => PIPE_II_current_PC,
			EXECUTION_UNIT_in_Adder2               => PIPE_II_Adder2,
			EXECUTION_UNIT_in_read_data1           => PIPE_II_read_data1,
			EXECUTION_UNIT_in_read_data2           => PIPE_II_read_data2,
			EXECUTION_UNIT_in_LUI                  => PIPE_II_LUI,
			EXECUTION_UNIT_in_RegWrite             => PIPE_II_RegWrite,
			EXECUTION_UNIT_in_MemRead              => PIPE_II_MemRead,
			EXECUTION_UNIT_in_AUIPC                => PIPE_II_AUIPC,
			EXECUTION_UNIT_in_Branch               => PIPE_II_Branch,
			EXECUTION_UNIT_in_ALUScr               => PIPE_II_ALUScr,
			EXECUTION_UNIT_in_MemWrite             => PIPE_II_MemWrite,
			EXECUTION_UNIT_in_Jump                 => PIPE_II_Jump,
			EXECUTION_UNIT_in_ALUOp                => PIPE_II_ALUOp,
			EXECUTION_UNIT_in_MemtoReg             => PIPE_II_MemtoReg,
			EXECUTION_UNIT_in_Funct3               => PIPE_II_Funct3,
			EXECUTION_UNIT_in_Immediate            => PIPE_II_Immediate,
			EXECUTION_UNIT_in_RD                   => PIPE_II_RD,
			EXECUTION_UNIT_in_MEM_WB_MUX_WriteData => WB_WriteData,
			EXECUTION_UNIT_in_EX_MEM_ALU_result    => PIPE_III_ALU_result,
			EXECUTION_UNIT_in_EX_MEM_RD            => PIPE_III_RD,
			EXECUTION_UNIT_in_MEM_WB_RD            => PIPE_IV_RD,
			EXECUTION_UNIT_in_EX_MEM_RegWrite      => PIPE_III_RegWrite,
			EXECUTION_UNIT_in_MEM_WB_RegWrite      => PIPE_IV_RegWrite,
			EXECUTION_UNIT_in_MEM_WB_Jump          => PIPE_IV_Jump,
			EXECUTION_UNIT_in_MEM_WB_Next_PC       => PIPE_IV_next_PC,
			EXECUTION_UNIT_out_Adder2              => Adder_PIPE_III,
			EXECUTION_UNIT_out_next_PC             => next_PC_PIPE_III,
			EXECUTION_UNIT_out_ALU_zero            => ALU_zero_PIPE_III,
			EXECUTION_UNIT_out_ALU_result          => ALU_result_PIPE_III,
			EXECUTION_UNIT_out_RegWrite            => RegWrite_PIPE_III,
			EXECUTION_UNIT_out_Branch              => Branch_PIPE_III,
			EXECUTION_UNIT_out_MemWrite            => MemWrite_PIPE_III,
			EXECUTION_UNIT_out_Jump                => Jump_PIPE_III,
			EXECUTION_UNIT_out_MemRead             => MemRead_PIPE_III,
			EXECUTION_UNIT_out_MemtoReg            => MemtoReg_PIPE_III,
			EXECUTION_UNIT_out_RD                  => RD_PIPE_III,
			EXECUTION_UNIT_out_ReadData2           => ReadData2_PIPE_III
		);

	i_PIPE_III_EX_MEM : PIPE_EX_MEM
		port map(
			PIPE_EX_MEM_clk            => RISC_V_clk,
			PIPE_EX_MEM_rst            => RISC_V_rst_n,
			PIPE_EX_MEM_ENABLE         => PIPE_III_en,
			PIPE_EX_MEM_in_Adder2      => Adder_PIPE_III,
			PIPE_EX_MEM_in_next_PC     => next_PC_PIPE_III,
			PIPE_EX_MEM_in_ALU_zero    => ALU_zero_PIPE_III,
			PIPE_EX_MEM_in_ALU_result  => ALU_result_PIPE_III,
			PIPE_EX_MEM_in_ReadData2   => ReadData2_PIPE_III,
			PIPE_EX_MEM_in_RegWrite    => RegWrite_PIPE_III,
			PIPE_EX_MEM_in_Branch      => Branch_PIPE_III,
			PIPE_EX_MEM_in_MemWrite    => MemWrite_PIPE_III,
			PIPE_EX_MEM_in_Jump        => Jump_PIPE_III,
			PIPE_EX_MEM_in_MemRead     => MemRead_PIPE_III,
			PIPE_EX_MEM_in_MemtoReg    => MemtoReg_PIPE_III,
			PIPE_EX_MEM_in_RD          => RD_PIPE_III,
			PIPE_EX_MEM_out_Adder2     => PIPE_III_Adder2,
			PIPE_EX_MEM_out_next_PC    => PIPE_III_next_PC,
			PIPE_EX_MEM_out_ALU_zero   => PIPE_III_ALU_zero,
			PIPE_EX_MEM_out_ALU_result => PIPE_III_ALU_result,
			PIPE_EX_MEM_out_ReadData2  => PIPE_III_MUX3,
			PIPE_EX_MEM_out_RegWrite   => PIPE_III_RegWrite,
			PIPE_EX_MEM_out_Branch     => PIPE_III_Branch,
			PIPE_EX_MEM_out_MemWrite   => PIPE_III_MemWrite,
			PIPE_EX_MEM_out_Jump       => PIPE_III_Jump,
			PIPE_EX_MEM_out_MemRead    => PIPE_III_MemRead,
			PIPE_EX_MEM_out_MemtoReg   => PIPE_III_MemtoReg,
			PIPE_EX_MEM_out_RD         => PIPE_III_RD
		);

	PCSrc                   <= PIPE_III_Branch and PIPE_III_ALU_zero;
	RISC_V_add_data_memory  <= PIPE_III_ALU_result;
	RISC_V_MemRead          <= PIPE_III_MemRead;
	RISC_V_MemWrite         <= PIPE_III_MemWrite;
	RISC_V_DATA_data_memory <= PIPE_III_MUX3; --It's not the ouput of MUX3, is the contect of RS2

	i_MEMORY_UNIT : MEMORY_UNIT
		port map(
			MEMORY_UNIT_in_next_PC    => PIPE_III_next_PC,
			MEMORY_UNIT_in_ADDRESS    => PIPE_III_ALU_result,
			MEMORY_UNIT_in_Jump       => PIPE_III_Jump,
			MEMORY_UNIT_in_RegWrite   => PIPE_III_RegWrite,
			MEMORY_UNIT_in_MemtoReg   => PIPE_III_MemtoReg,
			MEMORY_UNIT_in_RD         => PIPE_III_RD,
			MEMORY_UNIT_out_next_PC   => next_PC_PIPE_IV,
			MEMORY_UNIT_out_Jump      => Jump_PIPE_IV,
			MEMORY_UNIT_out_RegWrite  => RegWrite_PIPE_IV,
			MEMORY_UNIT_out_MemtoReg  => MemtoReg_PIPE_IV,
			MEMORY_UNIT_out_RD        => RD_PIPE_IV,
			MEMORY_UNIT_out_ALUResult => ALUResult_PIPE_IV
		);

	i_PIPE_IV_MEM_WB : PIPE_MEM_WB
		port map(
			PIPE_MEM_WB_clk           => RISC_V_clk,
			PIPE_MEM_WB_rst           => RISC_V_rst_n,
			PIPE_MEM_WB_ENABLE        => PIPE_IV_en,
			PIPE_MEM_WB_in_next_PC    => next_PC_PIPE_IV,
			PIPE_MEM_WB_in_PCSrc      => PCSrc,
			PIPE_MEM_WB_in_ReadData   => RISC_V_ReadData,
			PIPE_MEM_WB_in_ALUResult  => ALUResult_PIPE_IV,
			PIPE_MEM_WB_in_Jump       => Jump_PIPE_IV,
			PIPE_MEM_WB_in_RegWrite   => RegWrite_PIPE_IV,
			PIPE_MEM_WB_in_MemtoReg   => MemtoReg_PIPE_IV,
			PIPE_MEM_WB_in_RD         => RD_PIPE_IV,
			PIPE_MEM_WB_out_next_PC   => PIPE_IV_next_PC,
			PIPE_MEM_WB_out_ReadData  => PIPE_IV_ReadData,
			PIPE_MEM_WB_out_Jump      => PIPE_IV_Jump,
			PIPE_MEM_WB_out_RegWrite  => PIPE_IV_RegWrite,
			PIPE_MEM_WB_out_MemtoReg  => PIPE_IV_MemtoReg,
			PIPE_MEM_WB_out_RD        => PIPE_IV_RD,
			PIPE_MEM_WB_out_PCSrc     => PIPE_IV_PCSrc,
			PIPE_MEM_WB_out_ALUResult => PIPE_IV_ALUResult
		);

	i_WRITE_BACK_UNIT : WRITE_BACK_UNIT
		port map(
			WRITE_BACK_UNIT_in_next_PC    => PIPE_IV_next_PC,
			WRITE_BACK_UNIT_in_ReadData   => PIPE_IV_ReadData,
			WRITE_BACK_UNIT_in_MemtoReg   => PIPE_IV_MemtoReg,
			WRITE_BACK_UNIT_in_ALU_Result => PIPE_IV_ALUResult,
			PIPE_MEM_WB_out_MUX           => WB_WriteData
		);

end BEHAVIORAL;
