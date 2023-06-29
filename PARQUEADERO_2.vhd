library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity PARQUEADERO_2 is
    port (
        Password   			    		: in std_logic_vector(3 downto 0);
        Parqueadero 			       	: in std_logic_vector(7 downto 0);
		  
		  Clock    	  						: in std_logic;
		  Reset 		  						: in std_logic;
		  
		  Selector					      : in std_logic;
        Front_Sensor, Back_Sensor 	: in std_logic;
		  
		  Led_VERDE, Led_ROJO 			: out std_logic;
		  Password_view					: out std_logic_vector(3 downto 0);

		  N_Estacionamiento		    	: out std_logic_vector(6 downto 0);
		  Display_Parqueadero			: out std_logic_vector(6 downto 0);
        Espacio_Libre      		 	: out std_logic_vector(6 downto 0)
		  );
end PARQUEADERO_2 ; 

architecture PARQUEADERO_2_Arch of PARQUEADERO_2 is
    
   type State_Type is (Std_Inicial, Std_Contrasena,Std_Espera, Std_Estacionamiento);
   signal Estado_presente, Estado_sig : State_Type;

component DIVISOR_FRECUENCIA is
    port (  Clock 			  : in STD_LOGIC;
            Salida1, Salida2 : buffer STD_LOGIC
			);
end component;
	signal clk_1  	  : STD_LOGIC;
	signal clk_2  	  : STD_LOGIC;
	
component CONTRASENA_CORRECTA is
		port(
			Clock							: in std_logic;
			Reset           			: in std_logic;
			Password        			: in std_logic_vector(3 downto 0);
		
			Led_Verde, Led_Rojo	  	: out std_logic
			);
end component;
   signal Bandera_verde  	  : std_logic;
   signal Bandera_roja       : std_logic;

component PAGOS is
    port (
			Clock 		: in STD_LOGIC;
			Reset			: in STD_LOGIC;
			Enable		: in STD_LOGIC;
			Load			: in STD_LOGIC;
			
			Cobrar		: out integer
			);
end component;

	signal load	   : STD_LOGIC := '1';
	
   signal Pago_P1 : integer;
	signal Pago_P2 : integer;
	signal Pago_P3 : integer;
	signal Pago_P4 : integer;
	signal Pago_P5 : integer;
	signal Pago_P6 : integer;
	signal Pago_P7 : integer;
	signal Pago_P8 : integer;
	
	signal enable_P 	  : std_logic_vector(7 downto 0) := "00000000";
	
   signal COSTO 	 	  : integer range 0 to 9;
   
	signal Select_int 		  : integer range 1 to 8;
	signal contador_int 		  : integer range 1 to 9 := 1;
	
	signal Lugar_Parqueadero  : natural := 0;

