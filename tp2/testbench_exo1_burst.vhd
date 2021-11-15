entity test is
end test;

architecture bench of test is

component controleurburst is -- Ce testbench est presque le meme, à part que l'on adapte pour le burst
port(H, rst, ready, readwrite, burst:bit; -- On recopie donc l'entité du controleur burst
	oe, we:out bit;
	adr:out bit_vector(1 downto 0));
end component;

signal H, rst, ready, readwrite, burst, oe, we:bit; -- Il faut aussi ajouter les signaux d'entrée/sortie burst et adr
signal adr:bit_vector(1 downto 0);

begin
	UUT:controleurburst port map(H=>H, rst=>rst, ready=>ready, readwrite=>readwrite, burst=>burst, oe=>oe, we=>we, adr=>adr);
	-- Le port map est le meme, avec burst et adr en plus
	H<=not H after 10 ns;
	rst<='1', '0' after 255 ns, '1' after 265 ns; -- On a conservé le meme scenario
	ready<='1' after 25 ns, '0' after 115 ns, '1' after 165 ns, '0' after 215 ns, '1' after 275 ns;
	readwrite<='1' after 175 ns;
	burst<='1' after 80 ns; -- On ajoute l'évolution du signal burst
end bench;