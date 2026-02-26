library IEEE;
use IEEE.std_logic_1164.all;

entity INST_mem is port
(
	CLK	: in std_logic;
	ADDR	: in std_logic_vector(31 downto 0);
	INSTR	: out std_logic_vector(31 downto 0)
);
end INST_mem;

architecture behavior of INST_mem is

	-- 1. 生成されたROMのコンポーネント宣言
	component INST_rom is
		port (
			address : in  std_logic_vector(9 downto 0);
			clock   : in  std_logic;
			q       : out std_logic_vector(31 downto 0)
		);
	end component;

begin

	-- 2. ROMの呼び出しと信号の接続
	U_ROM : INST_rom port map (
		address => ADDR(11 downto 2), -- 32bitアドレスから必要な8bitを抽出
		clock   => CLK,              -- 高速なシステムクロックを接続
		q       => INSTR
	);

end behavior;