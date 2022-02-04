library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ALU is
end entity tb_ALU;

architecture testbench of tb_ALU is

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

	constant width : positive := 32;

	-- signal given by us
	signal OPCODE    : std_logic_vector(6 downto 0);
	signal FUNCT3    : std_logic_vector(2 downto 0);
	signal OPERAND_1 : std_logic_vector(width - 1 downto 0);
	signal OPERAND_2 : std_logic_vector(width - 1 downto 0);

	-- intermediate signals
	signal ALUOP_CU_AC    : std_logic_vector(1 downto 0);
	signal CONTROL_AC_ALU : std_logic_vector(3 downto 0);

	-- output signals
	signal ALU_OUT  : std_logic_vector(width - 1 downto 0); -- @suppress "signal ALU_OUT is never read"
	signal ALU_ZERO : std_logic;        -- @suppress "signal ALU_ZERO is never read"

begin

	i_CU : component CONTROL_UNIT
		port map(
			CU_IN_OPCODE    => OPCODE,
			CU_OUT_Branch   => open,
			CU_OUT_MemRead  => open,
			CU_OUT_ALUOp    => ALUOP_CU_AC,
			CU_OUT_MemWrite => open,
			CU_OUT_ALUSrc   => open,
			CU_OUT_RegWrite => open,
			CU_OUT_Jump     => open,
			CU_OUT_MemToReg => open,
			CU_OUT_Lui      => open,
			CU_OUT_Auipc    => open
		);

	i_AC : component ALU_CONTROL
		port map(
			ALU_CONTROL_IN_ALUOP  => ALUOP_CU_AC,
			ALU_CONTROL_IN_FUNCT3 => FUNCT3,
			ALU_CONTROL_OUT       => CONTROL_AC_ALU
		);

	i_ALU : component ALU
		generic map(
			N => width
		)
		port map(
			ALU_IN_A       => OPERAND_1,
			ALU_IN_B       => OPERAND_2,
			ALU_IN_CONTROL => CONTROL_AC_ALU,
			ALU_OUT        => ALU_OUT,
			ALU_OUT_ZERO   => ALU_ZERO
		);

	stimuli : process is
	begin
		-- add: 45 + 1026
		OPERAND_1 <= std_logic_vector(to_signed(45, OPERAND_1'length));
		OPERAND_2 <= std_logic_vector(to_signed(1026, OPERAND_2'length));
		OPCODE    <= "0110011";
		FUNCT3    <= "000";
		wait for 10 ns;

		-- addi: 45 + 1026
		OPCODE    <= "0010011";
		FUNCT3    <= "000";
		OPERAND_1 <= std_logic_vector(to_signed(45, OPERAND_1'length));
		OPERAND_2 <= std_logic_vector(to_signed(1026, OPERAND_2'length));
		wait for 10 ns;

		-- andi
		OPCODE    <= "0010011";
		FUNCT3    <= "111";
		OPERAND_1 <= "11001101011100111100010111101010";
		OPERAND_2 <= "10011111000101000110011000110101";
		wait for 10 ns;

		-- xor
		OPCODE    <= "0110011";
		FUNCT3    <= "100";
		OPERAND_1 <= "11001101011100111100010111101010";
		OPERAND_2 <= "10011111000101000110011000110101";
		wait for 10 ns;

		-- srai: 138858171 >> 6
		OPCODE    <= "0010011";
		FUNCT3    <= "101";
		OPERAND_1 <= std_logic_vector(to_signed(138858171, OPERAND_1'length));
		OPERAND_2 <= std_logic_vector(to_signed(6, OPERAND_2'length));
		wait for 10 ns;

		-- beq
		OPCODE    <= "1100011";
		FUNCT3    <= "000";
		OPERAND_1 <= std_logic_vector(to_signed(819593, OPERAND_1'length));
		OPERAND_2 <= std_logic_vector(to_signed(156, OPERAND_2'length));
		wait for 10 ns;
		OPCODE    <= "1100011";
		FUNCT3    <= "000";
		OPERAND_1 <= std_logic_vector(to_signed(16161, OPERAND_1'length));
		OPERAND_2 <= std_logic_vector(to_signed(16161, OPERAND_2'length));
		wait for 10 ns;

		-- slt: 158178 <> 2717723
		OPCODE    <= "0110011";
		FUNCT3    <= "010";
		OPERAND_1 <= std_logic_vector(to_signed(158178, OPERAND_1'length));
		OPERAND_2 <= std_logic_vector(to_signed(2717723, OPERAND_2'length));
		wait for 10 ns;
		OPCODE    <= "0110011";
		FUNCT3    <= "010";
		OPERAND_1 <= std_logic_vector(to_signed(2717723, OPERAND_1'length));
		OPERAND_2 <= std_logic_vector(to_signed(158178, OPERAND_2'length));
		wait for 10 ns;

		-- lw: target = 819593 - 156
		OPCODE    <= "0000011";
		FUNCT3    <= "010";
		OPERAND_1 <= std_logic_vector(to_signed(819593, OPERAND_1'length));
		OPERAND_2 <= std_logic_vector(to_signed(-156, OPERAND_2'length));
		wait for 10 ns;

		-- sw: target = 819593 - 156
		OPCODE    <= "0100011";
		FUNCT3    <= "010";
		OPERAND_1 <= std_logic_vector(to_signed(819593, OPERAND_1'length));
		OPERAND_2 <= std_logic_vector(to_signed(-156, OPERAND_2'length));
		wait for 10 ns;

		-- auipc: -15715 + 19483
		OPCODE    <= "0010111";
		FUNCT3    <= "010";             -- don't care for this operation
		OPERAND_1 <= std_logic_vector(to_signed(-15715, OPERAND_1'length));
		OPERAND_2 <= std_logic_vector(to_signed(19483, OPERAND_2'length));
		wait for 10 ns;

		-- lui: 0 + 19483
		OPCODE    <= "0110111";
		FUNCT3    <= "111";             -- don't care for this operation
		OPERAND_1 <= std_logic_vector(to_signed(0, OPERAND_1'length));
		OPERAND_2 <= std_logic_vector(to_signed(19483, OPERAND_2'length));

		wait;
	end process stimuli;

end architecture testbench;
