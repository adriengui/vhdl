library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity diviseur is
port(h,rst:bit;
	v:natural range 0 to 3;
	hd:out bit);
end diviseur;

architecture dflow of diviseur is
signal i:unsigned(3 downto 0):="0000";
begin
	hd<=to_bit(i(v));
	i<=(i+1) mod 16 when h'event and h='1' else "0000" when rst='1';
end dflow;

