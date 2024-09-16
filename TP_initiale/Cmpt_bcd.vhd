library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;



entity Cmpt_bcd is
		
port (clk_50mhz , rst : in std_logic ;
		Led_cmpt : out std_logic_vector(3 downto 0)
);
end entity Cmpt_bcd;
architecture TP1 of Cmpt_bcd is
signal clk_cmpt :std_logic;
signal Compteur_bcd : std_logic_vector(3 downto 0);
	
	begin
	process(clk_50mhz,rst)
	variable temp: integer range 0 to 25000000 ;
	variable clk_1s :std_logic ;
	begin 
			--if(rst ='0')then 
			--temp :=0;
			--clk_1s:='0';
	if(rising_edge(clk_50mhz))then 
			temp:=temp+1;
			if(temp=25000000)then 
			clk_1s:=not clk_1s;
			temp:=0;
			end if;
			end if;
					clk_cmpt<=clk_1s;
		end process;
	
	process(clk_cmpt,rst)
	
	begin 
			if(rst ='0')then 
			compteur_bcd<="0000";
			elsif(rising_edge(clk_cmpt))then 
			compteur_bcd<=compteur_bcd +1;
		end if;
	
	
	end process ;
	Led_cmpt<=compteur_bcd;	

end architecture TP1 ;
