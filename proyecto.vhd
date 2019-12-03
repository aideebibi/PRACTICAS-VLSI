library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity proyecto is
	Port( mclk : IN STD_LOGIC;
			entradasC: IN STD_LOGIC_VECTOR(3 downto 0); --"arr,abj,der,izq"
			entradaG: IN STD_LOGIC_VECTOR(1 downto 0); --"Bajar, subir"
			servoArrAbj : OUT STD_LOGIC;
			servoIzqDer : OUT STD_LOGIC;
			servoTomar : OUT STD_LOGIC
			);
end proyecto;

architecture Behavorial of proyecto is
--Constantes de cuenta
--RANGO: 1 a 2 ms
--de 1 1.5 ms, mas cerca de 1.5ms gira hacia el sentido 'A' a menor velocidad
--1 ms es la velocidad máx hacia el sentido 'A'
--Por lo tanto a 1.5 ms es STOP
--de 1.5 a 2ms, mas cerca de 1.5 ms gira hacia el sentido 'B' a menor velocidad
--2 ms es la velocidad máx hacia el sentido 'B'

--1 ms corresponde a un valor de cuenta de 50,000
constant arr: integer := 50000;    --S1
constant abajo: integer := 100000;  --S1
constant izq: integer := 50000;    --S2
constant der: integer := 100000;    --S2
constant stop: integer := 75000;   --COMÚN
constant bajar: integer := 100000;  --S3
constant subir: integer := 50000;  --S3


signal delay: integer range 0 to 50000000:=0; -- Reloj base 50 MHz
signal cont: STD_LOGIC_VECTOR (3 downto 0):="0000";
Signal div : std_logic :='0';
Signal PWM_Count: std_logic_vector (19 downto 0 ):="00000000000000000000";--1,000,000, señal que lleva la cuenta
begin


generacion_PWM: process( mclk,PWM_Count ) --Generación del contador
          begin
			    if rising_edge(mclk)then 
					PWM_Count <= PWM_Count + 1;
             end if;
				 if PWM_Count = x"F4240" then --1,000,000
					PWM_Count <= "00000000000000000000";
				 end if;
				 
end process generacion_PWM;


movimiento : process(PWM_Count,entradasC) is --Process para el proyecto de movimiento xy
	begin
	case entradasC is
		when "0000" => --TODOS DETENIDOS
		    --S1
			 if PWM_Count <= stop then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= stop then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if;  

		when "0001" => --Movimiento hacia izquierda
			 --S1
			 if PWM_Count <= izq then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= stop then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if;  
												
		when "0010" => --Movimiento hacia derecha
			 --S1
			 if PWM_Count <= der then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= stop then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if;  
			 
		when "0011" => --Movimiento inválido
			 --S1
			 if PWM_Count <= stop then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= stop then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if;  
			 
		when "0100" => --Movimiento abajo
			 --S1
			 if PWM_Count <= stop then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= abajo then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if; 
			 
		when "0101" => --Movimiento abajo e izquierda
			 --S1
			 if PWM_Count <= izq then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= abajo then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if; 
			 
		when "0110" => --Movimiento abajo y derecha
			 --S1
			 if PWM_Count <= der then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= abajo then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if; 
			 
		when "0111" => --Movimiento inválido
			 --S1
			 if PWM_Count <= stop then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= stop then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if; 
			 
		when "1000" => --Movimiento arriba
			 --S1
			 if PWM_Count <= stop then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= arr then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if; 
			 
		when "1001" => --Movimiento arriba e izquierda
			 --S1
			 if PWM_Count <= izq then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= arr then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if; 
			 
		when "1010" => --Movimiento arriba y derecha
			 --S1
			 if PWM_Count <= der then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= arr then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if; 
			 
		when "1011" => --Movimiento inválido
			 --S1
			 if PWM_Count <= stop then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= stop then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if; 
			 
		when "1100" => --Movimiento inválido
			 --S1
			 if PWM_Count <= stop then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= stop then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if;
			 
		when "1101" => --Movimiento inválido
			 --S1
			 if PWM_Count <= stop then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= stop then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if;
		
		when "1110" => --Movimiento inválido
			 --S1
			 if PWM_Count <= stop then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= stop then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if;
			 
		when "1111" => --Movimiento inválido
			 --S1
			 if PWM_Count <= stop then 
					servoIzqDer <= '1';
          else                                        
					servoIzqDer <= '0';
          end if;  
			 --S2
			 if PWM_Count <= stop then 
					servoArrAbj <= '1';
          else                                        
					servoArrAbj <= '0';
          end if;

	end case;

end process;

garrra : process(PWM_Count,entradaG) is --Process para el proyecto de la garra
	begin
	case entradaG is
		when "11" => --TODOS DETENIDOS
		    --S1
			 if PWM_Count <= stop then 
					servoTomar <= '1';
          else                                        
					servoTomar <= '0';
          end if;  
			 

		when "10" => --Movimiento bajar
			 if PWM_Count <= bajar then 
					servoTomar <= '1';
          else                                        
					servoTomar <= '0';
          end if;  
			
												
		when "01" => --Movimiento subir
			 if PWM_Count <= subir then 
					servoTomar <= '1';
          else                                        
					servoTomar <= '0';
          end if;  
			
			 
		when "00" => --Movimiento inválido
			 if PWM_Count <= stop then 
					servoTomar <= '1';
          else                                        
					servoTomar <= '0';
          end if;  
		
	end case;

end process;



end Behavorial;
