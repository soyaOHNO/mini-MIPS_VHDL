library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity INST_mem is port
(
	CLK	: in std_logic;
	P_CLK	: in std_logic;
   ADDR	: in std_logic_vector(31 downto 0);
   INSTR : out std_logic_vector(31 downto 0)
);
end INST_mem;

architecture behavior of INST_mem is
type mem_type is array (0 to 255) of std_logic_vector(31 downto 0);
signal memory : mem_type := (
	0 => x"20080006",   -- addi $t0, $zero, 6
	1 => x"20090003",   -- addi $t1, $zero, 3
	2 => x"01090018",   -- mult $t0, $t1
	3 => x"00008012",   -- mflo $s0      # 18 が入る
	4 => x"20080014",   -- addi $t0, $zero, 20
	5 => x"0109001A",   -- div  $t0, $t1
	6 => x"00008812",   -- mflo $s1      # 6 が入る
	7 => x"00009010",   -- mfhi $s2      # 2 が入る
	others => (others => '0')
);

begin
	INSTR <= memory(to_integer(unsigned(ADDR(9 downto 2))));
end behavior;
