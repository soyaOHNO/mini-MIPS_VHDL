library IEEE;
use IEEE.std_logic_1164.all;

entity ID_stage is port
(
	CLK			: in std_logic;
	PC_next_in	: in std_logic;
	INST			: in std_logic_vector(31 downto 0);
	in_RegWrite	: in std_logic;
	in_Overflow	: in std_logic;
	w_addr		: in std_logic_vector(4 downto 0);
	w_data		: in std_logic_vector(31 downto 0);
	RegDst		: out std_logic_vector(1 downto 0);
	RegWrite		: out std_logic;
	ALUop			: out std_logic_vector(1 downto 0);
	AluSrc		: out std_logic;
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
	PC_next_out	: out std_logic;
	PORT_A_data	: out std_logic_vector(31 downto 0);
	PORT_B_data	: out std_logic_vector(31 downto 0);
	opecode		: out std_logic_vector(5 downto 0);
	immediate	: out std_logic_vector(31 downto 0);
	RegDst0		: out std_logic_vector(4 downto 0);
	RegDst1		: out std_logic_vector(4 downto 0);
	DebugAddr	: in std_logic_vector(4 downto 0);
	DebugData	: out std_logic_vector(31 downto 0)
);
end ID_stage;

architecture behavior of ID_stage is

	signal oRegWrite	: std_logic;
	signal ImmSrc		: std_logic;
	signal PORT_A		: std_logic_vector(31 downto 0);
	signal PORT_B		: std_logic_vector(31 downto 0);

	component ControlUnit port
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
		UnSign		: out std_logic;
		MemByte		: out std_logic
	);
	end component;

	component RegFile32 is port
	(
		CLK		: in std_logic;
		RegWrite	: in std_logic;
		w_addr	: in std_logic_vector(4 downto 0);
		w_data	: in std_logic_vector(31 downto 0);
		r_addr1	: in std_logic_vector(4 downto 0);
		r_addr2	: in std_logic_vector(4 downto 0);
		r_data1	: out std_logic_vector(31 downto 0);
		r_data2	: out std_logic_vector(31 downto 0);
		DebugAddr: in std_logic_vector(4 downto 0);
		DebugData: out std_logic_vector(31 downto 0)
	);
	end component;

begin

	U_ControlUnit	: ControlUnit port map(	OPECODE => INST(31 downto 26),
														FUNCT => INST(5 downto 0),
														RegDst => RegDst,
														RegWrite => RegWrite,
														ALUop => ALUop,
														AluSrc => AluSrc,
														MemWrite =>MemWrite,
														MemToReg => MemToReg,
														JUMP => JUMP,
														BRANCH => BRANCH(0),
														JR => JR,
														MULT => MULT,
														DIV => DIV,
														HI => HI,
														LO => LO,
														HiLoWrite => HiLoWrite,
														LUI => LUI,
														UnSign => UnSign,
														MemByte => MemByte);

	BRANCH(1) <= INST(26);
	oRegWrite <= '0' when in_Overflow = '1' else in_RegWrite;

	U_RegFile32		: RegFile32 port map(CLK => CLK,
													RegWrite => oRegWrite,
													w_addr => w_addr,
													w_data => w_data,
													r_addr1 => INST(25 downto 21),
													r_addr2 => INST(20 downto 16),
													r_data1 => PORT_A,
													r_data2 => PORT_B,
													DebugAddr => DebugAddr,
													DebugData => DebugData);

	PC_next_out	<= PC_next_in;
	PORT_A_data	<= PORT_A;
	PORT_B_data	<= PORT_B;
	opecode		<= INST(31 downto 26);

	with INST(31 downto 26) select ImmSrc <= '1' when "001100", '1' when "001101", '1' when "001110", '0' when others;
	process(INST, ImmSrc)
	begin
		if ImmSrc = '0' then
			immediate(15 downto 0) <= INST(15 downto 0);
			immediate(31 downto 16) <= (others => INST(15));
		elsif ImmSrc = '1' then
			immediate <= x"0000" & INST(15 downto 0);
		else
			immediate <= (others => '0');
		end if;
	end process;

	RegDst0		<= INST(20 downto 16);
	RegDst1		<= INST(15 downto 11);

end behavior;
