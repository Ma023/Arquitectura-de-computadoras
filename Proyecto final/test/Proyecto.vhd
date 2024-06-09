LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY practica IS PORT (
    -- clk_0: inout std_logic;
    Reset, izq, der, enter : IN STD_LOGIC;
    DB : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    RS, RW, E : OUT STD_LOGIC;
    flags : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- N V Z C
    vidas : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END practica;

ARCHITECTURE programa OF practica IS
    COMPONENT OSCH
        GENERIC (NOM_FREQ : STRING := "44.33");--frecuencia dada
        PORT (
            STDBY : IN STD_LOGIC;
            OSC : OUT STD_LOGIC;
            SEDSTDBY : OUT STD_LOGIC
            );
    END COMPONENT;

    TYPE ROM IS ARRAY (200 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    TYPE ram_type IS ARRAY (31 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL RAM : ram_type;

    CONSTANT ROM_Program : ROM := (
        --- Inicio
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
        12 => "00100000", --
        13 => "00100000", --
        14 => "00100000", --
        15 => "00100000", --
        16 => "01010011", -- S
        17 => "01100101", -- e
        18 => "01101100", -- l
        19 => "00101110", -- .
        20 => "00100000", --
        21 => "01010000", -- P
        22 => "01100001", -- a
        23 => "01101100", -- l
        24 => "00101110", -- .
        25 => "00111010", -- :
        26 => "00100000", --
        27 => "00100000", -- a (hace referencia al lugar donde se mostrará las opciones)
        28 => "00100000", --
        29 => "00100000", --
        30 => "00100000", --
        31 => "00100000", --
        --Palabra : e l e c t r i c i d a d
        32 => "01100101", -- e
        33 => "01011111", -- _
        34 => "01011111", -- _
        35 => "01100011", -- c
        36 => "01011111", -- _
        37 => "01110010", -- r
        38 => "01011111", -- _
        39 => "01100011", -- c
        40 => "01011111", -- _
        41 => "01011111", -- _
        42 => "01100001", -- a
        43 => "01100100", -- d
        44 => "00100000", --
        45 => "00100000", --
        46 => "00100000", --
        47 => "00100000", --
        --- Palabra 2: v e r d e
        48 => "01011111", -- _
        49 => "01100101", -- e
        50 => "01011111", -- _
        51 => "01100100", -- d
        52 => "01011111", -- _
        53 => "00100000", --
        54 => "00100000", --
        55 => "00100000", --
        56 => "00100000", --
        57 => "00100000", --
        58 => "00100000", --
        59 => "00100000", --
        60 => "00100000", --
        61 => "00100000", --
        62 => "00100000", --
        63 => "00100000", --
        --- Palabra 3: l i b r o
        64 => "01101100", -- l
        65 => "01011111", -- _
        66 => "01100010", -- b
        67 => "01011111", -- _
        68 => "01101111", -- o
        69 => "00100000", --
        70 => "00100000", --
        71 => "00100000", --
        72 => "00100000", --
        73 => "00100000", --
        74 => "00100000", --
        75 => "00100000", --
        76 => "00100000", --
        77 => "00100000", --
        78 => "00100000", --
        79 => "00100000", --
        --- Palabra 4: b o s q u e
        80 => "01100010", -- b
        81 => "01011111", -- _
        82 => "01110011", -- s
        83 => "01110001", -- q
        84 => "01011111", -- _
        85 => "01100101", -- e
        86 => "00100000", --
        87 => "00100000", --
        88 => "00100000", --
        89 => "00100000", --
        90 => "00100000", --
        91 => "00100000", --
        92 => "00100000", --
        93 => "00100000", --
        94 => "00100000", --
        95 => "00100000", --
        --- Palabra 5: c a l c u l a d o r a
        96 => "01100011", -- c
        97 => "01011111", -- _
        98 => "01101100", -- l
        99 => "01100011", -- c
        100 => "01011111", -- _
        101 => "01101100", -- l
        102 => "01011111", -- _
        103 => "01100100", -- d
        104 => "01011111", -- _
        105 => "01110010", -- r
        106 => "01100001", -- a
        107 => "00100000", --
        108 => "00100000", --
        109 => "00100000", --
        110 => "00100000", --
        111 => "00100000", --
        -- Inicializacion de variables
        -- Inicio: inicia en 0
        112 => "00001011", -- Carga el indice del comienzo de la frase(j)
        113 => "00000001",
        114 => "00000000", -- 0 (j)
        115 => "00001111", -- JUMP a la segunda parte de la función
        116 => "10001110", -- 142
        -- Palabra 1: inicia en 32
        117 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        118 => "00000001",
        119 => "00100000", -- 32 (j)
        120 => "00001111", -- JUMP a la segunda parte de la funci�n
        121 => "10011001", -- 153
        -- Palabra 2: inicia en 48
        122 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        123 => "00000001",
        124 => "00110000", -- 48 (j)
        125 => "00001111", -- JUMP a la segunda parte de la funci�n
        126 => "10011001", -- 153
        -- Palabra 3: inicia en 64
        127 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        128 => "00000001",
        129 => "01000000", -- 64 (j)
        130 => "00001111", -- JUMP a la segunda parte de la funci�n
        131 => "10011001", -- 153
        -- Palabra 4: inicia en 80
        132 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        133 => "00000001",
        134 => "01010000", -- 80 (j)
        135 => "00001111", -- JUMP a la segunda parte de la funci�n
        136 => "10011001", -- 153
        -- Palabra 5: inicia en 96
        137 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        138 => "00000001",
        139 => "01100000", -- 96 (j)
        140 => "00001111", -- JUMP a la segunda parte de la funci�n
        141 => "10011001", -- 153
        --- Segunda Parte: Comienza a cargar la frase a la ram
        --- Inicializacion de variables
        142 => "00001011", -- i = 0
        143 => "00000000", -- RegsABCD(0)
        144 => "00000000", -- 0
        145 => "00001011", -- step = 1
        146 => "00000010", -- RegsABCD(2)
        147 => "00000001", -- 1
        148 => "00001011", -- size= 32
        149 => "00000011", -- RegsABCD(3)
        150 => "00100000", -- 32
        151 => "00001111", -- JUMP a la tercera parte
        152 => "10100010", -- 162
        --- Segunda Parte: Comienza a cargar la palabra a la ram
        --- Inicializacion de variables
        153 => "00001011", -- i = 0
        154 => "00000000", -- RegsABCD(0)
        155 => "00000000", -- 0
        156 => "00001011", -- step = 1
        157 => "00000010", -- RegsABCD(2)
        158 => "00000001", -- 1
        159 => "00001011", -- size= 16
        160 => "00000011", -- RegsABCD(3)
        161 => "00010000", -- 16 (No necesita saltar a la tercera parteporque est�n adyacentes)
        --- Tercera Parte: Ciclo para cargar la palabra o frase a la RAM desde la ROM
        162 => "00010100", -- ROM(j) to RAM(i)
        163 => "00000000", -- dest ram i(RegsABCD(0))
        164 => "00000001", -- orig rom j(RegsABCD(1))
        165 => "00000111", -- Suma
        166 => "00000010", -- i + step
        167 => "00001110", -- Guarda el MBR en RegsABCD(0)(A)
        168 => "00000000", -- i = i+1--
        169 => "00000111", -- Suma
        170 => "00010010", -- j + step
        171 => "00001110", -- Guarda el MBR en RegsABCD(1)(B)
        172 => "00000001", -- j = i+1
        173 => "00001000", -- Resta
        174 => "00000011", -- i-size
        175 => "00010000", -- Brach if i - size != 0
        176 => "00001001",
        177 => "10100010", -- Go to 162
        OTHERS => ("11111111")
    );
    -----------------------------------Señales para control del Display
    SIGNAL cuenta : STD_LOGIC_VECTOR(15 DOWNTO 0); -- almacena el dato a multiplexar
    ----------------------------------Señales auxiliares para el ciclo fetch
    SIGNAL bandera : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
    --signal comparador: std_logic_vector (2 downto 0) := (OTHERS => '0');
    SIGNAL PC1, PC2 : INTEGER;
    ------------------------------------Registros de proposito especifico
    SIGNAL dispmode : STD_LOGIC;
    SIGNAL PC : INTEGER := 0;
    SIGNAL MAR, IR : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
    SIGNAL MBR, ACC : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
    ----------------------------------------Registros de entrada a la ALU
    TYPE REGISTROS IS ARRAY (15 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    TYPE ESTADOS IS (Fetch, Decode, Execute);
    SIGNAL estado : ESTADOS := Fetch;
    SIGNAL RegsABCD : REGISTROS;
    SIGNAL REAUX, REAUX2, REAUX3 : signed(15 DOWNTO 0) := "0000000000000000"; --Auxiliares
    ------------------------------------Señales para controlar la LCD
    TYPE CONTROL IS(power_up, initialize, RESETLINE, line1, line2, send);
    TYPE CASO IS (frase, palabra);
    TYPE GAME IS (ini, veri, win, lose);
    SIGNAL contaux, contaux2 : INTEGER := 97;
    SIGNAL mov_pc : STD_LOGIC := '0'; -- Señal auxiliar para poder controlar el PC desde el juego
    -----------------------------------------------------Señales de reloj
    SIGNAL CLK : STD_LOGIC;
    CONSTANT max_count_lett2 : INTEGER := 5319600; --numero maximo para la cuenta
    SIGNAL count_lett2 : INTEGER RANGE 0 TO max_count_lett2; --llevara la cuenta hasta el 4433000
    SIGNAL clk_lett2 : STD_LOGIC := '0'; --senal para el clock a 120 ms
    CONSTANT max_count_lett : INTEGER := 69; --numero maximo para la cuenta
    SIGNAL count_lett : INTEGER RANGE 0 TO max_count_lett; --llevara la cuenta hasta el 692656 || 11082500
    SIGNAL clk_lett : STD_LOGIC := '0'; --señal para el clock de las letras de la LCD
    CONSTANT max_count_med : INTEGER := 10000; --numero maximo para la cuenta
    SIGNAL count_med : INTEGER RANGE 0 TO max_count_med; --llevara la cuenta hasta el 10000
    SIGNAL clk_med : STD_LOGIC := '0'; --señal para el clock medio
    -----------------------------------------------------
    
    
    PROCEDURE veriBandera(a, x, y : IN STD_LOGIC_VECTOR(15 DOWNTO 0); SIGNAL bandera : 
    OUT STD_LOGIC_VECTOR(3 DOWNTO 0)) IS

BEGIN
    IF (a(14) = '1') THEN --Negative
        bandera(3) <= '1';
    ELSE
        bandera(3) <= '0';
    END IF;
    bandera(2) <= a(14) XOR x(14) XOR y(14) XOR a(15); --Overflow
    IF (a(14 DOWNTO 0) = "000000000000000") THEN --Zero
        bandera(1) <= '1';
    ELSE
        bandera(1) <= '0';
    END IF;
    IF (a(15) = '1') THEN --Carry
        bandera(0) <= '1';
    ELSE
        bandera(0) <= '0';
    END IF;
END veriBandera;


BEGIN

OSCInst0 : OSCH
GENERIC MAP(NOM_FREQ => "44.33")
PORT MAP(STDBY => '0', OSC => CLK, SEDSTDBY => OPEN);


gen_clk_medio : PROCESS (CLK) --reduccion del clock de 44.33 MHz

BEGIN
    IF (CLK'event AND CLK = '1') THEN
        IF (count_med < max_count_med) THEN
            count_med <= count_med + 1;
        ELSE
            clk_med <= NOT clk_med;
            count_med <= 0;
        END IF;
    END IF;
END PROCESS gen_clk_medio;


gen_clk_lett : PROCESS (CLK) --reduccion del clock de 44.33 MHz
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


gen_clk_lett2 : PROCESS (CLK) --reduccion del clock de 44.33 MHz a 120 ms
BEGIN
    IF (CLK'event AND CLK = '1') THEN
        IF (count_lett2 < max_count_lett2) THEN
            count_lett2 <= count_lett2 + 1;
        ELSE
            clk_lett2 <= NOT clk_lett2;
            count_lett2 <= 0;
        END IF;
    END IF;
END PROCESS gen_clk_lett2;

dispmode <= RegsABCD(15)(0);

ControlUnit : PROCESS (Reset, PC, IR, CLK, mov_pc)
BEGIN
    PC1 <= PC + 1;
    PC2 <= PC + 2;
    IF (Reset = '1') THEN
        estado <= Fetch;
        flags <= "0000";
        -- comp <= "000";
        IR <= (OTHERS => '0');
        REAUX <= (OTHERS => '0');
        REAUX2 <= (OTHERS => '0');
        MBR <= (OTHERS => '0');
        RegsABCD <= (OTHERS => "0000000000000000");
        PC <= 112;
    ELSIF (CLK'event AND CLK = '1') THEN
        -- elsif (CLK'event and CLK = '1' and IR /="11111111")then
        IF (mov_pc = '1') THEN
            CASE (contaux2) IS
                WHEN 97 =>
                    PC <= 117;
                    estado <= Fetch;
                WHEN 98 =>
                    PC <= 122;
                    estado <= Fetch;
                WHEN 99 =>
                    PC <= 127;
                    estado <= Fetch;
                WHEN 100 =>
                    PC <= 132;
                    estado <= Fetch;
                WHEN OTHERS =>
                    PC <= 137;
                    estado <= Fetch;
            END CASE;
        END IF;
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
                    -- Cargar Num a RegsABCD
                    RegsABCD(to_integer(unsigned(MAR))) <= "00000000" & ROM_program(PC2);
                    PC <= PC + 3;
                    estado <= Fetch;
                ELSIF (IR = "00001110") THEN
                    -- Copiar del MBR al Registro(dest)
                    RegsABCD(to_integer(unsigned(MAR))) <= MBR;
                    estado <= Fetch;
                    PC <= PC + 2;
                ELSIF (IR = "00001111") THEN
                    -- Jump a una direccion
                    estado <= Fetch;
                    PC <= to_integer(unsigned(MAR));
                ELSIF (IR = "00010000") THEN
                    -- Branch (jump con condicion)
                    IF ((MAR(3 DOWNTO 0) XOR
                        bandera) = "0000") THEN
                        PC <= to_integer(unsigned(ROM_program(PC2)));
                    ELSE
                        PC <= PC + 3;
                    END IF;
                    estado <= Fetch;
                ELSIF (IR = "00010001") THEN
                    -- Comparador
                ELSIF (IR = "00010010") THEN
                    -- Escribir del MBR a la RAM
                    RAM(to_integer(unsigned(MAR))) <= MBR;
                    PC <= PC + 2;
                    estado <= Fetch;
                ELSIF (IR = "00010011") THEN
                    -- Leer de la RAM a RegsABCD
                    RegsABCD(to_integer(unsigned(MAR))) <=
                    RAM(to_integer(unsigned(RegsABCD(to_integer(unsigned(ROM_Program(PC2)))))));
                    PC <= PC + 3;
                    estado <= Fetch;
                ELSIF (IR = "00010100") THEN
                    -- Escribir de la ROM a la RAM
                    RAM(to_integer(unsigned(RegsABCD(to_integer(unsigned(MAR)))))) <= "00000000" & ROM_program(to_integer(unsigned(RegsABCD(to_integer(unsigned(ROM_Program(PC2)))))));
                    PC <= PC + 3;
                    estado <= Fetch;
                ELSIF (IR = "00010101") THEN
                    -- Omitir el resto del ciclo fetch
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
    cuenta <= '0' & MBR(14 DOWNTO 0);
END PROCESS;

end ARCHITECTURE;