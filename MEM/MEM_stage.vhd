library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity MEM_stage is port
(
	CLK			: in std_logic;
	PC_next_in	: in std_logic_vector(31 downto 0);
	RegWrite		: in std_logic;
	MemWrite		: in std_logic;
	MemToReg		: in std_logic_vector(1 downto 0);
	JUMP			: in std_logic;
	BRANCH		: in std_logic_vector(1 downto 0);
	JR				: in std_logic;
	MULT			: in std_logic;
	DIV			: in std_logic;
	HI				: in std_logic;
	LO				: in std_logic;
	HiLoWrite	: in std_logic;
	LUI			: in std_logic;
	UnSign		: in std_logic;
	MemByte		: in std_logic;
	Zero			: in std_logic;
	ALU_of		: in std_logic;
	ALU_out		: in std_logic_vector(31 downto 0);
	PORT_B		: in std_logic_vector(31 downto 0);
	RD_addr		: in std_logic_vector(4 downto 0);
	PC_next_out	: out std_logic_vector(31 downto 0);
);
end MEM_stage;

architecture behavior of MEM_stage is

	component Branch is port
	(
		BRANCHc	: in std_logic;
		INST26	: in std_logic;
		ZERO		: in std_logic;
		BraCtrl	: out std_logic
	);
	end component;

	component DataMem is port
	(
		CLK			: in std_logic;
		MemWrite  	: in std_logic;
		Address   	: in std_logic_vector(31 downto 0);
		WriteData 	: in std_logic_vector(31 downto 0);
		MemByte		: in std_logic;
		ReadData  	: out std_logic_vector(31 downto 0)
	);
	end component;


begin

	U_Branch			: Branch port map(BRANCHc => BRANCH(0),
												INST26 => BRANCH(1),
												ZERO => ZERO,
												BraCtrl => BraCtrl);
	
	U_DataMem		: DataMem port map(	CLK => P_CLK,
													MemWrite => MemWrite,
													Address => Result,
													WriteData => PORT_B,
													MemByte => MemByte,
													ReadData => ReadData);


end behavior;
