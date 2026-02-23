library IEEE;
use IEEE.std_logic_1164.all;

entity ControlUnit is port
(
	OPECODE		: in std_logic_vector(5 downto 0);
	FUNCT			: in std_logic_vector(5 downto 0);
	RegDst		: out std_logic_vector(1 downto 0);
	RegWrite		: out std_logic;
	ALUop			: out std_logic_vector(1 downto 0);
	AluSrc		: out std_logic;
	MemWrite		: out std_logic;
	MemToReg		: out std_logic_vector(1 downto 0);
	JUMP			: out std_logic;
	BRANCH		: out std_logic;
	JR				: out std_logic;
	MULT			: out std_logic;
	DIV			: out std_logic;
	HI				: out std_logic;
	LO				: out std_logic;
	HiLoWrite	: out std_logic;
	LUI			: out std_logic;
	ImmSrc		: out std_logic;
	UnSign		: out std_logic
);
end ControlUnit;

architecture behavior of ControlUnit is
begin

	process(OPECODE, FUNCT)
	begin
		RegDst   	<= "00";
		RegWrite 	<= '0';
		ALUop    	<= "00";
		AluSrc   	<= '0';
		MemWrite 	<= '0';
		MemToReg 	<= "00";
		JUMP     	<= '0';
		BRANCH   	<= '0';
		JR				<= '0';
		MULT			<= '0';
		DIV			<= '0';
		HI				<= '0';
		LO				<= '0';
		HiLoWrite	<= '0';
		LUI			<= '0';
		ImmSrc		<= '0';
		UnSign		<= '0';

		case OPECODE is
			when "000000" =>   -- R
				case FUNCT is
					when "001000" =>   -- jr
						JR <= '1';
					when "001001" =>   -- jalr
						JR <= '1';
						RegWrite <= '1';
						MemToReg <= "10";
						RegDst <= "01";
					when "011000" =>   -- mult
						MULT <= '1';
						HiLoWrite <= '1';
					when "011001" =>   -- multu
						MULT <= '1';
						HiLoWrite <= '1';
						UnSign <= '1';
					when "011010" =>   -- div
						DIV <= '1';
						HiLoWrite <= '1';
					when "011011" =>   -- divu
						DIV <= '1';
						HiLoWrite <= '1';
						UnSign <= '1';
					when "010000" =>
						HI			<= '1';
						RegDst	<= "01";
						RegWrite	<= '1';
					when "010010" =>
						LO			<= '1';
						RegDst	<= "01";
						RegWrite	<= '1';
					when others =>
						RegDst   <= "01";
						RegWrite <= '1';
						ALUop    <= "10";
				end case;

			when "100011" =>   -- lw
				RegWrite <= '1';
				AluSrc   <= '1';
				MemToReg <= "01";

			when "101011" =>   -- sw
				AluSrc   <= '1';
				MemWrite <= '1';

			when "001111" =>   -- LUI
				RegWrite <= '1';
				LUI      <= '1';

			when "001100" =>   -- ANDI
				RegWrite <= '1';
				ALUSrc   <= '1';
				ALUop    <= "11";
				ImmSrc   <= '1';

			when "001101" =>   -- ORI
				RegWrite <= '1';
				ALUSrc   <= '1';
				ALUop    <= "11";
				ImmSrc	<= '1';

			when "001110" =>   -- XORI
				RegWrite <= '1';
				ALUSrc   <= '1';
				ALUop    <= "11";
				ImmSrc	<= '1';

			when "001010" =>   -- slti
				RegWrite <= '1';
				ALUSrc   <= '1';
				ALUop    <= "11";

			when "001011" =>   -- sltiu
				RegWrite <= '1';
				ALUSrc   <= '1';
				ALUop    <= "11";

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

