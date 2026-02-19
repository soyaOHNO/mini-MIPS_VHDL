library IEEE;
use IEEE.std_logic_1164.all;

entity s_MIPS is port
(
	CLK	: in std_logic;
	KEY	: in std_logic_vector(3 downto 0);
);
end s_MIPS;

architecture behavior of s_MIPS is

	signal P_CLK : std_logic;
	signal RST : std_logic;
	signal PC_in : std_logic_vector(31 downto 0);
	signal PC_cur : std_logic_vector(31 downto 0);
	signal PC_next : std_logic_vector(31 downto 0);

	component PC port
	(
		RST		: in std_logic;
		P_CLK		: in std_logic;
		PC_in		: in std_logic_vector(31 downto 0);
		PC_out	: out std_logic_vector(31 downto 0)
	);
	end component;

	component PC_add port
	(
		PC_cur  : in  std_logic_vector(31 downto 0);
		PC_next : out std_logic_vector(31 downto 0)
	);
	end component;

begin

	process(KEY)
	begin
		P_CLK <= KEY(0);
		RST <= KEY(1);
	end process;

	PC : PC port map(RST => RST, P_CLK => P_CLK, PC_in => PC_in, PC_out => PC_cur);
	PC_add : PC_add port map(PC_cur => PC_cur, PC_next => PC_next);

end behavior;
