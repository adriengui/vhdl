library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test is
end test;

architecture bench of test is

component regneg is
generic(size:natural);
port(raz,nott,h:std_logic;
	q:out std_logic_vector(size-1 downto 0));
end component;

signal raz,nott,h:std_logic:='0';
signal q:std_logic_vector(3 downto 0):="0000";

begin
	UUT:regneg generic map(4) port map(raz,nott,h,q);
	h<=not h after 5 ns;
	-- raz<='1' after 82 ns, '0' after 148 ns;
	nott<='1' after 48 ns, '0' after 62 ns;
end bench;
