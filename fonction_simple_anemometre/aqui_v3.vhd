library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity aqui_v3 is
    port (
        clk_1hz  : in std_logic; 
		  raz_n  : in std_logic:='1';
		  continue  : in std_logic:='1';--start_stop  e_monocoup   continue   R_1s
		  start_stop : in std_logic:='0';
		  in_freq_anemometre : in std_logic;
        data : out std_logic_vector(7 downto 0)
    );
end entity aqui_v3;

architecture test1 of aqui_v3 is
    signal nmbr_periode : std_logic_vector(7 downto 0) := (others => '0');    
    signal periode_1 : std_logic_vector(15 downto 0) := (others => '0');  
    signal periode_2 : std_logic_vector(15 downto 0) := (others => '0');  
    signal e_monocoup_reg : std_logic := '0';  
    signal e_monocoup_prev : std_logic := '0'; 
    
begin

    -- Comptage des fronts montants de in_freq_anemometre
    process(clk_1hz, in_freq_anemometre, raz_n)
    begin
        if (raz_n = '0') then  
            nmbr_periode <= (others => '0');
        elsif (clk_1hz = '1' and raz_n = '1') then
            if (rising_edge(in_freq_anemometre)) then
                nmbr_periode <= std_logic_vector(unsigned(nmbr_periode) + 1);
            end if;
        elsif (clk_1hz = '0') then 
            nmbr_periode <= (others => '0');  
        end if;
    end process;

    -- Mise à jour de periode_1
    process(clk_1hz)
    begin
        if (falling_edge(clk_1hz)) then
            --periode_1  <= std_logic_vector(unsigned(nmbr_periode) * 2);
            periode_1 <= std_logic_vector(shift_left(unsigned(nmbr_periode), 1));
				
        end if;
    end process;

    -- mise à jour de periode_2
    process(clk_1hz)
    begin
        if rising_edge(clk_1hz) then
            -- Détecter le front montant de e_monocoup
            e_monocoup_prev <= e_monocoup_reg;
            e_monocoup_reg <= start_stop;

            if (e_monocoup_reg = '1' and e_monocoup_prev = '0' and continue = '1') then
                periode_2 <= periode_1;
            elsif (continue = '1') then
                periode_2 <= periode_1;
            end if;
        end if;
    end process;

    data <= periode_2(7 downto 0);

end architecture test1;
