entity test is
end test;

architecture bench of test is

component alarme is
generic(nb:natural;
	tbip,ts:time);
port(ma:bit;
	al:out boolean);
end component;

signal ma:bit;
signal al:boolean;

begin
	UUT:alarme generic map(4,4 ns,8 ns) port map(ma,al);
	ma<='1' after 10 ns, '0' after 90 ns, '1' after 105 ns, '0' after 188 ns;
end bench;