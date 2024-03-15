library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity div_freq is
    port(
        reset, clk: in std_logic;
        clkHlz: out std_logic
    );
end div_freq;

architecture rtl of div_freq is
    signal temp: std_logic:= '0';
    signal conta: integer range 0 to 24999999:=0;
begin
    process(reset,clk) is
    begin
        if (reset='0') then
            temp  <='0';
            conta <= 0;
        elsif(rising_edge(clk)) then
            if(conta=24999999) then
                temp<=not temp;
                conta<=0;
            else
                conta<=conta+1;
            end if;
        end if;
     end process;
     clkHlz<=temp;
end rtl;