library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FIRmoving8 is
-- On d�clare l'entit� avec des r�els pour l'entr�e/sortie
	port(x:real;
		y:out real;
		rst,h:std_logic);
end FIRmoving8;

architecture dataflow of FIRmoving8 is

	-- On d�clare les 8 �chantillons
	signal x1,x2,x3,x4,x5,x6,x7:real:=0.0;
	-- Le coefficient b est par d�faut �gal � 1/8 (moyenne)
	constant b:real:=0.125;

	begin
		-- Chaque �chantillon re�oit celui d'avant de mani�re synchrone
		x1<= x when h='1' and h'event else 0.0 when rst='0';
		x2<=x1 when h='1' and h'event else 0.0 when rst='0';
		x3<=x2 when h='1' and h'event else 0.0 when rst='0';
		x4<=x3 when h='1' and h'event else 0.0 when rst='0';
		x5<=x4 when h='1' and h'event else 0.0 when rst='0';
		x6<=x5 when h='1' and h'event else 0.0 when rst='0';
		x7<=x6 when h='1' and h'event else 0.0 when rst='0';
		-- La sortie re�oit la somme des �chantillons divis�e par 8
		Y<=b*(x+x1+x2+x3+x4+x5+x6+x7) when h='1' and h'event else 0.0 when rst='0';

end dataflow;
