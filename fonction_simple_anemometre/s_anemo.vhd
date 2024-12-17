library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity s_anemo is
    port (
        clk, raz_n, continue, start_stop, in_freq_anemometre : in std_logic;
        data: out std_logic_vector(7 downto 0)
    );
end entity s_anemo;


architecture f9 of s_anemo is


    component div_frequence
port (clk_in , rst : in std_logic ;
		clk_out : out std_logic 	
);
end component; 
--
--component continu_mono
--port (continu : in std_logic ;
--		etat_continu : out std_logic 	
--);
--end component; 
--
--component comparateur_mode
--port (etat_start_stop , etat_continu : in std_logic ;
--		etat_monocoup , maj_1s : out std_logic 	
--);
--end component; 
--
--component start_stop
--port (start_stop , etat_continu : in std_logic ;
--		etat_start_stop , data_valid : out std_logic 	
--);
--end component; 



    component aqui_v3
port (
        clk_1hz  : in std_logic; 
		  raz_n  : in std_logic;
		  continue  : in std_logic;
		  start_stop : in std_logic:='0';
		  in_freq_anemometre : in std_logic;
        data : out std_logic_vector(7 downto 0)
    );
end component; 

	 signal clk1hz: std_logic;


begin

c1 : div_frequence port map(clk,raz_n,clk1hz);
c2 : aqui_v3 port map(clk1hz,raz_n,continue,start_stop,in_freq_anemometre,data);

  
			   
end architecture f9;
