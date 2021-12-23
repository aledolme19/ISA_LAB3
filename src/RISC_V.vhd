---------------------------------------------------------------------------------------------
-- File: RISC_V.vhd
---------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISC_V is
    port(
        RISC_V_clk : in std_logic
    );
end entity RISC_V;

architecture BEHAVIORAL of RISC_V is


----------------COMPONENTS-------------------------------------------------------------
component FETCH_UNIT
    port(
        FETCH_UNIT_in_clk            : in  std_logic;
        FETCH_UNIT_in_jump           : in  std_logic;
        FETCH_UNIT_in_PCscr          : in  std_logic;
        FETCH_UNIT_in_jump_value     : in  std_logic_vector(31 downto 0);
        FETCH_UNIT_in_PCscr_value    : in  std_logic_vector(31 downto 0);
        FETCH_UNIT_in_Hazard_control : in  std_logic;
        FETCH_UNIT_out_next_PC       : out std_logic_vector(31 downto 0);
        FETCH_UNIT_out_current_PC    : out std_logic_vector(31 downto 0);
        FETCH_UNIT_out_instructions  : out std_logic_vector(31 downto 0)
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
        DECODING_UNIT_in_MEM_WB_RegWrite                                                                                                                                                                              : in  std_logic;
        DECODING_UNIT_in_MEM_WB_WriteData                                                                                                                                                                             : in  std_logic_vector(31 downto 0);
        DECODING_UNIT_in_MEM_WB_RD                                                                                                                                                                                    : in  std_logic_vector(4 downto 0);
        DECODING_UNIT_in_ID_EX_RD                                                                                                                                                                                     : in  std_logic_vector(4 downto 0);
        DECODING_UNIT_in_ID_EX_MemRead                                                                                                                                                                                : in  std_logic;
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


----------------SIGNALS--------------------------------------------------------------

---Fetch Unit Signals-----------------------------------------------------------------
signal Jump_ID_IF: std_logic;
signal PCSrc_ID_MEM: std_logic;
signal Jump_address_ID_IF : std_logic_vector(31 downto 0);
signal PCSrc_address_ID_MEM: std_logic_vector(31 downto 0);
signal Hazard_Control_PC_ID_IF: std_logic;
signal IF_next_PC, IF_current_PC, IF_instruction: std_logic_vector(31 downto 0);
--PIPE_IF_ID Signals-----------------------------------------------------------------
signal PIPE_I_rst: std_logic;
signal PIPE_I_en: std_logic; --coming from the HAZARD UNIT
signal PIPE_I_next_PC, PIPE_I_current_PC, PIPE_I_instruction: std_logic_vector(31 downto 0);
--Decoding Unit Signals---------------------------------------------------------------
signal MEM_WB_RegWrite: std_logic;
signal MEM_WB_WriteData: std_logic_vector(31 downto 0);
signal MEM_WB_RD: std_logic_vector(4 downto 0);
signal ID_EX_RD: std_logic_vector(4 downto 0);
signal ID_EX_MemRead: std_logic;
signal Adder2_PIPE_II: std_logic_vector(31 downto 0);
signal RS1_PIPE_II, RS2_PIPE_II: std_logic_vector(4 downto 0);
signal next_PC_PIPE_II, current_PC_PIPE_II: std_logic_vector(31 downto 0);
signal read_data1_PIPE_II, read_data2_PIPE_II: std_logic_vector(31 downto 0);
signal LUI_PIPE_II, RegWrite_PIPE_II, MemRead_PIPE_II, AUIPC_PIPE_II, Branch_PIPE_II, ALUScr_PIPE_II, MemWrite_PIPE_II, Jump_PIPE_II: std_logic;
signal ALUOp_PIPE_II, MemtoReg_PIPE_II: std_logic_vector(1 downto 0);
signal Funct3_PIPE_II: std_logic_vector(2 downto 0);
signal Immediate_PIPE_II: std_logic_vector(31 downto 0);
signal RD_PIPE_II: std_logic_vector(4 downto 0);
signal DECODING_UNIT_OUT_HAZARD_CONTROL: std_logic;



begin
    
    
    i_FETCH_UNIT: FETCH_UNIT
        port map(
            FETCH_UNIT_in_clk            => RISC_V_clk,
            FETCH_UNIT_in_jump           => Jump_ID_IF,
            FETCH_UNIT_in_PCscr          => PCSrc_ID_MEM,
            FETCH_UNIT_in_jump_value     => Jump_address_ID_IF,
            FETCH_UNIT_in_PCscr_value    => PCSrc_address_ID_MEM,
            FETCH_UNIT_in_Hazard_control => Hazard_Control_PC_ID_IF,
            FETCH_UNIT_out_next_PC       => IF_next_PC,
            FETCH_UNIT_out_current_PC    => IF_current_PC,
            FETCH_UNIT_out_instructions  => IF_instruction
        );
        
     
     i_PIPE_I_IF_ID: PIPE_IF_ID
         port map(
             PIPE_IF_ID_clk              => RISC_V_clk,
             PIPE_IF_ID_rst              => PIPE_I_rst,
             PIPE_IF_ID_ENABLE           => PIPE_I_en,
             PIPE_IF_ID_in_next_PC       => IF_next_PC,
             PIPE_IF_ID_in_current_PC    => IF_current_PC,
             PIPE_IF_ID_in_instructions  => IF_instruction,
             PIPE_IF_ID_out_next_PC      => PIPE_I_next_PC,
             PIPE_IF_ID_out_current_PC   => PIPE_I_current_PC,
             PIPE_IF_ID_out_instructions => PIPE_I_instruction
         );
         
         i_DECODING_UNIT: DECODING_UNIT
             port map(
                 DECODING_UNIT_in_CLK              => RISC_V_clk,
                 DECODING_UNIT_in_MEM_WB_RegWrite  => MEM_WB_RegWrite,
                 DECODING_UNIT_in_MEM_WB_WriteData => MEM_WB_WriteData,
                 DECODING_UNIT_in_MEM_WB_RD        => MEM_WB_RD,
                 DECODING_UNIT_in_ID_EX_RD         => ID_EX_RD,
                 DECODING_UNIT_in_ID_EX_MemRead    => ID_EX_MemRead,
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
    
    

end BEHAVIORAL;
