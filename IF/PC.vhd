library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity PC is port
(
	RST		: in std_logic;
	PC_cur	: in integer;
	PC_next	: out integer;
);
end PC;

architecture behavior of PC is
begin
	process(RST, PC_cur)
	begin
		if (RST'event and RST='1')then
			PC_next <= 0;
		else
			PC_next <= PC_cur;
		end if;
	end process;
end behavior;
