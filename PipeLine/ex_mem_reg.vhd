library IEEE;
use IEEE.std_logic_1164.all;

entity ex_mem_reg is port
(
	P_CLK			: in std_logic;
	PC_id			: in std_logic_vector(31 downto 0);
	ALUret_id	: in std_logic_vector(31 downto 0);
	MEMmux_id	: in std_logic;
	REGmux_id	: in std_logic;
	RegDst_id	: in std_logic_vector(4 downto 0);
	PC_ex			: out std_logic_vector(31 downto 0);
	ALUret_ex	: out std_logic_vector(31 downto 0);
	MEMmux_ex	: out std_logic;
	REGmux_ex	: out std_logic;
	RegDst_ex	: out std_logic_vector(4 downto 0)
);
end ex_mem_reg;

architecture behavior of ex_mem_reg is
begin
	process(P_CLK)
	begin
		if P_CLK'event and P_CLK = '1' then
			PC_ex <= PC_id;
			ALUret_ex <= ALUret_id;
			MEMmux_ex <= MEMmux_id;
			REGmux_ex <= REGmux_id;
			RegDst_ex <= RegDst_id;
		
		end if;
	end process;
end behavior;
