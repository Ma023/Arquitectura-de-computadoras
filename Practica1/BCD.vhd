library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity bin2bcd9 is
	PORT(
		num_bin: in STD_LOGIC_VECTOR(12 downto 0);
		num_bcd: out STD_LOGIC_VECTOR(15 downto 0)
	);
end bin2bcd9;
architecture Behavioral of bin2bcd9 is
begin
	proceso_bcd: process(num_bin)
	variable z: STD_LOGIC_VECTOR(28 downto 0);
	begin
		z := (others => '0');
		z(15 downto 3):=num_bin;
		for i in 0 to 9 loop
			--Unidades (4 bits).
			if z(16 downto 13) > 4 then
				z(16 downto 13) := z(16 downto 13)+3;
			end if;
			--Decenas (4 bits).
			if z(20 downto 17) > 4 then
				z(20 downto 17) := z(20 downto 17)+3;
			end if;
			--Centenas(4 bits).
			if z(24 downto 21) > 4 then
				z(24 downto 21) := z(24 downto 21)+3;
			end if;			
			--Miles(4 bits).
			if z(28 downto 25) > 4 then
				z(28 downto 25) := z(28 downto 25)+3;
			end if;
			z(28 downto 1) := z(27 downto 0);
		end loop;
		--Pasando datos de variable Z, correspondiente a BCD.
		num_bcd <= z(28 downto 13);
	end process;
end Behavioral;