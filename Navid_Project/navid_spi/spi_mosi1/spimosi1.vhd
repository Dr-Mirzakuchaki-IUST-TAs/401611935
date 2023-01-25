----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
---
entity spimosi1 is 
 ---
	Port(
	     ---Inputs
		  CLK_SYS      : in   std_logic;
		  start        : in   std_logic;
		  SCK          : in   std_logic;
		  Data_In      : in   std_logic_vector (23 downto 0);
		  ---Outputs
		  CS_n      : out  std_logic;
		  MOSI      : out  std_logic
  );
  ---
end spimosi1;
---
architecture Behavioral of spimosi1 is
---In/Outs
	signal   start_INT    : std_logic        := '0';
	signal   CS_n_INT     : std_logic        := '1';
	signal   MOSI_INT     : std_logic        := '0'; 
	signal   Data_In_INT  : std_logic_vector (23 downto 0) := (others => '0');
	--- Control signals
	signal   Bit_CNT      : unsigned         (4 downto 0)  := "10111";
   ---states
   type     FSM is (idle, instruction, write_st, delay_instruction, delay_cs);
   signal   state       : FSM                            := idle;
   ---  
begin
   ---
   CS_n   <= CS_n_INT;
   MOSI   <= MOSI_INT;
	---
	Process (CLK_SYS)
	begin
	   ---
     if (rising_edge (CLK_SYS)) then
	     ---
		  start_INT        <= start;
		  Data_In_INT      <= Data_In;
		    ---
		  case state is 
		     ---
			 when idle   => 
			    ---
				 MOSI_INT   <= '0';
				 Bit_CNT    <= "10111";
				 ---
				 if (start_INT = '1') then
				    state    <=  delay_instruction;
					 CS_n_INT <= '0';
				 else 
		       state       <=  idle;
				 CS_n_INT    <= '1';
				 end if;
				 ---
			 when  delay_instruction =>
			    ---
				 state       <= instruction;
				 CS_n_INT    <= '0';
				 MOSI_INT    <= Data_In_INT (to_integer(Bit_CNT));
				 Bit_CNT     <= Bit_CNT  - 1;
				 ---
		    when instruction   =>
			 ---
		       CS_n_INT    <= '0';
				 MOSI_INT    <= Data_In_INT (to_integer(Bit_CNT));
				 ---
             if (Bit_CNT /= 16) then
				     state     <= instruction;
					  Bit_CNT   <= Bit_CNT  - 1;
				else
				   state       <= write_st;
					Bit_CNT     <= "01111";
			   end if;
				---
		   when write_st  =>
			   ---
				CS_n_INT       <= '0';
		      MOSI_INT       <= Data_In_INT (to_integer(Bit_CNT));
				---
				 if (Bit_CNT /= 0) then
				     state     <= write_st;
					  Bit_CNT   <= Bit_CNT  - 1;
				  else  
		        state        <= delay_cs;
				  Bit_CNT      <= "10111";
				  end if;
				  ---
		    when  delay_cs =>
				  ---
				  state      <= idle;
				 CS_n_INT    <= '0';
				 MOSI_INT    <= '0';
				 Bit_CNT     <= "10111";
				 ---
    	 end case;
	    ---
	   end if;
   	---
    end Process;
	 ---
end Behavioral;

