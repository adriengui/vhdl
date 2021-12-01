library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test is
end test;

architecture bench of test is
component recepteur is
port(rst,rxd,h:std_logic;
	rxrdy,p:out std_logic;
	di:out std_logic_vector(7 downto 0));
end component;

signal rst,rxd,h,rxrdy,p:std_logic:='0';
signal di:std_logic_vector(7 downto 0):="00000000";

begin
	UUT:recepteur port map (rst,rxd,h,rxrdy,p,di);
	h<=not h after 5 ns;
	rxd<='1' after 12 ns, '0' after 62 ns, '1' after 91 ns, '0' after 153 ns, '1' after 302 ns, '0' after 374 ns;
end bench;

