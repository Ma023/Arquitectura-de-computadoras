LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;


ENTITY practica IS 
    PORT (
        Reset : IN STD_LOGIC;
        sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        DISPLAY : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        flags : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- N V Z C
        comp : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- < = >
        AN : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        blink_LED : out std_logic
        );
END practica;


ARCHITECTURE programa OF practica IS
    COMPONENT OSCH
        GENERIC (NOM_FREQ : STRING := "2.08");  --frecuencia dada
        PORT (
            STDBY : IN STD_LOGIC;
            OSC : OUT STD_LOGIC;
            SEDSTDBY : OUT STD_LOGIC
        );
    END COMPONENT;

    FUNCTION mult5(X : signed; Y : signed) RETURN STD_LOGIC_VECTOR IS
        VARIABLE m1, m2, m3, m4, m5, m6, m7, m8, auxM : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        VARIABLE Aa, Ba : STD_LOGIC_VECTOR(7 DOWNTO 0);

    BEGIN
        IF (X(7) = '1') THEN
            Aa := STD_LOGIC_VECTOR((NOT X(7 DOWNTO 0)) + 1);
        ELSE
            Aa := STD_LOGIC_VECTOR(X(7 DOWNTO 0));
        END IF;

        IF (Y(7) = '1') THEN
            Ba := STD_LOGIC_VECTOR((NOT Y(7 DOWNTO 0)) + 1);
        ELSE
            Ba := STD_LOGIC_VECTOR(Y(7 DOWNTO 0));
        END IF;

        m1(7 DOWNTO 0) := ((Aa(7) AND Ba(0)) & (Aa(6) AND Ba(0)) &
        (Aa(5) AND Ba(0)) & (Aa(4) AND Ba(0)) & (Aa(3) AND Ba(0)) & (Aa(2) AND
        Ba(0)) & (Aa(1) AND Ba(0)) & (Aa(0) AND Ba(0)));

        m2(8 DOWNTO 1) := ((Aa(7) AND Ba(1)) & (Aa(6) AND Ba(1)) &
        (Aa(5) AND Ba(1)) & (Aa(4) AND Ba(1)) & (Aa(3) AND Ba(1)) & (Aa(2) AND
        Ba(1)) & (Aa(1) AND Ba(1)) & (Aa(0) AND Ba(1)));

        m3(9 DOWNTO 2) := ((Aa(7) AND Ba(2)) & (Aa(6) AND Ba(2)) &
        (Aa(5) AND Ba(2)) & (Aa(4) AND Ba(2)) & (Aa(3) AND Ba(2)) & (Aa(2) AND
        Ba(2)) & (Aa(1) AND Ba(2)) & (Aa(0) AND Ba(2)));

        m4(10 DOWNTO 3) := ((Aa(7) AND Ba(3)) & (Aa(6) AND Ba(3)) &
        (Aa(5) AND Ba(3)) & (Aa(4) AND Ba(3)) & (Aa(3) AND Ba(3)) & (Aa(2) AND
        Ba(3)) & (Aa(1) AND Ba(3)) & (Aa(0) AND Ba(3)));

        m5(11 DOWNTO 4) := ((Aa(7) AND Ba(4)) & (Aa(6) AND Ba(4)) &
        (Aa(5) AND Ba(4)) & (Aa(4) AND Ba(4)) & (Aa(3) AND Ba(4)) & (Aa(2) AND
        Ba(4)) & (Aa(1) AND Ba(4)) & (Aa(0) AND Ba(4)));

        m6(12 DOWNTO 5) := ((Aa(7) AND Ba(5)) & (Aa(6) AND Ba(5)) &
        (Aa(5) AND Ba(5)) & (Aa(4) AND Ba(5)) & (Aa(3) AND Ba(5)) & (Aa(2) AND
        Ba(5)) & (Aa(1) AND Ba(5)) & (Aa(0) AND Ba(5)));

        m7(13 DOWNTO 6) := ((Aa(7) AND Ba(6)) & (Aa(6) AND Ba(6)) &
        (Aa(5) AND Ba(6)) & (Aa(4) AND Ba(6)) & (Aa(3) AND Ba(6)) & (Aa(2) AND
        Ba(6)) & (Aa(1) AND Ba(6)) & (Aa(0) AND Ba(6)));

        m8(14 DOWNTO 7) := ((Aa(7) AND Ba(7)) & (Aa(6) AND Ba(7)) &
        (Aa(5) AND Ba(7)) & (Aa(4) AND Ba(7)) & (Aa(3) AND Ba(7)) & (Aa(2) AND
        Ba(7)) & (Aa(1) AND Ba(7)) & (Aa(0) AND Ba(7)));


        auxM := m8 + m7 + m6 + m5 + m4 + m3 + m1 + m2;

        IF (X(7) = '1' AND Y(7) = '1') THEN
            RETURN auxM;
        ELSIF (X(7) = '0' AND Y(7) = '0') THEN
            RETURN auxM;
        ELSE
            RETURN ((NOT auxM) + 1);
        END IF;

    END mult5;

    FUNCTION div5(X : signed; Y : signed) RETURN STD_LOGIC_VECTOR IS
        VARIABLE c, r, d : unsigned(7 DOWNTO 0);
        VARIABLE auxD : STD_LOGIC_VECTOR(15 DOWNTO 0);
        VARIABLE Aa, Ba : STD_LOGIC_VECTOR(7 DOWNTO 0);

    BEGIN
        IF (X(7) = '1') THEN
            Aa := STD_LOGIC_VECTOR((NOT X(7 DOWNTO 0)) + 1);
        ELSE
            Aa := STD_LOGIC_VECTOR(X(7 DOWNTO 0));
        END IF;
        IF (Y(7) = '1') THEN
            Ba := STD_LOGIC_VECTOR((NOT Y(7 DOWNTO 0)) + 1);
        ELSE
            Ba := STD_LOGIC_VECTOR(Y(7 DOWNTO 0));
        END IF;
        IF Ba(7 DOWNTO 0) /= "00000000" THEN -- se valida que no sea entre '0'
            IF Ba(7 DOWNTO 0) = "00000001" THEN -- caso de la division entre 1
                auxD := STD_LOGIC_VECTOR("00000000" & Aa(7 DOWNTO 0));
            ELSE -- caso de la division entre 2 o mas
                c := (OTHERS => '0');
                r := unsigned(Aa(7 DOWNTO 0)); -- inicializacion del residuo al AUX
                d := unsigned(Ba(7 DOWNTO 0)); -- inicializacion del divisor al AUX2
                FOR i IN 0 TO 128 LOOP
                    IF (r >= d) THEN -- mientras el residuo sea mayor o igual al divisor
                        c := c + 1;
                        r := r - d; -- se hace una resta
                    END IF;

                END LOOP;

                auxD := "00000000" & STD_LOGIC_VECTOR(c);
            END IF;
        END IF;

        IF (X(7) = '1' AND Y(7) = '1') THEN
            RETURN auxD;
        ELSIF (X(7) = '0' AND Y(7) = '0') THEN
            RETURN auxD;
        ELSE
            RETURN ((NOT auxD) + 1);
        END IF;
    END div5;


    --ROM
    CONSTANT DirA : INTEGER := 4;--4
    CONSTANT DirB : INTEGER := 38;--23
    CONSTANT DirC : INTEGER := 76;--44
    CONSTANT DirD : INTEGER := 115;--65
    TYPE ROM IS ARRAY (127 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    ATTRIBUTE syn_romstyle : STRING;
    CONSTANT ROM_Program : ROM := (
        --DATOSPC
        0 => "00010100", -- W=20
        1 => "00000010", -- X=2
        2 => "00000101", -- Y=5
        3 => "00001000", -- Z=8
        --ECUACION UNO
        4 => "00001011", -- Guargar
        5 => "00000000", -- en A:
        6 => "00010001", -- 17
        7 => "00001100", -- Guardar
        8 => "00000101", -- el valor de X en B
        9 => "00001001", -- Se multiplica
        10 => "00000001", -- el valor de A a por el de B y se guarda en MBR
        11 => "00001110", -- Se mueve el resultado del MBR
        12 => "00001000", -- a C=17X
        13 => "00001011", -- Guargar
        14 => "00000000", -- en A:
        15 => "00011001", -- 25
        16 => "00001100", -- Guardar el valor de Y en B
        17 => "00000110", -- el valor de Y en B
        18 => "00001001", -- Se multiplica
        19 => "00000001", -- el valor de A a por el de B y se guarda en MBR
        20 => "00001110", -- Se mueve el resultado del MBR
        21 => "00001100", -- a D=25Y
        22 => "00001100", -- Guardar
        23 => "00000000", -- el valor de W en A
        24 => "00001011", -- Guargar
        25 => "00000100", -- en B:
        26 => "00000100", -- 4
        27 => "00001010", -- Se divide
        28 => "00000001", -- el valor de A entre el de B y se guarda en MBR
        29 => "00001110", -- Se mueve el resultado del MBR
        30 => "00000000", -- a A=W/4
        31 => "00000111", -- Se suma
        32 => "00001011", -- el valor de C con el de D y se guarda en MBR
        33 => "00001110", -- Se mueve el resultado del MBR
        34 => "00000100", -- a B=(17X + 25Y)
        35 => "00001000", -- Se resta
        36 => "00000100", -- el valor de B menos el de A y se guarda en MBR
        37 => "11111111", -- ciclado --22--
        --ECUACION DOS
        38 => "00001011", -- Guargar
        39 => "00000000", -- en A:
        40 => "00001010", -- 10
        41 => "00001100", -- Guardar
        42 => "00000101", -- el valor de X en B
        43 => "00001001", -- Se multiplica
        44 => "00000101", -- el valor de B a por el de B y se guarda en MBR
        45 => "00001110", -- Se mueve el resultado del MBR
        46 => "00000100", -- a B=X^2
        47 => "00001001", -- Se multiplica
        48 => "00000001", -- el valor de A a por el de B y se guarda en MBR
        49 => "00001110", -- Se mueve el resultado del MBR
        50 => "00001000", -- a C=10x^2
        51 => "00001011", -- Guargar
        52 => "00000000", -- en A:
        53 => "00011110", -- 30
        54 => "00001100", -- Guardar
        55 => "00000101", -- el valor de X en B
        56 => "00001001", -- Se multiplica
        57 => "00000001", -- el valor de A a por el de B y se guarda en MBR
        58 => "00001110", -- Se mueve el resultado del MBR
        59 => "00001100", -- a D=30x
        60 => "00001100", -- Guardar
        61 => "00000011", -- el valor de Z a A
        62 => "00001011", -- Guargar
        63 => "00000100", -- en B:
        64 => "00000010", -- 2
        65 => "00001010", -- Se divide
        66 => "00000001", -- el valor de A entre el de B y se guarda en MBR
        67 => "00001110", -- Se mueve el resultado del MBR
        68 => "00000000", -- a A=Z/2
        69 => "00000111", -- Se suma
        70 => "00001011", -- el valor de C con el de D y se guarda en MBR
        71 => "00001110", -- Se mueve el resultado del MBR
        72 => "00000100", -- a B=(10X^2 + 30x)
        73 => "00001000", -- Se resta
        74 => "00000100", -- el valor de B menos el de A y se guarda en MBR
        75 => "11111111", -- ciclado -- 43 --
        --ECUACION TRES
        76 => "00001100", -- Guardar
        77 => "00000000", -- el valor de W en A
        78 => "00001011", -- Guargar
        79 => "00000100", -- en B:
        80 => "00001010", -- 10
        81 => "00001010", -- Se divide
        82 => "00000001", -- el valor de A entre el de B y se guarda en MBR
        83 => "00001110", -- Se mueve el resultado del MBR
        84 => "00000000", -- a A=W/10
        85 => "00001100", -- Guargar
        86 => "00000101", -- el valor de X en B:
        87 => "00001001", -- Se multiplica
        88 => "00000101", -- el valor de B a por el de B y se guarda en MBR
        89 => "00001110", -- Se mueve el resultado del MBR
        90 => "00001000", -- a C=X^2
        91 => "00001001", -- Se multiplica
        92 => "00000110", -- el valor de B a por el de C y se guarda en MBR
        93 => "00001110", -- Se mueve el resultado del MBR
        94 => "00000100", -- a B=X^3
        95 => "00001000", -- Se resta
        96 => "00000001", -- al valor de A, el valor de B y se guarda en MBR
        97 => "00001110", -- Se mueve el resultado del MBR
        98 => "00001000", -- a C=(W/10)-X^3
        99 => "00001011", -- Guargar
        100 => "00000000", -- en A:
        101 => "00000111", -- 7
        102 => "00001100", -- Guardar
        103 => "00000111", -- el valor de Z en B
        104 => "00001001", -- Se multiplica
        105 => "00000001", -- el valor de A a por el de B y se guarda en MBR
        106 => "00001110", -- Se mueve el resultado del MBR
        107 => "00000100", -- a B=7z
        108 => "00001000", -- Se resta
        109 => "00001001", -- al valor de C, el valor de B y se guarda en MBR
        110 => "11111111", -- ciclado -- 64 --
        111 => "00010001", -- COMPARACION
        OTHERS => ("11111111")
    );


    SIGNAL cuenta : STD_LOGIC_VECTOR(15 DOWNTO 0);-- almacena el dato a multiplexar
    SIGNAL UNI, DEC, CEN, MIL : STD_LOGIC_VECTOR (3 DOWNTO 0); -- digitos unidades, decenas, centenas y unidad de millar
    SIGNAL D : STD_LOGIC_VECTOR (3 DOWNTO 0); -- sirve para almacenar los valores del display
    SIGNAL P : STD_LOGIC_VECTOR (15 DOWNTO 0); -- asigna UNI, DEC,CEN, MIL
    SIGNAL selector : STD_LOGIC_VECTOR (1 DOWNTO 0) := "00"; -- selector de barrido
    SIGNAL bandera : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL comparador : STD_LOGIC_VECTOR (2 DOWNTO 0) := (OTHERS => '0');

    ------------------------------------
    --Registros de proposito especifico
    SIGNAL PC : INTEGER := 0;
    SIGNAL MAR, IR : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
    SIGNAL MBR, ACC : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000"; -- Auxiliares
    ----------------------------------------Registros de entrada a la ALU
    TYPE REGISTROS IS ARRAY (4 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    TYPE ESTADOS IS (Fetch, Decode, Execute);
    SIGNAL estado : ESTADOS;
    SIGNAL RegsABCD : REGISTROS;
    SIGNAL REAUX, REAUX2, REAUX3 : signed(15 DOWNTO 0) := "0000000000000000";
    SIGNAL C1 : signed(15 DOWNTO 0) := "0000000010010010";
    SIGNAL C2 : signed(15 DOWNTO 0) := "0000000001001001";
    -----------------------------------------------------
    -- Señales de reloj
    SIGNAL CLK : STD_LOGIC;
    signal clk_low : STD_LOGIC := '0';

    CONSTANT max_count_med : INTEGER := 5000; --numero maximo para la cuenta
    SIGNAL count_med : INTEGER RANGE 0 TO max_count_med; --llevara la cuenta hasta el 5000
    SIGNAL clk_med : STD_LOGIC := '0'; --senal para el clock medio
    PROCEDURE veriBandera(a, x, y : IN STD_LOGIC_VECTOR(15 DOWNTO 0); SIGNAL
    bandera : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)) IS

BEGIN
    IF (a(14) = '1') THEN --Negative
        bandera(3) <= '1';
    ELSE
        bandera(3) <= '0';
    END IF;
    bandera(2) <= a(14) XOR x(14) XOR y(14) XOR a(15);
    --Overflow
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
GENERIC MAP(NOM_FREQ => "2.08")
PORT MAP(STDBY => '0', OSC => CLK, SEDSTDBY => OPEN);
gen_clk_medio : PROCESS (CLK) --reduccion del clock de 2.08 MHz

BEGIN
    IF (clk_low'event AND clk_low = '1') THEN
        IF (count_med < max_count_med) THEN
            count_med <= count_med + 1;
        ELSE
            clk_med <= NOT clk_med;
            count_med <= 0;
        END IF;
    END IF;
END PROCESS gen_clk_medio;

ControlUnit : PROCESS (Reset, IR, clk_low, sel)
BEGIN
    IF (Reset = '0') THEN
        estado <= Fetch;
        IR <= "00000000";
        flags <= "0000";
        comp <= "000";
        REAUX <= (OTHERS => '0');
        REAUX2 <= (OTHERS => '0');
        MBR <= "0000000000000000";
        RegsABCD <= (OTHERS => "0000000000000000");
        CASE sel IS
            WHEN "00" => PC <= DirA;
            WHEN "01" => PC <= DirB;
            WHEN "10" => PC <= DirC;
            WHEN OTHERS => PC <= DirD;
        END CASE;
    ELSIF (clk_low'event AND clk_low = '1' AND IR /= "11111111") THEN
        CASE estado IS
            WHEN Fetch =>
                IR <= ROM_program(PC);
                MAR <= ROM_program(PC + 1);
                estado <= Decode;
            WHEN Decode =>
                IF (IR = "00001011") THEN
                    -- Cargar Num a RegsABCD
                    RegsABCD(to_integer(unsigned(MAR(3 DOWNTO 2)))) <=
                    "00000000" & ROM_program(PC + 2);
                    PC <= PC + 3;
                    estado <= Fetch;
                ELSIF (IR = "00001100") THEN
                    -- Cargar Dato de ROM_prog a RegsABCD
                    RegsABCD(to_integer(unsigned(MAR(3 DOWNTO 2)))) <=
                    "00000000" & ROM_program(to_integer(unsigned(MAR(1 DOWNTO 0))));
                    estado <= Fetch;
                    PC <= PC + 2;
                ELSIF (IR = "00001101") THEN
                    -- Copiar Registro(orig) a Registro(dest)
                    RegsABCD(to_integer(unsigned(MAR(3 DOWNTO 2)))) <=
                    RegsABCD(to_integer(unsigned(MAR(1 DOWNTO 0))));
                    estado <= Fetch;
                    PC <= PC + 2;
                ELSIF (IR = "00001110") THEN
                    -- Copiar del MBR al Registro(dest)
                    RegsABCD(to_integer(unsigned(MAR(3 DOWNTO 2)))) <= MBR;
                    estado <= Fetch;
                    PC <= PC + 2;

                ELSIF (IR = "00001111") THEN
                    -- Jump a una direccion
                    estado <= Fetch;
                    PC <= to_integer(unsigned(MAR));
                ELSIF (IR = "00010000") THEN
                    -- Branch
                    IF (bandera(1) = '0') THEN
                        -- BNZ
                        estado <= Fetch;
                        PC <= 7;
                    ELSIF (bandera(1) = '1') THEN
                        -- BZ
                        estado <= Fetch;
                        PC <= 13;
                    ELSIF (bandera(2) = '1') THEN
                        -- BV
                        estado <= Fetch;
                        PC <= 16;
                    ELSIF (bandera(3) = '1') THEN
                        -- BN
                        estado <= Fetch;
                        PC <= 22;
                    ELSIF (bandera(0) = '1') THEN
                        -- BC
                        estado <= Fetch;
                        PC <= 31;
                    END IF;
                ELSIF (IR = "00010001") THEN
                    -- Comparador
                    IF (C1 < C2) THEN
                        comparador(2) <= '1';
                        estado <= Execute;
                        PC <= PC + 1;
                    ELSIF (C1 = C2) THEN
                        comparador(1) <= '1';
                        estado <= Execute;
                        PC <= PC + 1;
                    ELSIF (C1 > C2) THEN
                        comparador(0) <= '1';
                        estado <= Execute;
                        PC <= PC + 1;
                    END IF;
                ELSE
                    REAUX <=
                        signed(RegsABCD(to_integer(unsigned(MAR(3 DOWNTO 2)))));
                    REAUX2 <=
                        signed(RegsABCD(to_integer(unsigned(MAR(1 DOWNTO 0)))));
                    estado <= Execute;
                END IF;
            WHEN Execute =>
                MBR <= ACC;
                flags <= bandera;
                comp <= comparador;
                estado <= Fetch;
                PC <= PC + 2;
        END CASE;
    END IF;

    cuenta <= '0' & MBR(14 DOWNTO 0);

END PROCESS;

regALU : PROCESS (Reset, IR, REAUX, REAUX2)
    VARIABLE shift : STD_LOGIC_VECTOR(15 DOWNTO 0);
    VARIABLE desplazamientos : INTEGER;

BEGIN
    CASE IR IS
        WHEN "00000001" => ACC <= STD_LOGIC_VECTOR(NOT REAUX);
        
        WHEN "00000010" => ACC <= STD_LOGIC_VECTOR(REAUX AND REAUX2);
        
        WHEN "00000011" => ACC <= STD_LOGIC_VECTOR((NOT REAUX) + 1);
        
        WHEN "00000100" => ACC <= STD_LOGIC_VECTOR(REAUX OR REAUX2);
        
        WHEN "00000101" | "00000110" =>

            shift := STD_LOGIC_VECTOR(REAUX);
            desplazamientos := to_integer(REAUX2);

            FOR i IN 0 TO (10) LOOP
                IF (desplazamientos > 0) THEN
                    IF (IR = "00000101") THEN
                        --LSL
                        shift := shift(14 DOWNTO
                            0) & "0";
                    ELSE
                        --ASR
                        shift := shift(15) &
                            shift(15 DOWNTO 1);
                    END IF;
                    desplazamientos :=
                        desplazamientos - 1;
                END IF;
            END LOOP;

            ACC <= shift;

        WHEN "00000111" => 
            ACC <= STD_LOGIC_VECTOR(REAUX + REAUX2); --S U M A
            veriBandera(ACC, STD_LOGIC_VECTOR(REAUX), STD_LOGIC_VECTOR(REAUX2), bandera);
        WHEN "00001000" => -- REAUX3 <= REAUX-REAUX2;
            --R E S T A
            REAUX3(14 DOWNTO 0) <= (NOT REAUX2(14 DOWNTO 0)) + 1; --complemento a 2
            
            IF ((REAUX(14) XOR REAUX3(14)) = '1') THEN
                ACC <= STD_LOGIC_VECTOR(REAUX - REAUX2);
                veriBandera(ACC, STD_LOGIC_VECTOR(REAUX), STD_LOGIC_VECTOR(REAUX2), bandera);
            ELSE
                ACC <= STD_LOGIC_VECTOR(((NOT REAUX) + 1) + REAUX2);
                REAUX3 <= REAUX + ((NOT REAUX2) + 1);
                veriBandera(STD_LOGIC_VECTOR(REAUX3), STD_LOGIC_VECTOR(REAUX), STD_LOGIC_VECTOR((NOT REAUX2) + 1), bandera);
            END IF;

        WHEN "00001001" => REAUX3 <= signed(mult5(REAUX, REAUX2)); --M U L T I P L I C A C I O N
            veriBandera(STD_LOGIC_VECTOR(REAUX3), STD_LOGIC_VECTOR(REAUX), STD_LOGIC_VECTOR(REAUX2), bandera);
            
            IF (bandera(3) = '1') THEN
                ACC <= STD_LOGIC_VECTOR((NOT REAUX3) + 1);
            ELSE
                ACC <= STD_LOGIC_VECTOR(REAUX3);
            END IF;

        WHEN "00001010" => REAUX3 <= signed(div5(REAUX, REAUX2)); --D I V I S I O N
            veriBandera(STD_LOGIC_VECTOR(REAUX3), STD_LOGIC_VECTOR(REAUX), STD_LOGIC_VECTOR(REAUX2), bandera);
            
            IF (bandera(3) = '1') THEN
                ACC <= STD_LOGIC_VECTOR((NOT REAUX3) + 1);
            ELSE
                ACC <= STD_LOGIC_VECTOR(REAUX3);
            END IF;

        WHEN OTHERS => ACC <= (OTHERS => '0');
    END CASE;

END PROCESS;

asignacion : PROCESS (cuenta) --Algoritmo Shift and Add 3
    VARIABLE UM_C_D_U : STD_LOGIC_VECTOR(29 DOWNTO 0); --26 bits para separar las U.Millar - Centenas - Decenas - Unidades

BEGIN
    --ciclo de inicialización
    FOR I IN 0 TO 29 LOOP
        UM_C_D_U(I) := '0'; -- se inicializa con 0
    END LOOP;

    UM_C_D_U(13 DOWNTO 0) := cuenta(13 DOWNTO 0); --contador de 14 bits
    --ciclo de asignación UM-C-D-U
    FOR I IN 0 TO 13 LOOP -- FOR I IN 0 TO 9 LOOP -- si carga desde shift4 solo hace 10 veces el ciclo shift AND add
        
        -- los siguientes condicionantes comparan (>=5) y suman 3
        IF UM_C_D_U(17 DOWNTO 14) > 4 THEN -- U
            UM_C_D_U(17 DOWNTO 14) := UM_C_D_U(17 DOWNTO 14) + 3;
        END IF;

        IF UM_C_D_U(21 DOWNTO 18) > 4 THEN -- D

            UM_C_D_U(21 DOWNTO 18) := UM_C_D_U(21 DOWNTO 18) + 3;
        END IF;

        IF UM_C_D_U(25 DOWNTO 22) > 4 THEN -- C
            UM_C_D_U(25 DOWNTO 22) := UM_C_D_U(25 DOWNTO 22) + 3;
        END IF;

        IF UM_C_D_U(29 DOWNTO 26) > 4 THEN -- UM
            UM_C_D_U(29 DOWNTO 26) := UM_C_D_U(29 DOWNTO 26) + 3;
        END IF;

        UM_C_D_U(29 DOWNTO 1) := UM_C_D_U(28 DOWNTO 0); --realiza el corrimiento
    END LOOP;

    P <= UM_C_D_U(29 DOWNTO 14);-- guarda en P y en seguida se separan UM - C - D - U
    --UNIDADES
    UNI <= P(3 DOWNTO 0);
    --DECENAS
    DEC <= P(7 DOWNTO 4);
    --CENTENAS
    CEN <= P(11 DOWNTO 8);
    --MILLARES
    MIL <= P(15 DOWNTO 12);
END PROCESS asignacion;


    PROCESS (clk_low, UNI, DEC, CEN, MIL)

    BEGIN
        IF (rising_edge(clk_low)) THEN --Multiplexacion
            selector <= selector + '1';
            CASE(selector) IS
                WHEN "00" => AN <= "1110";
                    D <= UNI; -- UNIDADES
                WHEN "01" => AN <= "1101";
                    D <= DEC; -- DECENAS
                WHEN "10" => AN <= "1011";
                    D <= CEN; -- CENTENAS
                WHEN "11" => AN <= "0111";
                    D <= MIL; -- UNIDAD DE MILLAR
                WHEN OTHERS => AN <= "0111";
                    D <= MIL; -- UNIDAD DE MILLAR
            END CASE;
        END IF;

        CASE(D) IS
            -- abcdefg
            WHEN "0000" => DISPLAY <= "1000000"; --0
            WHEN "0001" => DISPLAY <= "1111001"; --1
            WHEN "0010" => DISPLAY <= "0100100"; --2
            WHEN "0011" => DISPLAY <= "0110000"; --3
            WHEN "0100" => DISPLAY <= "0011001"; --4
            WHEN "0101" => DISPLAY <= "0010010"; --5
            WHEN "0110" => DISPLAY <= "0000010"; --6
            WHEN "0111" => DISPLAY <= "1111000"; --7
            WHEN "1000" => DISPLAY <= "0000000"; --8
            WHEN "1001" => DISPLAY <= "0011000"; --9
            WHEN OTHERS => DISPLAY <= "0000110"; --E
        END CASE;

    END PROCESS;

    -- Dividor de frecuencias
    P_blink_LED: PROCESS(CLK)
        VARIABLE count : INTEGER RANGE 0 TO 2000000; 
    BEGIN
        IF( CLK'EVENT AND CLK = '1') THEN
            IF(count < 2000000) THEN
                count := count + 1;
            ELSE
                count := 0;
                clk_low <= NOT clk_low;
            END IF;
        END IF;
        blink_LED <= clk_low;
    END PROCESS;

end programa;