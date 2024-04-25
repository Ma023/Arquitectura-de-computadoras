library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity comparador_tb is
end entity comparador_tb;

architecture test of comparador_tb is
    -- Señales internas para el testbench
    signal a_tb, b_tb, c_tb : integer range -256 to 255;
    signal min_tb, max_tb  : integer range -256 to 255 := 0;

    -- Instancia del componente a probar
    component comparador
        port (
            a, b, c : in integer range -256 to 255;
            min, max: out integer range -256 to 255
        );
    end component;

begin
    -- Instancia del componente comparador
    dut: comparador
        port map (
            a => a_tb,
            b => b_tb,
            c => c_tb,
            min => min_tb,
            max => max_tb
        );

    -- Proceso de pruebas
    test_process: process
    begin
        -- Caso de prueba 1: a = 1, b = 2, c = 3
        a_tb <= 1;
        b_tb <= 2;
        c_tb <= 3;
        wait for 10 ns; -- Esperar para que el componente procese

        assert (min_tb = 1 and max_tb = 3) 
            report "Error en el Caso 1: min y/o max incorrectos" 
            severity error;

        -- Caso de prueba 2: a = -256, b = 255, c = 0
        a_tb <= -256;
        b_tb <= 255;
        c_tb <= 0;
        wait for 10 ns;

        assert (min_tb = -256 and max_tb = 255) 
            report "Error en el Caso 2: min y/o max incorrectos" 
            severity error;

        -- Caso de prueba 3: a = 100, b = -100, c = 50
        a_tb <= 100;
        b_tb <= -100;
        c_tb <= 50;
        wait for 10 ns;

        assert (min_tb = -100 and max_tb = 100) 
            report "Error en el Caso 3: min y/o max incorrectos" 
            severity error;

        -- Pruebas adicionales
        a_tb <= 0;
        b_tb <= 0;
        c_tb <= 0;
        wait for 10 ns;

        assert (min_tb = 0 and max_tb = 0) 
            report "Error en el Caso 4: min y/o max incorrectos" 
            severity error;

        -- Reporte final indicando éxito
        report "Pruebas del comparador completadas con éxito."
        severity note;

        wait; -- Mantener el proceso activo para evitar la terminación del testbench

    end process test_process;

end architecture test;
