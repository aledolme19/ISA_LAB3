library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FORWARDING_UNIT is
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
end entity FORWARDING_UNIT;

architecture BEHAVIORAL of FORWARDING_UNIT is

	component COMPARATOR_EQ
		generic(N : positive := 32);
		port(
			COMPARATOR_EQ_IN0 : in  std_logic_vector(N - 1 downto 0);
			COMPARATOR_EQ_IN1 : in  std_logic_vector(N - 1 downto 0);
			COMPARATOR_EQ_OUT : out std_logic
		);
	end component COMPARATOR_EQ;

	signal ID_EX_RS1_EQUALTO_EX_MEM_RD, ID_EX_RS1_EQUALTO_MEM_WB_RD, ID_EX_RS2_EQUALTO_EX_MEM_RD, ID_EX_RS2_EQUALTO_MEM_WB_RD : std_logic;
	signal isZERO_EX_MEM_RD, isZERO_MEM_WB_RD                                                                                 : std_logic;

begin

	i_COMP_ID_EX_RS1_EX_MEM_RD : component COMPARATOR_EQ
		generic map(
			N => 5
		)
		port map(
			COMPARATOR_EQ_IN0 => FU_IN_ID_EX_RS1,
			COMPARATOR_EQ_IN1 => FU_IN_EX_MEM_RD,
			COMPARATOR_EQ_OUT => ID_EX_RS1_EQUALTO_EX_MEM_RD
		);

	i_COMP_ID_EX_RS1_MEM_WB_RD : component COMPARATOR_EQ
		generic map(
			N => 5
		)
		port map(
			COMPARATOR_EQ_IN0 => FU_IN_ID_EX_RS1,
			COMPARATOR_EQ_IN1 => FU_IN_MEM_WB_RD,
			COMPARATOR_EQ_OUT => ID_EX_RS1_EQUALTO_MEM_WB_RD
		);

	i_COMP_ID_EX_RS2_EX_MEM_RD : component COMPARATOR_EQ
		generic map(
			N => 5
		)
		port map(
			COMPARATOR_EQ_IN0 => FU_IN_ID_EX_RS2,
			COMPARATOR_EQ_IN1 => FU_IN_EX_MEM_RD,
			COMPARATOR_EQ_OUT => ID_EX_RS2_EQUALTO_EX_MEM_RD
		);

	i_COMP_ID_EX_RS2_MEM_WB_RD : component COMPARATOR_EQ
		generic map(
			N => 5
		)
		port map(
			COMPARATOR_EQ_IN0 => FU_IN_ID_EX_RS2,
			COMPARATOR_EQ_IN1 => FU_IN_MEM_WB_RD,
			COMPARATOR_EQ_OUT => ID_EX_RS2_EQUALTO_MEM_WB_RD
		);

	i_isZERO_EX_MEM_RD : component COMPARATOR_EQ
		generic map(
			N => 5
		)
		port map(
			COMPARATOR_EQ_IN0 => FU_IN_EX_MEM_RD,
			COMPARATOR_EQ_IN1 => std_logic_vector(to_unsigned(0, 5)),
			COMPARATOR_EQ_OUT => isZERO_EX_MEM_RD
		);

	i_isZERO_MEM_WB_RD : component COMPARATOR_EQ
		generic map(
			N => 5
		)
		port map(
			COMPARATOR_EQ_IN0 => FU_IN_MEM_WB_RD,
			COMPARATOR_EQ_IN1 => std_logic_vector(to_unsigned(0, 5)),
			COMPARATOR_EQ_OUT => isZERO_MEM_WB_RD
		);

	FORWARDA_gen : process(FU_IN_EX_MEM_REGWRITE, isZERO_EX_MEM_RD, ID_EX_RS1_EQUALTO_EX_MEM_RD, ID_EX_RS1_EQUALTO_MEM_WB_RD, FU_IN_MEM_WB_REGWRITE, isZERO_MEM_WB_RD, FU_IN_MEM_WB_JUMP)
	begin
		if (FU_IN_EX_MEM_REGWRITE and not (isZERO_EX_MEM_RD) and ID_EX_RS1_EQUALTO_EX_MEM_RD) = '1' then
			FU_OUT_FORWARD_A <= "01";
		elsif (FU_IN_MEM_WB_REGWRITE and not (isZERO_MEM_WB_RD) and ID_EX_RS1_EQUALTO_MEM_WB_RD) = '1' then
			if FU_IN_MEM_WB_JUMP = '1' then
				FU_OUT_FORWARD_A <= "11";
			else
				FU_OUT_FORWARD_A <= "10";
			end if;
		else
			FU_OUT_FORWARD_A <= "00";
		end if;
	end process;

	FORWARDB_gen : process(FU_IN_EX_MEM_REGWRITE, isZERO_EX_MEM_RD, ID_EX_RS2_EQUALTO_EX_MEM_RD, ID_EX_RS2_EQUALTO_MEM_WB_RD, FU_IN_MEM_WB_REGWRITE, isZERO_MEM_WB_RD, FU_IN_MEM_WB_JUMP)
	begin
		if (FU_IN_EX_MEM_REGWRITE and not (isZERO_EX_MEM_RD) and ID_EX_RS2_EQUALTO_EX_MEM_RD) = '1' then
			FU_OUT_FORWARD_B <= "01";
		elsif (FU_IN_MEM_WB_REGWRITE and not (isZERO_MEM_WB_RD) and ID_EX_RS2_EQUALTO_MEM_WB_RD) = '1' then
			if FU_IN_MEM_WB_JUMP = '1' then
				FU_OUT_FORWARD_B <= "11";
			else
				FU_OUT_FORWARD_B <= "10";
			end if;
		else
			FU_OUT_FORWARD_B <= "00";
		end if;
	end process;

end architecture BEHAVIORAL;
