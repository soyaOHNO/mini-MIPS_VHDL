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
	HEX3	: out std_logic_vector(6 downto 0);
	HEX4	: out std_logic_vector(6 downto 0);
	HEX5	: out std_logic_vector(6 downto 0)
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
	signal RegDst		: std_logic_vector(1 downto 0);
	signal RegWrite	: std_logic;
	signal oRegWrite	: std_logic;
	signal ALUop		: std_logic_vector(1 downto 0);
	signal AluSrc		: std_logic;
	signal MemWrite	: std_logic;
	signal MemToReg	: std_logic_vector(1 downto 0);
	signal JUMP			: std_logic;
	signal BRANCHc		: std_logic;
	signal JRc			: std_logic;
	signal PORT_A		: std_logic_vector(31 downto 0);
	signal PORT_B		: std_logic_vector(31 downto 0);
	signal w_addr		: std_logic_vector(4 downto 0);
	signal m_data		: std_logic_vector(31 downto 0);
	signal l_data		: std_logic_vector(31 downto 0);
	signal w_data		: std_logic_vector(31 downto 0);
	signal ALUcontrols: std_logic_vector(4 downto 0);
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
	signal PC_jr		: std_logic_vector(31 downto 0);
	signal MULT			: std_logic;
	signal DIV			: std_logic;
	signal HI			: std_logic;
	signal LO			: std_logic;
	signal HiLoWrite	: std_logic;
	signal ozHiLoWrite: std_logic;
	signal MF			: std_logic;
	signal HI_out		: std_logic_vector(31 downto 0);
	signal LO_out		: std_logic_vector(31 downto 0);
	signal MF_out		: std_logic_vector(31 downto 0);
	signal LUI			: std_logic;
	signal ImmSrc		: std_logic;
	signal UnSign		: std_logic;
	signal MemByte		: std_logic;
	signal MUDI_of		: std_logic;
	signal ALU_of		: std_logic;
	signal Overflow	: std_logic;
	signal ZeroDiv		: std_logic;

	signal DebugAddr	: std_logic_vector(4 downto 0);
	signal DebugData	: std_logic_vector(31 downto 0);
	signal Print		: std_logic_vector(15 downto 0);
	signal Print_PC	: std_logic_vector(15 downto 0);
	signal dummy_HEX	: std_logic_vector(6 downto 0);
	-- 自動実行用のカウンタとパルス信号
	signal counter1	: integer range 0 to 4999999 := 0;
	signal auto_pulse1: std_logic;
	signal counter2	: integer range 0 to 50 := 0;
	signal auto_pulse2: std_logic;
	signal clk_flag	: std_logic_vector(1 downto 0);

	component PC port
	(
		CLK		: in std_logic;
		RST		: in std_logic;
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
		ADDR	: in std_logic_vector(31 downto 0);
		INSTR	: out std_logic_vector(31 downto 0)
	);
	end component;

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
		ImmSrc		: out std_logic;
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

	component AluControl port
	(
		OPECODE		: in std_logic_vector(5 downto 0);
		FUNCT			: in std_logic_vector(5 downto 0);
		ALUop			: in std_logic_vector(1 downto 0);
		ALUcontrols	: out std_logic_vector(4 downto 0)
	);
	end component;

	component ALU32 port
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
		CLK		: in std_logic;
		MemWrite	: in std_logic;
		Address	: in std_logic_vector(31 downto 0);
		WriteData: in std_logic_vector(31 downto 0);
		MemByte	: in std_logic;
		ReadData	: out std_logic_vector(31 downto 0)
	);
	end component;

	component CALC_MUDI port
	(
		A			: in std_logic_vector(31 downto 0);
		B			: in std_logic_vector(31 downto 0);
		MULT		: in std_logic;
		DIV		: in std_logic;
		UnSign	: in std_logic;
		HI_out	: out std_logic_vector(31 downto 0);
		LO_out	: out std_logic_vector(31 downto 0);
		Overflow	: out std_logic;
		ZeroDiv	: out std_logic
	);
	end component;

	component HILO_Reg is port
	(
		CLK			: in std_logic;
		A				: in std_logic_vector(31 downto 0);
		B				: in std_logic_vector(31 downto 0);
		MULT			: in std_logic;
		DIV			: in std_logic;
		HI				: in std_logic;
		LO				: in std_logic;
		HiLoWrite	: in std_logic;
		MF_out		: out std_logic_vector(31 downto 0)
	);
	end component;


