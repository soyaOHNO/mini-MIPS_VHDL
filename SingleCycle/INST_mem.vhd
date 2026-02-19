library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity INST_mem is port
(
	clk     : in  std_logic;
   addr    : in  std_logic_vector(31 downto 0);
   instr   : out std_logic_vector(31 downto 0)
);
end INST_mem;

architecture behavior of INST_mem is
type mem_type is array (0 to 255) of std_logic_vector(31 downto 0);
signal memory : mem_type := (
	0 => x"20080005",  -- 例: addi $t0, $zero, 5
	1 => x"20090003",  -- 例: addi $t1, $zero, 3
	2 => x"01095020",  -- 例: add $t2, $t0, $t1
	others => (others => '0')
);

begin
	process(clk)
	begin
		if rising_edge(clk) then
			instr <= memory(to_integer(unsigned(addr(9 downto 2))));
		end if;
	end process;
end behavior;
