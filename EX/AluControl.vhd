library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity AluControl is port
(
	OPECODE		: in std_logic_vector(5 downto 0);
	FUNCT			: in std_logic_vector(5 downto 0);
	ALUop			: in std_logic_vector(1 downto 0);
	ALUcontrols	: out std_logic_vector(4 downto 0)
);
end AluControl;

architecture behavior of AluControl is
begin

	process(ALUop, FUNCT)
	begin
		case ALUop is
			when "00" =>  -- lw, sw, addi
				ALUcontrols <= "00010";  -- ADD

			when "01" =>  -- branch
				ALUcontrols <= "00110";  -- SUB

			when "10" =>  -- R-type
				case FUNCT is
					when "100000" => ALUcontrols <= "00010"; -- add
					when "100001" => ALUcontrols <= "10010"; -- addu
					when "100010" => ALUcontrols <= "00110"; -- sub
					when "100011" => ALUcontrols <= "10110"; -- subu
					when "100100" => ALUcontrols <= "00000"; -- and
					when "100101" => ALUcontrols <= "00001"; -- or
					when "100110" => ALUcontrols <= "00011"; -- xor
					when "100111" => ALUcontrols <= "01100"; -- nor
					when "101010" => ALUcontrols <= "00111"; -- slt
					when "101011" => ALUcontrols <= "11010"; -- sltu
					when "000000" => ALUcontrols <= "01010"; -- sll
					when "000100" => ALUcontrols <= "01110"; -- sllv
					when "000010" => ALUcontrols <= "01001"; -- srl
					when "000110" => ALUcontrols <= "01101"; -- srlv
					when "000011" => ALUcontrols <= "01011"; -- sra
					when "000111" => ALUcontrols <= "01111"; -- srav
					when others   => ALUcontrols <= "00000";
				end case;

			when "11" =>  -- I-type-or
				case OPECODE is
					when "001100" => ALUcontrols <= "00000"; -- andi
					when "001001" => ALUcontrols <= "10010"; -- addiu
					when "001101" => ALUcontrols <= "00001"; -- ori
					when "001110" => ALUcontrols <= "00011"; -- xori
					when "001010" => ALUcontrols <= "00111"; -- slti
					when "001011" => ALUcontrols <= "11010"; -- sltiu
					when others	  => ALUcontrols <= "00000";
				end case;

			when others =>
				ALUcontrols <= "00000";
		end case;
	end process;

end behavior;
