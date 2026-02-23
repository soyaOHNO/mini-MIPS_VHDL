library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU32 is port
(
	A				: in std_logic_vector(31 downto 0);
	B				: in std_logic_vector(31 downto 0);
	AluControl	: in std_logic_vector(4 downto 0);
	shamt			: in std_logic_vector(4 downto 0);
	Result		: out std_logic_vector(31 downto 0);
	Zero			: out std_logic;
	Overflow		: out std_logic
);
end ALU32;

architecture structural of ALU32 is

	signal carry			: std_logic_vector(32 downto 0);
	signal set_msb			: std_logic;
	signal b_Result		: std_logic_vector(31 downto 0);
	signal shift_result	: std_logic_vector(31 downto 0);
	signal sra_result		: std_logic_vector(31 downto 0);
	signal xor_result		: std_logic_vector(31 downto 0);
	signal sltu_result	: std_logic_vector(31 downto 0);
	signal final_result	: std_logic_vector(31 downto 0);

begin

	shift_result <= std_logic_vector(shift_left(unsigned(B), to_integer(unsigned(shamt)))) when AluControl = "01000" 
					else std_logic_vector(shift_right(unsigned(B), to_integer(unsigned(shamt)))) when AluControl = "01001" 
					else (others => '0');
	sra_result <= std_logic_vector(shift_right(signed(B), to_integer(unsigned(shamt))));
	xor_result <= A xor B;
	sltu_result <= x"00000001" when unsigned(A) < unsigned(B) else x"00000000";

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
				AluControl => AluControl(3 downto 0),
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
				AluControl => AluControl(3 downto 0),
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
				AluControl => AluControl(3 downto 0),
				Cout       => carry(i+1),
				Set        => set_msb,
				ALU_out    => b_Result(i)
			);
		end generate;

	end generate;

	with AluControl select final_result <= shift_result when "01000", 
														shift_result when "01001",
														sra_result when "01011",
														xor_result when "00011",
														sltu_result when "11010",
														b_Result when others;
	Result <= final_result;
	Zero <= '1' when final_Result = x"00000000" else '0';
	Overflow <= (carry(31) xor carry(32)) and (not AluControl(4));

end structural;
