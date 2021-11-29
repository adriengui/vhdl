library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test is
end test;

-- Testbench pour la FIFO

architecture bench of test is
-- On recopie l'entité du composant
component fifo is
generic(N:natural:=8;
	deep:natural:=3);
port(rst,rw,enable,H:std_logic;
	datain:std_logic_vector(N-1 downto 0);
	full,empty:out std_logic;
	dataout:out std_logic_vector(N-1 downto 0));
end component;

-- On déclare tous les signaux d'entrée/sortie initialisés à 0
signal rst,rw,enable,H,full,empty:std_logic:='0';
signal datain, dataout:std_logic_vector(7 downto 0);

begin
	-- On instancie la FIFO avec son port map
	UUT:fifo port map(rst=>rst,rw=>rw,enable=>enable,H=>H,datain=>datain,full=>full,empty=>empty,dataout=>dataout);
	-- Puis on décrit le scénario en se basant sur celui du sujet pour comparer
	H<=not H after 20 ns;
	rst <='1' after 2 ns, '0' after 10 ns;
	rw<='1', '0' after 150 ns, '1' after 250 ns, '0' after 330 ns, '1' after 480 ns;
	enable<='1';
	datain<="11100000", "00100011" after 45 ns, "01001001" after 75 ns, "01000100" after 90 ns, "01010101" after 290 ns;
end bench;
