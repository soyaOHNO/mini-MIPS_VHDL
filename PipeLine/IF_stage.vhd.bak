library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity IF_stage is port
(
	CLK		: in std_logic;
	RST		: in std_logic;
   PC_in		: in std_logic_vector(31 downto 0);
	PC_next	: out std_logic_vector(31 downto 0);
	INST		: out std_logic_vector(31 downto 0)
);
end IF_stage;

architecture behavior of IF_stage is

	signal PC_cur	: std_logic_vector(31 downto 0);
	signal PC_next	: std_logic_vector(31 downto 0);

	component PC is port
	(
		CLK		: in std_logic;
		RST		: in std_logic;
		PC_in		: in std_logic_vector(31 downto 0);
		PC_out	: out std_logic_vector(31 downto 0)
	);
	end component;

	component PC_add is port
	(
		PC_cur  : in  std_logic_vector(31 downto 0);
		PC_next : out std_logic_vector(31 downto 0)
	);
	end component;

	component INST_mem is port
	(
		CLK	: in std_logic;
		ADDR	: in std_logic_vector(31 downto 0);
		INSTR	: out std_logic_vector(31 downto 0)
	);
	end component;

begin

	U_PC			: PC port map(CLK => CLK, RST => RST, PC_in => PC_in, PC_out => PC_cur);
	U_PC_add		: PC_add port map(PC_cur => PC_cur, PC_next => PC_next);
	U_INST_mem	: INST_mem port map(CLK => CLK, ADDR => PC_cur, INSTR => INST);

end behavior;
