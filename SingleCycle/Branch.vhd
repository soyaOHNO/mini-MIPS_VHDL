library IEEE;
use IEEE.std_logic_1164.all;

entity Branch is port
(
   BRANCHc	: in std_logic;
	INST26	: in std_logic;
   ZERO		: in std_logic;
	BraCtrl	: out std_logic
);
end Branch;

architecture behavior of Branch is
begin
	BraCtrl <= BRANCHc and (INST26 xor ZERO);
end behavior;

