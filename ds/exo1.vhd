library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity regas is
port(a,b:std_logic_vector(7 downto 0);
	f:out std_logic_vector(7 downto 0);
	s,ld,h:std_logic);
end regas;

architecture beh of regas is 
constant tco:time:=3 ns;
begin
	process(h)
	begin
		if h'event and h='1' and ld='1' then
			if s='1' then
				f<=a-b after tco;
			else
				f<=a+b after tco;
			end if;
		end if;
	end process;
end beh;