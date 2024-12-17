library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bip is
    port (
        clk_in       : in  std_logic; 
        raz_n          : in  std_logic:='0'; 
        bip_mode   : in  std_logic_vector(1 downto 0):="00" ;
        bip_out    : out std_logic  
    );
end entity bip;

architecture f1 of bip is




signal freq :  std_logic_vector (31 downto 0):="00000000000000001100001101010000";
signal duty :  std_logic_vector (31 downto 0):="00000000000000000110000110101000";
signal counter : std_logic_vector (31 downto 0):=(others => '0');
signal pwm_on : std_logic:='0';

signal enable_pwm : std_logic:='0';

signal duration_cnt_signal  : integer := 0; -- For timing the 250ms or 100ms periods
constant CLK_FREQ    : integer := 50_000_000; -- 50 MHz clock
constant PERIOD_250MS: integer := CLK_FREQ / 4; -- 250ms = 1/4 second
constant PERIOD_100MS: integer := CLK_FREQ / 10; -- 100ms = 1/10 second

--signal state_done    : std_logic := '0'; -- Tracks if the operation for the current state is done
signal state_signal  : integer := 0;

begin


	divide: process (clk_in, raz_n)
	begin
		if raz_n = '0' then 
		counter <= (others => '0');
		elsif clk_in'event and clk_in = '1' then
			if counter >= freq then
			counter <= (others => '0');
			else
			counter <= counter + 1;
			end if;
		end if;
		end process divide;
		
	compare: process (clk_in, raz_n)
	begin
		if raz_n = '0' then 
		   pwm_on <= '0';
		elsif clk_in'event and clk_in = '1' then
			if counter >= duty then
			pwm_on <= '0';
			elsif counter = 0 then
			pwm_on <= '1';
			end if;
		end if;
		end process compare;








    process(clk_in, raz_n)
	 variable state: integer range 0 to 3 := 0 ;
	 variable duration_cnt : integer := 0;  -- Use a variable here
	 variable state_done: std_logic := '0';    begin
        if (raz_n = '0') then
		  		state:=0;
			   enable_pwm<='0';
				--state_done<='0';
				state_done:='0';

            --bip_out <= '0';
				
        elsif rising_edge(clk_in) then		  
			case state is
			
			--état 0
			when 0 =>
				if(bip_mode="00")then
					state:=1;
				end if;
				if(bip_mode="01")then
					state:=2;
				end if;
				if(bip_mode="11")then
					state:=3;
				end if;
			--bip_out<='0';
			enable_pwm<='0';
			
			--état 1
			when 1 =>
				if(bip_mode="01" or bip_mode="11")then
					state:=0;
				end if;
         -- no bip pwm 					
			--bip_out<='0';
         enable_pwm<='0';

			
			--état 2 	
			when 2 =>
				if(bip_mode="00" or bip_mode="11")then
				state_done := '0';
				duration_cnt := 0;
				state:=0;
					

				end if;
			-- 1 bip pwm for 250 ms	 
			
			if (duration_cnt < 12500000 and state_done='0') then          
            duration_cnt := duration_cnt + 1;
            enable_pwm <= '1';
         else
				enable_pwm <= '0';
				--state_done<='1';
				state_done := '0';

				--duration_cnt := 0;

             --state <= 0;
         end if;
			
			duration_cnt_signal <= duration_cnt;
			
			--état 3
			when 3 =>
				if(bip_mode="00" or bip_mode="01")then
					state:=0;
					duration_cnt := 0;
					state_done := '0';

				end if;
         -- 2 bip pwm, one for 250ms wait for 100ms then another for 250 ms
		   if(state_done = '0')then 
	
				if duration_cnt < PERIOD_250MS then
                    duration_cnt := duration_cnt + 1;
                    enable_pwm <= '1';
            elsif duration_cnt < PERIOD_250MS + PERIOD_100MS then
                    duration_cnt := duration_cnt + 1;
                    enable_pwm <= '0';
            elsif duration_cnt < 2 * PERIOD_250MS + PERIOD_100MS then
                    duration_cnt := duration_cnt + 1;
                    enable_pwm <= '1';
            else
                    duration_cnt := 0;
                    enable_pwm <= '0';
						  state_done := '1';

                    --state := 0;
            end if;	
         end if;
			end case;
		end if ;	    
				
		state_signal<= state;
    end process;

	 
	 
	process (clk_in, raz_n)
	begin
		if (raz_n = '0') then 
		--reset
		bip_out <= '0';

		elsif clk_in'event and clk_in = '1' then
			if (enable_pwm='1') then
			bip_out <= pwm_on;
			else
			bip_out <= '0';
			end if;
		end if;
		end process ;
    

	 
	 
	 
 

end architecture f1;




