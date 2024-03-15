-- Diseña un sumador-restador de 4 bits utilizando el método de complemento a 2 y sumadores completos (full adders). 

library IEEE;
use IEEE.std_logic_1164.all;

entity sumador_restador_a2 is
    port (
        A : in std_logic_vector(3 downto 0);
        B : in std_logic_vector(3 downto 0);
        M : in std_logic; -- Selector
        Suma : out std_logic_vector(3 downto 0);
        Cout : out std_logic;
        V : out std_logic -- Para ver si hay desbordamiento
    );
end entity sumador_restador_a2;

-- Full Adder de 1 bit
architecture rtl1bit of FullAdder is
begin
    Suma <= (A xor B) xor (Cin);
    Cout <= (A and B) or ((A xor B) and Cin);   
end architecture rtl1bit;

-- Sumador/Restador complemento a 2
architecture rtl of sumador_restador_a2 is
    
    component FullAdder
        port(
            A: in std_logic;
            B: in std_logic;
            Cin: in std_logic;
            Suma: out std_logic;
            Cout: out std_logic
        );
    end component;

    signal V_aux : std_logic;
    signal B_intermedia : std_logic_vector(3 downto 0);
    signal Suma_intermedia : std_logic_vector(3 downto 0);
    signal Cout_intermedia : std_logic_vector(3 downto 0);
    
begin

    B_intermedia(0) <= B(0) xor M;
    FA0: FullAdder port map (
        A => A(0),
        B => B_intermedia(0),
        Cin => M,
        Suma => Suma_intermedia(0),
        Cout => Cout_intermedia(0)
    );

    B_intermedia(1) <= B(1) xor M;
    FA1: FullAdder port map (
        A => A(1),
        B => B_intermedia(1),
        Cin => Cout_intermedia(0),
        Suma => Suma_intermedia(1),
        Cout => Cout_intermedia(1)
    );

    B_intermedia(2) <= B(2) xor M;
    FA2: FullAdder port map (
        A => A(2),
        B => B_intermedia(2),
        Cin => Cout_intermedia(1),
        Suma => Suma_intermedia(2),
        Cout => Cout_intermedia(2)
    );

    B_intermedia(3) <= B(3) xor M;
    FA3: FullAdder port map (
        A => A(3),
        B => B_intermedia(3),
        Cin => Cout_intermedia(2),
        Suma => Suma_intermedia(3),
        Cout => Cout_intermedia(3)
    );
    
    -- Verificar si hubo un desborde
    process(Cout_intermedia)
    begin
        if Cout_intermedia(3) /= Cout_intermedia(2) then
            V <= '1'; -- Hubo desbordamiento
            report "Overflow detected"; -- Informar sobre el desbordamiento
        else
            V <= '0'; -- No hubo desbordamiento
        end if;
    end process;
     
    Suma <= Suma_intermedia;
    Cout <= Cout_intermedia(2);

end architecture rtl;
