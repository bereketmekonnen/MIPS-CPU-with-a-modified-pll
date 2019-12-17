library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
	
entity Complete_MIPS is
port(CLOCK_50: in std_logic;
	 SW : IN STD_LOGIC_VECTOR(9 downto 0);
	 KEY : IN STD_LOGIC_VECTOR(3 downto 0); 
	 LEDR : OUT STD_LOGIC_VECTOR(9 downto 0);    
	 HEX0 : OUT STD_LOGIC_VECTOR(0 to 6);      
	 HEX1 : OUT STD_LOGIC_VECTOR(0 to 6);     
	 HEX2 : OUT STD_LOGIC_VECTOR(0 to 6);        
	 HEX3 : OUT STD_LOGIC_VECTOR(0 to 6);       
	 HEX4 : OUT STD_LOGIC_VECTOR(0 to 6);         
	 HEX5 : OUT STD_LOGIC_VECTOR(0 to 6);
	 A_Out, D_Out: out unsigned(31 downto 0));
end Complete_MIPS;
	
architecture model of Complete_MIPS is 
component MIPS is
port(CLK, RST: in std_logic;
	 Mem_Bus_in: in unsigned(31 downto 0);
     CS, WE: out std_logic;
	 LEDstate: out std_logic_vector(4 downto 0);
     ADDR: out unsigned(31 downto 0);
	 --Mem_Bus: inout unsigned(31 downto 0));
     Mem_Bus_out: out unsigned(31 downto 0));
end component;
component Memory is
port(CS, WE, Clk: in std_logic;
	 ADDR: in unsigned(31 downto 0);
	 --Mem_Bus: inout unsigned(31 downto 0));
     Mem_Bus_in: in unsigned(31 downto 0);
     Mem_Bus_out: out unsigned(31 downto 0));
end component;   
--------------------------- 34.6MHz PLL
component fastest_pll_0002 is
port (
	refclk   : in  std_logic := '0'; --  refclk.clk
	rst      : in  std_logic := '0'; --   reset.reset
	outclk_0 : out std_logic        -- outclk0.clk
);
end component;	 
-------------------------- Multiplexer 	
component MUX IS
port(CLK_1: in std_logic;
     KEY: in std_logic;
     SW: in std_logic;
     CLK: out std_logic);
end component;
-------------------------- HEX to Seven Segment Display
component hexToSevenSegment is
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
end component;
-------------------------- Signals  
signal CLK_1, CLK, RST: std_logic;
signal CS, WE: std_logic;
signal ADDR, Mem_Bus_in, Mem_Bus_out: unsigned(31 downto 0);
attribute keep: boolean;
attribute keep of CLK_1, CLK, RST, ADDR, Mem_Bus_in, Mem_Bus_out: signal is true;
--signal Mem_Bus: unsigned(31 downto 0));
begin
	PLL1: fastest_pll_0002 port map (CLOCK_50, '0', CLK_1);
	--PLL1: pll_0002 port map (CLOCK_50, '0', CLK_1);
	MUX1: MUX port map (CLK_1, KEY(0), SW(0), CLK);
	CPU: MIPS port map (CLK, RST, Mem_Bus_in, CS, WE, LEDR(4 downto 0), ADDR, Mem_Bus_out);
	MEM: Memory port map (CS, WE, CLK, ADDR, Mem_Bus_out, Mem_Bus_in);
	H2S: hexToSevenSegment port map (SW(9), SW(2 downto 1), ADDR, Mem_Bus_in, Mem_Bus_out, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	RST <= not KEY(1);
	A_Out <= ADDR;
	D_Out <= Mem_Bus_in; 
end model;