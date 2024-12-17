library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Temporisateur_3s is
    port (
        clk_in       : in  std_logic; 
        rst          : in  std_logic; 
        enable_tempo : in  std_logic; 
        tempo_out    : out std_logic  
    );
end entity Temporisateur_3s;

architecture f1 of Temporisateur_3s is
    signal clk_1s      : std_logic := '0'; 
    signal temp        : integer range 0 to 25000000 := 0; 
    signal cnt_3       : integer range 0 to 3 := 0; 
    signal tempo_active : std_logic := '0';
begin

   
    process(clk_in, rst)
    begin
        if rst = '0' then
            temp <= 0;
            clk_1s <= '0';
        elsif rising_edge(clk_in) then
            if temp = 25000000 - 1 then
                clk_1s <= not clk_1s; 
                temp <= 0;
            else
                temp <= temp + 1;
            end if;
        end if;
    end process;

    
    process(clk_1s, rst)
    begin
        if rst = '0' then
            cnt_3 <= 0;
            tempo_active <= '0';
        elsif rising_edge(clk_1s) then
            if enable_tempo = '1' then
                if cnt_3 < 3 then
                    cnt_3 <= cnt_3 + 1;
                end if;
                if cnt_3 = 3 then
                    tempo_active <= '1';
                end if;
            else
                cnt_3 <= 0;
                tempo_active <= '0';
            end if;
        end if;
    end process;

   
    tempo_out <= tempo_active;

end architecture f1;