begin
Password_view(3) <= Password(3);
Password_view(2) <= Password(2);
Password_view(1) <= Password(1);
Password_view(0) <= Password(0);
    
    DIVISOR_FREQ		  :	DIVISOR_FRECUENCIA port map (Clock => Clock, Salida1 => clk_1, Salida2 => clk_2);
	 
	 

	 
    STATE_MEMORY: process (clock, reset)
						begin 
							if (reset ='1') then 
								Estado_presente <= Std_Inicial;
								elsif(clock'event and clock='1') then 
									Estado_presente <= Estado_sig;
							end if;
						END PROCESS;
    

    NEXT_STATE_LOGIC: PROCESS (Estado_presente, Front_Sensor, Back_Sensor)
						    begin 
							 case (Estado_presente) is 
							 
								when Std_Inicial =>  if (Front_Sensor ='1' and Back_Sensor ='0') then
																Estado_sig<=Std_Contrasena;
															else 
																Estado_sig<=Std_Inicial;
															end if;				
    
								when Std_Contrasena =>  if ( Back_Sensor ='1' and Bandera_verde = '1'  ) then
																	Estado_sig<=Std_Estacionamiento;
																else 								
																	Estado_sig<= Std_Espera;
																end if;
            
								when Std_Espera =>  if (Back_Sensor ='1' and Bandera_verde = '1' ) then
																Estado_sig<=Std_Estacionamiento;
													     else 
																Estado_sig<=Std_Espera;
														  end if;	
							
								when Std_Estacionamiento =>  if (Front_Sensor ='0' and Back_Sensor ='0' ) then
																		Estado_sig<=Std_Inicial;
																	  else 
																		Estado_sig<=Std_Estacionamiento;
																	  end if;
    
								when others => Estado_sig<=Std_Inicial;
    
								end case;
								end process;

	OUTPUT_LOGIC : process (Estado_presente, Front_Sensor, Back_Sensor)
						begin
						case (Estado_presente) is
		
							when Std_Inicial => if (Front_Sensor = '0' and Back_Sensor = '0') then
														Led_VERDE <= '0';
														Led_ROJO  <= '0';
									  				  end if;
				
							when Std_Contrasena => if (Front_Sensor = '1' and Back_Sensor = '0') then
															Led_VERDE <= Bandera_verde;
															Led_ROJO  <= Bandera_roja;
														  end if;
				
							when Std_Espera =>  if (Back_Sensor ='1' and Bandera_verde = '1' ) then
														Led_VERDE <= Bandera_verde;
														Led_ROJO  <= Bandera_roja;
									 				  end if;
					
							when Std_Estacionamiento => if (Back_Sensor = '1' and Bandera_verde = '1') then
																	enable_P <= Parqueadero;	
												 				 end if;
				
							when others => Led_VERDE <= '0';
												Led_ROJO  <= '0';
					 	end case;
					  end process;
	
	CORECT_PASSWORD	  : 	CONTRASENA_CORRECTA port map (Clock => Clock, Reset => Reset, Password => Password, Led_Verde => Bandera_verde, Led_Rojo => Bandera_roja);
	 
	P1 : PAGOS port map (Clock => clk_1, Reset => Reset, Enable => enable_P(0), Load => load, Cobrar => Pago_P1);
	P2 : PAGOS port map (Clock => clk_1, Reset => Reset, Enable => enable_P(1), Load => load, Cobrar => Pago_P2);
	P3 : PAGOS port map (Clock => clk_1, Reset => Reset, Enable => enable_P(2), Load => load, Cobrar => Pago_P3);
	P4 : PAGOS port map (Clock => clk_1, Reset => Reset, Enable => enable_P(3), Load => load, Cobrar => Pago_P4);
	P5 : PAGOS port map (Clock => clk_1, Reset => Reset, Enable => enable_P(4), Load => load, Cobrar => Pago_P5);
	P6 : PAGOS port map (Clock => clk_1, Reset => Reset, Enable => enable_P(5), Load => load, Cobrar => Pago_P6);
	P7 : PAGOS port map (Clock => clk_1, Reset => Reset, Enable => enable_P(6), Load => load, Cobrar => Pago_P7);
	P8 : PAGOS port map (Clock => clk_1, Reset => Reset, Enable => enable_P(7), Load => load, Cobrar => Pago_P8);
						 
--------------------------------------------------------------------------------------------------

    process(Selector)
    begin
        if rising_edge(Selector) then
            if contador_int > 8 then
                contador_int <= 1;
            else
                contador_int <= contador_int + 1;
            end if;
        end if;
        Select_int <= contador_int;
    end process;

    with Select_int select
    COSTO <= Pago_P1 when 1,
				 Pago_P2 when 2,
             Pago_P3 when 3,
             Pago_P4 when 4,
             Pago_P5 when 5,
             Pago_P6 when 6,
             Pago_P7 when 7,
             Pago_P8 when 8;
				 
Decodificar_C:	process (COSTO) begin
					case COSTO is 
						when 0 =>Display_Parqueadero<= "0000001";
						when 1 =>Display_Parqueadero<= "1001111";
						when 2 =>Display_Parqueadero<= "0010010";
						when 3 =>Display_Parqueadero<= "0000110";
						when 4 =>Display_Parqueadero<= "1001100";
						when 5 =>Display_Parqueadero<= "0100100";
						when 6 =>Display_Parqueadero<= "0100000";
						when 7 =>Display_Parqueadero<= "0001111";
						when 8 =>Display_Parqueadero<= "0000000";
						when 9 =>Display_Parqueadero<= "0000100";
						when others  =>Display_Parqueadero<= "1111111";
					end case;
					end process;

Decodificador_NE: process (Select_int) begin
						case Select_int is 
							when 1 =>N_Estacionamiento<= "1001111";
							when 2 =>N_Estacionamiento<= "0010010";
							when 3 =>N_Estacionamiento<= "0000110";
							when 4 =>N_Estacionamiento<= "1001100";
							when 5 =>N_Estacionamiento<= "0100100";
							when 6 =>N_Estacionamiento<= "0100000";
							when 7 =>N_Estacionamiento<= "0001111";
							when 8 =>N_Estacionamiento<= "0000000";
							when others  =>N_Estacionamiento<= "1111111";
						end case;
						end process;

--------------------------------------------------------------------------------------------------
Cont_parqueadero:  process (Parqueadero)
							 begin
								for i in Parqueadero'range loop
									if Parqueadero(i) = '0' then
										Lugar_Parqueadero <= Lugar_Parqueadero + 1;
									end if;
								end loop;
							 end process;
							 
Decodificar_CostP:	process (Lugar_Parqueadero) begin
							case Lugar_Parqueadero is 
								when 0 =>Espacio_Libre<= "0000001";
								when 1 =>Espacio_Libre<= "1001111";
								when 2 =>Espacio_Libre<= "0010010";
								when 3 =>Espacio_Libre<= "0000110";
								when 4 =>Espacio_Libre<= "1001100";
								when 5 =>Espacio_Libre<= "0100100";
								when 6 =>Espacio_Libre<= "0100000";
								when 7 =>Espacio_Libre<= "0001111";
								when 8 =>Espacio_Libre<= "0000000";
								when 9 =>Espacio_Libre<= "0000100";
								when others  =>Espacio_Libre<= "1111111";
							end case;
						end process;
 
end PARQUEADERO_2_Arch;