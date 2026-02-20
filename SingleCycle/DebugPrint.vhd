library IEEE;
use IEEE.std_logic_1164.all;

entity DebugPrint is port 
( 
	Print	: in std_logic_vector(15 downto 0);
	HEX0	: out std_logic_vector(6 downto 0);
	HEX1	: out std_logic_vector(6 downto 0);
	HEX2	: out std_logic_vector(6 downto 0);
	HEX3	: out std_logic_vector(6 downto 0)
);
end DebugPrint;

architecture behavior of DebugPrint is
begin
	process(Print)
	begin
		case Print(3 downto 0) is
			when x"0" => HEX0 <= "1000000";
			when x"1" => HEX0 <= "1111001";
			when x"2" => HEX0 <= "0100100";
			when x"3" => HEX0 <= "0110000";
			when x"4" => HEX0 <= "0011001";
			when x"5" => HEX0 <= "0010010";
			when x"6" => HEX0 <= "0000010";
			when x"7" => HEX0 <= "1011000";
			when x"8" => HEX0 <= "0000000";
			when x"9" => HEX0 <= "0010000";
			when x"a" => HEX0 <= "0001000";
			when x"b" => HEX0 <= "0000011";
			when x"c" => HEX0 <= "1000110";
			when x"d" => HEX0 <= "0100001";
			when x"e" => HEX0 <= "0000110";
			when x"f" => HEX0 <= "0001110";
			when others => HEX0 <= "0111111";
		end case;
		case Print(7 downto 4) is
			when x"0" => HEX1 <= "1000000";
			when x"1" => HEX1 <= "1111001";
			when x"2" => HEX1 <= "0100100";
			when x"3" => HEX1 <= "0110000";
			when x"4" => HEX1 <= "0011001";
			when x"5" => HEX1 <= "0010010";
			when x"6" => HEX1 <= "0000010";
			when x"7" => HEX1 <= "1011000";
			when x"8" => HEX1 <= "0000000";
			when x"9" => HEX1 <= "0010000";
			when x"a" => HEX1 <= "0001000";
			when x"b" => HEX1 <= "0000011";
			when x"c" => HEX1 <= "1000110";
			when x"d" => HEX1 <= "0100001";
			when x"e" => HEX1 <= "0000110";
			when x"f" => HEX1 <= "0001110";
			when others => HEX1 <= "0111111";
		end case;
		case Print(11 downto 8) is
			when x"0" => HEX2 <= "1000000";
			when x"1" => HEX2 <= "1111001";
			when x"2" => HEX2 <= "0100100";
			when x"3" => HEX2 <= "0110000";
			when x"4" => HEX2 <= "0011001";
			when x"5" => HEX2 <= "0010010";
			when x"6" => HEX2 <= "0000010";
			when x"7" => HEX2 <= "1011000";
			when x"8" => HEX2 <= "0000000";
			when x"9" => HEX2 <= "0010000";
			when x"a" => HEX2 <= "0001000";
			when x"b" => HEX2 <= "0000011";
			when x"c" => HEX2 <= "1000110";
			when x"d" => HEX2 <= "0100001";
			when x"e" => HEX2 <= "0000110";
			when x"f" => HEX2 <= "0001110";
			when others => HEX2 <= "0111111";
		end case;
		case Print(15 downto 12) is
			when x"0" => HEX3 <= "1000000";
			when x"1" => HEX3 <= "1111001";
			when x"2" => HEX3 <= "0100100";
			when x"3" => HEX3 <= "0110000";
			when x"4" => HEX3 <= "0011001";
			when x"5" => HEX3 <= "0010010";
			when x"6" => HEX3 <= "0000010";
			when x"7" => HEX3 <= "1011000";
			when x"8" => HEX3 <= "0000000";
			when x"9" => HEX3 <= "0010000";
			when x"a" => HEX3 <= "0001000";
			when x"b" => HEX3 <= "0000011";
			when x"c" => HEX3 <= "1000110";
			when x"d" => HEX3 <= "0100001";
			when x"e" => HEX3 <= "0000110";
			when x"f" => HEX3 <= "0001110";
			when others => HEX3 <= "0111111";
		end case;
	end process;
end behavior;
