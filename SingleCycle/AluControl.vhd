library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity AluControl is port
(
	OPECODE		: in std_logic_vector(5 downto 0);
	FUNCT			: in std_logic_vector(5 downto 0);
	ALUop			: in std_logic_vector(1 downto 0);
	ALUcontrols	: out std_logic_vector(3 downto 0)
);
end AluControl;

architecture behavior of AluControl is
begin

	process(ALUop, FUNCT)
	begin
		case ALUop is
			when "00" =>  -- lw, sw, addi
				ALUcontrols <= "0010";  -- ADD

			when "01" =>  -- branch
				ALUcontrols <= "0110";  -- SUB

			when "10" =>  -- R-type
				case FUNCT is
					when "100000" => ALUcontrols <= "0010"; -- add
					when "100001" => ALUcontrols <= "0010"; -- addu
					when "100010" => ALUcontrols <= "0110"; -- sub
					when "100011" => ALUcontrols <= "0110"; -- subu
					when "100100" => ALUcontrols <= "0000"; -- and
					when "100101" => ALUcontrols <= "0001"; -- or
					when "100110" => ALUcontrols <= "0011"; -- xor
					when "100111" => ALUcontrols <= "1100"; -- nor
					when "101010" => ALUcontrols <= "0111"; -- slt
					when "101011" => ALUcontrols <= "1010"; -- sltu
					when "000000" => ALUcontrols <= "1000"; -- sll
					when "000010" => ALUcontrols <= "1001"; -- srl
					when "000011" => ALUcontrols <= "1011"; -- sra
					when others   => ALUcontrols <= "0000";
				end case;

			when "11" =>  -- I-type-or
				case OPECODE is
					when "001100" => ALUcontrols <= "0000"; -- andi
					when "001001" => ALUcontrols <= "0000"; -- andiu
					when "001101" => ALUcontrols <= "0001"; -- ori
					when "001110" => ALUcontrols <= "0011"; -- xori
					when "001010" => ALUcontrols <= "0111"; -- slti
					when "001011" => ALUcontrols <= "1010"; -- sltiu
					when others	  => ALUcontrols <= "0000";
				end case;

			when others =>
				ALUcontrols <= "0000";
		end case;
	end process;

end behavior;
