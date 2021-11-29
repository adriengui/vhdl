library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test is
end test;

architecture bench of test is
component cell is
port(Ai,Bi,Ci:std_logic;
	Sc:std_logic_vector(1 downto 0);
	Gi,Co:out std_logic);
end component;

signal Ai,Bi,Ci,Gi,Co:std_logic:='0';
signal Sc:std_logic_vector(1 downto 0):="00";

begin
UUT:cell port map(Ai=>Ai,Bi=>Bi,Ci=>Ci,Sc=>Sc,Gi=>Gi,Co=>Co);
Ai<='1', '0' after 40 ns, '1' after 75 ns;
Bi<='1' after 120 ns;
Sc<="01" after 40 ns, "11" after 80 ns, "10" after 120 ns, "00" after 160 ns;
Ci<='1' after 120 ns;

end bench;
