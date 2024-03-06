-- Sumador/Restador de complemento a 2 de 12 bits
library IEEE;
use IEEE.std_logic_1164.all;

entity sumador_a2 is
    port (
        A : in std_logic_vector(11 downto 0);
        B : in std_logic_vector(11 downto 0);
        M : in std_logic; -- Selector
        Suma : out std_logic_vector(11 downto 0);
        Cout : out std_logic;
        V : out std_logic -- Para ver si hay desbordamiento
    );
end entity sumador_a2;

-- Full Adder de 1 bit
architecture rtl1bit of FullAdder is
begin
    Suma <= (A xor B) xor (Cin);
    Cout <= (A and B) xor ((A xor B) and Cin);   
end architecture rtl1bit;

-- Sumador/Restador complemento a 2
architecture rtl of sumador_a2 is
    
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
    signal B_intermedia : std_logic_vector(11 downto 0);
    signal Suma_intermedia : std_logic_vector(11 downto 0);
    signal Cout_intermedia : std_logic_vector(11 downto 0);
    
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
    
    B_intermedia(4) <= B(4) xor M;
    FA4: FullAdder port map (
        A => A(4),
        B => B_intermedia(4),
        Cin => Cout_intermedia(3),
        Suma => Suma_intermedia(4),
        Cout => Cout_intermedia(4)
    );

    B_intermedia(5) <= B(5) xor M;
    FA5: FullAdder port map (
        A => A(5),
        B => B_intermedia(5),
        Cin => Cout_intermedia(4),
        Suma => Suma_intermedia(5),
        Cout => Cout_intermedia(5)
    );

    B_intermedia(6) <= B(6) xor M;
    FA6: FullAdder port map (
        A => A(6),
        B => B_intermedia(6),
        Cin => Cout_intermedia(5),
        Suma => Suma_intermedia(6),
        Cout => Cout_intermedia(6)
    );

    B_intermedia(7) <= B(7) xor M;
    FA7: FullAdder port map (
        A => A(7),
        B => B_intermedia(7),
        Cin => Cout_intermedia(6),
        Suma => Suma_intermedia(7),
        Cout => Cout_intermedia(7)
    );
    
    B_intermedia(8) <= B(8) xor M;
    FA8: FullAdder port map (
        A => A(8),
        B => B_intermedia(8),
        Cin => Cout_intermedia(7),
        Suma => Suma_intermedia(8),
        Cout => Cout_intermedia(8)
    );

    B_intermedia(9) <= B(9) xor M;
    FA9: FullAdder port map (
        A => A(9),
        B => B_intermedia(9),
        Cin => Cout_intermedia(8),
        Suma => Suma_intermedia(9),
        Cout => Cout_intermedia(9)
    );

    B_intermedia(10) <= B(10) xor M;
    FA10: FullAdder port map (
        A => A(10),
        B => B_intermedia(10),
        Cin => Cout_intermedia(9),
        Suma => Suma_intermedia(10),
        Cout => Cout_intermedia(10)
    );

    B_intermedia(11) <= B(11) xor M;
    FA11: FullAdder port map (
        A => A(11),
        B => B_intermedia(11),
        Cin => Cout_intermedia(10),
        Suma => Suma_intermedia(11),
        Cout => Cout_intermedia(11)
    );
    
    -- Verificar si hubo un desborde
    process(Cout_intermedia)
    begin
        if Cout_intermedia(11) /= Cout_intermedia(10) then
            V <= '1'; -- Hubo desbordamiento
            report "Overflow detected"; -- Informar sobre el desbordamiento
        else
            V <= '0'; -- No hubo desbordamiento
        end if;
    end process;
     
    Suma <= Suma_intermedia;
    Cout <= Cout_intermedia(11);

end architecture rtl;