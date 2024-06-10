LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY practica IS PORT (
    Reset : IN STD_LOGIC;
    flags : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) 
);
END practica;

ARCHITECTURE programa OF practica IS
    COMPONENT OSCH
        GENERIC (NOM_FREQ : STRING := "44.33");
        PORT (
            STDBY : IN STD_LOGIC;
            OSC : OUT STD_LOGIC;
            SEDSTDBY : OUT STD_LOGIC);
    END COMPONENT;
    TYPE ROM IS ARRAY (200 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    TYPE ram_type IS ARRAY (31 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL RAM : ram_type;
    CONSTANT ROM_Program : ROM := (
        
        0 => "00100000", 
        1 => "00100000", 
        2 => "00100000", 
        3 => "00100000", 
        4 => "01000001", 
        5 => "01001000", 
        6 => "01001111", 
        7 => "01010010", 
        8 => "01000011", 
        9 => "01000001", 
        10 => "01000100", 
        11 => "01001111", 
        12 => "00100000", 
        13 => "00100000", 
        14 => "00100000", 
        15 => "00100000", 
        16 => "01010011", 
        17 => "01100101", 
        18 => "01101100", 
        19 => "00101110", 
        20 => "00100000", 
        21 => "01010000", 
        22 => "01100001", 
        23 => "01101100", 
        24 => "00101110", 
        25 => "00111010", 
        26 => "00100000", 
        27 => "00100000", 
        28 => "00100000", 
        29 => "00100000", 
        30 => "00100000", 
        31 => "00100000", 
        
        32 => "01100001", 
        33 => "01011111", 
        34 => "01011111", 
        35 => "01100001", 
        36 => "01011111", 
        37 => "01100001", 
        38 => "01011111", 
        39 => "01100001", 
        40 => "01011111", 
        41 => "01011111", 
        42 => "01100001", 
        43 => "00100000", 
        44 => "00100000", 
        45 => "00100000", 
        46 => "00100000", 
        47 => "00100000", 
        
        48 => "01011111", 
        49 => "01100001", 
        50 => "01011111", 
        51 => "01110101", 
        52 => "01011111", 
        53 => "00100000", 
        54 => "00100000", 
        55 => "00100000", 
        56 => "00100000", 
        57 => "00100000", 
        58 => "00100000", 
        59 => "00100000", 
        60 => "00100000", 
        61 => "00100000", 
        62 => "00100000", 
        63 => "00100000", 
        
        64 => "01101010", 
        65 => "01011111", 
        66 => "01100101", 
        67 => "01011111", 
        68 => "01101111", 
        69 => "00100000", 
        70 => "00100000", 
        71 => "00100000", 
        72 => "00100000", 
        73 => "00100000", 
        74 => "00100000", 
        75 => "00100000", 
        76 => "00100000", 
        77 => "00100000", 
        78 => "00100000", 
        79 => "00100000", 
        
        80 => "01101101", 
        81 => "01011111", 
        82 => "01110010", 
        83 => "01101001", 
        84 => "01011111", 
        85 => "01101111", 
        86 => "00100000", 
        87 => "00100000", 
        88 => "00100000", 
        89 => "00100000", 
        90 => "00100000", 
        91 => "00100000", 
        92 => "00100000", 
        93 => "00100000", 
        94 => "00100000", 
        95 => "00100000", 
        
        96 => "01110110", 
        97 => "01011111", 
        98 => "01101110", 
        99 => "01110100", 
        100 => "01011111", 
        101 => "01101100", 
        102 => "01011111", 
        103 => "01100100", 
        104 => "01011111", 
        105 => "01110010", 
        106 => "00100000", 
        107 => "00100000", 
        108 => "00100000", 
        109 => "00100000", 
        110 => "00100000", 
        111 => "00100000", 
        
        
        112 => "00001011", 
        113 => "00000001",
        114 => "00000000", 
        115 => "00001111", 
        116 => "10001110", 
        
        117 => "00001011", 
        118 => "00000001",
        119 => "00100000", 
        120 => "00001111", 
        121 => "10011001", 
        
        122 => "00001011", 
        123 => "00000001",
        124 => "00110000", 
        125 => "00001111", 
        126 => "10011001", 
        
        127 => "00001011", 
        128 => "00000001",
        129 => "01000000", 
        130 => "00001111", 
        131 => "10011001", 
        
        132 => "00001011", 
        133 => "00000001",
        134 => "01010000", 
        135 => "00001111", 
        136 => "10011001", 
        
        137 => "00001011", 
        138 => "00000001",
        139 => "01100000", 
        140 => "00001111", 
        141 => "10011001", 
        
        
        142 => "00001011", 
        143 => "00000000", 
        144 => "00000000", 
        145 => "00001011", 
        146 => "00000010", 
        147 => "00000001", 
        148 => "00001011", 
        149 => "00000011", 
        150 => "00100000", 
        151 => "00001111", 
        152 => "10100010", 
        
        
        153 => "00001011", 
        154 => "00000000", 
        155 => "00000000", 
        156 => "00001011", 
        157 => "00000010", 
        158 => "00000001", 
        159 => "00001011", 
        160 => "00000011", 
        161 => "00010000", 
        
        162 => "00010100", 
        163 => "00000000", 
        164 => "00000001", 
        165 => "00000111", 
        166 => "00000010", 
        167 => "00001110", 
        168 => "00000000", 
        169 => "00000111", 
        170 => "00010010", 
        171 => "00001110", 
        172 => "00000001", 
        173 => "00001000", 
        174 => "00000011", 
        175 => "00010000", 
        176 => "00001001",
        177 => "10100010", 
        OTHERS => ("11111111")
    );

    SIGNAL bandera : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
    
    SIGNAL PC1, PC2 : INTEGER;
    
    SIGNAL PC : INTEGER := 0;
    SIGNAL MAR, IR : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
    SIGNAL MBR, ACC : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
    
    TYPE REGISTROS IS ARRAY (15 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    TYPE ESTADOS IS (Fetch, Decode, Execute);
    SIGNAL estado : ESTADOS;
    SIGNAL RegsABCD : REGISTROS;
    SIGNAL REAUX, REAUX2, REAUX3 : signed(15 DOWNTO 0) := "0000000000000000"; 
    
    SIGNAL CLK : STD_LOGIC;
    CONSTANT max_count_lett : INTEGER := 69;     
    SIGNAL count_lett : INTEGER RANGE 0 TO max_count_lett; 
    SIGNAL clk_lett : STD_LOGIC := '0'; 


    BEGIN
    OSCInst0 : OSCH
    GENERIC MAP(NOM_FREQ => "44.33")
    PORT MAP(STDBY => '0', OSC => CLK, SEDSTDBY => OPEN);

    gen_clk_lett : PROCESS (CLK) 
    BEGIN
        IF (CLK'event AND CLK = '1') THEN
            IF (count_lett < max_count_lett) THEN
                count_lett <= count_lett + 1;
            ELSE
                clk_lett <= NOT clk_lett;
                count_lett <= 0;
            END IF;
        END IF;
    END PROCESS gen_clk_lett;

    ControlUnit : PROCESS (Reset, PC, IR, CLK_lett)
    BEGIN
        PC1 <= PC + 1;
        PC2 <= PC + 2;
        IF (Reset = '0') THEN
            estado <= Fetch;
            flags <= "0000";
            
            IR <= (OTHERS => '0');
            REAUX <= (OTHERS => '0');
            REAUX2 <= (OTHERS => '0');
            MBR <= (OTHERS => '0');
            RegsABCD <= (OTHERS => "0000000000000000");
            PC <= 112;
        ELSIF (CLK_lett'event AND CLK_lett = '1') THEN
            CASE estado IS
                WHEN Fetch =>
                    IR <= ROM_program(PC);
                    MAR <= ROM_program(PC1);
                    estado <= Decode;
                WHEN Decode =>
                    IF (IR = "11111111") THEN
                        PC <= PC;
                        estado <= Fetch;
                    ELSIF (IR = "00001011") THEN
                        
                        RegsABCD(to_integer(unsigned(MAR))) <= "00000000" & ROM_program(PC2);
                        PC <= PC + 3;
                        estado <= Fetch;
                    ELSIF (IR = "00001100") THEN
                        
                        RegsABCD(to_integer(unsigned(MAR(7
                        DOWNTO 4)))) <= "00000000" & ROM_program(to_integer(unsigned(MAR(1 DOWNTO 0))));
                        estado <= Fetch;
                        PC <= PC + 2;
                    ELSIF (IR = "00001101") THEN
                        
                        RegsABCD(to_integer(unsigned(MAR(7
                        DOWNTO 4)))) <= RegsABCD(to_integer(unsigned(MAR(3 DOWNTO 0))));
                        estado <= Fetch;
                        PC <= PC + 2;
                    ELSIF (IR = "00001110") THEN
                        
                        RegsABCD(to_integer(unsigned(MAR))) <= MBR;
                        estado <= Fetch;
                        PC <= PC + 2;
                    ELSIF (IR = "00001111") THEN
                        
                        estado <= Fetch;
                        PC <= to_integer(unsigned(MAR));
                    ELSIF (IR = "00010000") THEN
                        
                        IF ((MAR(3 DOWNTO 0) XOR
                            bandera) = "0000") THEN
                            PC <=
                                to_integer(unsigned(ROM_program(PC2)));
                        ELSE
                            PC <= PC + 3;
                        END IF;
                        estado <= Fetch;
                    ELSIF (IR = "00010001") THEN
                        
                    ELSIF (IR = "00010010") THEN
                        
                        RAM(to_integer(unsigned(MAR))) <=
                        MBR;
                        PC <= PC + 2;
                        estado <= Fetch;
                    ELSIF (IR = "00010011") THEN
                        
                        RegsABCD(to_integer(unsigned(MAR))) <=
                        RAM(to_integer(unsigned(RegsABCD(to_integer(unsigned(ROM_Program(PC2)))))));
                        PC <= PC + 3;
                        estado <= Fetch;
                    ELSIF (IR = "00010100") THEN
                        
                        RAM(to_integer(unsigned(RegsABCD(to_integer(unsigned(MAR)))))) <= "00000000" & ROM_program(to_integer(unsigned(RegsABCD(to_integer(unsigned(ROM_Program(PC2)))))));
                        PC <= PC + 3;
                        estado <= Fetch;
                    ELSIF (IR = "00010101") THEN
                        
                    ELSIF (IR = "00010110") THEN
                        RegsABCD(15)(0) <= '1';
                        PC <= PC + 1;
                        estado <= Fetch;
                    ELSE
                        REAUX <=
                            signed(RegsABCD(to_integer(unsigned(MAR(7 DOWNTO 4)))));
                        REAUX2 <=
                            signed(RegsABCD(to_integer(unsigned(MAR(3 DOWNTO 0)))));
                        estado <= Execute;
                    END IF;
                WHEN Execute =>
                    MBR <= ACC;
                    flags <= bandera;
                    estado <= Fetch;
                    PC <= PC + 2;
            END CASE;
        END IF;
    END PROCESS;

END programa;
