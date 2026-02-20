library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity s_MIPS is port
(
	CLK	: in std_logic;
	KEY	: in std_logic_vector(3 downto 0);
	SW		: in std_logic_vector(9 downto 0);
	HEX0	: out std_logic_vector(6 downto 0);
	HEX1	: out std_logic_vector(6 downto 0);
	HEX2	: out std_logic_vector(6 downto 0);
	HEX3	: out std_logic_vector(6 downto 0)
);
end s_MIPS;

architecture behavior of s_MIPS is

	signal P_CLK		: std_logic;
	signal key_sync1	: std_logic;
	signal key_sync2	: std_logic;
	signal rst_sync1	: std_logic;
	signal rst_sync2	: std_logic;
	signal RST			: std_logic;
	signal PC_in		: std_logic_vector(31 downto 0);
	signal PC_cur		: std_logic_vector(31 downto 0);
	signal PC_next		: std_logic_vector(31 downto 0);
	signal INST			: std_logic_vector(31 downto 0);
	signal RegDst		: std_logic;
	signal RegWrite	: std_logic;
	signal ALUop		: std_logic_vector(1 downto 0);
	signal AluSrc		: std_logic;
	signal MemWrite	: std_logic;
	signal MemToReg	: std_logic;
	signal JUMP			: std_logic;
	signal BRANCHc		: std_logic;
	signal PORT_A		: std_logic_vector(31 downto 0);
	signal PORT_B		: std_logic_vector(31 downto 0);
	signal w_addr		: std_logic_vector(4 downto 0);
	signal w_data		: std_logic_vector(31 downto 0);
	signal ALUcontrols: std_logic_vector(3 downto 0);
	signal EXPaddr		: std_logic_vector(31 downto 0);
	signal ALU_B		: std_logic_vector(31 downto 0);
	signal Result		: std_logic_vector(31 downto 0);
	signal Zero			: std_logic;
	signal BraCtrl		: std_logic;
	signal ReadData	: std_logic_vector(31 downto 0);
	signal SHIFTaddr	: std_logic_vector(31 downto 0);
	signal PC_branch	: std_logic_vector(31 downto 0);
	signal PC_jump		: std_logic_vector(31 downto 0);
	signal PC_jb		: std_logic_vector(31 downto 0);
	signal DebugAddr	: std_logic_vector(4 downto 0);
	signal DebugData	: std_logic_vector(31 downto 0);
	signal Print		: std_logic_vector(15 downto 0);

	component PC port
	(
		CLK		: in std_logic;
		RST		: in std_logic;
		P_CLK		: in std_logic;
		PC_in		: in std_logic_vector(31 downto 0);
		PC_out	: out std_logic_vector(31 downto 0)
	);
	end component;

	component PC_add port
	(
		PC_cur  : in  std_logic_vector(31 downto 0);
		PC_next : out std_logic_vector(31 downto 0)
	);
	end component;

	component INST_mem port
	(
		CLK	: in std_logic;
		P_CLK	: in std_logic;
		ADDR	: in std_logic_vector(31 downto 0);
		INSTR	: out std_logic_vector(31 downto 0)
	);
	end component;

	component ControlUnit port
	(
		OPECODE	: in std_logic_vector(5 downto 0);
		RegDst	: out std_logic;
		RegWrite	: out std_logic;
		ALUop		: out std_logic_vector(1 downto 0);
		AluSrc	: out std_logic;
		MemWrite	: out std_logic;
		MemToReg	: out std_logic;
		JUMP		: out std_logic;
		BRANCH	: out std_logic
	);
	end component;

	component RegFile32 is port
	(
		CLK		: in std_logic;
		P_CLK		: in std_logic;
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

	component AluControl port
	(
		INST			: in std_logic_vector(5 downto 0);
		ALUop			: in std_logic_vector(1 downto 0);
		ALUcontrols	: out std_logic_vector(3 downto 0)
	);
	end component;

	component ALU32 port
	(
		A				: in std_logic_vector(31 downto 0);
		B				: in std_logic_vector(31 downto 0);
		AluControl	: in std_logic_vector(3 downto 0);
		Result		: out std_logic_vector(31 downto 0);
		Zero			: out std_logic
	);
	end component;

	component Branch port
	(
		BRANCHc	: in std_logic;
		INST26	: in std_logic;
		ZERO		: in std_logic;
		BraCtrl	: out std_logic
	);
	end component;

	component DataMem port
	(
		P_CLK     : in  std_logic;
		MemWrite  : in  std_logic;
		Address   : in  std_logic_vector(31 downto 0);
		WriteData : in  std_logic_vector(31 downto 0);
		ReadData  : out std_logic_vector(31 downto 0)
	);
	end component;


begin

	process(CLK)
	begin
		if (CLK'event and CLK = '1') then
			key_sync1 <= KEY(0);
			key_sync2 <= key_sync1;
		end if;
	end process;
	P_CLK <= key_sync1 and not key_sync2;

	process(CLK)
	begin
		if rising_edge(CLK) then
			rst_sync1 <= KEY(1);
			rst_sync2 <= rst_sync1;
		end if;
	end process;
	RST <= rst_sync2;

	U_PC				: PC port map(CLK => CLK, RST => RST, P_CLK => P_CLK, PC_in => PC_in, PC_out => PC_cur);
	U_PC_add			: PC_add port map(PC_cur => PC_cur, PC_next => PC_next);
	U_INST_mem		: INST_mem port map(CLK => CLK, P_CLK => P_CLK, ADDR => PC_cur, INSTR => INST);
	U_ControlUnit	: ControlUnit port map(OPECODE => INST(31 downto 26), RegDst => RegDst, RegWrite => RegWrite, ALUop => ALUop, AluSrc => AluSrc, MemWrite =>MemWrite, MemToReg => MemToReg, JUMP => JUMP, BRANCH => BRANCHc);
	w_addr <= INST(20 downto 16) when RegDst = '0' else INST(15 downto 11);
	U_RegFile32		: RegFile32 port map(CLK => CLK, P_CLK => P_CLK, RegWrite => RegWrite, w_addr => w_addr, w_data => w_data, r_addr1 => INST(25 downto 21), r_addr2 => INST(20 downto 16), r_data1 => PORT_A, r_data2 => PORT_B, DebugAddr => DebugAddr, DebugData => DebugData);
	U_AluControl	: AluControl port map(INST => INST(5 downto 0), ALUop => ALUop, ALUcontrols => ALUcontrols);
	EXPaddr(15 downto 0) <= INST(15 downto 0);
	EXPaddr(31 downto 16) <= (others => INST(15));
	ALU_B <= PORT_B when AluSrc = '0' else EXPaddr;
	U_ALU32			: ALU32 port map(A => PORT_A, B => ALU_B, AluControl => AluControls, Result => Result, Zero => Zero);
	U_Branch			: Branch port map(BRANCHc => BRANCHc, INST26 => INST(26), ZERO => ZERO, BraCtrl => BraCtrl);
	U_DataMem		: DataMem port map(P_CLK => P_CLK, MemWrite => MemWrite, Address => Result, WriteData => PORT_B, ReadData => ReadData);
	w_data <= Result when MemToReg = '0' else ReadData;
	SHIFTaddr <= EXPaddr(29 downto 0) & "00";
	PC_branch <= PC_next + SHIFTaddr;
	PC_jb <= PC_next when BraCtrl = '0' else PC_branch;
	PC_jump <= PC_next(31 downto 28) & INST(25 downto 0) & "00";
	PC_in <= PC_jb when JUMP = '0' else PC_jump;

	DebugAddr <= SW(4 downto 0);
	Print <= DebugData(15 downto 0) when SW(5) = '0' else DebugData(31 downto 16);
	U_DebugPrint : entity work.DebugPrint port map(Print => Print, HEX0  => HEX0, HEX1  => HEX1, HEX2  => HEX2,HEX3  => HEX3);

end behavior;
