entity addsub is
generic(n:natural);
port(x,y:bit_vector(n-1 downto 0);
	as:bit;
	s:out bit_vector(n-1 downto 0));
end addsub;

architecture mixte of addsub is

component fai is
port(a,b,ci:bit;
	s,co:out bit);
end component;

component faf is
port(a,b,ci:bit;
	s:out bit);
end component;

signal xo:bit_vector(n-1 downto 0);
signal c:bit_vector(n-1 downto 1);

begin
	genxo:for i in 0 to n-1 generate
		xo(i)<=y(i) xor as;
	end generate;
	cell0:fai port map(x(0),xo(0),as,s(0),c(1));
	gen:for i in 1 to n-2 generate
		celli:fai port map(x(i),xo(i),c(i),s(i),c(i+1));
	end generate;
	celln:faf port map(x(n-1),xo(n-1),c(n-1),s(n-1));

end mixte;
