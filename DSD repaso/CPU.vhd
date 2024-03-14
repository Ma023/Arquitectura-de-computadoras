library IEEE;
use IEEE.std_logic_1164.all;

entity CPU is
    port (
        clock : in STD_LOGIC;
        load : in STD_LOGIC;
        data_input : in std_logic_vector(11 downto 0);
        seleccion : in std_logic_vector(3 downto 0);
        salida : out std_logic_vector(17 downto 0)
    );
end entity CPU;


-- Arquitectura de la CPU (contiene el registro y la ALU)
architecture rtl of CPU is

    -- Component del registro de 12 bits
    component registro_PIPO 
        port ( 
            Clock : in STD_LOGIC;
            Load : in STD_LOGIC; -- Terminal para cargar datos
            Data_In : in STD_LOGIC_VECTOR (11 downto 0); -- Datos de entrada (A y B)
            Data_Out : out STD_LOGIC_VECTOR (11 downto 0) -- Datos de salida
        );
    end component;

    -- Component de la ALU
    component ALU
        port (
            A : in std_logic_vector(11 downto 0);
            B : in std_logic_vector(11 downto 0);
            seleccion : in std_logic_vector(3 downto 0);
            salida_ALU : out std_logic_vector(17 downto 0)        
        );
    end component;

    signal salida_registro : std_logic_vector(11 downto 0);
    signal salida_ALU : std_logic_vector(17 downto 0);

begin
    registro: registro_PIPO port map(
        Clock => clock,
        Load => load,
        Data_In => data_input,
        Data_Out => salida_registro
    );

    alu_instancia: ALU port map (
        A => salida_registro,
        B => data_input,
        seleccion => seleccion,
        salida_ALU => salida_ALU
    );

    salida <= salida_ALU;
    
end architecture rtl;
