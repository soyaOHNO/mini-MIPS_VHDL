library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity if_id_reg is port
(
	P_CLK		: in std_logic;
   PC_if		: in std_logic_vector(31 downto 0);
	INST_if	: in std_logic_vector(31 downto 0);
   PC_id		: out std_logic_vector(31 downto 0);
	INST_id	: out std_logic_vector(31 downto 0)
);
end if_id_reg;

architecture behavior of if_id_reg is
begin
	process(P_CLK)
	begin
		if P_CLK'event and P_CLK = '1' then
			PC_id <= PC_if;
			INST_id <= INST_if;
		end if;
	end process;
end behavior;
