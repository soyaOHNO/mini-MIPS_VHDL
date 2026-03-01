library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity id_ex_reg is port
(
	CLK			: in std_logic;
	RegDst_id	: in std_logic_vector(1 downto 0);
	RegWrite_id	: in std_logic;
	ALUop_id		: in std_logic_vector(1 downto 0);
	AluSrc_id	: in std_logic;
	MemWrite_id	: in std_logic;
	MemToReg_id	: in std_logic_vector(1 downto 0);
	JUMP_id		: in std_logic;
	BRANCH_id	: in std_logic_vector(1 downto 0);
	JR_id			: in std_logic;
	MULT_id		: in std_logic;
	DIV_id		: in std_logic;
	HI_id			: in std_logic;
	LO_id			: in std_logic;
	HiLoWrite_id: in std_logic;
	LUI_id		: in std_logic;
	ImmSrc_id	: in std_logic;
	UnSign_id	: in std_logic;
	MemByte_id	: in std_logic;
	PC_next_id	: in std_logic;
	PORT_A_id	: in std_logic_vector(31 downto 0);
	PORT_B_id	: in std_logic_vector(31 downto 0);
	opecode_id	: in std_logic_vector(5 downto 0);
	immediate_id: in std_logic_vector(31 downto 0);
	RegDst0_id	: in std_logic_vector(4 downto 0);
	RegDst1_id	: in std_logic_vector(4 downto 0);
	RegDst_ex	: out std_logic_vector(1 downto 0);
	RegWrite_ex	: out std_logic;
	ALUop_ex		: out std_logic_vector(1 downto 0);
	AluSrc_ex	: out std_logic;
	MemWrite_ex	: out std_logic;
	MemToReg_ex	: out std_logic_vector(1 downto 0);
	JUMP_ex		: out std_logic;
	BRANCH_ex	: out std_logic_vector(1 downto 0);
	JR_ex			: out std_logic;
	MULT_ex		: out std_logic;
	DIV_ex		: out std_logic;
	HI_ex			: out std_logic;
	LO_ex			: out std_logic;
	HiLoWrite_ex: out std_logic;
	LUI_ex		: out std_logic;
	ImmSrc_ex	: out std_logic;
	UnSign_ex	: out std_logic;
	MemByte_ex	: out std_logic;
	PC_next_ex	: out std_logic;
	PORT_A_ex	: out std_logic_vector(31 downto 0);
	PORT_B_ex	: out std_logic_vector(31 downto 0);
	opecode_ex	: out std_logic_vector(5 downto 0);
	immediate_ex: out std_logic_vector(31 downto 0);
	RegDst0_ex	: out std_logic_vector(4 downto 0);
	RegDst1_ex	: out std_logic_vector(4 downto 0)
);
end id_ex_reg;

architecture behavior of id_ex_reg is
begin
	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			RegDst_ex		<= RegDst_ex;
			RegWrite_ex		<= RegWrite_id;
			ALUop_ex			<= ALUop_id;
			AluSrc_ex		<= AluSrc_id;
			MemWrite_ex		<= MemWrite_id;
			MemToReg_ex		<= MemToReg_id;
			JUMP_ex			<= JUMP_id;
			BRANCH_ex		<= BRANCH_id;
			JR_ex				<= JR_id;
			MULT_ex			<= MULT_id;
			DIV_ex			<= DIV_id;
			HI_ex				<= HI_id;
			LO_ex				<= LO_id;
			HiLoWrite_ex	<= HiLoWrite_id;
			LUI_ex			<= LUI_id;
			ImmSrc_ex		<= ImmSrc_id;
			UnSign_ex		<= UnSign_id;
			MemByte_ex		<= MemByte_id;
			PC_next_ex		<= PC_next_id;
			PORT_A_ex		<= PORT_A_id;
			PORT_B_ex		<= PORT_B_id;
			opecode_ex		<= opecode_id;
			immediate_ex	<= immediate_id;
			RegDst0_ex		<= RegDst0_id;
			RegDst1_ex		<= RegDst1_id;
		end if;
	end process;
end behavior;
