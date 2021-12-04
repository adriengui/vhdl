library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity regneg is
generic(size:natural);
port(raz,nott,h:std_logic;
	q:out std_logic_vector(size-1 downto 0));
end regneg;

architecture structure of regneg is

component celli is
generic(tsu:time);
port(c0,c2,h:std_logic;
	qi:out std_logic);
end component;

signal c:std_logic:='0';

begin
	c<=raz nor nott;
	gen:for i in 0 to size-1 generate
		for cell:celli use entity work.celli(beh);
		cell:celli generic map(4 ns) port map(c,nott,h,q(i));
	end generate;
end structure;
