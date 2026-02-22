library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CALC_MUDI is port
(
	A			: in std_logic_vector(31 downto 0);
	B			: in std_logic_vector(31 downto 0);
	MULT		: in std_logic;
	DIV		: in std_logic;
	HI_out	: out std_logic_vector(31 downto 0);
	LO_out	: out std_logic_vector(31 downto 0)
);
end CALC_MUDI;

architecture behavior of CALC_MUDI is
begin
	process(A, B, MULT, DIV)
		variable temp64 : signed(63 downto 0);
	begin
		HI_out <= (others => '0');
		LO_out <= (others => '0');

		if MULT = '1' then
			temp64 := signed(A) * signed(B);
			HI_out <= std_logic_vector(temp64(63 downto 32));
			LO_out <= std_logic_vector(temp64(31 downto 0));

		elsif DIV = '1' then
			LO_out <= std_logic_vector(signed(A) / signed(B));
			HI_out <= std_logic_vector(signed(A) mod signed(B));
		end if;
	end process;
end behavior;
