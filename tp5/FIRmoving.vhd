library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FIRmoving8 is
-- On déclare l'entité avec des réels pour l'entrée/sortie
	port(x:real;
		y:out real;
		rst,h:std_logic);
end FIRmoving8;

architecture dataflow of FIRmoving8 is

	-- On déclare les 8 échantillons
	signal x1,x2,x3,x4,x5,x6,x7:real:=0.0;
	-- Le coefficient b est par défaut égal à 1/8 (moyenne)
	constant b:real:=0.125;

	begin
		-- Chaque échantillon reçoit celui d'avant de manière synchrone
		x1<= x when h='1' and h'event else 0.0 when rst='0';
		x2<=x1 when h='1' and h'event else 0.0 when rst='0';
		x3<=x2 when h='1' and h'event else 0.0 when rst='0';
		x4<=x3 when h='1' and h'event else 0.0 when rst='0';
		x5<=x4 when h='1' and h'event else 0.0 when rst='0';
		x6<=x5 when h='1' and h'event else 0.0 when rst='0';
		x7<=x6 when h='1' and h'event else 0.0 when rst='0';
		-- La sortie reçoit la somme des échantillons divisée par 8
		Y<=b*(x+x1+x2+x3+x4+x5+x6+x7) when h='1' and h'event else 0.0 when rst='0';

end dataflow;
