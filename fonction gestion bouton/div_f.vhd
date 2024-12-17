library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity div_f is
		
port (clk_in , rst : in std_logic ;
		clk_out : out std_logic 	
);
end entity div_f;

architecture f1 of div_f is

---- diviseur de frequence 10hz
	
	begin
	process(clk_in,rst)
	variable temp: integer range 0 to 2500000 ;
	variable clk_1s :std_logic ;
	begin 
			if(rst ='0')then 
			temp :=0;
			clk_1s:='0';
	elsif(rising_edge(clk_in))then 
			temp:=temp+1;
			if(temp=2500000)then 
			clk_1s:=not clk_1s;
			temp:=0;
			end if;
			end if;
					clk_out<=clk_1s;
		end process;
	

end architecture f1 ;
