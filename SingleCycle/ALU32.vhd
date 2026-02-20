library IEEE;
use IEEE.std_logic_1164.all;

entity ALU32 is port
(
	A				: in std_logic_vector(31 downto 0);
	B				: in std_logic_vector(31 downto 0);
	AluControl	: in std_logic_vector(3 downto 0);
	Result		: out std_logic_vector(31 downto 0);
	Zero			: out std_logic
);
end ALU32;

architecture structural of ALU32 is

	signal carry			: std_logic_vector(32 downto 0);
	signal set_msb			: std_logic;
	signal overflow_sig	: std_logic;
	signal b_Result		: std_logic_vector(31 downto 0);

begin

	carry(0) <= AluControl(2);

	gen_alu : for i in 0 to 31 generate
	begin

		LSB: if i = 0 generate
			U : entity work.ALU port map
			(
				PORT_A     => A(i),
				PORT_B     => B(i),
				SLT        => set_msb,
				Cin        => carry(i),
				AluControl => AluControl,
				Cout       => carry(i+1),
				Set        => open,
				ALU_out    => b_Result(i)
			);
		end generate;

		MID: if i > 0 and i < 31 generate
			U : entity work.ALU port map
			(
				PORT_A     => A(i),
				PORT_B     => B(i),
				SLT        => '0',
				Cin        => carry(i),
				AluControl => AluControl,
				Cout       => carry(i+1),
				Set        => open,
				ALU_out    => b_Result(i)
			);
		end generate;

		MSB: if i = 31 generate
			U : entity work.ALU port map
			(
				PORT_A     => A(i),
				PORT_B     => B(i),
				SLT        => '0',
				Cin        => carry(i),
				AluControl => AluControl,
				Cout       => carry(i+1),
				Set        => set_msb,
				ALU_out    => b_Result(i)
			);
		end generate;

	end generate;

	Result <= b_Result;
	Zero <= '1' when b_Result = x"00000000" else '0';

end structural;
