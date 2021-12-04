library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity celli is
generic(tsu:time);
port(c0,c2,h:std_logic;
	qi:out std_logic);
end celli;

architecture dflow of celli is
signal s:std_logic:='0';
begin
	s<=(c0 or s) and (c2 or not s) when h'event and h='1';
	qi<=s;
end dflow;

architecture beh of celli is
begin
	process(h)
	variable s:std_logic:='0';
	begin
		if h='1' and h'event then
			assert c0'stable(tsu) and c2'stable(tsu) report "viol tsu" severity error;
			s:=(c0 or s) and (c2 or not s);
			qi<=s;
		end if;
	end process;
end beh;
