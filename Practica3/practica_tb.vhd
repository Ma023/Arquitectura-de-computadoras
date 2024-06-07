LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY practica_tb IS
END practica_tb;

ARCHITECTURE test_arch OF practica_tb IS
    -- Declarar el componente que se va a probar
    COMPONENT practica
        PORT (
            Reset : IN STD_LOGIC;
            sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            DISPLAY : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            flags : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            comp : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            AN : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            blink_LED : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Declarar las señales de entrada y salida para el testbench
    SIGNAL Reset_tb : STD_LOGIC := '1';
    SIGNAL sel_tb : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL DISPLAY_tb : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL flags_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL comp_tb : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL AN_tb : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";
    SIGNAL blink_LED_tb : STD_LOGIC;
    SIGNAL CLK_tb : STD_LOGIC := '0';

    -- Función para convertir un std_logic_vector a una cadena
    FUNCTION vector_to_string(v : STD_LOGIC_VECTOR) RETURN STRING IS
        VARIABLE result : STRING(1 TO v'LENGTH);
    BEGIN
        FOR i IN 1 TO v'LENGTH LOOP
            IF v(i-1) = '0' THEN
                result(i) := '0';
            ELSE
                result(i) := '1';
            END IF;
        END LOOP;
        RETURN result;
    END FUNCTION;

BEGIN
    -- Generador de reloj para la simulación
    ClockGen: PROCESS
    BEGIN
        -- Alternar el reloj cada 10 ns para obtener una frecuencia de 50 MHz
        CLK_tb <= NOT CLK_tb;
        WAIT FOR 10 ns;
    END PROCESS;

    -- Instanciar el dispositivo bajo prueba (DUT)
    UUT: practica
        PORT MAP(
            Reset => Reset_tb,
            sel => sel_tb,
            DISPLAY => DISPLAY_tb,
            flags => flags_tb,
            comp => comp_tb,
            AN => AN_tb,
            blink_LED => blink_LED_tb
        );

    -- Test case para verificar el reset y el comportamiento básico
    TestProc: PROCESS
    BEGIN
        -- Iniciar el testbench con un reporte
        REPORT "Iniciando testbench para practica" SEVERITY note;

        -- Probar con el Reset activado
        Reset_tb <= '0';
        WAIT FOR 20 ns;
        Reset_tb <= '1';

        -- Probar diferentes valores para "sel"
        sel_tb <= "00";  -- Selección por defecto
        WAIT FOR 40 ns;

        sel_tb <= "01";  -- Prueba con otro valor
        WAIT FOR 40 ns;

        sel_tb <= "10";  -- Otro valor para verificar
        WAIT FOR 40 ns;

        sel_tb <= "11";  -- Última prueba para "sel"
        WAIT FOR 40 ns;

        -- Verificar el valor de la salida "DISPLAY"
        REPORT "Valor del DISPLAY: " & vector_to_string(DISPLAY_tb) SEVERITY note;

        -- Fin del testbench
        REPORT "Fin de la simulación del testbench" SEVERITY note;

        WAIT;
    END PROCESS TestProc;

END ARCHITECTURE test_arch;
