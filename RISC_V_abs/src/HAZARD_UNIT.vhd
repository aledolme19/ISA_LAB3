library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HAZARD_UNIT is
	port(
		HU_IN_IF_ID_RS1          : in  std_logic_vector(4 downto 0);
		HU_IN_IF_ID_RS2          : in  std_logic_vector(4 downto 0);
		HU_IN_ID_EX_MEMREAD      : in  std_logic;
		HU_IN_ID_EX_RD           : in  std_logic_vector(4 downto 0);
		HU_IN_IF_ID_BRANCH       : in  std_logic;
		HU_IN_ID_EX_BRANCH       : in  std_logic;
		HU_IN_EX_MEM_BRANCH      : in  std_logic;
		HU_IN_ID_EX_JUMP         : in  std_logic;
		HU_IN_MEM_WB_BRANCHTAKEN : in  std_logic;
		HU_OUT_IF_ID_PC_WRITE    : out std_logic;
		HU_OUT_NOP_SEL           : out std_logic
	);
end entity HAZARD_UNIT;

architecture BEHAVIORAL of HAZARD_UNIT is

	component COMPARATOR_EQ
		generic(N : positive := 32);
		port(
			COMPARATOR_EQ_IN0 : in  std_logic_vector(N - 1 downto 0);
			COMPARATOR_EQ_IN1 : in  std_logic_vector(N - 1 downto 0);
			COMPARATOR_EQ_OUT : out std_logic
		);
	end component COMPARATOR_EQ;

	signal RS1_EQUALTO_RD, RS2_EQUALTO_RD : std_logic;

begin

	i_COMP_RS1_RD : component COMPARATOR_EQ
		generic map(
			N => 5
		)
		port map(
			COMPARATOR_EQ_IN0 => HU_IN_IF_ID_RS1,
			COMPARATOR_EQ_IN1 => HU_IN_ID_EX_RD,
			COMPARATOR_EQ_OUT => RS1_EQUALTO_RD
		);

	i_COMP_RS2_RD : component COMPARATOR_EQ
		generic map(
			N => 5
		)
		port map(
			COMPARATOR_EQ_IN0 => HU_IN_IF_ID_RS2,
			COMPARATOR_EQ_IN1 => HU_IN_ID_EX_RD,
			COMPARATOR_EQ_OUT => RS2_EQUALTO_RD
		);

	NOP_gen : process(HU_IN_MEM_WB_BRANCHTAKEN, HU_IN_ID_EX_JUMP, HU_IN_ID_EX_BRANCH, HU_IN_ID_EX_MEMREAD, RS1_EQUALTO_RD, RS2_EQUALTO_RD, HU_IN_EX_MEM_BRANCH, HU_IN_IF_ID_BRANCH)
	begin
		if HU_IN_MEM_WB_BRANCHTAKEN = '1' then -- In case of BRANCH taken another NOP (3rd) is required in the following clock cycle, in order to decode the right instruction, otherwise this NOP is not necessary
			HU_OUT_NOP_SEL <= '1';
		elsif HU_IN_ID_EX_JUMP = '1' then -- Every time a JUMP is decoded a NOP is inserted 
			HU_OUT_NOP_SEL <= '1';
		elsif (HU_IN_ID_EX_BRANCH or (HU_IN_ID_EX_MEMREAD and (RS1_EQUALTO_RD or RS2_EQUALTO_RD))) = '1' then -- A NOP is required anytime a BRANCH or LOAD instruction in decoded
			HU_OUT_NOP_SEL <= '1';
		elsif HU_IN_EX_MEM_BRANCH = '1' then -- The 2nd NOP after BRANCH instruction
			HU_OUT_NOP_SEL <= '1';
		elsif HU_IN_IF_ID_BRANCH = '1' then -- At the clock cycle in which BRANCH is decoded NOP is not needed
			HU_OUT_NOP_SEL <= '0';
		else
			HU_OUT_NOP_SEL <= '0';
		end if;
	end process;

	EN_gen : process(HU_IN_MEM_WB_BRANCHTAKEN, HU_IN_ID_EX_JUMP, HU_IN_ID_EX_BRANCH, HU_IN_ID_EX_MEMREAD, RS1_EQUALTO_RD, RS2_EQUALTO_RD, HU_IN_EX_MEM_BRANCH, HU_IN_IF_ID_BRANCH)
	begin
		if HU_IN_MEM_WB_BRANCHTAKEN = '1' then
			HU_OUT_IF_ID_PC_WRITE <= '1';
		elsif HU_IN_ID_EX_JUMP = '1' then
			HU_OUT_IF_ID_PC_WRITE <= '1';
		elsif (HU_IN_ID_EX_BRANCH or (HU_IN_ID_EX_MEMREAD and (RS1_EQUALTO_RD or RS2_EQUALTO_RD))) = '1' then -- When NOP is inserted enable of PC and IF/ID pipe register is disabled
			HU_OUT_IF_ID_PC_WRITE <= '0';
		elsif HU_IN_EX_MEM_BRANCH = '1' then
			HU_OUT_IF_ID_PC_WRITE <= '1';
		elsif HU_IN_IF_ID_BRANCH = '1' then -- At the clock cycle in which BRANCH is decoded enable of PC and IF/ID pipe register is disabled to avoid new instructions enter in pipe queue
			HU_OUT_IF_ID_PC_WRITE <= '0';
		else
			HU_OUT_IF_ID_PC_WRITE <= '1';
		end if;
	end process;

end architecture BEHAVIORAL;
