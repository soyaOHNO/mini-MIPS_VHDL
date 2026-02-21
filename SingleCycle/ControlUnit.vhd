library IEEE;
use IEEE.std_logic_1164.all;

entity ControlUnit is port
(
	OPECODE	: in std_logic_vector(5 downto 0);
	RegDst	: out std_logic_vector(1 downto 0);
	RegWrite	: out std_logic;
	ALUop		: out std_logic_vector(1 downto 0);
	AluSrc	: out std_logic;
	MemWrite	: out std_logic;
	MemToReg	: out std_logic_vector(1 downto 0);
	JUMP		: out std_logic;
	BRANCH	: out std_logic
);
end ControlUnit;

architecture behavior of ControlUnit is
begin

	process(OPECODE)
	begin
		RegDst   <= "00";
		RegWrite <= '0';
		ALUop    <= "00";
		AluSrc   <= '0';
		MemWrite <= '0';
		MemToReg <= "00";
		JUMP     <= '0';
		BRANCH   <= '0';

		case OPECODE is
			when "000000" =>   -- R
				RegDst   <= "01";
				RegWrite <= '1';
				ALUop    <= "10";

			when "100011" =>   -- lw
				RegWrite <= '1';
				AluSrc   <= '1';
				MemToReg <= "01";

			when "101011" =>   -- sw
				AluSrc   <= '1';
				MemWrite <= '1';

			when "000100" =>   -- beq
				BRANCH   <= '1';
				ALUop    <= "01";

			when "000101" =>   -- bne
				BRANCH   <= '1';
				ALUop    <= "01";

			when "001000" =>   -- addi
				RegWrite <= '1';
				AluSrc   <= '1';
				ALUop    <= "00";

			when "000010" =>   -- j
				JUMP <= '1';

			when "000011" =>   -- jal
				JUMP     <= '1';
				RegWrite <= '1';
				RegDst   <= "10";
				MemToReg <= "10";

			when others =>
				null;
		end case;
	end process;
end behavior;

