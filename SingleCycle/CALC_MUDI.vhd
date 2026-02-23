library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CALC_MUDI is port
(
	A			: in std_logic_vector(31 downto 0);
	B			: in std_logic_vector(31 downto 0);
	MULT		: in std_logic;
	DIV		: in std_logic;
	UnSign	: in std_logic;
	HI_out	: out std_logic_vector(31 downto 0);
	LO_out	: out std_logic_vector(31 downto 0);
	Overflow	: out std_logic;
	ZeroDiv	: out std_logic
);
end CALC_MUDI;

architecture behavior of CALC_MUDI is
begin
	process(A, B, MULT, DIV, UnSign)
		variable temp64  : signed(63 downto 0);
		variable utemp64 : unsigned(63 downto 0);
	begin
		Overflow <= '0';
		ZeroDiv <= '0';
		HI_out <= (others => '0');
		LO_out <= (others => '0');

		if UnSign = '0' then
			if MULT = '1' then
				temp64 := signed(A) * signed(B);
				HI_out <= std_logic_vector(temp64(63 downto 32));
				LO_out <= std_logic_vector(temp64(31 downto 0));

			elsif DIV = '1' then
				if signed(B) /= 0 then -- ゼロ除算対策
					LO_out <= std_logic_vector(signed(A) / signed(B));
					HI_out <= std_logic_vector(signed(A) mod signed(B));
				else
					ZeroDiv <= '1';
				end if;
				if (A = x"80000000" and B = x"FFFFFFFF") then
					Overflow <= '1';
				end if;
			end if;
			
		elsif UnSign = '1' then
			if MULT = '1' then
				utemp64 := unsigned(A) * unsigned(B);
				HI_out <= std_logic_vector(utemp64(63 downto 32));
				LO_out <= std_logic_vector(utemp64(31 downto 0));

			elsif DIV = '1' then
				if unsigned(B) /= 0 then -- ゼロ除算対策
					LO_out <= std_logic_vector(unsigned(A) / unsigned(B));
					HI_out <= std_logic_vector(unsigned(A) mod unsigned(B));
				else
					ZeroDiv <= '1';
				end if;
			end if;
		else
			LO_out <= (others => '0');
			HI_out <= (others => '0');
		end if;
	end process;
end behavior;
