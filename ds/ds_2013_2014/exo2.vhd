library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity circuit is
port(a,b:std_logic_vector(7 downto 0);
	f:out std_logic_vector(7 downto 0);
	s,ld,h:std_logic);
end circuit;

architecture dflow of circuit is

signal as:std_logic_vector(7 downto 0);

constant tco:time:=3 ns;
constant tcomb:time:=6 ns;

begin
	as<=a+b after tcomb when s='0' else a-b after tcomb;
	f<=as after tco when h'event and h='1' and ld='1';
end dflow;