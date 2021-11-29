entity test is
end test;

-- Testbench pour une cellule élémentaire

architecture bench of test is
-- On recopie l'entité de la cellule
component cell is
port(Ai,Bi,Ci:bit;
	S:bit_vector(1 downto 0);
	Gi,Co:out bit);
end component;

-- On déclare les signaux d'entrée/sortie
signal Ai,Bi,Ci,Gi,Co:bit;
signal S:bit_vector(1 downto 0);

begin
-- On instancie la cellule avec son port map
	UUT:cell port map(Ai=>Ai,Bi=>Bi,Ci=>Ci,S=>S,Gi=>Gi,Co=>Co);
-- Et enfin on décrit un scénario de test
	Ai<='1', '0' after 40 ns, '1' after 75 ns;
	Bi<='1' after 120 ns;
	S<="01" after 40 ns, "11" after 80 ns, "10" after 120 ns, "00" after 160 ns;
	Ci<='1' after 120 ns;

end bench;
