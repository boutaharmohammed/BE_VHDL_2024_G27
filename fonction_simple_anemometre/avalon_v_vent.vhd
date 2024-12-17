library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.all;

entity avalon_v_vent is
port(  
    in_freq_anemometre : in std_logic;
    clk, chipselect, write_n, reset_n : in std_logic;
    writedata : in std_logic_vector (31 downto 0);
    address : in std_logic_vector (1 downto 0);
    readdata : out std_logic_vector (31 downto 0)
);
end entity avalon_v_vent;

architecture f13 of avalon_v_vent is

    -- Component declarations with added signals for `start_stop_tmp`, `continu_tmp`, and `raz_n_tmp`
    component div_frequence
        port (
            clk_in, rst : in std_logic;
            clk_out : out std_logic
        );
    end component;

    component aqui_v3
        port (
            clk_1hz : in std_logic; 
            raz_n : in std_logic;
            R_1s : in std_logic;
            e_monocoup : in std_logic := '0';
            in_freq_anemometre : in std_logic;
            start_stop : in std_logic;
            continu : in std_logic;
            data : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signals
    signal raz_n : std_logic;
    signal R_1s : std_logic;
    signal e_monocoup : std_logic := '0';
    signal data : std_logic_vector(7 downto 0);
    signal clk1hz : std_logic;

    -- Additional signals for Avalon interface
    signal config : std_logic_vector (31 downto 0);
    signal start_stop_tmp, continu_tmp, raz_n_tmp : std_logic;
    signal data_valid : std_logic;

begin

    -- Instantiate the div_frequence component
    c1 : div_frequence
        port map (
            clk_in => clk,
            rst => raz_n,
            clk_out => clk1hz
        );

    -- Instantiate the aqui_v3 component, passing the `start_stop_tmp`, `continu_tmp`, and `raz_n_tmp` signals
    c2 : aqui_v3
        port map (
            clk_1hz => clk1hz,
            raz_n => raz_n_tmp,
            R_1s => R_1s,
            e_monocoup => e_monocoup,
            in_freq_anemometre => in_freq_anemometre,
            start_stop => start_stop_tmp,
            continu => continu_tmp,
            data => data
        );

    -- Process for writing to registers (Avalon interface)
    process_write: process (clk, reset_n)
    begin
        if reset_n = '0' then
            config <= (others => '0');
            start_stop_tmp <= '0';
            continu_tmp <= '0';
            raz_n_tmp <= '0';
        elsif rising_edge(clk) then
            if chipselect = '1' and write_n = '0' then
                config <= writedata;
                start_stop_tmp <= config(2);
                continu_tmp <= config(1);
                raz_n_tmp <= config(0);
            end if;
        end if;
    end process;

    -- Process for reading from registers (Avalon interface)
    process_Read: process (data_valid, data)
    begin
        readdata <= "0000000000000000000000" & data_valid & '0' & data;
    end process;

    -- Additional logic for data_valid signal (example behavior)

end architecture f13;
