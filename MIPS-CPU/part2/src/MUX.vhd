library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity MUX is
port(CLK_1: in std_logic; -- 1 MHz Clock
	 KEY: in std_logic;
	 SW: in std_logic;
	 CLK: out std_logic);
end entity MUX;	 

architecture behavioral of MUX is
begin  	
	 CLK <= not KEY when SW = '0' else CLK_1;
end behavioral;