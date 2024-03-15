library IEEE;
use IEEE.std_logic_1164.all;

entity maquina_de_estados_Mealy is
    port (
        X : in std_logic;
        Y : out std_logic
    );
end entity maquina_de_estados_Mealy;

architecture rtl of maquina_de_estados_Mealy is
    
    signal clock : std_logic := '0'; -- Se inicializa el clock
    signal Qt : std_logic_vector(1 downto 0) := "00"; -- Estado inicial
    signal Qt_next : std_logic_vector(1 downto 0) := "00"; -- Estado siguiente
    signal sequence_detected : std_logic := '0'; -- Se inicializa la señal de detección de secuencia

begin

    process(clock)
    begin
        if rising_edge(clock) then
            -- Lógica de transición de estados
            case Qt is
                when "00" =>
                    if X = '1' then
                        Qt_next <= "01";
                    else
                        Qt_next <= "00";
                    end if;
                when "01" =>
                    if X = '1' then
                        Qt_next <= "10";
                    else
                        Qt_next <= "00";
                    end if;
                when "10" =>
                    if X = '1' then
                        Qt_next <= "11"; -- Se cambia a "11" para detectar la secuencia
                        sequence_detected <= '1'; -- Se detecta la secuencia de tres 1's
                    else
                        Qt_next <= "00";
                        sequence_detected <= '0'; -- Se reinicia la detección
                    end if;
                when others =>
                    Qt_next <= "00"; -- Estado inicial si no hay coincidencia
                    sequence_detected <= '0'; -- Se reinicia la detección
                    report "Estado no válido" severity warning; -- Mensaje de advertencia para estados no válidos
            end case;
            -- Actualización del estado actual
            Qt <= Qt_next;
        end if;
    end process;

    -- Salida de la señal de detección de secuencia
    Y <= sequence_detected;
    
end architecture rtl;
