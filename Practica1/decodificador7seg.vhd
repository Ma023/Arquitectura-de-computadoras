library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decodificador7seg is
    Port(
        vectorEntrada: in STD_LOGIC_VECTOR(3 downto 0);
        selector: in STD_LOGIC;
        vectorSegmentos: out STD_LOGIC_VECTOR(6 downto 0)
    );
end decodificador7seg;

architecture Behavioral of decodificador7seg is
    type Segmentos is array (0 to 9) of STD_LOGIC_VECTOR(6 downto 0);
    constant TablaSegmentos: Segmentos := (
        "1000000", -- 0
        "1111001", -- 1
        "0100100", -- 2
        "0110001", -- 3
        "0011001", -- 4
        "0010011", -- 5
        "0000011", -- 6
        "1111000", -- 7
        "0000001", -- 8
        "0001001"  -- 9
    );

begin
    process(vectorEntrada,selector)
    begin
	if to_integer(unsigned(vectorEntrada)) >= 9 then
		vectorSegmentos <= "0000000";
	else
        	if selector = '1' then
  	          vectorSegmentos <= TablaSegmentos(to_integer(unsigned(vectorEntrada)));
        	else
  	          vectorSegmentos <= not TablaSegmentos(to_integer(unsigned(vectorEntrada)));
        	end if;
	end if;
    end process;
end Behavioral;