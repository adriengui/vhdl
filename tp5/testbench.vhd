library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test is
end test;

architecture bench of test is
-- On recopie l'entité du filtre
	component FIRmoving8 is
		port(x:real;
			y:out real;
			rst,h:std_logic);
	end component;

	-- On déclare les signaux
	signal x,y:real:=0.0;
	signal rst,h:std_logic:='0';

	begin
		-- On instancie le composant
		UUT:FIRmoving8 port map(x=>x,y=>y,rst=>rst,h=>h);
		h<=not h after 20 ns;
		rst<='1';
	-- Enfin on se base sur les valeurs du sujet pour la simulation
		x<=0.0, 1.0 after 40 ns, 3.0 after 80 ns, 4.0 after 120 ns, 6.0 after 160 ns, 7.0 after 200 ns, 9.0 after 240 ns, 10.0 after 280 ns, 12.0 after 320 ns, 14.0 after 360 ns, 15.0 after 400 ns, 17.0 after 440 ns, 18.0 after 480 ns;

end bench;