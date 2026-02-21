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
	0 => x"20080001",   -- addi $t0,$zero,1
	1 => x"00084900",   -- sll  $t1,$t0,4
	2 => x"0C000004",   -- jal FUNC (アドレス4)
	3 => x"200A0063",   -- addi $t2,$zero,99
	4 => x"200B0007",   -- addi $t3,$zero,7
	others => (others => '0')
);

begin
	INSTR <= memory(to_integer(unsigned(ADDR(9 downto 2))));
end behavior;
