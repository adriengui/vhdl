library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity operateur is
generic(n:natural);
port(x,y:std_logic_vector(n-1 downto 0);
	f:std_logic;
	s:out std_logic_vector(n-1 downto 0));
end operateur;

architecture dataflow of operateur is

signal yi:std_logic_vector(n-1 downto 0);
signal c:std_logic_vector(n-1 downto 0);

component fulladd is
port(x,y,cin:std_logic;
	s,cout:out std_logic);
end component;

begin
	yi(0)<=y(0) xor f;
	cell0:fulladd port map(x(0), yi(0), f, s(0), c(0));
	gen:for i in 1 to n-1 generate
		yi(i)<=y(i) xor f;
		celli:fulladd port map(x(i),yi(i),c(i-1), s(i), c(i));
	end generate;
end dataflow;