entity operateur is
generic(N:natural);
port(Cin:bit; -- Retenue entrante
	A,B:bit_vector(N-1 downto 0); -- Opérandes
	S:bit_vector(1 downto 0); -- Entrées de sélection
	G:out bit_vector(N-1 downto 0); -- Résultat
	Cout:out bit); -- Retenue sortante
end operateur;

architecture dataflow of operateur is
-- On recopie d'abord l'entité de la cellule élémentaire
component cell is
port(Ai,Bi,Ci:bit;
	S:bit_vector(1 downto 0);
	Gi,Co:out bit);
end component;

signal C:bit_vector(N-1 downto 1); -- Signal interne pour les retenues

begin
	-- On déclare la première cellule indépendament car sa retenue entrante est Cin
	cell0:cell port map(Ai=>A(0),Bi=>B(0),Ci=>Cin,S=>S,Gi=>G(0),Co=>C(1));
	-- Ensuite on instancie toutes les autres cellules sauf la dernière avec une boucle
	-- car leur entrées/sorties sont récurrentes
	celli:for i in 1 to n-2 generate
		cei:cell port map(Ai=>A(i),Bi=>B(i),Ci=>C(i),S=>S,Gi=>G(i),Co=>C(i+1));
	end generate;
	-- Enfin, on déclare aussi la dernière cellule séparément car sa retenue sortante est Cout
	celln:cell port map(Ai=>A(N-1),Bi=>B(N-1),Ci=>C(N-1),S=>S,Gi=>G(N-1),Co=>Cout);
end dataflow;