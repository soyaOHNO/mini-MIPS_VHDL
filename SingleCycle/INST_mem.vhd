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
	0 => x"3C081234",   -- lui  $t0, 0x1234        # → 0x12340000
	1 => x"3C09ABCD",   -- lui  $t1, 0xABCD
	2 => x"35295678",   -- ori  $t1, $t1, 0x5678   # → 0xABCD5678
	3 => x"340AFFFF",   -- ori  $t2, $zero, 0xFFFF # → 0x0000FFFF（符号拡張されないこと確認）
	others => (others => '0')
);

begin
	INSTR <= memory(to_integer(unsigned(ADDR(9 downto 2))));
end behavior;
