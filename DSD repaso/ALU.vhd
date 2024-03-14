library IEEE;
use IEEE.std_logic_1164.all;


entity ALU is
    port (
        A : in std_logic_vector(11 downto 0);
        B : in std_logic_vector(11 downto 0);
        seleccion : in std_logic_vector(3 downto 0);
        salida_ALU : out std_logic_vector(17 downto 0)        
    );
end entity ALU;


-- Arquitectura de la ALU
architecture rtl of ALU is

    component sumador_a2
        port(
            A : in std_logic_vector(11 downto 0);
            B : in std_logic_vector(11 downto 0);
            M : in std_logic; -- Selector
            Suma : out std_logic_vector(11 downto 0);
            Cout : out std_logic
            -- V_a2 : out std_logic -- Para ver si hay desbordamiento
        );
    end component;

    signal A_signal : std_logic_vector(11 downto 0);
    signal B_signal : std_logic_vector(11 downto 0);
    signal M_signal : std_logic;
    signal suma_signal : std_logic_vector(11 downto 0);
    signal cout_signal : std_logic;
    signal resultado : std_logic_vector(17 downto 0);
    signal uno : std_logic_vector(11 downto 0) := "000000000001"; -- Valor de B
    
begin
    
    -- Creación de instancia de componente de sumador a 2
    sum_a2 : sumador_a2 port map(
        A => A_signal,
        B => B_signal,
        M => M_signal,
        Suma => suma_signal,
        Cout => cout_signal
    );
    
    process (seleccion, A, B, suma_signal, resultado)
    begin


        case seleccion is
                
            when "0000" => -- Suma (8 bits)
                A_signal <= "0000" & A(7 downto 0);
                B_signal <= "0000" & B(7 downto 0);
                M_signal <= '0';
                resultado <= "000000" & suma_signal;
                
            when "0001" => -- Resta (8 bits)
                
                A_signal <= "0000" & A(7 downto 0);
                B_signal <= "0000" & B(7 downto 0);
                M_signal <= '1';
                resultado(11 downto 0) <= suma_signal; 
                resultado(17 downto 12) <= "000000";
                
            when "0010" => -- A + 1

                A_signal <= A;
                B_signal <= uno;
                M_signal <= '0';
                resultado(11 downto 0) <= suma_signal; 
                resultado(12) <= cout_signal;
                resultado(17 downto 13) <= "00000";

            when "0011" =>  -- A - 1

                A_signal <= A;
                B_signal <= uno;
                M_signal <= '1';
                resultado(11 downto 0) <= suma_signal;
                resultado(12) <= cout_signal;
                resultado(17 downto 12) <= "000000";
                
            when "0100" => -- B + 1

                A_signal <= B;
                B_signal <= uno;
                M_signal <= '0';
                resultado(11 downto 0) <= suma_signal;
                resultado(12) <= cout_signal;
                resultado(17 downto 13) <= "00000";
                
            when "0101" => -- B - 1
                A_signal <= B;
                B_signal <= uno;
                M_signal <= '1';
                resultado(11 downto 0) <= suma_signal;
                resultado(17 downto 12) <= "000000";
                
            when "0110" => -- A + B (12 bits)

                A_signal <= A;
                B_signal <= B;
                M_signal <= '0';
                resultado(11 downto 0) <= suma_signal;
                resultado(12) <= cout_signal;
                resultado(17 downto 13) <= "00000";
                
            when "0111" => -- A - B (12 bits)
            
                A_signal <= A;
                B_signal <= B;
                M_signal <= '1';
                resultado <= "000000" & suma_signal;
                
            when "1000" => -- AND
                for i in 0 to 11 loop
                    resultado(i) <= A(i) and B(i);
                end loop;
                
                resultado(17 downto 12) <= "000000";

            when "1001" => -- OR
                for i in 0 to 11 loop
                    resultado(i) <= A(i) or B(i);
                end loop;
                
                resultado(17 downto 12) <= "000000";
                
            when "1010" => -- XOR
                for i in 0 to 11 loop
                    resultado(i) <= A(i) xor B(i);
                end loop;
                
                resultado(17 downto 12) <= "000000";

            when "1011" => -- COMP 1
                resultado(11 downto 0) <= not A(11 downto 0);
                resultado(17 downto 12) <= "000000";
                
            when "1100" => -- COMP 2
                A_signal <= not A(11 downto 0);
                B_signal <= uno;
                M_signal <= '0';
                resultado(11 downto 0) <= suma_signal;
                resultado(12) <= cout_signal;
                resultado(17 downto 13) <= "00000";
                
                
            when "1101" => -- Multiplicación
                -- completar código
                
            when "1110" => -- División
                -- completar código
                
            when "1111" => -- Corrimiento a la derecha
                -- completar código
            when others =>
                report"opcion no valida";

        end case;        

    end process;
    
    -- Asignar la salida_ALU fuera del proceso
    salida_ALU <= resultado;

end architecture rtl;