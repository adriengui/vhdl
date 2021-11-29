-- Bibliothèques pour les std_logic
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
-- Pour utiliser les signed/unsigned
use ieee.numeric_std.all;
-- Pour utiliser la puissance
use ieee.math_real.all;

entity fifo is
-- Par défaut les données ont une taille de 8 bits
-- et la FIFO comporte 8 registres (2^3)
generic(N:natural:=8;
	deep:natural:=3);
-- On déclare ensuite tous les signaux d'entrée/sortie
port(rst,rw,enable,H:std_logic;
	datain:std_logic_vector(N-1 downto 0);
	full,empty:out std_logic;
	dataout:out std_logic_vector(N-1 downto 0));
end fifo;

architecture dataflow of fifo is

constant pow:natural:=2**deep; -- Cette constante contient le nombre de registres

-- On déclare le tableau contenant les registres
type registre is array(pow-1 downto 0) of std_logic_vector(N-1 downto 0);
signal reg:registre;
-- Signaux internes
signal mux:std_logic_vector(N-1 downto 0); -- Le signal de sortie du multiplexeur
signal ld,ud:std_logic:='0'; -- Les signaux Load et Up/Down
signal fulemp:std_logic:='0'; -- Signal pour le AND sur les sorties du compteur
-- Signal pour le compteur
signal q:std_logic_vector(deep downto 0):=std_logic_vector(to_unsigned(0,deep+1));

begin
	-- Logique combinatoire pour Load et Up/Down
	ld<=rw and enable;
	ud<=enable and (not rw);
	-- Description du comportement du compteur. A noter que l'on utilise to_signed pour le fixer à -1 sur le reset
	q<=std_logic_vector(to_signed(-1,deep+1)) when rst='1' else q+1 when ud='0' and H='1' and H'event else q-1 when ud='1' and H='1' and H'event;
	-- AND sur les sorties du compteur
	fulemp<='1' when q(deep-1 downto 0)=std_logic_vector(to_unsigned(pow-1,deep)) else '0';
	empty<=fulemp and q(deep); -- Flag empty
	full<=fulemp and not q(deep); -- Flag full

	-- On décrit le premier registre séparément car son entrée est datain
	reg(0)<=std_logic_vector(to_unsigned(0,N)) when rst='1' else datain when ld='1' and H='1' and H'event;
	-- Et on peut ensuite décrire tous les autres à l'aide d'une boucle car leurs entrées/sorties sont récurrentes
	transferts:for i in 1 to pow-1 generate
		reg(i)<=std_logic_vector(to_unsigned(0,N)) when rst='1' else reg(i-1) when ld='1' and H='1' and H'event;
	end generate;

	-- Sur le multiplexeur on sélectionne le registre avec la valeur du compteur
	mux<=reg(conv_integer(q(deep-1 downto 0)));
	-- Et enfin la sortie reçoit la valeur du mux lors d'une opération de lecture
	dataout<=mux when rw='0' else (others=>'Z');

end dataflow;
