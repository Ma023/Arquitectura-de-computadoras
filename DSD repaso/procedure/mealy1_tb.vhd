library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mealy1_tb is
end mealy1_tb;

architecture Behavioral of mealy1_tb is
    -- Componente de la entidad que se va a probar
    component mealy1
        Port (
            clk      : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            data     : in  STD_LOGIC;  -- Entrada de datos
            detected : out STD_LOGIC  -- Salida de detección de secuencia
        );
    end component;

    -- Señales para el testbench
    signal clk_tb      : STD_LOGIC := '0';
    signal reset_tb    : STD_LOGIC := '0';
    signal data_tb     : STD_LOGIC := '0';
    signal detected_tb : STD_LOGIC;

    -- Periodo del reloj
    constant CLK_PERIOD : time := 10 ns;

    -- Contador para el número de ciclos de reloj
    signal cycle_count : integer := 0;

begin
    -- Instancia del componente a probar
    dut: mealy1
        Port map (
            clk      => clk_tb,
            reset    => reset_tb,
            data     => data_tb,
            detected => detected_tb
        );

    -- Generación del reloj con contador de ciclos
    clk_process : process
    begin
        while cycle_count < 10 loop
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
            cycle_count <= cycle_count + 1;
        end loop;

        -- Al llegar al número de ciclos, terminamos el test
        report "Pruebas completadas después de 10 ciclos de reloj." severity note;
        wait;
    end process;

    -- Proceso de estímulos para el testbench
    stimulus_process : process
    begin
        -- Inicialización y reinicio
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';

        -- Aplicar secuencia de entrada
        data_tb <= '0';
        wait for 10 ns;
        data_tb <= '1';
        wait for 10 ns;
        data_tb <= '0'; -- Esta secuencia no debe activar la salida

        -- Secuencia correcta
        data_tb <= '0';
        wait for 10 ns;
        data_tb <= '1';
        wait for 10 ns;
        data_tb <= '1'; -- Esta secuencia debe activar la salida

        -- Reporte final indicando éxito
        report "testbench finalizado con exito."
        severity note;

        -- El proceso espera hasta que termine el proceso del reloj
        wait;
    end process;

end Behavioral;
