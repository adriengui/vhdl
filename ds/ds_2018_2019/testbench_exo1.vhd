entity test is
end test;

architecture bench of test is

component compteur is
port(rst,raz,inc,clk:bit;
	q:out natural range 0 to 999);
end component;

signal rst,raz,inc,clk:bit;
signal q:natural range 0 to 999;

begin
	UUT:compteur port map(rst,raz,inc,clk,q);
	clk<=not clk after 10 ns;
	inc <='1' after 15 ns, '0' after 102 ns, '1' after 145 ns;
	raz<='1' after 95 ns, '0' after 125 ns;
end bench;