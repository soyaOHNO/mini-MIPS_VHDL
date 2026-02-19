library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity IFstage is port
(
	CLK	: in std_logic;
	RST	: in std_logic;
   PC_a	: in std_logic_vector(31 downto 0);
	PC_b	: in std_logic_vector(31 downto 0);
	PcSrc	: in std_logic;
   PC		: out std_logic_vector(31 downto 0);
	INST	: out std_logic_vector(31 downto 0)
);
end IFstage;

architecture behavior of IFstage is

	signal PC_mux : std_logic_vector(31 downto 0);
	signal PC_next : std_logic_vector(31 downto 0);

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

	component InstrMem port
	(
		CLK	: in std_logic;
		ADDR	: in std_logic_vector(31 downto 0);
		INST	: out std_logic_vector(31 downto 0)
	);
	end component;

begin

    U_add : PC_add port map(PC_cur => PC_cur, PC_next => PC_next);
    PC_mux <= PC_next when PcSrc = '0' else PC_b;
    U_pc : PC port map(RST => RST, PC_in => PC_mux, PC_out => PC_cur);
    U_imem : InstrMem port map(CLK => CLK, ADDR => PC_cur, INST => INST);
    PC <= PC_cur;

end behavior;
