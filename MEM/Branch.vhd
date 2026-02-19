library IEEE;
use IEEE.std_logic_1164.all;

entity Branch is port
(
   INST		: in  std_logic_vector(31 downto 0);
   ZERO		: in  std_logic;
	BRANCH	: out std_logic
);
end Branch;

architecture behavior of Branch is
begin
	BRANCH <= ((not INST(31)) and (not INST(30)) and (not INST(29))) and (INST(28)) and (not INST(27)) and (INST(26) xor ZERO);
end behavior;

