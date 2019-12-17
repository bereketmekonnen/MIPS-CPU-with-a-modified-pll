library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity stateToLEDR is  
	port(state: in integer range 0 to 4;
		 LEDstate: out std_logic_vector(4 downto 0)); 
end entity stateToLEDR; 

architecture dataflow of stateToLEDR is 
function stateToLEDs(LEDon: integer range 0 to 4) return std_logic_vector is
variable ret: std_logic_vector(4 downto 0);
begin
	case LEDon is
		when 0 => ret:= "00000";
		when 1 => ret:= "00001";
		when 2 => ret:= "00010";
		when 3 => ret:= "00100";
		when 4 => ret:= "01000";
		when others => ret:= "00000";
	end case;
	return ret;
end function;
begin  
	process(state) 	 
	begin  
		LEDstate <= stateToLEDs(state);
	end process;
end architecture dataflow;