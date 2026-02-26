library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity RegFile32 is port
(
	CLK		: in std_logic;
	RegWrite	: in std_logic;
	w_addr	: in std_logic_vector(4 downto 0);
	w_data	: in std_logic_vector(31 downto 0);
	r_addr1	: in std_logic_vector(4 downto 0);
	r_addr2	: in std_logic_vector(4 downto 0);
	r_data1	: out std_logic_vector(31 downto 0);
	r_data2	: out std_logic_vector(31 downto 0);
	DebugAddr: in std_logic_vector(4 downto 0);
	DebugData: out std_logic_vector(31 downto 0)
);
end RegFile32;

architecture behavior of RegFile32 is 
type reg_array is
	array (0 to 31) of std_logic_vector(31 downto 0);
signal regs : reg_array:= (others => (others => '0'));
begin
	process(CLK)
	begin
		if (CLK'event and CLK = '1') then
			if RegWrite = '1' then
				if w_addr /= "00000" then
					regs(to_integer(unsigned(w_addr))) <= w_data;
				end if;
			end if;
		end if;
	end process;

	r_data1 <= (others => '0') when r_addr1 = "00000" else regs(to_integer(unsigned(r_addr1)));
	r_data2 <= (others => '0') when r_addr2 = "00000" else regs(to_integer(unsigned(r_addr2)));
	DebugData <= (others => '0') when DebugAddr = "00000" else regs(to_integer(unsigned(DebugAddr)));

end behavior;
