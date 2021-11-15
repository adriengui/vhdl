entity test is
end test;

architecture bench of test is

component compteur is -- Comme toujours, on recopie ici l'entité du composant
port(clk, rst, E, S:bit;
	cup:out bit);
end component;

signal clk, rst, E, S, cup:bit; -- On définit les signaux d'entrée/sortie

begin
	UUT:compteur port map(clk=>clk, rst=>rst, E=>E, S=>S, cup=>cup);
	-- Dans le port map on fait l'assignation par nom de tous les signaux	

	clk<=not clk after 10 ns; -- On décrit un scénario permettant de 
	-- tester à peu près toutes les possibilités du système
	rst<='1';
	E<='1' after 32 ns, '0' after 72 ns, '1' after 112 ns;
	S<='1' after 152 ns;
end bench;
