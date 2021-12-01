library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity fulladd is
port(x,y,cin:std_logic;
	s,cout:out std_logic);
end fulladd;

architecture dataflow of fulladd is

signal v:std_logic:='0';

begin
	v<=x xor y;
	s<=v xor cin;
	cout<=(cin and v) or (x and y);
end dataflow;