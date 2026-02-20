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
	0 => x"20080000",	--addi $t0, $zero, 0
	1 => x"20090001",	--addi $t1, $zero, 1
	2 => x"200A000B",	--addi $t2, $zero, 11 <- loop
	3 => x"01094020",	--add  $t0, $t0, $t1
	4 => x"21290001",	--addi $t1, $t1, 1
	5 => x"112A0001",	--beq  $t1, $t2, end
	6 => x"08000003",	--j    loop
	7 => x"08000007",	--j end <- end
	others => (others => '0')
);

begin
	process(CLK, P_CLK)
	begin
		if rising_edge(CLK) and (P_CLK = '1') then
			INSTR <= memory(to_integer(unsigned(ADDR(9 downto 2))));
		end if;
	end process;
end behavior;
