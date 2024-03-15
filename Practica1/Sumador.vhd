LIBRARY IEEE;
use ieee.std_logic_1164.all;

entity SUMADORCOMPLETO is
	port(A,B,Cin: in std_logic;
		 Res,Cout: out std_logic);
end entity;

architecture arch of SUMADORCOMPLETO is 
	begin 
	Res <= (A xor B) xor Cin;
	Cout <= (A and B) or (A and Cin) or (B and Cin);
end architecture;