library IEEE;
use IEEE.std_logic_1164.all;

--FullAdder 1 byte
entity FullAdder1Byte is
    port(
        A: in std_logic_vector(7 downto 0);
        B: in std_logic_vector(7 downto 0);
        Cin: in std_logic;
        Suma: out std_logic_vector(7 downto 0);
        Cout: out std_logic
    );
end entity FullAdder1Byte;

architecture rtl of FullAdder1Byte is

    component FullAdder
        port(
            A: in std_logic;
            B: in std_logic;
            Cin: in std_logic;
            Suma: out std_logic;
            Cout: out std_logic
        );
    end component;

    signal Suma_intermedia : std_logic_vector(7 downto 0);
    signal Cout_intermedia : std_logic_vector(6 downto 0);

begin

    FA0: FullAdder port map (
        A => A(0),
        B => B(0),
        Cin => Cin,
        Suma => Suma_intermedia(0),
        Cout => Cout_intermedia(0)
    );

    FA1: FullAdder port map (
        A => A(1),
        B => B(1),
        Cin => Cout_intermedia(0),
        Suma => Suma_intermedia(1),
        Cout => Cout_intermedia(1)
    );

    FA2: FullAdder port map (
        A => A(2),
        B => B(2),
        Cin => Cout_intermedia(1),
        Suma => Suma_intermedia(2),
        Cout => Cout_intermedia(2)
    );

    FA3: FullAdder port map (
        A => A(3),
        B => B(3),
        Cin => Cout_intermedia(2),
        Suma => Suma_intermedia(3),
        Cout => Cout_intermedia(3)
    );
    
    FA4: FullAdder port map (
        A => A(4),
        B => B(4),
        Cin => Cout_intermedia(3),
        Suma => Suma_intermedia(4),
        Cout => Cout_intermedia(4)
    );

    FA5: FullAdder port map (
        A => A(5),
        B => B(5),
        Cin => Cout_intermedia(4),
        Suma => Suma_intermedia(5),
        Cout => Cout_intermedia(5)
    );

    FA6: FullAdder port map (
        A => A(6),
        B => B(6),
        Cin => Cout_intermedia(5),
        Suma => Suma_intermedia(6),
        Cout => Cout_intermedia(6)
    );

    FA7: FullAdder port map (
        A => A(7),
        B => B(7),
        Cin => Cout_intermedia(6),
        Suma => Suma_intermedia(7),
        Cout => Cout
    );

    Suma <= Suma_intermedia;

end architecture rtl;

-- Full Adder de 1 bit
architecture rtl1bit of FullAdder is
begin
    Suma <= (A xor B) xor (Cin);
    Cout <= (A and B) xor ((A xor B) and Cin);   
end architecture rtl1bit;
