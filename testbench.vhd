entity test is
end test;

architecture bench of test is
component registredouble is
generic(N:natural:=4;
	tmux:time:=3 ns;
	tco:time:=2 ns);
port(sel,H:bit;
	A,B:bit_vector(N downto 1);
	R:out bit_vector(N downto 1));
end component;

signal sel,H:bit;
signal A,B,R:bit_vector(4 downto 1);

begin
UUT: registredouble port map(sel,H,A,B,R);
A<="1011";
B<="0110";
sel<='1' after 55 ns, '0' after 70 ns;
H<=not H after 20 ns;
end bench;
