----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL;
---
ENTITY SPI_MOSI_tb IS
END SPI_MOSI_tb;
---
ARCHITECTURE behavior OF SPI_MOSI_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    
   --Inputs
   signal CLK_SYS        : std_logic                      := '0';
   signal start          : std_logic                      := '0';
   signal SCK            : std_logic                      := '0';
   signal Data_In  : std_logic_vector (23 downto 0) := (others => '0');
	
 	--Outputs
   signal CS_n : std_logic;
   signal MOSI : std_logic;

   --- Internal  Signal
	signal SCK_start : std_logic    := '0';
	
   -- Clock period definitions
   constant CLK_SYS_period : time := 50 ns;
	constant SCK_period     : time := 50 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut:entity work.spimosi1 PORT MAP (
          CLK_SYS    => CLK_SYS,
          start      => start,
          SCK        => SCK,
          CS_n       => CS_n,
          MOSI       => MOSI,
			 Data_In    => Data_In
        );

   -- Clock process definitions
   CLK_SYS_process :process
   begin
		CLK_SYS <= '0';
		wait for CLK_SYS_period/2;
		CLK_SYS <= '1';
		wait for CLK_SYS_period/2;
   end process;
 
   --- SCK_start generator
   SCK_start_Pro: process
	begin
	    	SCK_start   <= '0','1' after 625 ns, '0' after 1800 ns, '1' after 2075 ns, '0' after 3250 ns, '1' after 3525 ns, '0' after 4700 ns, '1' after 4975 ns, '0' after 6150 ns;
		   wait;
		 end process  SCK_start_Pro;
		 
		 --- SCK generator
		 SCK_Pro:  process
		 begin
	     	  ---
		 if (SCK_Start = '1') then
		     ---
		     SCK <= '0';
	      wait for SCK_period/2;
		   SCK   <= '1';
		   wait for SCK_period/2;
			---
	  else
	      ---
			SCK <= '0';
	      wait until SCK_Start = '1';
			---
			end if;
			---
			end process  SCK_Pro;
			
			--- Start generator
			Start_Pro : process
			begin
			---
			Start   <= '0', '1' after 490 ns, '0' after 530 ns, '1' after 1940 ns, '0' after 1980 ns, '1' after 3390 ns, '0' after 3430 ns, '1' after 4840 ns, '0' after 4880 ns;
		   wait;
			--
			end process  start_Pro;
			---
			
			Data_In_Pro:process
	begin
		---
		Data_In <=   --- INITIALIZATION LATCH MAP
            		"011000000000010010001011", 
						--- FUNCTION LATCH MAP
				      "011000000000010010001010"  after 2000 ns,
						--- REFERENCE COUNTER LATCH MAP
						"000000000000010010001100"  after 3410 ns,
						--- AB COUNTER LATCH MAP
						"010000000000011100001101"  after 4860 ns;
						
		wait;
		---
	end process Data_In_Pro;
			
			
   -- Stimulus process
  -- stim_proc: process
  -- begin		
      -- hold reset state for 100 ns.
   --   wait for 100 ns;	

     -- wait for CLK_SYS_period*10;

      -- insert stimulus here 

     -- wait;
   --end process;

END;
