-------------------MAE_gestion_bouton---------------------------

--port(
-- entrées: BP_Babord,BP_Tribord, BP_STBY, clk_50M, raz_n
-- sorties: codeFonction, ledBabord, ledTribord,ledSTBY, out_bip
--) 

--clk_50M: horloge à 50MHz
-- raz_n: actif à 0 => initialise le circuit

-- codeFonction:
-- =0000: pas d'action, le pilote est en veille
-- =0001: mode manuel action vérin babord
-- =0010: mode manuel action vérin tribord
-- =0011: mode pilote automatique/cap
-- =0100: incrément de 1° consigne de cap
-- =0101: incrément de 10° consigne de cap
-- =0111: décrément de 1° consigne de cap
-- =0110: décrément de 10° consigne de cap



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MAE_gestion_bouton is		
port (BP_Babord : in std_logic := '0';
		BP_Tribord : in std_logic := '0';
		BP_STBY : in std_logic:= '0';
		clk_50M : in std_logic;
		raz_n : in std_logic := '0';
		t_3s : in std_logic := '0';
		codeFonction : out std_logic_vector(3 downto 0):="0000";
		ledBabord : out std_logic_vector(1 downto 0):=(others=>'0');
		ledTribord : out std_logic_vector(1 downto 0):=(others=>'0');
		ledSTBY : out std_logic_vector(1 downto 0):=(others=>'0');
		out_bip : out std_logic_vector(1 downto 0):=(others=>'0');
		a_tempo : out std_logic:= '0'
		);
end entity MAE_gestion_bouton;


architecture exmpl of MAE_gestion_bouton is
	
	begin
	
	process(clk_50M,raz_n)
	variable state: integer range 0 to 11 ;
	begin
---reset asynchrone 	
		if(raz_n='0') then			
			state:=0;
			codeFonction<="0000";
			ledBabord<="00";
			ledTribord<="00";
			ledSTBY<="00";
			out_bip<="00";
	--BP_Babord  BP_Tribord   BP_STBY
	--ledBabord  ledTribord   ledSTBY
	 
		elsif(rising_edge(clk_50M))then
			case state is
			--état 0 MODE manuele 
			when 0 =>
				if(BP_Babord='1' and  BP_Tribord='0' and BP_STBY='0' )then
					state:=1;
				end if;
				if(BP_Babord='0' and  BP_Tribord='1' and BP_STBY='0')then
					state:=2;
				end if;
				if(BP_Babord='0' and  BP_Tribord='0' and BP_STBY='1')then
					state:=3;
				end if;
				
			codeFonction<="0000";
			ledSTBY<="11";
			ledBabord<="01";
			ledTribord<="01";
			out_bip<="00";	

			
		   --état 1
			when 1 =>
				if(BP_Babord='0')then
					state:=0;
				end if;
				
			codeFonction<="0001";
			ledSTBY<="00";
			ledBabord<="10";
			ledTribord<="00";
			out_bip<="01";
			--1 bip
				
		   --état 2		
			when 2 =>
				if(BP_Tribord='0')then
					state:=0;
				end if;
			
			codeFonction<="0010";
			ledSTBY<="00";
			ledBabord<="00";
			ledTribord<="10";
			out_bip<="01";
			--1 bip	
			
			--état 3
			when 3 =>
				if(BP_STBY='0')then
					state:=4;
				end if;
			codeFonction<="0011";
			ledSTBY<="11";
			ledBabord<="01";
			ledTribord<="01";
			out_bip<="01";	
			--1 bip

---état 4 Mode automatique
			when 4 =>
				if(BP_Babord='0' and  BP_Tribord='0' and BP_STBY='1')then
					state:=5;
				end if;
				if(BP_Babord='1' and  BP_Tribord='0' and BP_STBY='0')then
					state:=6;
				end if;
				if(BP_Babord='0' and  BP_Tribord='1' and BP_STBY='0')then
					state:=9;
				end if;
				
			codeFonction<="0011";
			ledSTBY<="10";
			ledBabord<="00";
			ledTribord<="00";
			out_bip<="00";	
			--1 bip					
			
			--état 5
			when 5 =>
				if(BP_STBY='0')then
					state:=0;
				end if;
				
				
			codeFonction<="0000";
			ledSTBY<="10";
			ledBabord<="00";
			ledTribord<="00";
			out_bip<="01";		
			--1 bip	
			
		   --état 6
			when 6 =>
			
				if(BP_Babord='0' and t_3s='0'  )then
					state:=7;
				end if;
				if(BP_Babord='1' and t_3s='1' )then
					state:=8;
				end if;
				
		   ledSTBY<="00";
			ledBabord<="10";
			ledTribord<="00";        
		   a_tempo<='1';
			out_bip<="01";		
			--1 bip
			
         --état 7
			when 7 =>
			
						
			codeFonction<="0111";
		   a_tempo<='0';
		   state:=4;--clock 0.1ms

	
         --état 8
			when 8 =>
			
				if(BP_Babord='0')then
					state:=4;
				end if;
				
	     	codeFonction<="0110";
			ledSTBY<="00";
			ledBabord<="11";-- atention C.L 2 fois
			ledTribord<="00";
		   a_tempo<='0';
			out_bip<="11";		
			--2 bip

			
         --état 9			
			when 9 =>
			
				if(BP_Tribord='0' and t_3s='0'  )then
					state:=10;
				end if;
				if(BP_Tribord='1' and t_3s='1' )then
					state:=11;
				end if;
				
		   ledSTBY<="00";
			ledBabord<="00";
			ledTribord<="10";        
		   a_tempo<='1';
			out_bip<="01";		
	
			--1 bip
			
			--état 10
			when 10 =>
			
			
      	codeFonction<="0100";	        
		   a_tempo<='0';	
			state:=4;--clock 0.1ms

			--état 11
			when 11 =>
			
				if(BP_Tribord='0')then
					state:=4;
				end if;
				
	     	codeFonction<="0101";
			ledSTBY<="00";
			ledBabord<="00";
			ledTribord<="11";-- atention C.L 2 fois
		   a_tempo<='0';
			out_bip<="11";			
			--2 bip
			
			
			
			end case;
		end if ;		
	end process;
	

end architecture exmpl ;

