library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity MIPS is port
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
end MIPS;

architecture behavior of MIPS is

	signal P_CLK         : std_logic;
	signal key_sync1		: std_logic;
	signal key_sync2		: std_logic;
	signal counter1		: integer range 0 to 4999999 := 0;
	signal auto_pulse1	: std_logic;
	signal counter2		: integer range 0 to 50 := 0;
	signal auto_pulse2	: std_logic;
	signal clk_flag		: std_logic_vector(1 downto 0);
	signal RST           : std_logic;

	signal PC_in_F       : std_logic_vector(31 downto 0);
	signal PC_next_F     : std_logic_vector(31 downto 0);
	signal INST_F        : std_logic_vector(31 downto 0);

	signal PC_next_D     : std_logic_vector(31 downto 0);
	signal INST_D        : std_logic_vector(31 downto 0);

	signal RegDst_D      : std_logic_vector(1 downto 0);
	signal RegWrite_D    : std_logic;
	signal ALUop_D       : std_logic_vector(1 downto 0);
	signal AluSrc_D      : std_logic;
	signal MemWrite_D    : std_logic;
	signal MemToReg_D    : std_logic_vector(1 downto 0);
	signal JUMP_D        : std_logic;
	signal BRANCH_D      : std_logic_vector(1 downto 0);
	signal JR_D          : std_logic;

	signal PORT_A_D      : std_logic_vector(31 downto 0);
	signal PORT_B_D      : std_logic_vector(31 downto 0);
	signal immediate_D   : std_logic_vector(31 downto 0);
	signal RegDst0_D     : std_logic_vector(4 downto 0);
	signal RegDst1_D     : std_logic_vector(4 downto 0);

	signal RegDst_E      : std_logic_vector(1 downto 0);
	signal RegWrite_E    : std_logic;
	signal ALUop_E       : std_logic_vector(1 downto 0);
	signal AluSrc_E      : std_logic;
	signal MemWrite_E    : std_logic;
	signal MemToReg_E    : std_logic_vector(1 downto 0);
	signal JUMP_E        : std_logic;
	signal BRANCH_E      : std_logic_vector(1 downto 0);
	signal JR_E          : std_logic;

	signal PC_next_E     : std_logic_vector(31 downto 0);
	signal PORT_A_E      : std_logic_vector(31 downto 0);
	signal PORT_B_E      : std_logic_vector(31 downto 0);
	signal immediate_E   : std_logic_vector(31 downto 0);
	signal RegDst0_E     : std_logic_vector(4 downto 0);
	signal RegDst1_E     : std_logic_vector(4 downto 0);

	signal ALU_out_E     : std_logic_vector(31 downto 0);
	signal Zero_E        : std_logic;
	signal RD_addr_E     : std_logic_vector(4 downto 0);

	signal RegWrite_M    : std_logic;
	signal MemWrite_M    : std_logic;
	signal MemToReg_M    : std_logic_vector(1 downto 0);
	signal JUMP_M        : std_logic;
	signal BRANCH_M      : std_logic_vector(1 downto 0);
	signal JR_M          : std_logic;

	signal PC_next_M     : std_logic_vector(31 downto 0);
	signal ALU_out_M     : std_logic_vector(31 downto 0);
	signal PORT_B_M      : std_logic_vector(31 downto 0);
	signal RD_addr_M     : std_logic_vector(4 downto 0);

	signal ReadData_M    : std_logic_vector(31 downto 0);
	signal BraCtrl_M     : std_logic;

	signal RegWrite_W    : std_logic;
	signal MemToReg_W    : std_logic_vector(1 downto 0);
	signal ReadData_W    : std_logic_vector(31 downto 0);
	signal ALU_out_W     : std_logic_vector(31 downto 0);
	signal RD_addr_W     : std_logic_vector(4 downto 0);

	signal w_data_W      : std_logic_vector(31 downto 0);


	signal DebugAddr	: std_logic_vector(4 downto 0);
	signal DebugData	: std_logic_vector(31 downto 0);
	signal Print		: std_logic_vector(15 downto 0);
	signal Print_PC	    : std_logic_vector(15 downto 0);
	signal dummy_HEX	: std_logic_vector(6 downto 0);



	component IF_stage is port
	(
		CLK		: in std_logic;
		RST		: in std_logic;
		PC_in		: in std_logic_vector(31 downto 0);
		PC_next	: out std_logic_vector(31 downto 0);
		INST		: out std_logic_vector(31 downto 0)
	);
	end component;

	component if_id_reg is port
	(
		CLK		: in std_logic;
		PC_if		: in std_logic_vector(31 downto 0);
		INST_if	: in std_logic_vector(31 downto 0);
		PC_id		: out std_logic_vector(31 downto 0);
		INST_id	: out std_logic_vector(31 downto 0)
	);
	end component;

	component ID_stage is port
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
	RST <= not KEY(1);


	w_data_W <= ReadData_W when MemToReg_W = "01" else ALU_out_W;
	PC_in_F <= PC_next_F; 

	U_IF : IF_stage port map(
		CLK     => P_CLK,
		RST     => RST,
		PC_in   => PC_in_F,
		PC_next => PC_next_F,
		INST    => INST_F
	);

	U_if_id_reg : if_id_reg port map(
		CLK     => P_CLK,
		PC_if   => PC_next_F,
		INST_if => INST_F,
		PC_id   => PC_next_D,
		INST_id => INST_D
	);

	U_ID : ID_stage port map(
		CLK         => P_CLK,
		PC_next_in  => PC_next_D,
		INST        => INST_D,
		in_RegWrite => RegWrite_W,
		in_Overflow => '0',
		w_addr      => RD_addr_W,
		w_data      => w_data_W,
		RegDst      => RegDst_D,
		RegWrite    => RegWrite_D,
		ALUop       => ALUop_D,
		AluSrc      => AluSrc_D,
		MemWrite    => MemWrite_D,
		MemToReg    => MemToReg_D,
		JUMP        => JUMP_D,
		BRANCH      => BRANCH_D,
		JR          => JR_D,
		PORT_A_data => PORT_A_D,
		PORT_B_data => PORT_B_D,
		immediate   => immediate_D,
		RegDst0     => RegDst0_D,
		RegDst1     => RegDst1_D,
		opecode     => open,
		DebugAddr   => DebugAddr,
		DebugData   => DebugData
	);

	U_id_ex_reg : id_ex_reg port map(
		CLK          => P_CLK,
		RegDst_id    => RegDst_D,
		RegWrite_id  => RegWrite_D,
		ALUop_id     => ALUop_D,
		AluSrc_id    => AluSrc_D,
		MemWrite_id  => MemWrite_D,
		MemToReg_id  => MemToReg_D,
		JUMP_id      => JUMP_D,
		BRANCH_id    => BRANCH_D,
		JR_id        => JR_D,
		PORT_A_id    => PORT_A_D,
		PORT_B_id    => PORT_B_D,
		immediate_id => immediate_D,
		RegDst0_id   => RegDst0_D,
		RegDst1_id   => RegDst1_D,
		PC_next_id   => PC_next_D,
		RegDst_ex    => RegDst_E,
		RegWrite_ex  => RegWrite_E,
		ALUop_ex     => ALUop_E,
		AluSrc_ex    => AluSrc_E,
		MemWrite_ex  => MemWrite_E,
		MemToReg_ex  => MemToReg_E,
		JUMP_ex      => JUMP_E,
		BRANCH_ex    => BRANCH_E,
		JR_ex        => JR_E,
		PORT_A_ex    => PORT_A_E,
		PORT_B_ex    => PORT_B_E,
		immediate_ex => immediate_E,
		RegDst0_ex   => RegDst0_E,
		RegDst1_ex   => RegDst1_E,
		PC_next_ex   => PC_next_E
	);

	U_EX : EX_stage port map(
		CLK          => P_CLK,
		PC_next_in   => PC_next_E,
		RegDst       => RegDst_E,
		RegWrite_in  => RegWrite_E,
		ALUop        => ALUop_E,
		AluSrc       => AluSrc_E,
		MemWrite_in  => MemWrite_E,
		MemToReg_in  => MemToReg_E,
		JUMP_in      => JUMP_E,
		BRANCH_in    => BRANCH_E,
		JR_in        => JR_E,
		PORT_A_data  => PORT_A_E,
		PORT_B_data  => PORT_B_E,
		immediate    => immediate_E,
		RegDst0      => RegDst0_E,
		RegDst1      => RegDst1_E,
		opecode      => immediate_E(31 downto 26),
		ALU_out      => ALU_out_E,
		Zero         => Zero_E,
		RD_addr      => RD_addr_E,
		RegWrite     => RegWrite_M,
		MemWrite     => MemWrite_M,
		MemToReg     => MemToReg_M,
		JUMP         => JUMP_M,
		BRANCH       => BRANCH_M,
		JR           => JR_M,
		PORT_B       => PORT_B_M,
		PC_next_out  => PC_next_M
	);

	U_ex_mem_reg : ex_mem_reg port map(
		P_CLK          => P_CLK,
		RegWrite_ex    => RegWrite_M,
		MemWrite_ex    => MemWrite_M,
		MemToReg_ex    => MemToReg_M,
		JUMP_ex        => JUMP_M,
		BRANCH_ex      => BRANCH_M,
		JR_ex          => JR_M,
		PC_next_ex     => PC_next_M,
		Zero_ex        => Zero_E,
		ALU_out_ex     => ALU_out_E,
		PORT_B_ex      => PORT_B_M,
		RD_addr_ex     => RD_addr_E,
		RegWrite_mem   => RegWrite_M,
		MemWrite_mem   => MemWrite_M,
		MemToReg_mem   => MemToReg_M,
		JUMP_mem       => JUMP_M,
		BRANCH_mem     => BRANCH_M,
		JR_mem         => JR_M,
		PC_next_mem    => PC_next_M,
		Zero_mem       => open,
		ALU_out_mem    => ALU_out_M,
		PORT_B_mem     => PORT_B_M,
		RD_addr_mem    => RD_addr_M
	);

	U_MEM : MEM_stage port map(
		CLK          => P_CLK,
		PC_next_in   => PC_next_M,
		RegWrite_in  => RegWrite_M,
		MemWrite     => MemWrite_M,
		MemToReg_in  => MemToReg_M,
		JUMP         => JUMP_M,
		BRANCH       => BRANCH_M,
		JR           => JR_M,
		Zero         => '0',
		ALU_in       => ALU_out_M,
		PORT_B       => PORT_B_M,
		RD_addr_in   => RD_addr_M,
		ReadData     => ReadData_M,
		BraCtrl      => BraCtrl_M,
		RegWrite     => RegWrite_W,
		MemToReg     => MemToReg_W,
		ALU_out      => ALU_out_W,
		RD_addr      => RD_addr_W
	);

	U_mem_wb_reg : mem_wb_reg port map(
		CLK            => P_CLK,
		RegWrite_mem   => RegWrite_W,
		MemToReg_mem   => MemToReg_W,
		BraCtrl_mem    => BraCtrl_M,
		ReadData_mem   => ReadData_M,
		ALU_out_mem    => ALU_out_W,
		RD_addr_mem    => RD_addr_W,
		RegWrite_wb    => RegWrite_W,
		MemToReg_wb    => MemToReg_W,
		BraCtrl_wb     => open,
		ReadData_wb    => ReadData_W,
		ALU_out_wb     => ALU_out_W,
		RD_addr_wb     => RD_addr_W
	);



	DebugAddr <= SW(4 downto 0);
	Print <= DebugData(15 downto 0) when SW(5) = '0' else DebugData(31 downto 16);
	U_DebugPrint : entity work.DebugPrint port map(
		Print    => Print,
		Overflow => '0', -- ※現状はパイプラインから引いていないため '0' 固定
		ZeroDiv  => '0', -- ※同上
		HEX0     => HEX0,
		HEX1     => HEX1,
		HEX2     => HEX2,
		HEX3     => HEX3
	);

	Print_PC <= x"00" & PC_in_F(9 downto 2); 
	U_DebugPrint_PC : entity work.DebugPrint port map(
		Print    => Print_PC,
		Overflow => '0',
		ZeroDiv  => '0',
		HEX0     => HEX4,
		HEX1     => HEX5,
		HEX2     => dummy_HEX,
		HEX3     => dummy_HEX
	);

end behavior;