library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DataMem is port
(
	CLK			: in std_logic;
	P_CLK			: in std_logic;
	MemWrite  	: in std_logic;
	Address   	: in std_logic_vector(31 downto 0);
	WriteData 	: in std_logic_vector(31 downto 0);
	MemByte		: in std_logic;
	ReadData  	: out std_logic_vector(31 downto 0)
);
end DataMem;

architecture behavior of DataMem is

	type ram_type is array (0 to 31) of std_logic_vector(31 downto 0);
	signal RAM : ram_type := (others => (others => '0'));
	signal addr_index : integer range 0 to 31;
	
	-- 読み出し用の中間シグナル
	signal word_data : std_logic_vector(31 downto 0);
	signal byte_data : std_logic_vector(7 downto 0);

begin

	-- アドレスの上位ビットからワード単位のインデックスを計算
	addr_index <= to_integer(unsigned(Address(6 downto 2)));

	-- 【書き込みプロセス (sw / sb)】
	process(CLK)
		-- 32ビットまとめて書き込むための一時変数を用意
		variable temp_data : std_logic_vector(31 downto 0);
	begin
		if (CLK'event and CLK = '1') then
			if (P_CLK = '1') then
				if MemWrite = '1' then
					if MemByte = '1' then
						-- sbの場合：現在の32bitデータを一度読み出し、8bitだけ書き換える (Read-Modify-Write)
						temp_data := RAM(addr_index);
						
						case Address(1 downto 0) is
							when "00" => temp_data(7 downto 0)   := WriteData(7 downto 0);
							when "01" => temp_data(15 downto 8)  := WriteData(7 downto 0);
							when "10" => temp_data(23 downto 16) := WriteData(7 downto 0);
							when "11" => temp_data(31 downto 24) := WriteData(7 downto 0);
							when others => null;
						end case;
						
						-- 修正した32bitデータを丸ごとRAMに書き戻す
						RAM(addr_index) <= temp_data;
					else
						-- sw (Store Word) の場合：32ビット丸ごと書き換える
						RAM(addr_index) <= WriteData;
					end if;
				end if;
			end if;
		end if;
	end process;
	
	-- 【読み出しロジック (lw / lb)】
	-- まず32ビットのワードデータを取得
	word_data <= RAM(addr_index);
	
	-- アドレスの下位2ビットを見て、ターゲットの1バイト(8ビット)を抽出
	with Address(1 downto 0) select byte_data <=
		word_data(7 downto 0)   when "00",
		word_data(15 downto 8)  when "01",
		word_data(23 downto 16) when "10",
		word_data(31 downto 24) when others;

	-- MemByteが1なら符号拡張した32ビットを出力、0ならワードデータをそのまま出力
	ReadData <= std_logic_vector(resize(signed(byte_data), 32)) when MemByte = '1' else word_data;
	
end behavior;
