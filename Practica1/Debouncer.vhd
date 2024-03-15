library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity debouncer is
    PORT(
        entrada: in STD_LOGIC;
        cclk: in STD_LOGIC; --Tiene que ser de baja frecuencia
        clr: in STD_LOGIC;
        salida: out STD_LOGIC
    );
end debouncer;

architecture Behavioral of debouncer is
SIGNAL delay1, delay2, delay3: STD_LOGIC;
begin
    process(cclk, clr)
    begin
        if clr = '1' then
            delay1 <= '1';
            delay2 <= '1';
            delay3 <= '1';
        elsif cclk'event and cclk = '1' then
            delay1 <= entrada;
            delay2 <= delay1;
            delay3 <= delay2;
        end if;
    end process;
    salida <= delay1 or delay2 or delay3;            
end Behavioral;