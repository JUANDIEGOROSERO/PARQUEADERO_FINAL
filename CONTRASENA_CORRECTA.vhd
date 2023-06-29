library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity CONTRASENA_CORRECTA is
	port(
		Clock							: in std_logic;
		Reset           			: in std_logic;
		Password        			: in std_logic_vector(3 downto 0);
		
		Led_Verde, Led_Rojo	  	: out std_logic
		);
end CONTRASENA_CORRECTA; 

architecture CONTRASENA_CORRECTA_Arch of CONTRASENA_CORRECTA is

type State_Type is (Std_0, Std_Ingresa, Std_Intento1, Std_Intento2, Std_Intento3);
signal Estado_Actual, Estado_Siguiente : State_Type;

begin

STATE_MEMORY:	process(Clock, Reset)
					begin 
						if (Reset ='1') then 
							Estado_Actual <= Std_0;
							elsif (Clock'event and Clock='1') then 
								Estado_Actual <= Estado_Siguiente;
						end if;
					end process;

---------------------------------------------------------------------------------------------
NEXT_STATE_LOGIC:	process (Estado_Actual, Password)
						begin	
						CASE (Estado_Actual) is 
						when Std_0 =>  if (Password="0110") then
												Estado_Siguiente<=Std_Ingresa;
											else 
												Estado_Siguiente<=Std_Intento1;
											end if;
							
						when Std_Ingresa =>  if (Password="0110") then
														Estado_Siguiente<=std_0;
													else 
														Estado_Siguiente<=Std_Intento1;
													end if;	
							
						when Std_Intento1 => if (Password="0110") then
														Estado_Siguiente<=Std_Ingresa;
													else 
														Estado_Siguiente<=Std_Intento2;
													end if;
							
						when Std_Intento2 => if (Password="0110") then
														Estado_Siguiente<=Std_Ingresa;
													else 
														Estado_Siguiente<=Std_Intento3;
													end if;

						when Std_Intento3 => if (Password="0110") then
														Estado_Siguiente<=Std_Ingresa;
													else 
														Estado_Siguiente<=Std_0;
													end if;
							
						when others 		=> 	Estado_Siguiente<=Std_0;
    
						end case;
						end process;

---------------------------------------------------------------------------------------------
OUTPUT_LOGIC : process (Estado_Actual, Password)
					begin
					case (Estado_Actual) is
					
					when Std_0 =>	if (Password="0110") then
											Led_Verde <= '1'; 
											Led_Rojo <= '0';
										else
											Led_Verde <= '0'; 
											Led_Rojo <= '1';
										end if;
					
					when Std_Ingresa =>  if (Password="0110") then
													Led_Verde<='1'; 
													Led_Rojo<='0';
												else 
													Led_Verde<='0'; 
													Led_Rojo<='1';
												end if;		
							
					when Std_Intento1 =>	if (Password="0110") then
													Led_Verde <= '1'; 
													Led_Rojo <= '0';
												else
													Led_Verde <= '0'; 
													Led_Rojo <= '1';
												end if;
					
					when Std_Intento2 =>	if (Password="0110") then
													Led_Verde <= '1'; 
													Led_Rojo <= '0';
												else
													Led_Verde <= '0'; 
													Led_Rojo <= '1';
												end if;
					
					when Std_Intento3 =>	if (Password="0110") then
													Led_Verde <= '1'; 
													Led_Rojo <= '0';
												else
													Led_Verde <= '0'; 
													Led_Rojo <= '1';
												end if;
					
					when others 		=> Led_Verde <= '0'; 
												Led_Rojo  <= '0';
					
					end case;
					
					end process;

end CONTRASENA_CORRECTA_Arch;