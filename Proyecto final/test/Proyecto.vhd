LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY practica IS PORT (
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
            SEDSTDBY : OUT STD_LOGIC);
    END COMPONENT;
    TYPE ROM IS ARRAY (254 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
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
        27 => "00100000", -- a (hace referencia al lugar donde semostrar� las opciones)
        28 => "00100000", --
        29 => "00100000", --
        30 => "00100000", --
        31 => "00100000", --
        --Palabra : e l e c t r i c i d a d
        32 => "01100101", -- e
        33 => "01101100", -- l
        34 => "01011111", -- _
        35 => "01100011", -- c
        36 => "01110100", -- t
        37 => "01011111", -- _
        38 => "01011111", -- i
        39 => "01011111", -- _
        40 => "01011111", -- i
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
        --- Palabra 6: v e n t i l a d o r
        112 => "01110100", -- v
        113 => "01011111", -- _
        114 => "01011111", -- _
        115 => "01110100", -- t
        116 => "01011111", -- i
        117 => "01101100", -- l
        118 => "01011111", -- _
        119 => "01100100", -- d
        120 => "01100011", -- _
        121 => "01110010", -- r
        122 => "00100000", --
        123 => "00100000", --
        124 => "00100000", --
        125 => "00100000", --
        126 => "00100000", --
        127 => "00100000", --
        --- Palabra 7: p r o c e s a d o r
        128 => "01110000", -- p
        129 => "01100101", -- r
        130 => "01011111", -- _
        131 => "01011111", -- _
        132 => "01100100", -- e
        133 => "01110010", -- s
        134 => "01011111", -- _
        135 => "01011111", -- _
        136 => "01011111", -- _
        137 => "01110010", -- r
        138 => "00100000", --
        139 => "00100000", --
        140 => "00100000", --
        141 => "00100000", --
        142 => "00100000", --
        143 => "00100000", --
        --- Palabra 8: m e m o r i a
        144 => "01101101", -- m
        145 => "01011111", -- _
        146 => "01101100", -- m
        147 => "01011111",-- _
        148 => "01110010", -- r
        149 => "01011111", -- _
        150 => "01011111", -- _
        151 => "00100000", --
        152 => "00100000", --
        153 => "00100000", --
        154 => "00100000", --
        155 => "00100000", --
        156 => "00100000", --
        157 => "00100000", --
        158 => "00100000", --
        -- Inicializacion de variables
        -- Inicio: inicia en 0
        159 => "00001011", -- Carga el indice del comienzo de la frase(j)
        160 => "00000001",
        161 => "00000000", -- 0 (j)
        162 => "00001111", -- JUMP a la segunda parte de la funci�n
        163 => "11001100", -- 204
        -- Palabra 1: inicia en 32
        164 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        165 => "00000001",
        166 => "00100000", -- 32 (j)
        167 => "00001111", -- JUMP a la segunda parte de la funci�n
        168 => "11010111", -- 215
        -- Palabra 2: inicia en 48
        169 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        170 => "00000001",
        171 => "00110000", -- 48 (j)
        172 => "00001111", -- JUMP a la segunda parte de la funci�n
        173 => "11010111", -- 215
        -- Palabra 3: inicia en 64
        174 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        175 => "00000001",
        176 => "01000000", -- 64 (j)
        177 => "00001111", -- JUMP a la segunda parte de la funci�n
        178 => "11010111", -- 215
        -- Palabra 4: inicia en 80
        179 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        180 => "00000001",
        181 => "01010000", -- 80 (j)
        182 => "00001111", -- JUMP a la segunda parte de la funci�n
        183 => "11010111", -- 215
        -- Palabra 5: inicia en 96
        184 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        185 => "00000001",
        186 => "01100000", -- 96 (j)
        187 => "00001111", -- JUMP a la segunda parte de la funci�n
        188 => "11010111", -- 215
        --- Palabra 6: inicia en 112
        189 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        190 => "00000001",
        191 => "01110000", -- 112 (j)
        192 => "00001111", -- JUMP a la segunda parte de la función
        193 => "11010111", -- 215
        --- Palabra 7: inicia en 128
        194 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        195 => "00000001",
        196 => "10000000", -- 128 (j)
        197 => "00001111", -- JUMP a la segunda parte de la función
        198 => "11010111", -- 215
        --- Palabra 8: inicia en 144
        199 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        200 => "00000001",
        201 => "10010000", -- 144 (j)
        202 => "00001111", -- JUMP a la segunda parte de la función
        203 => "11010111", -- 215
        --- Segunda Parte: Comienza a cargar la frase a la ram
        --- Inicializacion de variables
        204 => "00001011", -- i = 0
        205 => "00000000", -- RegsABCD(0)
        206 => "00000000", -- 0 (RegsABCD(0))
        207 => "00001011", -- step = 1
        208 => "00000010", -- RegsABCD(2)
        209 => "00000001", -- 1 (RegsABCD(2))
        210 => "00001011", -- size= 32
        211 => "00000011", -- RegsABCD(3)
        212 => "00100000", -- 32 (RegsABCD(3))
        213 => "00001111", -- JUMP a la tercera parte
        214 => "11100000", -- 224
        --- Segunda Parte: Comienza a cargar la palabra a la ram
        --- Inicializacion de variables
        215 => "00001011", -- i = 0
        216 => "00000000", -- RegsABCD(0)
        217 => "00000000", -- 0 (RegsABCD(0))
        218 => "00001011", -- step = 1
        219 => "00000010", -- RegsABCD(2)
        220 => "00000001", -- 1 (RegsABCD(2))
        221 => "00001011", -- size= 16
        222 => "00000011", -- RegsABCD(3)
        223 => "00010000", -- 16 (RegsABCD(3))
        --- Tercera Parte: Ciclo para cargar la palabra o frase a la RAMdesde la ROM
        224 => "11100000", -- ROM(j) to RAM(i)
        225 => "00000000", -- dest ram i(RegsABCD(0))
        226 => "00000001", -- orig rom j(RegsABCD(1))
        227 => "00000111", -- Suma
        228 => "00000010", -- i + step
        229 => "00001110", -- Guarda el MBR en RegsABCD(0)(A)
        230 => "00000000", -- i = i+1--
        231 => "00000111", -- Suma
        232 => "00010010", -- j + step
        233 => "00001110", -- Guarda el MBR en RegsABCD(1)(B)
        234 => "00000001", -- j = i+1
        235 => "00001000", -- Resta
        236 => "00000011", -- i-size
        237 => "00010000", -- Brach if i - size != 0
        238 => "00001001",
        239 => "11100000", -- 224
        OTHERS => ("11111111")
    );
    -----------------------------------Se�ales para control del Display
    SIGNAL cuenta : STD_LOGIC_VECTOR(15 DOWNTO 0); -- almacena eldato a multiplexar
    ----------------------------------Se�ales auxiliares para el ciclo fetch
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
    SIGNAL estado : ESTADOS;
    SIGNAL RegsABCD : REGISTROS;
    SIGNAL REAUX, REAUX2, REAUX3 : signed(15 DOWNTO 0) := "0000000000000000"; --Auxiliares
    ------------------------------------Se�ales para controlar la LCD
    TYPE CONTROL IS(power_up, initialize, RESETLINE, line1, line2, send);
    TYPE CASO IS (frase, palabra);
    TYPE GAME IS (ini, veri, win, lose);
    SIGNAL state : CONTROL;
    SIGNAL est : CASO;
    SIGNAL juego : GAME;
    SIGNAL bcdSig : STD_LOGIC_VECTOR(11 DOWNTO 0);
    CONSTANT freq : INTEGER := 133; --system clock frequency in MHz
    SIGNAL ptr : NATURAL RANGE 0 TO 16 := 15; -- To keep track of what character weare up to
    SIGNAL line : STD_LOGIC := '1';
    SIGNAL line1Sig : STD_LOGIC_VECTOR(127 DOWNTO 0); -- Guarda lo que se muestra en la linea1 de la LCD
    SIGNAL line2Sig : STD_LOGIC_VECTOR(127 DOWNTO 0); -- Guarda lo que se muestra en la linea2 de la LCD
    SIGNAL contaux, contaux2 : INTEGER := 97;
    SIGNAL mov_pc : STD_LOGIC := '0'; -- Se�al auxiliar para poder controlar el PCdesde el juego
    SIGNAL auxV : STD_LOGIC_VECTOR(2 DOWNTO 0); -- Guarda las vidas que tiene eljugador
    SIGNAL auxP : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11111111"; -- Guarda la letraseleccionada por el usuario
    SIGNAL auxP1, auxP2 : STD_LOGIC_VECTOR(87 DOWNTO 0); -- Se�ales para la verificacion de la palabra
    -----------------------------------------------------Senales de reloj
    SIGNAL CLK : STD_LOGIC;
    CONSTANT max_count_lett2 : INTEGER := 5319600; --numero maximo para lacuenta
    SIGNAL count_lett2 : INTEGER RANGE 0 TO max_count_lett2; --llevara la cuentahasta el 4433000
    SIGNAL clk_lett2 : STD_LOGIC := '0'; --senal para el clock a120 ms
    CONSTANT max_count_lett : INTEGER := 69; --numero maximo para lacuenta
    --constant max_count_lett: INTEGER := 11082500; --numero maximo parala cuenta
    SIGNAL count_lett : INTEGER RANGE 0 TO max_count_lett; --llevara la cuentahasta el 692656 || 11082500
    SIGNAL clk_lett : STD_LOGIC := '0'; --senal para el clockde las letras de la LCD
    CONSTANT max_count_med : INTEGER := 10000; --numero maximo para lacuenta
    SIGNAL count_med : INTEGER RANGE 0 TO max_count_med; --llevara la cuentahasta el 10000
    SIGNAL clk_med : STD_LOGIC := '0'; --senal para el clockmedio
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

