library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity comparateur is
generic(n:natural);
port(a,b:std_logic_vector(n-1 downto 0);
	inf,eq,sup: out std_logic);
end comparateur;

architecture dflow of comparateur is

component cell is
port(ai,bi,ii,ei,si:std_logic;
	io,eo,so:out std_logic);
end component;

signal iss,ess,sss:std_logic_vector(n-2 downto 0);

begin

cell0:cell port map(a(n-1),b(n-1),'0','1','0',iss(n-2),ess(n-2),sss(n-2));
gen:for i in n-2 downto 1 generate
	celli:cell port map(a(i),b(i),iss(i),ess(i),sss(i),iss(i-1),ess(i-1),sss(i-1));
end generate;
celln:cell port map(a(0),b(0),iss(0),ess(0),sss(0),inf,eq,sup);

end dflow;