library ieee;
use ieee.std_logic_1164.all;
--------------------------------------------------------
entity DIVISOR_FRECUENCIA is
    port (  Clock 			  : in STD_LOGIC;
            Salida1, Salida2 : buffer STD_LOGIC);
end DIVISOR_FRECUENCIA;
--------------------------------------------------------
architecture DF_Arch of DIVISOR_FRECUENCIA is  
        signal Contador1: INTEGER range 0 to 50000000;

begin
DF:     process (Clock)
			variable Contador2: INTEGER range 0 to 50000000;
        begin
            if (Clock' event and Clock='1') then
                Contador1 <= Contador1 + 1;
                Contador2 := Contador2 + 1;
					if (Contador1 = 24999999 ) then
                    Salida1 <= NOT Salida1;
                    Contador1 <= 1;
					end if;

					if (Contador2 = 25000000 ) THEN
                    Salida2 <= NOT Salida2;
                    Contador2 := 1;
					end if;
					
            end if;
        end process;
end DF_Arch;