ControlUnit : PROCESS (Reset, PC, IR, CLK_lett, mov_pc)
BEGIN
    PC1 <= PC + 1;
    PC2 <= PC + 2;
    IF (Reset = '0') THEN
        estado <= Fetch;
        flags <= "0000";
        -- comp <= "000";
        IR <= (OTHERS => '0');
        REAUX <= (OTHERS => '0');
        REAUX2 <= (OTHERS => '0');
        MBR <= (OTHERS => '0');
        RegsABCD <= (OTHERS => "0000000000000000");
        PC <= 159;
    ELSIF (CLK_lett'event AND CLK_lett = '1') THEN
        -- elsif (CLK'event and CLK = '1' and IR /="11111111")then
        IF (mov_pc = '1') THEN
            CASE (contaux2) IS
                WHEN 97 =>
                    PC <= 164;
                    estado <= Fetch;
                WHEN 98 =>
                    PC <= 169;
                    estado <= Fetch;
                WHEN 99 =>
                    PC <= 174;
                    estado <= Fetch;
                WHEN 100 =>
                    PC <= 179;
                    estado <= Fetch;
                WHEN 101 =>
                    PC <= 184;
                    estado <= Fetch;
                WHEN 102 =>
                    PC <= 189;
                    estado <= Fetch;
                WHEN 103 =>
                    PC <= 194;
                    estado <= Fetch;
                WHEN OTHERS =>
                PC <= 199;
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
                ELSIF (IR = "00001100") THEN
                    -- Cargar Dato de ROM_prog a RegsABCD
                    RegsABCD(to_integer(unsigned(MAR(7
                    DOWNTO 4)))) <= "00000000" & ROM_program(to_integer(unsigned(MAR(1 DOWNTO 0))));
                    estado <= Fetch;
                    PC <= PC + 2;
                ELSIF (IR = "00001101") THEN
                    -- Copiar Registro(orig) a Registro(dest)
                    RegsABCD(to_integer(unsigned(MAR(7
                    DOWNTO 4)))) <= RegsABCD(to_integer(unsigned(MAR(3 DOWNTO 0))));
                    estado <= Fetch;
                    PC <= PC + 2;
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
                        PC <=
                            to_integer(unsigned(ROM_program(PC2)));
                    ELSE
                        PC <= PC + 3;
                    END IF;
                    estado <= Fetch;
                ELSIF (IR = "00010001") THEN
                    -- Comparador
                ELSIF (IR = "00010010") THEN
                    -- Escribir del MBR a la RAM
                    RAM(to_integer(unsigned(MAR))) <=
                    MBR;
                    PC <= PC + 2;
                    estado <= Fetch;
                ELSIF (IR = "00010011") THEN
                    -- Leer de la RAM a RegsABCD
                    RegsABCD(to_integer(unsigned(MAR))) <=
                    RAM( to_integer( unsigned( RegsABCD( to_integer(unsigned( ROM_Program(PC2) )) ) ) ) );
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

ahor : PROCESS (clk_lett2, izq, der, enter, line1Sig, line2Sig, mov_pc,
    contaux2) -- Control del ahorcado
BEGIN
    IF (clk_lett2'EVENT AND clk_lett2 = '1') THEN
        IF (reset = '0') THEN
            est <= frase;
            auxV <= "111";
            auxP <= "11111111";
            contaux <= 97;
            contaux2 <= 97;
        END IF;
        CASE est IS
            WHEN frase =>
                line1Sig <= RAM(0)(7 DOWNTO 0) &
                    RAM(1)(7 DOWNTO 0) &
                    RAM(2)(7 DOWNTO 0) &
                    RAM(3)(7 DOWNTO 0) &
                    RAM(4)(7 DOWNTO 0) &
                    RAM(5)(7 DOWNTO 0) &
                    RAM(6)(7 DOWNTO 0) &
                    RAM(7)(7 DOWNTO 0) &
                    RAM(8)(7 DOWNTO 0) &
                    RAM(9)(7 DOWNTO 0) &
                    RAM(10)(7 DOWNTO 0) &
                    RAM(11)(7 DOWNTO 0) &
                    RAM(12)(7 DOWNTO 0) &
                    RAM(13)(7 DOWNTO 0) &
                    RAM(14)(7 DOWNTO 0) &
                    RAM(15)(7 DOWNTO 0);
                line2Sig <= RAM(16)(7 DOWNTO 0) &
                    RAM(17)(7 DOWNTO 0) &
                    RAM(18)(7 DOWNTO 0) &
                    RAM(19)(7 DOWNTO 0) &
                    RAM(20)(7 DOWNTO 0) &
                    RAM(21)(7 DOWNTO 0) &
                    RAM(22)(7 DOWNTO 0) &
                    RAM(23)(7 DOWNTO 0) &
                    RAM(24)(7 DOWNTO 0) &
                    RAM(25)(7 DOWNTO 0) &
                    RAM(26)(7 DOWNTO 0) &
                    STD_LOGIC_VECTOR(to_unsigned(contaux, IR'length)) &
                    RAM(28)(7 DOWNTO 0) &
                    RAM(29)(7 DOWNTO 0) &
                    RAM(30)(7 DOWNTO 0) &
                    RAM(31)(7 DOWNTO 0);
                IF (izq = '1') THEN
                    IF (contaux = 97) THEN
                        contaux <= 104;
                    ELSE
                        contaux <= contaux - 1;
                    END IF;
                ELSIF (der = '1') THEN
                    IF (contaux = 104) THEN
                        contaux <= 97;
                    ELSE
                        contaux <= contaux + 1;
                    END IF;
                ELSIF (enter = '1') THEN
                    est <= palabra;
                    juego <= ini;
                    line2Sig <= "00100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000";
                    contaux2 <= contaux;
                    contaux <= 97;
                    mov_pc <= '1';
                END IF;
            WHEN palabra =>
                mov_pc <= '0';
                vidas <= auxV;
                auxP2 <= line1Sig(127 DOWNTO 40);
                CASE juego IS
                    WHEN ini =>
                        line1Sig <= RAM(0)(7
                            DOWNTO 0) &
                            RAM(1)(7 DOWNTO 0) &
                            RAM(2)(7 DOWNTO 0) &
                            RAM(3)(7 DOWNTO 0) &
                            RAM(4)(7 DOWNTO 0) &
                            RAM(5)(7 DOWNTO 0) &
                            RAM(6)(7 DOWNTO 0) &
                            RAM(7)(7 DOWNTO 0) &
                            RAM(8)(7 DOWNTO 0) &
                            RAM(9)(7 DOWNTO 0) &
                            RAM(10)(7 DOWNTO 0) &
                            RAM(11)(7 DOWNTO 0) &
                            RAM(12)(7 DOWNTO 0) &
                            RAM(13)(7 DOWNTO 0) &
                            RAM(14)(7 DOWNTO 0) &
                            RAM(15)(7 DOWNTO 0);
                        line2Sig(119 DOWNTO 112) <= STD_LOGIC_VECTOR(to_unsigned(contaux, IR'length));
                    WHEN veri =>
                        CASE (contaux2) IS
                                    --1. 87-80 1ero
                                    --2. 79-72
                                    --3. 71-64
                                    --4. 63-56
                                    --5. 55-48
                                    --6. 47-40
                                    --7. 39-32
                                    --8. 31-24
                                    --9. 23-16
                                    --10. 15-0
                            WHEN 97 =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "01100101011011000110010101100011011101000111001001011111011000110101111101100100011001000110000101100100") THEN--electricidad
                                        juego <= win;
                                    ELSE

                                        IF (auxP = "01100101") THEN -- e
                                            auxP1(71 DOWNTO 64) <= "01100101";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01110010") THEN -- r
                                            auxP1(47 DOWNTO 40) <= "01110010";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01100011") THEN -- c
                                            auxP1(31 DOWNTO 24) <= "01100011";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01100100") THEN -- d
                                            auxP1(15 DOWNTO 8) <= "01100100";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "11111111") THEN
                                            auxP1 <= auxP1;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                        line1Sig(127 DOWNTO 40) <= auxP1;
                                    END IF;
                                ELSE
                                    juego <= lose;
                                END IF;
                            WHEN 98 =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "0110110101100001011011010111010101110100001000000010000000100000001000000010000000100000") THEN -- mamut
                                        line1Sig <= line1Sig;
                                        juego <= win;
                                    ELSE
                                        IF(auxP = "01110100") THEN -- v
                                            auxP1(87 DOWNTO 80) <= "01110100";
                                            auxP <= "11111111";
                                            contaux <= 97;                                        
                                        ELSIF (auxP = "01110010") THEN -- r
                                            auxP1(71 DOWNTO 64) <= "01110010";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01100101") THEN -- e
                                            auxP1(55 DOWNTO 48) <= "01100101";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "11111111") THEN
                                            auxP1 <= auxP1;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                        line1Sig(127 DOWNTO 40) <= auxP1;
                                    END IF;
                                    ELSE
                                        juego <= lose;
                                END IF;
                            WHEN 99 =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "0110101001110101011001010110011101101111001000000010000000100000001000000010000000100000") THEN -- juego
                                        line1Sig <= line1Sig;
                                        juego <= win;
                                    ELSE
                                        IF (auxP = "01011111") THEN -- i
                                            auxP1(79 DOWNTO 72) <= "01011111";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01110010") THEN -- r
                                            auxP1(63 DOWNTO 56) <= "01110010";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "11111111") THEN
                                            auxP1 <= auxP1;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                        line1Sig(127 DOWNTO 40) <= auxP1;
                                    END IF;
                                    ELSE
                                        juego <= lose;
                                END IF;
                            WHEN 100 =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "0111011001100101011011100111010001101001011011000110000101100100011011110111001000100000") THEN -- ventilador
                                        juego <= win;
                                    ELSE
                                        IF (auxP = "01101111") THEN -- o
                                            auxP1(79 DOWNTO 72) <= "01101111";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        -- Falta este
                                        ELSIF (auxP = "01110101") THEN -- u
                                            auxP1(55 DOWNTO 48) <= "01110101";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                        line1Sig(127 DOWNTO 40) <= auxP1;
                                    END IF;
                                    ELSE
                                        juego <= lose;
                                END IF;
                            WHEN 101 =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "0110110101100001011100100110100101101110011011110010000000100000001000000010000000100000") THEN -- marino
                                        line1Sig <= line1Sig;
                                        juego <= win;
                                    ELSE
                                        IF (auxP = "01100001") THEN -- a
                                            auxP1(79 DOWNTO 72) <= "01100001";
                                            auxP1(39 DOWNTO 32) <= "01100001";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        -- Falta este
                                        ELSIF (auxP = "01110101") THEN -- u
                                            auxP1(63 DOWNTO 56) <= "01110101";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01101110") THEN -- n
                                            auxP1(55 DOWNTO 48) <= "01101110";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01101111") THEN -- o
                                            auxP1(23 DOWNTO 16) <= "01101111";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "11111111") THEN
                                            auxP1 <= auxP1;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                    END IF;
                                        line1Sig(127 DOWNTO 40) <= auxP1;
                                END IF;
                            WHEN 102 =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "0110110101100001011100100110100101101110011011110010000000100000001000000010000000100000") THEN -- marino
                                        line1Sig <= line1Sig;
                                        juego <= win;
                                    ELSE
                                        IF (auxP = "01100101") THEN -- e
                                            auxP1(79 DOWNTO 72) <= "01100101";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01101110") THEN -- n
                                            auxP1(71 DOWNTO 64) <= "01101110";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01100001") THEN -- a
                                            auxP1(39 DOWNTO 32) <= "01100001";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01101111") THEN -- o
                                            auxP1(23 DOWNTO 16) <= "01101111";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "11111111") THEN
                                            auxP1 <= auxP1;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                        line1Sig(127 DOWNTO 40) <= auxP1;
                                    END IF;
                                    ELSE
                                        juego <= lose;
                                END IF;
                            
                            WHEN 103 =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "0110110101100001011100100110100101101110011011110010000000100000001000000010000000100000") THEN -- marino
                                        line1Sig <= line1Sig;
                                        juego <= win;
                                    ELSE
                                        IF (auxP = "01101111") THEN -- o
                                            auxP1(71 DOWNTO 64) <= "01101111";
                                            auxP1(23 DOWNTO 16) <= "01101111";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01100011") THEN -- c
                                            auxP1(63 DOWNTO 56) <= "01100011";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01100001") THEN -- a
                                            auxP1(39 DOWNTO 32) <= "01100001";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01100100") THEN -- d
                                            auxP1(71 DOWNTO 64) <= "01100100";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "11111111") THEN
                                            auxP1 <= auxP1;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                        line1Sig(127 DOWNTO 40) <= auxP1;
                                    END IF;
                                    ELSE
                                        juego <= lose;
                                END IF;          
                            WHEN OTHERS =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "0110110101100001011100100110100101101110011011110010000000100000001000000010000000100000") THEN -- marino
                                        line1Sig <= line1Sig;
                                        juego <= win;
                                    ELSE
                                        IF (auxP = "01100101") THEN -- e
                                            auxP1(79 DOWNTO 72) <= "01100101";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01101111") THEN -- o
                                            auxP1(63 DOWNTO 56) <= "01101111";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01011111") THEN -- i
                                            auxP1(47 DOWNTO 40) <= "01011111";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01100001") THEN -- a
                                            auxP1(39 DOWNTO 32) <= "01100001";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "11111111") THEN
                                            auxP1 <= auxP1;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                        line1Sig(127 DOWNTO 40) <= auxP1;
                                    END IF;
                                    ELSE
                                        juego <= lose;
                                END IF;                   
                        END CASE;
                        line2Sig(119 DOWNTO 112) <= STD_LOGIC_VECTOR(to_unsigned(contaux, IR'length));
                    WHEN win =>
                        line2Sig(119 DOWNTO 56) <=
                        "0100011101000001010011100100000101010011010101000100010111110101";--PalabraGANASTE
                    WHEN lose => line2Sig(119 DOWNTO 48) <= "010000010100100001001111010100100100001101000001010001000100111111101111";--Palabra AHORCADO
                END CASE;
            IF (izq = '1') THEN
                IF (contaux = 97) THEN
                    contaux <= 104;
                ELSE
                    contaux <= contaux - 1;
                END IF;
            ELSIF (der = '1') THEN
                IF (contaux = 104) THEN
                    contaux <= 97;
                ELSE
                    contaux <= contaux + 1;
                END IF;
            ELSIF (enter = '1') THEN
                juego <= veri;
                auxP <=
                    STD_LOGIC_VECTOR(to_unsigned(contaux, IR'length));
                auxP1 <= line1Sig(127 DOWNTO 40); --Se le asigna la palabra a la cual se irá modificando
            END IF;
        END CASE;
    END IF;
END PROCESS ahor;

regALU : PROCESS (IR, REAUX, REAUX2) -- ALU
    VARIABLE shift : STD_LOGIC_VECTOR(15 DOWNTO 0);
    VARIABLE desplazamientos : INTEGER;
BEGIN
    CASE IR IS
        WHEN "00000001" => ACC <= STD_LOGIC_VECTOR(NOT REAUX);
        WHEN "00000010" => ACC <= STD_LOGIC_VECTOR(REAUX AND
            REAUX2);
        WHEN "00000011" => ACC <= STD_LOGIC_VECTOR((NOT REAUX) +
            1);
        WHEN "00000100" => ACC <= STD_LOGIC_VECTOR(REAUX OR
            REAUX2);
        WHEN "00000111" => ACC <= STD_LOGIC_VECTOR(REAUX + REAUX2);
            --S U M A
            veriBandera(ACC, STD_LOGIC_VECTOR(REAUX), STD_LOGIC_VECTOR(REAUX2), bandera
            );
        WHEN "00001000" => -- REAUX3 <= REAUX-REAUX2;
            --R E S T A
            REAUX3(14 DOWNTO 0) <= (NOT REAUX2(14 DOWNTO 0)) +
            1; --complemento a 2
            IF ((REAUX(14) XOR REAUX3(14)) = '1') THEN
                ACC <= STD_LOGIC_VECTOR(REAUX - REAUX2);
                veriBandera(ACC, STD_LOGIC_VECTOR(REAUX), STD_LOGIC_VECTOR(REAUX2), bandera
                );
            ELSE
                ACC <= STD_LOGIC_VECTOR(((NOT
                    REAUX) + 1) + REAUX2);
                REAUX3 <= REAUX + ((NOT REAUX2) + 1);
                veriBandera(STD_LOGIC_VECTOR(REAUX3), STD_LOGIC_VECTOR(REAUX), STD_LOGIC_VECTOR((NOT REAUX2) + 1), bandera);
            END IF;
        WHEN OTHERS => ACC <= (OTHERS => '0');
    END CASE;
END PROCESS;

contLCD : PROCESS (clk, reset, line1Sig, line2Sig, dispmode) -- Interfaz de la LCD
    VARIABLE count : INTEGER := 0;
BEGIN
    IF (Reset = '0') THEN
        state <= power_up;
    ELSIF (clk'EVENT AND clk = '1') THEN
        CASE state IS
            WHEN power_up => --wait 50 ms to ensure Vddhas risen and required LCD wait is met
                IF (count < (50000 * freq)) THEN --wait50 ms
                    count := count + 1;
                    state <= power_up;
                ELSE --power-up complete
                    count := 0;
                    RS <= '0';
                    RW <= '0';
                    DB <= "00110000";
                    state <= initialize;
                END IF;
            WHEN initialize => --cycle throughinitialization sequence
                count := count + 1;
                IF (count < (10 * freq)) THEN --function set
                    DB <= "00111100"; --2-linemode, display on
                    E <= '1';
                    state <= initialize;
                ELSIF (count < (60 * freq)) THEN --wait50 us
                    DB <= "00000000";
                    E <= '0';
                    state <= initialize;
                ELSIF (count < (70 * freq)) THEN --display on/off control
                    DB <= "00001100"; --display on, cursor off, blink off
                    E <= '1';
                    state <= initialize;
                ELSIF (count < (120 * freq)) THEN --wait50 us
                    DB <= "00000000";
                    E <= '0';
                    state <= initialize;
                ELSIF (count < (130 * freq)) THEN --display clear
                    DB <= "00000001";
                    E <= '1';
                    state <= initialize;
                ELSIF (count < (2130 * freq)) THEN --wait2 ms
                    DB <= "00000000";
                    E <= '0';
                    state <= initialize;
                ELSIF (count < (2140 * freq)) THEN --entrymode set
                    DB <= "00000110"; --incrementmode, entire shift off
                    E <= '1';
                    state <= initialize;
                ELSIF (count < (2200 * freq)) THEN --wait60 us
                    DB <= "00000000";
                    E <= '0';
                    state <= initialize;
                ELSE --initialization complete
                    count := 0;
                    state <= RESETLINE;
                END IF;
            WHEN RESETLINE =>
                ptr <= 16;
                IF line = '1' THEN
                    DB <= "10000000";
                    RS <= '0';
                    RW <= '0';
                    count := 0;
                    state <= send;
                ELSE
                    DB <= "11000000";
                    RS <= '0';
                    RW <= '0';
                    count := 0;
                    state <= send;
                END IF;
            WHEN line1 =>
                line <= '1';
                IF dispmode = '1' AND (ptr = 6 OR ptr = 7
                    ) THEN
                    IF ptr = 7 THEN
                        DB <= "0011" & bcdsig(7
                            DOWNTO 4);
                    ELSE
                        DB <= "0011" & bcdsig(3
                            DOWNTO 0);
                    END IF;
                ELSE
                    DB <= line1Sig(ptr * 8 + 7 DOWNTO
                        ptr * 8);
                END IF;
                RS <= '1';
                RW <= '0';
                count := 0;
                line <= '1';
                state <= send;
            WHEN line2 =>
                line <= '0';
                DB <= line2Sig(ptr * 8 + 7 DOWNTO ptr * 8);
                RS <= '1';
                RW <= '0';
                count := 0;
                state <= send;
            WHEN send => --send instruction to lcd
                IF (count < (50 * freq)) THEN --do notexit for 50us
                    IF (count < freq) THEN --negative enable
                        E <= '0';
                    ELSIF (count < (14 * freq)) THEN --positive enable half-cycle
                        E <= '1';
                    ELSIF (count < (27 * freq)) THEN --negative enable half-cycle
                        E <= '0';
                    END IF;
                    count := count + 1;
                    state <= send;
                ELSE
                    count := 0;
                    IF line = '1' THEN
                        IF ptr = 0 THEN
                            line <= '0';
                            state <= resetline;
                        ELSE
                            ptr <= ptr - 1;
                            state <= line1;
                        END IF;
                    ELSE
                        IF ptr = 0 THEN
                            line <= '1';
                            state <= resetline;
                        ELSE
                            ptr <= ptr - 1;
                            state <= line2;
                        END IF;
                    END IF;
                END IF;
        END CASE;
    END IF;
END PROCESS contLCD;
END programa;