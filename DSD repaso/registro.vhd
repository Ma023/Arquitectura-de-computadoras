-- Registro PIPO de 12 bits
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Registro_PIPO is
    Port ( 
        Clock : in STD_LOGIC;
        Load : in STD_LOGIC; -- Terminal para cargar datos
        Data_In : in STD_LOGIC_VECTOR (11 downto 0); -- Datos de entrada (A y B)
        Data_Out : out STD_LOGIC_VECTOR (11 downto 0) -- Datos de salida
    );
end Registro_PIPO;

architecture Behavioral of Registro_PIPO is
    signal Registro : STD_LOGIC_VECTOR (11 downto 0); -- Registro interno de 12 bits
begin
    process (Clock)
    begin
        if rising_edge(Clock) then
            if Load = '1' then
                -- Cargar datos en el registro
                Registro <= Data_In;
            end if;
        end if;
    end process;

    -- Salida en paralelo
    Data_Out <= Registro;

end Behavioral;
