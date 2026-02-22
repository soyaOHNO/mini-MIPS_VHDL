library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity HILO_Reg is port
(
	P_CLK		: in std_logic;
	A			: in std_logic_vector(31 downto 0);
	B			: in std_logic_vector(31 downto 0);
	MULT		: in std_logic;
	DIV		: in std_logic;
	HI			: in std_logic;
	LO			: in std_logic;
	MF_out	: out std_logic_vector(31 downto 0)
);
end HILO_Reg;

architecture behavior of HILO_Reg is
	signal HI_data : std_logic_vector(31 downto 0);
	signal LO_data : std_logic_vector(31 downto 0);
begin
	process(P_CLK)
	begin
		if P_CLK'event and P_CLK = '1' then
			if MULT = '1' or DIV = '1' then
					HI_data <= A;
					LO_data <= B;
			end if;
		end if;
	end process;

	MF_out <= HI_data when HI = '1' else LO_data when LO = '1' else (others => '0');

end behavior;
