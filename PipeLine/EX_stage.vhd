library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity EX_stage is port
(
	CLK			: in std_logic;
	PC_next_in	: in std_logic_vector(31 downto 0);
	RegDst		: in std_logic_vector(1 downto 0);
	RegWrite_in	: in std_logic;
	ALUop			: in std_logic_vector(1 downto 0);
	AluSrc		: in std_logic;
	MemWrite_in	: in std_logic;
	MemToReg_in	: in std_logic_vector(1 downto 0);
	JUMP_in		: in std_logic;
	BRANCH_in	: in std_logic_vector(1 downto 0);
	JR_in			: in std_logic;
	MULT_in		: in std_logic;
	DIV_in		: in std_logic;
	HI_in			: in std_logic;
	LO_in			: in std_logic;
	HiLoWrite_in: in std_logic;
	LUI_in		: in std_logic;
	UnSign_in	: in std_logic;
	MemByte_in	: in std_logic;
	PORT_A_data	: in std_logic_vector(31 downto 0);
	PORT_B_data	: in std_logic_vector(31 downto 0);
	opecode		: in std_logic_vector(5 downto 0);
	immediate	: in std_logic_vector(31 downto 0);
	RegDst0		: in std_logic_vector(4 downto 0);
	RegDst1		: in std_logic_vector(4 downto 0);
	RegWrite		: out std_logic;
	MemWrite		: out std_logic;
	MemToReg		: out std_logic_vector(1 downto 0);
	JUMP			: out std_logic;
	BRANCH		: out std_logic_vector(1 downto 0);
	JR				: out std_logic;
	MULT			: out std_logic;
	DIV			: out std_logic;
	HI				: out std_logic;
	LO				: out std_logic;
	HiLoWrite	: out std_logic;
	LUI			: out std_logic;
	UnSign		: out std_logic;
	MemByte		: out std_logic;
	PC_next_out	: out std_logic_vector(31 downto 0);
	Zero			: out std_logic;
	ALU_of		: out std_logic;
	ALU_out		: out std_logic_vector(31 downto 0);
	PORT_B		: out std_logic_vector(31 downto 0);
	RD_addr		: out std_logic_vector(4 downto 0)
);
end EX_stage;

architecture behavior of EX_stage is

	signal ALU_B			: std_logic_vector(31 downto 0);
	signal ALUcontrols	: std_logic_vector(4 downto 0);
	signal imm_shift		: std_logic_vector(31 downto 0);

	component AluControl is port
	(
		OPECODE		: in std_logic_vector(5 downto 0);
		FUNCT			: in std_logic_vector(5 downto 0);
		ALUop			: in std_logic_vector(1 downto 0);
		ALUcontrols	: out std_logic_vector(4 downto 0)
	);
	end component;

	component ALU32 is port
	(
		A				: in std_logic_vector(31 downto 0);
		B				: in std_logic_vector(31 downto 0);
		AluControl	: in std_logic_vector(4 downto 0);
		shamt			: in std_logic_vector(4 downto 0);
		Result		: out std_logic_vector(31 downto 0);
		Zero			: out std_logic;
		Overflow		: out std_logic
	);
	end component;


begin

	U_AluControl	: AluControl port map(	OPECODE => opecode,
														FUNCT => immediate(5 downto 0),
														ALUop => ALUop,
														ALUcontrols => ALUcontrols);

	ALU_B <= PORT_B_data when AluSrc = '0' else immediate;
	U_ALU32			: ALU32 port map(	A => PORT_A_data,
												B => ALU_B,
												AluControl => AluControls,
												shamt => immediate(10 downto 6),
												Result => ALU_out,
												Zero => Zero,
												Overflow => ALU_of);

	imm_shift	<= immediate(31 downto 2) & "00";
	PC_next_out	<= PC_next_in + imm_shift;
	PORT_B		<= PORT_B_data;
	with RegDst select RD_addr <= RegDst0 when "00", RegDst1 when "01", "11111" when "10", (others => '0') when others;

	RegWrite   <= RegWrite_in;
	MemWrite   <= MemWrite_in;
	MemToReg   <= MemToReg_in;
	JUMP       <= JUMP_in;
	BRANCH     <= BRANCH_in;
	JR         <= JR_in;
	MULT       <= MULT_in;
	DIV        <= DIV_in;
	HI         <= HI_in;
	LO         <= LO_in;
	HiLoWrite  <= HiLoWrite_in;
	LUI        <= LUI_in;
	UnSign     <= UnSign_in;
	MemByte    <= MemByte_in;

end behavior;
