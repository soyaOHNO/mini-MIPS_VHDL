library IEEE;
use IEEE.std_logic_1164.all;

entity ADDER is port
(
   A		: in std_logic;
	B		: in std_logic;
	Cin	: in std_logic;
	S		: out std_logic;
	Cout	: out std_logic
);
end ADDER;

architecture behavior of ADDER is
begin

	Cout <= ((A xor B) and Cin) or (A and B);
	S <= (A xor B) xor Cin;

end behavior;

