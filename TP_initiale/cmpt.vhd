library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;




entity cmpt is
		
port (clk_50mhz , rst : in std_logic ;
		led : out std_logic 	
);
end entity cmpt;
architecture TP1 of cmpt is

	
	begin
	process(clk_50mhz,rst)
	variable temp: integer range 0 to 25000000 ;
	variable clk_1s :std_logic ;
	begin 
			if(rst ='0')then 
			temp :=0;
			clk_1s:='0';
	elsif(rising_edge(clk_50mhz))then 
			temp:=temp+1;
			if(temp=25000000)then 
			clk_1s:=not clk_1s;
			temp:=0;
			end if;
			end if;
					led<=clk_1s;
		end process;
	

end architecture TP1 ;
