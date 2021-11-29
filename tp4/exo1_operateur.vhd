entity operateur is
generic(N:natural);
port(Cin:bit;
	A,B:bit_vector(N-1 downto 0);
	S:bit_vector(1 downto 0);
	G:out bit_vector(N-1 downto 0);
	Cout:out bit);
end operateur;

architecture dataflow of operateur is
component cell is
port(Ai,Bi,Ci:bit;
	Sc:bit_vector(1 downto 0);
	Gi,Co:out bit);
end component;

signal C:bit_vector(N-1 downto 1);

begin
	cell0:cell port map(Ai=>A(0),Bi=>B(0),Ci=>Cin,Sc=>S,Gi=>G(0),Co=>C(1));
	celli:for i in 1 to n-2 generate
		cei:cell port map(Ai=>A(i),Bi=>B(i),Ci=>C(i),Sc=>S,Gi=>G(i),Co=>C(i+1));
	end generate;
	celln:cell port map(Ai=>A(N-1),Bi=>B(N-1),Ci=>C(N-1),Sc=>S,Gi=>G(N-1),Co=>Cout);
end dataflow;