library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity ControlUnit is port
(
	INST		: in std_logic_vector(31 downto 0);
	RegDst	: out std_logic;
	RegWrite	: out std_logic;
	ALUop0	: out std_logic;
	ALUop1	: out std_logic;
	MemWrite	: out std_logic;
	MemToReg	: out std_logic
);
end ControlUnit;

architecture behavior of ControlUnit is
begin

	process(INST)
	variable R	: std_logic;
	variable lw	: std_logic;
	variable sw	: std_logic;
	variable j	: std_logic;
	begin

		R  := (not INST(31)) and (not INST(30)) and (not INST(29)) and (not INST(28)) and (not INST(27)) and (not INST(26));
		lw := (INST(31))     and (not INST(30)) and (not INST(29)) and (not INST(28)) and (INST(27))     and (INST(26));
		sw := (INST(31))     and (not INST(30)) and (INST(29))     and (not INST(28)) and (INST(27))     and (INST(26));
		j  := (not INST(31)) and (not INST(30)) and (not INST(29)) and (INST(28))     and (not INST(27));

		RegDst   <= R;
		RegWrite <= R or lw;
		ALUop0   <= j;
		ALUop1   <= R;
		MemWrite <= sw;
		MemToReg <= lw;

	end process;

end behavior;
