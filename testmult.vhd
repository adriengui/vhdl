library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test is
end test;

architecture bench of test is
component mult is
port(multiplieur,multiplicande:std_logic_vector(4 downto 0);
	go,clk,rst:std_logic;
	S:out std_logic_vector(9 downto 0);
	fin:out std_logic);
end component;

signal multiplieur,multiplicande:std_logic_vector(4 downto 0):="00000";
signal S:std_logic_vector(9 downto 0):="0000000000";
signal go,rst,fin,clk:std_logic:='0';

begin
	UUT:mult port map(multiplieur=>multiplieur,multiplicande=>multiplicande,go=>go,clk=>clk,rst=>rst,S=>S,fin=>fin);
	clk<=not clk after 10 ns;
	go<='1' after 2 ns, '0' after 12 ns;
	multiplieur<="10111";
	multiplicande<="10011";

end bench;