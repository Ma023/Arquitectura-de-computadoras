library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Multiplexor is
    PORT(
        entrada1: in std_logic_vector(3 downto 0);
        entrada2: in std_logic_vector(3 downto 0);
        entrada3: in std_logic_vector(3 downto 0);
        entrada4: in std_logic_vector(3 downto 0);
        Reloj: in std_logic;
        Displays: out std_logic_vector(3 downto 0);
        Segmentos: out std_logic_vector(6 downto 0)
    );
end Multiplexor;

architecture Multi of Multiplexor is
    COMPONENT decodificador7seg
        Port(
            vectorEntrada: in STD_LOGIC_VECTOR(3 downto 0);
            selector: in STD_LOGIC;
            vectorSegmentos: out STD_LOGIC_VECTOR(6 downto 0)
        );
    end COMPONENT;
    SIGNAL Cuenta: integer range 0 to 100000;
    signal Seleccion: std_logic_vector(1 downto 0):="00";
    signal Mostrar: std_logic_vector(3 downto 0):="1110";
    signal tmp: std_logic;
    signal tmp_seg : std_logic_vector(3 downto 0) :="1110";

begin
    uut: decodificador7seg PORT MAP(
        vectorEntrada=>tmp_seg,
        selector=>'1',
        vectorSegmentos=>Segmentos
    );
    Conteo_clk: Process(Reloj)
    begin
        if rising_edge(Reloj) then
            if Cuenta < 100 then
                Cuenta <= Cuenta+1;
            else
                Seleccion<=Seleccion+1;
                Cuenta<=0;
            end if;
        end if;
    end Process;

    Mostrar_displays: process(Seleccion)
    begin
	Mostrar <= Mostrar(0) & Mostrar(3 downto 1); 
       case Mostrar is
            when "1110" => tmp_seg <= entrada1;
            when "1101" => tmp_seg <= entrada2;
            when "1011" => tmp_seg <= entrada3;
            when "0111" => tmp_seg <= entrada4;
            when others => tmp_seg <= "1111";
	end case;  
    end process;
    


    Displays <= Mostrar;
    --Segmentos <= "1000000";
end Multi;
