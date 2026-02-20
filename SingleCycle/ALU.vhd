library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is port
(
   PORT_A		: in std_logic;
	PORT_B		: in std_logic;
	SLT			: in std_logic;
	Cin			: in std_logic;
	AluControl	: in std_logic_vector(3 downto 0);
	Cout			: out std_logic;
	Set			: out std_logic;
	ALU_out		: out std_logic
);
end ALU;

architecture behavior of ALU is

	signal Axor : std_logic;
	signal Bxor : std_logic;
	signal So : std_logic;
	signal Co : std_logic;

	component ADDER port
	(
		A		: in std_logic;
		B		: in std_logic;
		Cin	: in std_logic;
		S		: out std_logic;
		Cout	: out std_logic
	);
	end component;

begin

	Axor <= AluControl(3) xor PORT_A;
	Bxor <= AluControl(2) xor PORT_B;
	U_ADDER : ADDER port map(A => Axor, B => Bxor, Cin => Cin, S => So, Cout => Co);
	Cout <= Co;
	Set <= So;

	process(Axor, Bxor, So, SLT, AluControl)
	begin

		if ((AluControl(0) = '0') and (AluControl(1) = '0')) then
			ALU_out <= Axor and Bxor;
		elsif ((AluControl(0) = '1') and (AluControl(1) = '0')) then
			ALU_out <= Axor or Bxor;
		elsif ((AluControl(0) = '0') and (AluControl(1) = '1')) then
			ALU_out <= So;
		elsif ((AluControl(0) = '1') and (AluControl(1) = '1')) then
			ALU_out <= SLT;
		else
			ALU_out <= '0';
		end if;
	end process;
    
end behavior;

