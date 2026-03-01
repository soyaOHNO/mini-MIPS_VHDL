library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity PC is port
(
	RST		: in std_logic;
   PC_in		: in  std_logic_vector(31 downto 0);
	PC_out	: out std_logic_vector(31 downto 0)
);
end PC;

architecture behavior of PC is
begin
	process(RST, PC_in)
	begin
		if (RST'event and RST='1')then
			PC_out <= 0;
		else
			PC_out <= PC_in;
		end if;
	end process;
end behavior;
