library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity IFstage is port
(
	P_CLK		: in std_logic;
	RST		: in std_logic;
   PC			: in std_logic_vector(31 downto 0);
   PC_id		: out std_logic_vector(31 downto 0);
	INST_id	: out std_logic_vector(31 downto 0)
);
end IFstage;

architecture behavior of IFstage is

	component PC port
	(
		RST		: in std_logic;
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
	process(P_CLK, RST)
	begin
		if P_CLK'event and P_CLK = '1' then
			PC_id <= PC_if;
			INST_id <= INST_if;
		end if;
	end process;
end behavior;
