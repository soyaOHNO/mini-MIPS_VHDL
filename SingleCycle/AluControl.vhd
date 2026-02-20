library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity AluControl is port
(
	INST			: in std_logic_vector(5 downto 0);
	ALUop			: in std_logic_vector(1 downto 0);
	ALUcontrols	: out std_logic_vector(3 downto 0)
);
end AluControl;

architecture behavior of AluControl is
begin

	process(INST, ALUop)
	begin

		ALUcontrols(0) <= ALUop(1) and (((not INST(1)) and INST(0)) or INST(3));
		ALUcontrols(1) <= not (ALUop(1) and INST(2));
		ALUcontrols(2) <= ((not ALUop(1)) and ALUop(0)) or (ALUop(1) and INST(1));
		ALUcontrols(3) <= ALUop(1) and INST(2) and INST(1);

	end process;

end behavior;
