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
	0 => x"2008FFFF",   -- addi $t0, $zero, -1      # 0xFFFFFFFF
	1 => x"20090001",   -- addi $t1, $zero, 1
	2 => x"0109502A",   -- slt  $t2, $t0, $t1      # signed  → 1
	3 => x"0109582B",   -- sltu $t3, $t0, $t1      # unsigned→ 0
	4 => x"2008AAAA",   -- addi $t0, $zero, 0xAAAA
	5 => x"3909FFFF",   -- xori $t1, $t0, 0xFFFF   # → 0x00005555
	6 => x"30080005",   -- subi $t0, $zero, 5      # → 0xFFFFFFFB

	others => (others => '0')
);

begin
	INSTR <= memory(to_integer(unsigned(ADDR(9 downto 2))));
end behavior;
