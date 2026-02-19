library IEEE;
use IEEE.std_logic_1164.all;

entity PC is port
(
	RST		: in std_logic;
	P_CLK		: in std_logic;
   PC_in		: in std_logic_vector(31 downto 0);
	PC_out	: out std_logic_vector(31 downto 0)
);
end PC;

architecture behavior of PC is
begin
	process(P_CLK, RST, PC_in)
	begin
		if (RST'event and RST = '1')then
			PC_out <= 0;
		end if;
		
		if (P_CLK'event and P_CLK = '1')then
			PC_out <= PC_in;
		end if;
	end process;
end behavior;
