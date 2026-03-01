library IEEE;
use IEEE.std_logic_1164.all;

entity mem_wb_reg is port
(
	CLK				: in std_logic;
	MemToReg_mem	: in std_logic_vector(1 downto 0);
	BraCtrl_mem		: in std_logic;
	ReadData_mem	: in std_logic_vector(31 downto 0);
	ALU_out_mem		: in std_logic_vector(31 downto 0);
	RD_addr_mem		: in std_logic_vector(4 downto 0);
	RegWrite_mem	: in std_logic;
	MemToReg_wb		: out std_logic_vector(1 downto 0);
	BraCtrl_wb		: out std_logic;
	ReadData_wb		: out std_logic_vector(31 downto 0);
	ALU_out_wb		: out std_logic_vector(31 downto 0);
	RD_addr_wb		: out std_logic_vector(4 downto 0);
	RegWrite_wb		: in std_logic
);
end mem_wb_reg;

architecture behavior of mem_wb_reg is
begin
	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			MemToReg_wb	<= MemToReg_mem;
			BraCtrl_wb	<= BraCtrl_mem;
			ReadData_wb	<= ReadData_mem;
			ALU_out_wb	<= ALU_out_mem;
			RD_addr_wb	<= RD_addr_mem;
			RegWrite_wb	<= RegWrite_mem;
		end if;
	end process;
end behavior;
