library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplicador_por_4 is
    port (
        A : in std_logic_vector(3 downto 0);
        B : in std_logic_vector(3 downto 0);
        Result : out std_logic_vector(9 downto 0)
    );
end entity multiplicador_por_4;

architecture Behavioral of multiplicador_por_4 is
    procedure MultiplyByFourProc(
        A : in std_logic_vector(3 downto 0);
        B : in std_logic_vector(3 downto 0);
        Result : out std_logic_vector(9 downto 0)
    ) is
        variable TempResult : integer range 0 to 900; 
        variable TempResultVec : std_logic_vector(9 downto 0);
    begin
        TempResult := to_integer(unsigned(A)) * to_integer(unsigned(B)) * 4;
        TempResultVec := std_logic_vector(to_unsigned(TempResult, 10));
        Result := TempResultVec; 
    end MultiplyByFourProc;

begin
    process (A, B)
        variable ResultVar : std_logic_vector(9 downto 0); 
    begin
        MultiplyByFourProc(A, B, ResultVar); -- Llamada al procedure
        Result <= ResultVar;
    end process;
end architecture;