library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;



entity compteur is
		
port (clk_50mhz , rst : in std_logic ;
		Led_cmpt : out std_logic_vector(3 downto 0)
);
end entity compteur;
architecture TP1 of compteur is

signal Compteur_bcd : std_logic_vector(3 downto 0);
	
	begin
	
	process(clk_50mhz,rst)
	
	begin 
			if(rst ='0')then 
			compteur_bcd<="0000";
			elsif(compteur_bcd="1010")then 
			compteur_bcd<="0000";
			elsif(rising_edge(clk_50mhz))then 
			compteur_bcd<=compteur_bcd +1;
		end if;
	
	
	end process ;
	Led_cmpt<=compteur_bcd;	

end architecture TP1 ;
