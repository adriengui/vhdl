library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cell is
port(ai,bi,ii,ei,si:std_logic;
	io,eo,so:out std_logic);
end cell;

architecture dflow of cell is
begin
	so<=si or (ei and ai and not bi);
	io<=ii or (ei and bi and not ai);
	eo<=ei and not(ai xor bi);
end dflow;