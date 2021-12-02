library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity aff7seg is
port(data:unsigned(12 downto 0);
	aff3,aff2,aff1,aff0:out unsigned(6 downto 0));
end aff7seg;

architecture dflow of aff7seg is

signal r1, r2, r3, q1, q2, q3:unsigned(12 downto 0);
signal c1,c2,c3:unsigned(6 downto 0);
signal e1,e2,e3:bit;

constant tconv:time:=5 ns;
constant tmux:time:=7 ns;
constant tdiv:time:=40 ns;

function conv(i:unsigned(12 downto 0)) return unsigned is -- Ce n'est pas à faire
variable a:integer;
begin
	a:=to_integer(i);
	case a is
		when 0 => return "1000000";
		when 1 => return "1111001";
		when 2 => return "0100100";
		when 3 => return "0110000";
		when 4 => return "0011001";
		when 5 => return "0010010";
		when 6 => return "0000010";
		when 7 => return "1111000";
		when 8 => return "0000000";
		when 9 => return "0010000";
		when others => return "1111111";
	end case;
end conv;

begin
	q1<=data/10 after tdiv;
	q2<=q1/10 after tdiv;
	q3<=q2/10 after tdiv;
	r1<=data mod 10 after tdiv;
	r2<=q1 mod 10 after tdiv;
	r3<=q2 mod 10 after tdiv;
	c1<=conv(r2) after tconv;
	c2<=conv(r3) after tconv;
	c3<=conv(q3) after tconv;
	aff0<=conv(r1) after tconv;
	aff1<=c1 when e1='0' else "1111111" after tmux;
	aff2<=c2 when e2='0' else "1111111" after tmux;
	aff3<=c3 when e3='0' else "1111111" after tmux;
	e1<='1' when q1="0000000000000" else '0';
	e2<='1' when q2="0000000000000" else '0';
	e3<='1' when q3="0000000000000" else '0';

end dflow;