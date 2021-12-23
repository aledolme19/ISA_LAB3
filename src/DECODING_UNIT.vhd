library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DECODING_UNIT is
    port(
        --INPUTS--
        DECODING_UNIT_in_CLK: in std_logic;
        DECODING_UNIT_in_MEM_WB_RegWrite: in std_logic;
        DECODING_UNIT_in_MEM_WB_WriteData: in std_logic_vector(31 downto 0);
        DECODING_UNIT_in_MEM_WB_RD: in std_logic_vector(4 downto 0);
        DECODING_UNIT_in_ID_EX_RD: in std_logic_vector(4 downto 0);
        DECODING_UNIT_in_ID_EX_MemRead: in std_logic;
        DECODING_UNIT_in_INSTR    : in  std_logic_vector(31 downto 0);
        DECODING_UNIT_in_next_PC : in  std_logic_vector(31 downto 0);
        DECODING_UNIT_in_current_PC : in  std_logic_vector(31 downto 0);
        --OUTPUTS--
        DECODING_UNIT_out_Adder2: out std_logic_vector(31 downto 0);
        DECODING_UNIT_out_RS1, DECODING_UNIT_out_RS2: out std_logic_vector(4 downto 0);
        DECODING_UNIT_out_next_PC, DECODING_UNIT_out_current_PC: out std_logic_vector(31 downto 0);
        DECODING_UNIT_out_read_data1, DECODING_UNIT_out_read_data2: out std_logic_vector(31 downto 0);
        DECODING_UNIT_out_LUI, DECODING_UNIT_out_RegWrite, DECODING_UNIT_out_MemRead, DECODING_UNIT_out_AUIPC, 
        DECODING_UNIT_out_Branch, DECODING_UNIT_out_ALUScr, DECODING_UNIT_out_MemWrite , DECODING_UNIT_out_Jump : out std_logic;
        DECODING_UNIT_out_ALUOp, DECODING_UNIT_out_MemtoReg: out std_logic_vector(1 downto 0);
        DECODING_UNIT_out_Funct3 : out std_logic_vector(2 downto 0);
        DECODING_UNIT_out_Immediate: out std_logic_vector(31 downto 0);
        DECODING_UNIT_out_RD: out std_logic_vector(4 downto 0);
        DECODING_UNIT_out_Hazard_Control: out std_logic
    );
end entity DECODING_UNIT;

architecture BEHAVIORAL of DECODING_UNIT is

    ------------COMPONONENTs--------------------------------------------------
    component REGISTER_FILE
        generic(
            width        : positive := 32;
            address_bits : positive := 5
        );
        port(
            RF_IN_CLK        : in  std_logic;
            RF_IN_RST_N      : in  std_logic;
            RF_IN_REGWRITE   : in  std_logic;
            RF_IN_WRITE_RD   : in  std_logic_vector(address_bits - 1 downto 0);
            RF_IN_WRITE_DATA : in  std_logic_vector(width - 1 downto 0);
            RF_IN_READ_RS1   : in  std_logic_vector(address_bits - 1 downto 0);
            RF_IN_READ_RS2   : in  std_logic_vector(address_bits - 1 downto 0);
            RF_OUT_RS1       : out std_logic_vector(width - 1 downto 0);
            RF_OUT_RS2       : out std_logic_vector(width - 1 downto 0)
        );
    end component REGISTER_FILE;

    component ADDER2_NBIT
        generic(N : positive := 32);
        port(
            ADDER_IN_A     : in  std_logic_vector(N - 1 downto 0);
            ADDER_IN_B     : in  std_logic_vector(N - 1 downto 0);
            ADDER_IN_CARRY : in  std_logic;
            ADDER_OUT_S    : out std_logic_vector(N - 1 downto 0)
        );
    end component ADDER2_NBIT;


    component CONTROL_UNIT
        port(
            CU_IN_OPCODE    : in  std_logic_vector(6 downto 0);
            CU_OUT_Branch   : out std_logic;
            CU_OUT_MemRead  : out std_logic;
            CU_OUT_ALUOp    : out std_logic_vector(1 downto 0);
            CU_OUT_MemWrite : out std_logic;
            CU_OUT_ALUSrc   : out std_logic;
            CU_OUT_RegWrite : out std_logic;
            CU_OUT_Jump     : out std_logic;
            CU_OUT_MemToReg : out std_logic_vector(1 downto 0);
            CU_OUT_Lui      : out std_logic;
            CU_OUT_Auipc    : out std_logic
        );
    end component CONTROL_UNIT;


    component IMM_GEN
        port(
            IMM_GEN_IN_INSTR : in  std_logic_vector(31 downto 0);
            IMM_GEN_OUT      : out std_logic_vector(63 downto 0)
        );
    end component IMM_GEN;


    component HAZARD_UNIT
        port(
            HU_IN_IF_ID_RS1     : in  std_logic_vector(4 downto 0);
            HU_IN_IF_ID_RS2     : in  std_logic_vector(4 downto 0);
            HU_IN_ID_EX_MEMREAD : in  std_logic;
            HU_IN_ID_EX_RD      : in  std_logic_vector(4 downto 0);
            HU_OUT_IF_ID_WRITE  : out std_logic;
            HU_OUT_PC_WRITE     : out std_logic
        );
    end component HAZARD_UNIT;


    component bN_2to1mux
        generic(N : positive := 8);
        port(
            x, y   : in  std_logic_vector(N - 1 downto 0);
            s      : in  std_logic;
            output : out std_logic_vector(N - 1 downto 0)
        );
    end component bN_2to1mux;


    ----------------SIGNALS--------------------------------------------------------------
    --instruction decomponsition signals
    signal RS1, RS2, RD : std_logic_vector(4 downto 0);
    signal OPCODE: std_logic_vector(6 downto 0);
    signal FUNCT3: std_logic_vector(2 downto 0);

    signal Branch, MemRead, MemWrite, ALUSrc, RegWrite, Jump, Lui, Auipc: std_logic;
    signal ALUOp, MemToReg: std_logic_vector(1 downto 0);

    signal input1_MUX_Control, input2_MUX_Control: std_logic_vector(14 downto 0);
    signal out_MUX_Control:  std_logic_vector(14 downto 0);

    signal HAZARD_mux_sel: std_logic;
    
    signal immediate, immediate_shifted: std_logic_vector(63 downto 0);

