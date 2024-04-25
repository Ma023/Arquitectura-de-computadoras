library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mealy1 is
    Port (
        clk    : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        data   : in  STD_LOGIC;  -- Entrada de datos
        detected : out STD_LOGIC  -- Salida de detección de secuencia
    );
end mealy1;

architecture Behavioral of mealy1 is
    -- Definición de los estados
    type state_type is (S0, S1, S2);
    signal estado_actual, estado_siguiente : state_type;
    
    -- Procedure para la transición de estados
    procedure transicion_estados(
        current_state: in state_type;
        input_data: in STD_LOGIC;
        next_state: out state_type
    ) is
    begin
        case current_state is
            when S0 =>
                if input_data = '0' then
                    next_state := S1;
                else
                    next_state := S0;
                end if;

            when S1 =>
                if input_data = '1' then
                    next_state := S2;
                else
                    next_state := S0;
                end if;

            when S2 =>
                if input_data = '1' then
                    next_state := S0;
                else
                    next_state := S1;
                end if;
        end case;
    end transicion_estados;
    
begin
    process(clk, reset)
        variable estado_siguiente_var : state_type;
    begin
        if reset = '1' then
            estado_actual <= S0;
            detected <= '0';
        elsif rising_edge(clk) then
            -- Llamada al procedimiento para manejar la transición de estados
            transicion_estados(estado_actual, data, estado_siguiente_var);

            estado_actual <= estado_siguiente_var;

            -- Salida basada en el estado y entrada (Mealy)
            if estado_actual = S2 and data = '1' then
                detected <= '1';
            else
                detected <= '0';
            end if;
        end if;
    end process;
end Behavioral;
