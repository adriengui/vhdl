entity test is
end test;

architecture bench of test is

component compteur is
port(clk, rst, E, S:bit;
	cup:out bit);
end component;

signal clk, rst, E, S, cup:bit;

begin
	UUT:compteur port map(clk=>clk, rst=>rst, E=>E, S=>S, cup=>cup);
	clk<=not clk after 10 ns;
	rst<='1';--, '0' after 85 ns, '1' after 115 ns;--, '0' after 200 ns, '1' after 250 ns;
	E<='1' after 100 ns;--, '0' after 140 ns, '1' after 170 ns;
	S<='1' after 225 ns;
end bench;
