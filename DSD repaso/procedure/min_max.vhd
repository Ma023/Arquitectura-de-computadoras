library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity comparador is
    port (
        a, b,c : in integer range -256 to 255;
        min, max: out integer range -256 to 255
    );
end entity comparador;

architecture rtl of comparador is
    
    procedure min_max ( signal a,b,c: in integer range -256 to 255;
                        signal min, max: out integer range -256 to 255) is
    begin
        if (a >= b) then
            if (a >= c) then max <= a;
                if (b >= c) then 
                    min <= c;
                    report "valores de min y max actualizados 1" 
                    severity note;
                else 
                    min <= b;
                    report "valores de min y max actualizados 2" 
                    severity note;
                end if;
            else
                max <= c;
                min <= b;
                report "valores de min y max actualizados 3" 
                severity note;
            end if;
        else
            if (b >= c) then max <= b;
                if (a >= c) then 
                    min <= c;
                    report "valores de min y max actualizados 4" 
                    severity note;
                else
                    min <= a;
                    report "valores de min y max actualizados 5" 
                    severity note;
                end if;
            else
                max <= c;
                min <= a;
                report "valores de min y max actualizados 6" 
                severity note;
            end if;
        end if;
    end procedure min_max;


begin
    process(a,b,c)
    begin
        min_max(a, b, c, min, max);
    end process;
end architecture rtl;