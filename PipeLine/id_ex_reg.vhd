library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity id_ex_reg is port
(
	P_CLK			: in std_logic;
	PC_id			: in std_logic_vector(31 downto 0);
	REGA_id		: in std_logic_vector(31 downto 0);
	REGB_id		: in std_logic_vector(31 downto 0);
	ALUmux_id	: in std_logic;
	MEMmux_id	: in std_logic;
	REGmux_id	: in std_logic;
	SHIFT_id		: in std_logic_vector(31 downto 0);
	RegDst1_id	: in std_logic_vector(4 downto 0);
	RegDst2_id	: in std_logic_vector(4 downto 0);
	PC_ex			: out std_logic_vector(31 downto 0);
	REGA_ex		: out std_logic_vector(31 downto 0);
	REGB_ex		: out std_logic_vector(31 downto 0);
	ALUmux_ex	: out std_logic;
	MEMmux_ex	: out std_logic;
	REGmux_ex	: out std_logic;
	SHIFT_ex		: out std_logic_vector(31 downto 0);
	RegDst1_ex	: out std_logic_vector(4 downto 0);
	RegDst2_ex	: out std_logic_vector(4 downto 0)
);
end id_ex_reg;

architecture behavior of id_ex_reg is
begin
	process(P_CLK)
	begin
		if P_CLK'event and P_CLK = '1' then
			PC_ex <= PC_id;
			REGA_ex <= REGA_id;
			REGB_ex <= REGB_id;
			ALUmux_ex <= ALUmux_id;
			MEMmux_ex <= MEMmux_id;
			REGmux_ex <= REGmux_id;
			SHIFT_ex <= SHIFT_id;
			RegDst1_ex <= RegDst1_id;
			RegDst2_ex <= RegDst2_id;
		end if;
	end process;
end behavior;
