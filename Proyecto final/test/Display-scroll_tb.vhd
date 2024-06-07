library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ROM_RAM_Display_tb is
end ROM_RAM_Display_tb;

architecture Behavioral of ROM_RAM_Display_tb is
    -- Component declaration for the Unit Under Test (UUT)
    component ROM_RAM_Display
        Port ( clk : in  STD_LOGIC;
               scroll : in  STD_LOGIC;
               segs : out  STD_LOGIC_VECTOR(7 downto 0);
               digits : out  STD_LOGIC_VECTOR(3 downto 0));
    end component;

    -- Signals to connect to UUT
    signal clk_tb : STD_LOGIC := '0';
    signal scroll_tb : STD_LOGIC := '0';
    signal segs_tb : STD_LOGIC_VECTOR(7 downto 0);
    signal digits_tb : STD_LOGIC_VECTOR(3 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: ROM_RAM_Display
        Port map (
            clk => clk_tb,
            scroll => scroll_tb,
            segs => segs_tb,
            digits => digits_tb
        );

    -- Clock process definitions
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period/2;
            clk_tb <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize Inputs
        scroll_tb <= '0';
        wait for 100 ns;

        -- Apply scroll signal
        scroll_tb <= '1';
        wait for clk_period * 5;
        scroll_tb <= '0';
        wait for clk_period * 15;

        -- Apply scroll signal again
        scroll_tb <= '1';
        wait for clk_period * 5;
        scroll_tb <= '0';
        wait for clk_period * 15;

        -- Stop simulation
        wait;
    end process;

end Behavioral;
