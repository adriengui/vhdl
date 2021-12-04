entity test is
end test;

architecture bench of test is

component diviseur is
port(h,rst:bit;
	v:natural range 0 to 3;
	hd:out bit);
end component;

signal h,rst,hd:bit;
signal v:natural range 0 to 3;

begin
	UUT:diviseur port map(h,rst,v,hd);
	h<=not h after 5 ns;
	v<=2 after 67 ns, 1 after 222 ns, 3 after 342 ns;
end bench;
