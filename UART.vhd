library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity UART is
	PORT(
		CLK : IN std_logic;
		SW:  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDG:OUT  STD_LOGIC_VECTOR (7 DOWNTO 0);
		LEDR:OUT  STD_LOGIC_VECTOR (7 DOWNTO 0);
		UART_TX:OUT STD_LOGIC;
      UART_RX:IN STD_LOGIC;
		startT:IN STD_LOGIC

		);
end UART;

architecture Behavioral of UART is

signal tx_ini_s: std_logic;
signal tx_fin_s: std_logic;
signal rx_in_s: std_logic;
signal datain_s: std_logic_vector(7 downto 0);
signal  dout_s: std_logic_vector(7 downto 0);

   
	COMPONENT RS232 is
	generic	(	FPGA_CLK :			INTEGER := 50000000;	--FRECUENCIA DEL FPGA 
				BAUD_RS232 :		INTEGER := 9600		--BAUDIOS
			);
			
	PORT(
		CLK : IN std_logic;
		RX : IN std_logic;
		TX_INI : IN std_logic;
		DATAIN : IN std_logic_vector(7 downto 0);          
		TX_FIN : OUT std_logic;
		TX : OUT std_logic;
		RX_IN : OUT std_logic;
		DOUT : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

begin
	Inst_RS232: RS232 	PORT MAP(
		CLK =>CLK,
		RX =>UART_RX,
		TX_INI =>tx_ini_s,
		TX_FIN =>tx_fin_s,
		TX =>UART_TX,
		RX_IN =>rx_in_s,
		DATAIN =>datain_s,
		DOUT =>dout_s
	);
	
process(clk)
begin
if rising_edge(CLK) then
  if(tx_fin_s='0' and startT='1') then
  datain_s<=SW(7 DOWNTO 0);
  tx_ini_s<='1';
  LEDG<=datain_s;
  ELSE
  tx_ini_s<='0';
  END IF;
 END IF;
end process;


process(clk)
begin
if rising_edge(CLK) then
  if(rx_in_s='1') then
  dout_s<=dout_s(7 DOWNTO 0);
  LEDR<=dout_s;
  END IF;
 END IF;
end process;
        
end Behavioral;

