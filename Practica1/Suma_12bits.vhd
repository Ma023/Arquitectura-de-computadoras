library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity sumador12bits is
    PORT(
        A: in STD_LOGIC_VECTOR(11 downto 0);
        B: in STD_LOGIC_VECTOR(11 downto 0);
        Resultado: out STD_LOGIC_VECTOR(12 downto 0)
);
end entity;

architecture sumador of sumador12bits is
    component SUMADORCOMPLETO is
        port(
            A, B: in std_logic;
            Cin: in std_logic;
            Res: out std_logic
        );
    end component;
    SIGNAL Cout_tmp: STD_LOGIC_VECTOR(11 downto 0);
    SIGNAL Res_tmp: STD_LOGIC_VECTOR(11 downto 0);
    begin
        bit_n: SUMADORCOMPLETO port map(A=>A(0),B=>B(0),Cin=>'0', Res=>Res_tmp(0), Cout=>Cout_tmp(0));
        for_loop: for i in 1 to 11 generate
            bit_n: SUMADORCOMPLETO port map(A(i),B(i),Cout_tmp(i-1), Res_tmp(i), Cout_tmp(i));        
        end generate;
        Resultado <= Cout_tmp(11) & Res_tmp;
    end sumador;
