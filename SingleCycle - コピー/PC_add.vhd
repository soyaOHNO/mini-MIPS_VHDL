library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity PC_add is port
(
   PC_cur  : in  std_logic_vector(31 downto 0);
	PC_next : out std_logic_vector(31 downto 0)
);
end PC_add;

architecture behavior of PC_add is
begin
    PC_next <= PC_cur + x"00000004";
end behavior;
