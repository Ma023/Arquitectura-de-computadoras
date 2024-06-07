library IEEE;
use IEEE.STD_LOGIC;
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
        -- ...
        others => "11111111"
    );

    signal RAM : RAM_type;
    signal word_index : INTEGER range 0 to 31;
    signal char_index : INTEGER range 0 to 15;
    signal display_data : STD_LOGIC_VECTOR(15 downto 0);

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
                RAM(0) <= "01100001" & "01011111" & "01100001" & "01011111"; -- Word 1: "abra"
                RAM(1) <= "01101101" & "01011111" & "01110010" & "01011111"; -- Word 2: "mamu"
                RAM(2) <= "01101010" & "01011111" & "01100101" & "01011111"; -- Word 3: "juego"
                RAM(3) <= "01101101" & "01011111" & "01110010" & "01011111"; -- Word 4: "marino"
                RAM(4) <= "01110110" & "01011111" & "01101110" & "01011111"; -- Word 5: "ventilador"
            end if;
        end if;
    end process;

    -- Scrolling mechanism
    process(clk)
    begin
        if rising_edge(clk) then
            if scroll = '1' then
                word_index <= (word_index + 1) mod 31;
                char_index <= 0;
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
            display_data <= RAM(word_index)(char_index + 3 downto char_index);
            char_index <= (char_index + 1) mod 16;
        end if;
    end process;
end Behavioral;