begin

    --instruction decomponsition
    RS1 <= DECODING_UNIT_in_INSTR(19 downto 15);
    RS2 <= DECODING_UNIT_in_INSTR(24 downto 20);
    OPCODE <= DECODING_UNIT_in_INSTR(6 downto 0);
    FUNCT3 <= DECODING_UNIT_in_INSTR(14 downto 12);
    RD <= DECODING_UNIT_in_INSTR(11 downto 7);



    i_REGISTER_FILE: REGISTER_FILE
        generic map(
            width        => 32,
            address_bits => 5
        )
        port map(
            RF_IN_CLK        => DECODING_UNIT_in_CLK,
            RF_IN_RST_N      => RF_IN_RST_N,
            RF_IN_REGWRITE   => DECODING_UNIT_in_MEM_WB_RegWrite,
            RF_IN_WRITE_RD   => DECODING_UNIT_in_MEM_WB_RD,
            RF_IN_WRITE_DATA => DECODING_UNIT_in_MEM_WB_WriteData,
            RF_IN_READ_RS1   => RS1,
            RF_IN_READ_RS2   => RS2,
            RF_OUT_RS1       => DECODING_UNIT_out_read_data1,
            RF_OUT_RS2       => DECODING_UNIT_out_read_data2
        );


    i_CONTROL_UNIT: CONTROL_UNIT
        port map(
            CU_IN_OPCODE    => OPCODE,
            CU_OUT_Branch   => Branch,
            CU_OUT_MemRead  => MemRead,
            CU_OUT_ALUOp    => ALUOp,
            CU_OUT_MemWrite => MemWrite,
            CU_OUT_ALUSrc   => ALUSrc,
            CU_OUT_RegWrite => RegWrite,
            CU_OUT_Jump     => Jump,
            CU_OUT_MemToReg => MemToReg,
            CU_OUT_Lui      => Lui,
            CU_OUT_Auipc    => Auipc
        );


    input1_MUX_Control <= (others=>'0');
    input2_MUX_Control<= Branch & MemRead & ALUOp & MemWrite & ALUSrc & RegWrite & Jump & MemToReg & Lui & Auipc & FUNCT3;

    i_MUX_CONTROL: bN_2to1mux
        generic map(
            N => 15
        )
        port map(
            x      => input2_MUX_Control,
            y      => input1_MUX_Control,
            s      => HAZARD_mux_sel,
            output => out_MUX_Control
        );
        
        
     i_IMMEDIATE_UNIT: IMM_GEN
         port map(
             IMM_GEN_IN_INSTR => DECODING_UNIT_in_INSTR,
             IMM_GEN_OUT      => immediate
         );


    immediate_shifted <= immediate(62 downto 0) & "0";
    
    i_ADDER2: ADDER2_NBIT
        generic map(
            N => 32
        )
        port map(
            ADDER_IN_A     => immediate_shifted,
            ADDER_IN_B     => DECODING_UNIT_in_current_PC,
            ADDER_IN_CARRY => '0',
            ADDER_OUT_S    => DECODING_UNIT_out_Adder2
        );
    
    


    ----OUTPUT--------------------------
    DECODING_UNIT_out_Branch<= out_MUX_Control(0);
    DECODING_UNIT_out_MemRead<= out_MUX_Control(1);
    DECODING_UNIT_out_ALUOp<= out_MUX_Control(3 downto 2);
    DECODING_UNIT_out_MemWrite <= out_MUX_Control(4);
    DECODING_UNIT_out_ALUScr<= out_MUX_Control(5);
    DECODING_UNIT_out_RegWrite <= out_MUX_Control(6);
    DECODING_UNIT_out_Jump <= out_MUX_Control(7);
    DECODING_UNIT_out_MemtoReg <= out_MUX_Control(9 downto 8);
    DECODING_UNIT_out_LUI <= out_MUX_Control(10);
    DECODING_UNIT_out_AUIPC<= out_MUX_Control(11);
    DECODING_UNIT_out_Funct3 <= out_MUX_Control(14 downto 12);
   
   DECODING_UNIT_out_RS1 <= RS1;
   DECODING_UNIT_out_RS2 <= RS2;
   DECODING_UNIT_out_RD <= RD;
   
   DECODING_UNIT_out_next_PC <= DECODING_UNIT_in_next_PC;
   DECODING_UNIT_out_current_PC <= DECODING_UNIT_in_current_PC;
      
   

  
  
  
  



end architecture BEHAVIORAL;
