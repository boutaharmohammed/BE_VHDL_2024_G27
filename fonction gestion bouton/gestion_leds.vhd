LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity gestion_leds is
    PORT (
        clk : in std_logic;            
        reset_n : in std_logic;        
        SIG_LED : in std_logic_vector(1 downto 0); 
        LED_out : out std_logic        
    );
end gestion_leds;

architecture fsm of gestion_leds is
    
    signal led_state : std_logic := '0'; 
begin
    
    process (clk, reset_n)
        variable etat : integer range 0 to 4 := 0; 
        variable counter : integer:= 0; 
		  variable state_done : std_logic:='0'; 
        variable dim_counter : integer range 0 to 5 := 0; 
		  constant clock_freq : integer :=50_000_000;
		  constant Period_250MS :integer :=clock_freq/4;
		  constant Period_100MS :integer :=clock_freq/10;
    begin
	 
        if reset_n = '0' then
            etat := 0;
            LED_out <= '0';
            counter := 0;
            dim_counter := 0;
        elsif rising_edge(clk) then
            case etat is
                -- État 0 : LEDs éteintes, transition selon SIG_LED
                when 0 =>
                    LED_out <= '0'; -- LEDs éteintes
                    if SIG_LED = "00" then
                        etat := 1; -- Passe à l'état LED éteinte
                    elsif SIG_LED = "01" then
                        etat := 2; -- Passe à l'état LED faiblement éclairée
                    elsif SIG_LED = "10" then
                        etat := 3; -- Passe à l'état LED allumée
                    elsif SIG_LED = "11" then
                        etat := 4; -- Passe à l'état LED clignotante
                    end if;

                -- État 1 : LED éteinte
                when 1 =>
                    LED_out <= '0'; -- LED reste éteinte
                    if SIG_LED /= "00" then
                        etat := 0; -- Retour à l'état 0
                    end if;

                -- État 2 : LED faiblement éclairée
                when 2 =>
                    -- Alternance pour faible éclairage (par modulation temporelle)
                    if dim_counter < 2 then
                        LED_out <= '1'; -- LED brièvement allumée
                    else
                        LED_out <= '0'; -- LED éteinte
                    end if;

                    if dim_counter = 5 then
                        dim_counter := 0; -- Réinitialise le compteur
                    else
                        dim_counter := dim_counter + 1;
                    end if;

                    if SIG_LED /= "01" then
                        etat := 0; -- Retour à l'état 0
                    end if;

                -- État 3 : LED allumée
                when 3 =>
                    LED_out <= '1'; -- LED allumée
                    if SIG_LED /= "10" then
                        etat := 0; -- Retour à l'état 0
                    end if;

                -- État 4 : LED clignotante
                when 4 =>
					     if SIG_LED /= "11" then
                        etat := 0; -- Retour à l'état 0
								state_done:='0';
                    end if;
						  if state_done='0' then 
					     if counter < Period_250MS then
						  		counter:=counter+1;
                        LED_out <= '1'; -- sortie a 1
                  
						 
                    elsif
                        counter < Period_250MS+Period_100MS 
								then 
								 LED_out <= '0'; -- sortie a 0
								 counter:=counter+1;

						   elsif
                        counter <2 * (Period_250MS+Period_100MS)
								then 
								 LED_out <= '1'; -- sortie a 1
								  counter:=counter+1;
							else 
								   counter:=0;
								   LED_out <= '0'; -- sortie a 0
									state_done:='1';
                    end if;
						  
						  end if;
                    --LED_out <= led_state; -- Assignation de la LED clignotante
                    
						--retourne à l'état 0
                when others =>
                    etat := 0;
            end case;
        end if;
    end process;
end fsm;