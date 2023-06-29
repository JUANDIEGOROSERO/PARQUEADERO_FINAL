library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity PAGOS is
    Port (
			Clock 		: in STD_LOGIC;
			Reset			: in STD_LOGIC;
			Enable		: in STD_LOGIC;
			Load			: in STD_LOGIC;
			
			Cobrar		: out integer
			);
end PAGOS;

architecture PAGOS_Arch of PAGOS is

    signal Conteo : integer range 0 to 49;
    
begin

    process (Clock, Reset)

    variable Data_in : STD_LOGIC_VECTOR (5 downto 0);

    begin

            if Reset = '0' then
                Conteo <= 0;
                elsif (rising_edge(Clock)) then
                    if Enable = '1' then
                            if Load = '1' then
										Conteo <= to_integer(unsigned(Data_in));
											if (Conteo = 49) then
												Conteo <= 0;
                                    else
                                    Conteo <= Conteo + 1;
                                 end if;
                             end if;
						  end if;
                        
                    if Enable = '1' then
                        if Load = '0' then
                           Conteo <= to_integer(unsigned(Data_in));
                        end if;
                    end if;	
                            
                    if enable = '0' then
                        if Load = '0' then
                            Conteo <= to_integer(unsigned(Data_in));
                        end if;
                    end if;
            end if;
				
            if (Conteo mod 5) = 0 then
                Cobrar <= Conteo/ 5;
            end if;
    end process;

end PAGOS_Arch;