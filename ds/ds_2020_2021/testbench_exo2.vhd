library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test is
end test;

architecture bench of test is

component operateur is
generic(n:natural);
port(x,y:std_logic_vector(n-1 downto 0);
	f:std_logic;
	s:out std_logic_vector(n-1 downto 0));
end component;

signal x,y,s:std_logic_vector(3 downto 0):="0000";
signal f:std_logic:='0';

begin
	UUT:operateur generic map(4) port map (x,y,f,s);
	x<="0111";
	y<="0010";
	f<='1' after 40 ns, '0' after 80 ns;
end bench;

