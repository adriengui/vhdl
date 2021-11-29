entity test is
end test;

architecture bench of test is
component operateur is
generic(N:natural);
port(Cin:bit;
	A,B:bit_vector(N-1 downto 0);
	S:bit_vector(1 downto 0);
	G:out bit_vector(N-1 downto 0);
	Cout:out bit);
end component;

signal Cin,Cout:bit;
signal S:bit_vector(1 downto 0);
signal A,B,G:bit_vector(4 downto 0);

begin
	UUT:operateur generic map(N=>5) port map(Cin=>Cin,A=>A,B=>B,S=>S,G=>G,Cout=>Cout);
	A<="01001";
	B<="00010";
	S<="01" after 40 ns, "11" after 80 ns, "10" after 120 ns, "00" after 160 ns;
	Cin<='1' after 120 ns;
end bench;
