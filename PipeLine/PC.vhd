library IEEE;
use IEEE.std_logic_1164.all;

entity PC is port
(
	CLK		: in std_logic;
	RST		: in std_logic;
   PC_in		: in std_logic_vector(31 downto 0);
	PC_out	: out std_logic_vector(31 downto 0)
);
end PC;

architecture behavior of PC is
begin
	process(CLK)
	begin
		if (CLK'event and CLK = '1') then
			if RST = '1' then
				PC_out <= x"00000000";
			else
				PC_out <= PC_in;
			end if;
		end if;
	end process;
end behavior;