begin

	process(CLK)
	begin
		if rising_edge(CLK) then -- (CLK'event and CLK = '1') と同じ意味です
			-- 【手動用】ボタンのエッジ検出
			key_sync1 <= not KEY(0);
			key_sync2 <= key_sync1;
			
			-- 【自動用】5,000,000進カウンタ (50MHzクロックで0.1秒周期)
			if counter1 = 4999999 then
				counter1 <= 0;
				auto_pulse1 <= '1'; -- 1クロック分だけパルスを立てる
			else
				counter1 <= counter1 + 1;
				auto_pulse1 <= '0';
			end if;
			-- 【自動用】n進カウンタ
			if counter2 = 50 then
				counter2 <= 0;
				auto_pulse2 <= '1'; -- 1クロック分だけパルスを立てる
			else
				counter2 <= counter2 + 1;
				auto_pulse2 <= '0';
			end if;
		end if;
	end process;
	-- SW(6) が '0' の時は自動パルス、'1' の時は手動パルスを P_CLK に接続
	clk_flag <= SW(7) & SW(6);
	with clk_flag select P_CLK <= auto_pulse1 when "01", auto_pulse2 when "10", (key_sync1 and (not key_sync2)) when others;

	-- process(CLK)
	-- begin
	-- 	if CLK'event and CLK = '1' then
	-- 		rst_sync1 <= not KEY(1);
	-- 		rst_sync2 <= rst_sync1;
	-- 	end if;
	-- end process;
	RST <= not KEY(1);

	U_PC				: PC port map(CLK => P_CLK, RST => RST, PC_in => PC_in, PC_out => PC_cur);
	U_PC_add			: PC_add port map(PC_cur => PC_cur, PC_next => PC_next);
	U_INST_mem		: INST_mem port map(CLK => not P_CLK, ADDR => PC_cur, INSTR => INST);
	U_ControlUnit	: ControlUnit port map(OPECODE => INST(31 downto 26), FUNCT => INST(5 downto 0), RegDst => RegDst, RegWrite => RegWrite, ALUop => ALUop, AluSrc => AluSrc, MemWrite =>MemWrite, MemToReg => MemToReg, JUMP => JUMP, BRANCH => BRANCHc, JR => JRc, MULT => MULT, DIV => DIV, HI => HI, LO => LO, HiLoWrite => HiLoWrite, LUI => LUI, ImmSrc => ImmSrc, UnSign => UnSign, MemByte => MemByte);
	with RegDst select w_addr <= INST(20 downto 16) when "00", INST(15 downto 11) when "01", "11111" when "10", (others => '0') when others;
	oRegWrite <= '0' when Overflow = '1' else RegWrite;
	U_RegFile32		: RegFile32 port map(CLK => P_CLK, RegWrite => oRegWrite, w_addr => w_addr, w_data => w_data, r_addr1 => INST(25 downto 21), r_addr2 => INST(20 downto 16), r_data1 => PORT_A, r_data2 => PORT_B, DebugAddr => DebugAddr, DebugData => DebugData);
	U_AluControl	: AluControl port map(OPECODE => INST(31 downto 26), FUNCT => INST(5 downto 0), ALUop => ALUop, ALUcontrols => ALUcontrols);
	process(INST, ImmSrc)
	begin
		if ImmSrc = '0' then
			EXPaddr(15 downto 0) <= INST(15 downto 0);
			EXPaddr(31 downto 16) <= (others => INST(15));
		elsif ImmSrc = '1' then
			EXPaddr <= x"0000" & INST(15 downto 0);
		else
			EXPaddr <= (others => '0');
		end if;
	end process;
	ALU_B <= PORT_B when AluSrc = '0' else EXPaddr;
	U_CALC_MUDI		: CALC_MUDI port map(A => PORT_A, B => ALU_B, MULT => MULT, DIV => DIV, UnSign => UnSign, HI_out => HI_out, LO_out => LO_out, Overflow => MUDI_of, ZeroDiv => ZeroDiv);
	ozHiLoWrite <= HiLoWrite and ((not MUDI_of) or (not ZeroDiv));
	U_HILO_Reg		: HILO_Reg port map(CLK => P_CLK, A => HI_out, B => LO_out, MULT => MULT, DIV => DIV, HI => HI, LO => LO, HiLoWrite => ozHiLoWrite, MF_out => MF_out);
	U_ALU32			: ALU32 port map(A => PORT_A, B => ALU_B, AluControl => AluControls, shamt => INST(10 downto 6), Result => Result, Zero => Zero, Overflow => ALU_of);
	U_Branch			: Branch port map(BRANCHc => BRANCHc, INST26 => INST(26), ZERO => ZERO, BraCtrl => BraCtrl);
	U_DataMem		: DataMem port map(CLK => P_CLK, MemWrite => MemWrite, Address => Result, WriteData => PORT_B, MemByte => MemByte, ReadData => ReadData);
	with MemToReg select m_data <= Result when "00", ReadData when "01", PC_next when "10", (others => '0') when others;
	MF <= HI or LO;
	with MF select l_data <= m_data when '0', MF_out when '1', (others => '0') when others;
	w_data <= l_data when LUI = '0' else INST(15 downto 0) & x"0000";
	SHIFTaddr <= EXPaddr(29 downto 0) & "00";
	PC_branch <= PC_next + SHIFTaddr;
	PC_jb <= PC_next when BraCtrl = '0' else PC_branch;
	PC_jump <= PC_next(31 downto 28) & INST(25 downto 0) & "00";
	PC_jr <= PC_jb when JUMP = '0' else PC_jump;
	PC_in <= PC_jr when JRc = '0' else PORT_A;
	Overflow <= MUDI_of or ALU_of;

	DebugAddr <= SW(4 downto 0);
	Print <= DebugData(15 downto 0) when SW(5) = '0' else DebugData(31 downto 16);
	U_DebugPrint : entity work.DebugPrint port map(Print => Print, Overflow => Overflow, ZeroDiv => ZeroDiv, HEX0  => HEX0, HEX1  => HEX1, HEX2  => HEX2,HEX3  => HEX3);
	Print_PC <= x"00" & PC_cur(9 downto 2);
	U_DebugPrint_PC : entity work.DebugPrint port map(Print => Print_PC, Overflow => '0', ZeroDiv => '0', HEX0  => HEX4, HEX1  => HEX5, HEX2  => dummy_HEX, HEX3  => dummy_HEX);

end behavior;
