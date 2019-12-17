library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Memory is
  port(CS, WE, Clk: in std_logic;
  	   ADDR: in unsigned(31 downto 0);
       --Mem_Bus: inout unsigned(31 downto 0);
       Mem_Bus_in: in unsigned(31 downto 0);
	   Mem_Bus_out: out unsigned(31 downto 0));	
end Memory;

architecture Internal of Memory is
  type RAMtype is array (0 to 1023) of unsigned(31 downto 0);  -- RAM increased to allow storing in 0x0200
  signal RAM1: RAMtype := (
  --- BEGINNING OF WEIGHTED AVERAGE PROGRAM 
    x"30000000", -- andi $0, $0, 0  => 0. $0 = 0  
    x"20010006", -- addi $1, $0, 6  => 1. $1 = 6
    x"34020012", -- ori $2, $0, 18  => 2. $2 = 18 
	x"00221820", -- add $3, $1, $2  => 3. $3 = $1 + $2 = 24
---	Testing multu, divu, mflo, mfhi
	--x"00220019", -- multu $1, $2 => $1 * $2 = 108
	--x"00005812", -- mflo $11     => $11 = 108
	--x"0062001B", -- divu $3, $2  => ($3 / $2 = 1) & ($3 % $2 = 6)
	--x"00006012", -- mflo $12     => $12 = 1
	--x"00006810", -- mfhi $13     => $13 = 6
    --x"00412022", -- sub $4, $2, $1  => 4. $4 = $2 - $1 = 12
    --x"00222824", -- and $5, $1, $2  => 5. $5 = $1 and $2 = 2
    --x"00223025", -- or $6, $1, $2   => 6. $6 = $1 or $2 = 22
    --x"0022382A", -- slt $7, $1, $2  => 7. $7 = 1 because $1<$2
    --x"00024100", -- sll $8, $2, 4   => 8. $8 = 18 * 16 = 288
    --x"00014842", -- srl $9, $1, 1   => 9. $9 = 6/2 = 3
    --x"10220001", -- beq $1, $2, 1   => 10. Will not branch. $10 incorrect if fails.
    --x"8C0A0004", -- lw $10, 4($0)   => 11. $10 = 5th instr = x"00412022" = 4268066
    --x"14620001", -- bne $1, $2, 1   => 12. Will branch to PC+1+1. $1 wrong if fails
    --x"30210000", -- andi $1, $1, 0  => 13. $1 = 0 (skipped)
    --x"08000010", -- j 16            => 14. PC = 16 = PC+1+1. $2 wrong if fails
    --x"30420000", -- andi $2, $2, 0  => 15. $2 = 0 (skipped)
    --x"00400008", -- jr $2           => 16. PC = $2 = 18 = PC+1+1. $3 wrong if fails
    --x"30630000", -- andi $3, $3, 0  => 17. $3 = 0 (skipped)
	--x"AC030040", -- sw $3, 64($0)   => 18. Mem(64) = $3
    --x"AC040041", -- sw $4, 65($0)   => 19. Mem(65) = $4
    --x"AC050042", -- sw $5, 66($0)   => 20. Mem(66) = $5
    --x"AC060043", -- sw $6, 67($0)   => 21. Mem(67) = $6
    --x"AC070044", -- sw $7, 68($0)   => 22. Mem(68) = $7
    --x"AC080045", -- sw $8, 69($0)   => 23. Mem(69) = $8
    --x"AC090046", -- sw $9, 70($0)   => 24. Mem(70) = $9
    --x"AC0A0047", -- sw $10, 71($0) => 25. Mem(71) = $10 
	x"00232020", -- add $4, $1, $3	=> $4 = $1 + $3 = 30
	x"00822822", -- sub $5, $4, $2  => $5 = $4 - $2 = 12
	x"20060009", -- addi $6, $0, 9  => $6 = $0 + 9  = 9
	x"00C13822", --	sub $7, $6, $1  => $7 = $6 - $1 = 3
	x"20080001", --	addi $8, $0, 1  => $8 = $0 + 1  = 1
	x"00E84820", -- add $9, $7, $8  => $9 = $7 + $8 = 4
	x"00E95020", -- add $10, $7, $9 => $10 = $7 + $9 = 7
--- Store Values in MEM starting at 0x0100	
	x"AC020100", -- sw $2 256($0)  => Mem(256) = $2 = 18 
	x"AC030101", -- sw $3 257($0)  => Mem(257) = $3 = 24
	x"AC070102", -- sw $7 258($0)  => Mem(258) = $7 = 3
	x"AC080103", -- sw $8 259($0)  => Mem(259) = $8 = 1
	x"AC010104", -- sw $1 260($0)  => Mem(260) = $1 = 6
	x"AC0A0105", -- sw $10 261($0) => Mem(261) = $10 = 7
	x"AC050106", -- sw $5 262($0)  => Mem(262) = $5 = 12
	x"AC090107", -- sw $9 263($0)  => Mem(263) = $9 = 4
	x"AC060108", -- sw $6 264($0)  => Mem(264) = $6 = 9
	x"AC040109", -- sw $4 265($0)  => Mem(265) = $4 = 30
--- Store Weights in MEM starting at 0x0200
	x"AC010200", -- sw $1 512($0) => Mem(512) = $1 = 6
	x"AC020201", -- sw $2 513($0) => Mem(513) = $2 = 18
	x"AC030202", -- sw $3 514($0) => Mem(514) = $3 = 24
	x"AC040203", -- sw $4 515($0) => Mem(515) = $4 = 30
	x"AC050204", -- sw $5 516($0) => Mem(516) = $5 = 12
	x"AC060205", -- sw $6 517($0) => Mem(517) = $6 = 9
	x"AC070206", -- sw $7 518($0) => Mem(518) = $7 = 3
	x"AC080207", -- sw $8 519($0) => Mem(519) = $8 = 1
	x"AC090208", -- sw $9 520($0) => Mem(520) = $9 = 4
	x"AC000209", -- sw $0 521($0) => Mem(521) = $0 -- last Weight is 0
--- Multiple Values by Weights stored starting at $12
	x"00410018", -- mult $2, $1  => $2 * $1 = 108
	x"00006012", -- mflo $12 	 => $12 = 108
	x"00620018", -- mult $3, $2  => $3 * $2 = 432
	x"00006812", -- mflo $13 	 => $13 = 432
	x"00E30018", -- mult $7, $3  => $7 * $3 = 72
	x"00007012", -- mflo $14 	 => $14 = 72
	x"01040018", -- mult $8, $4  => $8 * $4 = 30
	x"00007812", -- mflo $15     => $15 = 30
	x"00250018", -- mult $1, $5  => $1 * $5 = 72
	x"00008012", -- mflo $16 	 => $16 = 72
	x"01460018", -- mult $10, $6 => $10 * $6 = 63
	x"00008812", -- mflo $17 	 => $17 = 63
	x"00A70018", -- mult $5, $7  => $5 * $7 = 36
	x"00009012", -- mflo $18 	 => $18 = 36
	x"01280018", -- mult $9, $8  => $9 * $8 = 4
	x"00009812", -- mflo $19 	 => $19 = 4
	x"00C90018", -- mult $6, $9  => $6 * $9 = 36
	x"0000A012", -- mflo $20 	 => $20 = 36
	x"00800018", -- mult $4, $0  => $4 * $0 = 0
	x"0000A812", -- mflo $21 	 => $21 = 0
--- Add Weighted Value to get Total Weighted Value stored in $22
	x"018DB020", -- $22 = $12 + $13 = 540  
	x"02CEB020", -- $22 = $22 + $14 = 612
	x"02CFB020", -- $22 = $22 + $15 = 642
	x"02D0B020", -- $22 = $22 + $16 = 714
	x"02D1B020", -- $22 = $22 + $17 = 777
	x"02D2B020", -- $22 = $22 + $18 = 813
	x"02D3B020", -- $22 = $22 + $19 = 817
	x"02D4B020", -- $22 = $22 + $20 = 853
	x"02D5B020", -- $22 = $22 + $21 = 853
--- Add Weights to get Total Weight stored in $11
	x"00225820", -- $11 = $1 + $2  = 24
	x"01635820", -- $11 = $11 + $3 = 48
	x"01645820", -- $11 = $11 + $4 = 78
	x"01655820", -- $11 = $11 + $5 = 90
	x"01665820", -- $11 = $11 + $6 = 99
	x"01675820", -- $11 = $11 + $7 = 102
	x"01685820", -- $11 = $11 + $8 = 103
	x"01695820", -- $11 = $11 + $9 = 107
	x"01605820", -- $11 = $11 + $0 = 107
--- Divide Total Weighted Value by Total Weight to get Weighted Average Value
	x"02CB001A", -- div $22, $11 => ($22 / $11 = 7) & ($22 % $11 = 55)  
	x"0000B812", -- mflo $23 => $23 = 7
	x"0000C010", -- mfhi $24 => $24 = 104			
--- Store Weighted Average Value in Memory Location 0x00FF
	x"AC1700FF", -- sw $23 255($0) => Mem(255) = $23 = 7 
--- END OF WEIGHTED AVERAGE PROGRAM
	others  => (others => '0')
  );
  signal output: unsigned(31 downto 0);
begin
  --Mem_Bus <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when CS = '0' or WE = '1'
  --else output; 
  Mem_Bus_out <= output when CS='1' and WE='0' 
  	else x"00000000";
  process(Clk)
  begin
    if Clk = '0' and Clk'event then
      if CS = '1' and WE = '1' then
		--RAM1(to_integer(ADDR(6 downto 0))) <= Mem_Bus;
        RAM1(to_integer(ADDR(9 downto 0))) <= Mem_Bus_in;
      end if;
    output <= RAM1(to_integer(ADDR(9 downto 0))); -- ADDR range increased to access full RAM
    end if;
  end process;
end Internal;