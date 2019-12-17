library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity hexToSevenSegment is
	port(sw9: in std_logic;
		 sw21: in std_logic_vector(1 downto 0);
		 ADDR: in unsigned(31 downto 0); 
		 Mem_Bus_in: in unsigned(31 downto 0);
		 Mem_Bus_out: in unsigned(31 downto 0);
		 h0: out std_logic_vector(6 downto 0);
		 h1: out std_logic_vector(6 downto 0);
		 h2: out std_logic_vector(6 downto 0);
		 h3: out std_logic_vector(6 downto 0);
		 h4: out std_logic_vector(6 downto 0);
		 h5: out std_logic_vector(6 downto 0));
end entity;

architecture dataflow of hexToSevenSegment is
function hexToSegments(hexDigit: std_logic_vector(3 downto 0)) return std_logic_vector is
variable ret: std_logic_vector(0 to 6);
begin
	case hexDigit is
		when x"0" => ret:= not "1111110";
		when x"1" => ret:= not "0110000";
		when x"2" => ret:= not "1101101";
		when x"3" => ret:= not "1111001";
		when x"4" => ret:= not "0110011";
		when x"5" => ret:= not "1011011";
		when x"6" => ret:= not "1011111";
		when x"7" => ret:= not "1110000";
		when x"8" => ret:= not "1111111";
		when x"9" => ret:= not "1111011";
		when x"a" => ret:= not "1110111";
		when x"b" => ret:= not "0011111";
		when x"c" => ret:= not "1001110";
		when x"d" => ret:= not "0111101";
		when x"e" => ret:= not "1001111";
		when x"f" => ret:= not "1000111";
		when others => ret:= "1111111";
	end case;
	return ret;
end function;
signal output: unsigned(31 downto 0);
begin  
	process(sw9, sw21, ADDR, Mem_Bus_in, Mem_Bus_out)
	begin
		case sw21 is
			when "00" =>
				output <= ADDR;
				h0 <= not "1110111";
			when "01" =>
				output <= Mem_Bus_in;
				h0 <= not "0000111";
			when "10" =>
				output <= Mem_Bus_out;	
				h0 <= not "0110001";
			when others =>
				output <= x"88888888";
				h0 <= "1111111";
		end case; 
		case sw9 is
			when '0' =>	
				h5 <= hexToSegments(std_logic_vector(output(15 downto 12)));
				h4 <= hexToSegments(std_logic_vector(output(11 downto 8)));
				h3 <= hexToSegments(std_logic_vector(output(7 downto 4)));
				h2 <= hexToSegments(std_logic_vector(output(3 downto 0)));
				h1 <= not "1111110";
			when '1' =>
				h5 <= hexToSegments(std_logic_vector(output(31 downto 28)));
				h4 <= hexToSegments(std_logic_vector(output(27 downto 24)));
				h3 <= hexToSegments(std_logic_vector(output(23 downto 20)));
				h2 <= hexToSegments(std_logic_vector(output(19 downto 16)));
				h1 <= not "0110000";
			when others =>
				h5 <= "1111111";
				h4 <= "1111111";
				h3 <= "1111111";
				h2 <= "1111111";
				h1 <= "1111111";
		end case;
	end process;
end architecture;