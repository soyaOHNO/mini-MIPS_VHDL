library IEEE;
use IEEE.std_logic_1164.all;

entity HazardDetectionUnit is port 
(
	PC					: in std_logic_vector(31 downto 0);
	SYSCALL			: in std_logic;
	Overflow			: in std_logic;
	ZeroDiv			: in std_logic;
	EPC				: out std_logic_vector(31 downto 0);
	Cause				: out std_logic_vector(3 downto 0);
	Exception_Flag	: out std_logic
);
end HazardDetectionUnit;

architecture behavior of HazardDetectionUnit is
begin
	EPC <= PC;

	process(SYSCALL, Overflow, ZeroDiv)
	begin
		Exception_Flag <= '1';
		if SYSCALL = '1' then
			Cause <= "1000";
		elsif ZeroDiv = '1' then
			Cause <= "1110";
		elsif Overflow = '1' then
			Cause <= "1100";
		else
			Cause <= "0000";
			Exception_Flag <= '0';
		end if;
	end process;

end behavior;