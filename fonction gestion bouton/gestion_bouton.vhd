library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity gestion_bouton is
		
port (BP_Babord : in std_logic := '0';
		BP_Tribord : in std_logic := '0';
		BP_STBY : in std_logic:= '0';
		clk_50M : in std_logic;
		raz_n : in std_logic := '0';
		codeFonction : out std_logic_vector(3 downto 0):="0000";
		ledBabord : out std_logic:= '0';
		ledTribord : out std_logic:= '0';
		ledSTBY : out std_logic:= '0';
		out_bip : out std_logic:= '0'
		); 
end entity gestion_bouton;

architecture f1 of gestion_bouton is
signal		wire_1 : std_logic 	;
signal		wire_2 : std_logic 	;
signal		wire_clk : std_logic 	;
signal		wire_3 : std_logic_vector(1 downto 0);
signal		wire_4 : std_logic_vector(1 downto 0);
signal		wire_5 : std_logic_vector(1 downto 0);
signal		wire_bip : std_logic_vector(1 downto 0);


component Temporisateur_3s
port (
        clk_in       : in  std_logic; -- Input clock
        rst          : in  std_logic; -- Reset signal
        enable_tempo : in  std_logic; -- Enable signal
        tempo_out    : out std_logic  -- Output signal
    );
end component; 

--

component div_f 		
port (clk_in , rst : in std_logic ;
		clk_out : out std_logic 	
);
end component; 

--

component MAE_gestion_bouton
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
end component; 

--
component bip 		
 port (
        clk_in       : in  std_logic; 
        raz_n          : in  std_logic:='0'; 
        bip_mode   : in  std_logic_vector(1 downto 0):="00" ;
        bip_out    : out std_logic  
    );
end component; 
--

component gestion_leds 		
    port (
        clk : in std_logic;            
        reset_n : in std_logic;        
        SIG_LED : in std_logic_vector(1 downto 0); 
        LED_out : out std_logic        
    );
end component; 

----


begin
	 
	
c1 : Temporisateur_3s port map(clk_50M,raz_n,wire_2,wire_1);

c2 : MAE_gestion_bouton port map(
      BP_Babord =>  NOT (BP_Babord),
		BP_Tribord  =>  NOT (BP_Tribord),
		BP_STBY => NOT (BP_STBY),
		clk_50M => wire_clk,
		raz_n => raz_n,
		t_3s =>  wire_1,
		codeFonction => codeFonction,
		ledBabord  => wire_3,
		ledTribord  => wire_4,
		ledSTBY => wire_5,
		out_bip => wire_bip,
		a_tempo =>  wire_2
		);
	
c3 : div_f port map(clk_50M,raz_n,wire_clk);

c4 : bip   port map(clk_50M,raz_n,wire_bip,out_bip);

c5 : gestion_leds port map(clk_50M,raz_n,wire_3,ledBabord);
c6 : gestion_leds port map(clk_50M,raz_n,wire_4,ledTribord);
c7 : gestion_leds port map(clk_50M,raz_n,wire_5,ledSTBY);

	
	

end architecture f1 ;
