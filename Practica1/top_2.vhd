library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity top_program is 
    PORT(
        Reloj: INOUT STD_LOGIC;
        Sw1: in STD_LOGIC_VECTOR(11 downto 0);
        Sw2: in STD_LOGIC_VECTOR(11 downto 0);
        btn: in STD_LOGIC;
        Segmentos: out STD_LOGIC_VECTOR(6 downto 0);
        SelectorDisp: out STD_LOGIC_VECTOR(3 downto 0)
    );
end entity;


architecture Behavioral of top_program is
-------------------------------------------------------------
-- Config clk in Machx02

component OSCH
    generic(NOM_FREQ: string);
    port(
        STDBY: in std_logic; 
        OSC: out std_logic
        );
end component;
-------------------------------------------------------------


COMPONENT sumador12bits is
    PORT(
        A: in STD_LOGIC_VECTOR(11 downto 0);
        B: in STD_LOGIC_VECTOR(11 downto 0);
        Resultado: out STD_LOGIC_VECTOR(12 downto 0)
    );
end COMPONENT;

COMPONENT bin2bcd9 is
    PORT(
		num_bin: in STD_LOGIC_VECTOR(12 downto 0);
		num_bcd: out STD_LOGIC_VECTOR(15 downto 0)
    );
end COMPONENT;

COMPONENT Multiplexor is
    PORT(
        entrada: in std_logic_vector(15 downto 0);
        Reloj_Mux: in std_logic;
        SelectorCC_AC : in std_logic := '0';
        Displays: out std_logic_vector(3 downto 0);
        Segmentos: out std_logic_vector(6 downto 0)
    );
end COMPONENT;

COMPONENT div_freq is
    PORT(
        reset, clk: in std_logic;
        clkHlz: out std_logic
    );
end COMPONENT;

COMPONENT debouncer is
    PORT(
        entrada: in STD_LOGIC;
        cclk: in STD_LOGIC; --Tiene que ser de baja frecuencia
        clr: in STD_LOGIC;
        salida: out STD_LOGIC    
    );
end COMPONENT;

SIGNAL A, B: STD_LOGIC_VECTOR(11 downto 0);
SIGNAL estado: integer := 0;
SIGNAL Resultado_Suma: STD_LOGIC_VECTOR(12 downto 0);
SIGNAL BCD: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL reloj_baja_frec: STD_LOGIC;
SIGNAL btn_filtrado: STD_LOGIC;

begin
-------------------------------------------------------------
-- Config clk in Machx02

    OSCinst0: OSCH
    generic map("26.60")
    port map('0', Reloj);
-------------------------------------------------------------

    uut: sumador12bits port map(
        A,
        B,
        Resultado=>Resultado_Suma
    );
    uut1: bin2bcd9 port map(
		num_bin=>Resultado_Suma,
		num_bcd=>BCD
    );
    uut2: Multiplexor port map(
        entrada=>BCD,
        Reloj_Mux=>Reloj,
        Displays=>SelectorDisp,
        Segmentos=>Segmentos
    );    
    uut3: div_freq port map(
        reset=>'1',
        clk=>Reloj,
        clkHlz=>reloj_baja_frec
    );
    uut4: debouncer port map(
        entrada=> btn,
        cclk=>reloj_baja_frec,
        clr=>'0',
        salida=>btn_filtrado
    );
    --Se toma como que es un active low (1 boton sin presionar, 0 boton presionado)
    process(btn_filtrado)
    begin
        if rising_edge(btn_filtrado) then
            A <= Sw1;
            B <= Sw2;
        end if;
    end process;

end Behavioral;