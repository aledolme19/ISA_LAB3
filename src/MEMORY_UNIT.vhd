library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEMORY_UNIT is
	port(
		MEMORY_UNIT_in_next_PC                         : in  std_logic_vector(31 downto 0);
		MEMORY_UNIT_in_ADDRESS                         : in  std_logic_vector(31 downto 0);
		MEMORY_UNIT_in_Jump, MEMORY_UNIT_in_RegWrite   : in  std_logic;
		MEMORY_UNIT_in_MemtoReg                        : in  std_logic_vector(1 downto 0);
		MEMORY_UNIT_in_RD                              : in  std_logic_vector(4 downto 0);
		--output---------------
		MEMORY_UNIT_out_next_PC                        : out std_logic_vector(31 downto 0);
		MEMORY_UNIT_out_Jump, MEMORY_UNIT_out_RegWrite : out std_logic;
		MEMORY_UNIT_out_MemtoReg                       : out std_logic_vector(1 downto 0);
		MEMORY_UNIT_out_RD                             : out std_logic_vector(4 downto 0);
		MEMORY_UNIT_out_ALUResult                      : out std_logic_vector(31 downto 0)
	);
end entity MEMORY_UNIT;

architecture RTL of MEMORY_UNIT is

begin

	---output-------------------
	MEMORY_UNIT_out_next_PC   <= MEMORY_UNIT_in_next_PC;
	MEMORY_UNIT_out_Jump      <= MEMORY_UNIT_in_Jump;
	MEMORY_UNIT_out_MemtoReg  <= MEMORY_UNIT_in_MemtoReg;
	MEMORY_UNIT_out_RD        <= MEMORY_UNIT_in_RD;
	MEMORY_UNIT_out_RegWrite  <= MEMORY_UNIT_in_RegWrite;
	MEMORY_UNIT_out_ALUResult <= MEMORY_UNIT_in_ADDRESS;

end architecture RTL;
