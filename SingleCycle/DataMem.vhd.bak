library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DataMem is port
(
	CLK       : in  std_logic;
	MemRead   : in  std_logic;
	MemWrite  : in  std_logic;
	Address   : in  std_logic_vector(31 downto 0);
	WriteData : in  std_logic_vector(31 downto 0);
	ReadData  : out std_logic_vector(31 downto 0)
);
end DataMem;

architecture behavior of DataMem is

	type ram_type is array (0 to 255) of std_logic_vector(31 downto 0);
	signal RAM : ram_type := (others => (others => '0'));

	signal addr_index : integer range 0 to 255;

begin

	addr_index <= to_integer(unsigned(Address(9 downto 2)));
	-- word aligned (4byte単位)
	
	process(CLK)
	begin
		if (CLK'event and CLK = '1') then
			if MemWrite = '1' then
				RAM(addr_index) <= WriteData;
			end if;
		end if;
	end process;
	
	ReadData <= RAM(addr_index) when MemRead = '1' else (others => '0');
	
end behavior;
