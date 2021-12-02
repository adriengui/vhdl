library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test is
end test;

architecture bench of test is

component comparateur is
generic(n:natural);
port(a,b:std_logic_vector(n-1 downto 0);
	inf,eq,sup: out std_logic);
end component;

signal a,b:std_logic_vector(3 downto 0):="0000";
signal inf,eq,sup: std_logic:='0';

begin
	UUT:comparateur generic map(4) port map(a,b,inf,eq,sup);
	a<="1010" after 15 ns, "1100" after 30 ns, "0010" after 45 ns;
	b<="0011" after 22 ns, "1100" after 37 ns, "1011" after 52 ns;

end bench;
