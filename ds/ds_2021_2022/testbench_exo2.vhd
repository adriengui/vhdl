entity test is
end test;

architecture bench of test is

component fsm is
port(rst,clk,x:bit;
	s0,s1,s2:out bit);
end component;

signal rst,clk,x,s0,s1,s2:bit;

begin
	UUT:fsm port map(rst,clk,x,s0,s1,s2);
	rst<='1' after 2 ns;
	clk<=not clk after 5 ns;
	x<='1' after 12 ns, '0' after 19 ns, '1' after 32 ns, '0' after 47 ns, '1' after 98 ns;
end bench;
