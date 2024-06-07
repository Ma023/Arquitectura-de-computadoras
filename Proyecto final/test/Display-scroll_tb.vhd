library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ROM_RAM_Display_tb is
end entity ROM_RAM_Display_tb;

architecture Behavioral of ROM_RAM_Display_tb is
    -- Señales del testbench
    signal clk : STD_LOGIC := '0';
    signal scroll : STD_LOGIC := '0';
    signal segs : STD_LOGIC_VECTOR(7 downto 0);
    signal digits : STD_LOGIC_VECTOR(3 downto 0);

    -- Instancia del componente bajo prueba (DUT)
    component ROM_RAM_Display
        Port ( clk : in  STD_LOGIC;
               scroll : in  STD_LOGIC;
               segs : out  STD_LOGIC_VECTOR(7 downto 0);
               digits : out  STD_LOGIC_VECTOR(3 downto 0));
    end component;

begin
    -- Instancia del DUT
    uut: ROM_RAM_Display
        Port map (
            clk => clk,
            scroll => scroll,
            segs => segs,
            digits => digits
        );

    -- Generador de reloj
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Generador de la señal de desplazamiento
    stimulus: process
    begin
        -- Prueba inicial sin desplazamiento
        scroll <= '0';
        wait for 100 ns;

        -- Activar desplazamiento
        scroll <= '1';
        wait for 50 ns;
        scroll <= '0';
        wait for 200 ns;

        -- Pruebas adicionales pueden ser agregadas aquí

        -- Finalizar simulación
        wait;
    end process;
end architecture Behavioral;
