entity test is
end test;

architecture bench of test is
component registredouble is
generic(N:natural:=4;
	tco:time);
port(sel,H:bit;
	A,B:bit_vector(N downto 1);
	R:out bit_vector(N downto 1));
end component;

signal sel,H:bit;
signal A,B,R:bit_vector(4 downto 1);

for UUT:registredouble use entity work.registredouble(structure);

begin
	UUT: registredouble generic map(tco=>2 ns) port map(sel=>sel,H=>H,A=>A,B=>B,R=>R);

	H<=not H after 20 ns;
	sel<='1' after 58 ns, '0' after 90 ns, '1' after 190 ns, '0' after 275 ns;
	A<="1011", "0010" after 150 ns;
	B<="0110", "1100" after 200 ns;
end bench;
