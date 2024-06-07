library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ROM_RAM_Display is
    Port ( clk : in  STD_LOGIC;
           scroll : in  STD_LOGIC;
           segs : out  STD_LOGIC_VECTOR(7 downto 0);
           digits : out  STD_LOGIC_VECTOR(3 downto 0));
end ROM_RAM_Display;

architecture Behavioral of ROM_RAM_Display is
    type ROM_type is array (200 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
    type RAM_type is array (31 downto 0) of STD_LOGIC_VECTOR(15 downto 0);

    constant ROM_Program : ROM_type := (
        -- Inicio
        0 => "00100000", --
        1 => "00100000", --
        2 => "00100000", --
        3 => "00100000", --
        4 => "01000001", -- A
        5 => "01001000", -- H
        6 => "01001111", -- O
        7 => "01010010", -- R
        8 => "01000011", -- C
        9 => "01000001", -- A
        10 => "01000100", -- D
        11 => "01001111", -- O
        --...
        others => "11111111"
    );

    signal RAM : RAM_type := (others => (others => '0'));
    signal word_index : INTEGER range 0 to 31 := 0;
    signal char_index : INTEGER range 0 to 15 := 0;
    signal display_data : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

    component DisplayDriver
        Port ( clk : in  STD_LOGIC;
               data : in  STD_LOGIC_VECTOR(15 downto 0);
               segs : out  STD_LOGIC_VECTOR(7 downto 0);
               digits : out  STD_LOGIC_VECTOR(3 downto 0));
    end component;

begin
    -- Initialize RAM with words
    process(clk)
    begin
        if rising_edge(clk) then
            if word_index = 0 then
                RAM(0) <= "01100001" & "01100010"; -- Word 1: "ab"
                RAM(1) <= "01110010" & "01100001"; -- Word 2: "ra"
                RAM(2) <= "01101101" & "01100001"; -- Word 3: "ma"
                RAM(3) <= "01101101" & "01110101"; -- Word 4: "mu"
                RAM(4) <= "01101010" & "01110101"; -- Word 5: "ju"
                RAM(5) <= "01100101" & "01100111"; -- Word 6: "eg"
                RAM(6) <= "01101111" & "00100000"; -- Word 7: "o "
                RAM(7) <= "01101101" & "01100001"; -- Word 8: "ma"
                RAM(8) <= "01110010" & "01101001"; -- Word 9: "ri"
                RAM(9) <= "01101110" & "01101111"; -- Word 10: "no"
                RAM(10) <= "01110110" & "01100101"; -- Word 11: "ve"
                RAM(11) <= "01101110" & "01110100"; -- Word 12: "nt"
                RAM(12) <= "01101001" & "01101100"; -- Word 13: "il"
                RAM(13) <= "01100001" & "01100100"; -- Word 14: "ad"
                RAM(14) <= "01101111" & "01110010"; -- Word 15: "or"
            end if;
        end if;
    end process;

    -- Scrolling mechanism
    process(clk)
    begin
        if rising_edge(clk) then
            if scroll = '1' then
                word_index <= (word_index + 1) mod 32;
                char_index <= 0;
            else
                char_index <= (char_index + 1) mod 16;
            end if;
        end if;
    end process;

    -- Display driver
    DisplayDriver_inst : DisplayDriver
        Port map ( clk => clk,
                   data => display_data,
                   segs => segs,
                   digits => digits);

    -- Display data generation
    process(clk)
    begin
       if rising_edge(clk) then
            if char_index <= 12 then
                display_data <= RAM(word_index)(char_index + 3 downto char_index);
            elsif char_index < 16 then
                display_data <= RAM(word_index)(15 downto char_index);
            else
                display_data <= RAM((word_index + 1) mod 32)(char_index - 16 downto 0);
            end if;
        end if;
    end process;
end Behavioral;
