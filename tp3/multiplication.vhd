library ieee;
use ieee.std_logic_1164.all; -- Il faut tout d'abord inclure le std_logic
use ieee.std_logic_unsigned.all;

entity mult is
-- Les entrées seront de 8 bits et la sortie de 16 bits
port(multiplieur,multiplicande:std_logic_vector(7 downto 0);
	go,clk,rst:std_logic;
	S:out std_logic_vector(15 downto 0);
	fin:out std_logic);
end mult;

architecture rtl of mult is

-- On déclare les signaux internes
signal z, ldc, razc, lda, shiftdec, ldqi, cout, c:std_logic:='0';

-- Somme et multiplex correspondent aux signaux en sortie d'additionneur
-- et de multiplexeur respectivement
signal a,q,somme,multiplex:std_logic_vector(7 downto 0):="00000000";

-- On doit utiliser un signal interne à l'additionneur de 9 bits
-- nous permettant de récupérer la retenue sur le bit de poids fort
signal v:std_logic_vector(8 downto 0):="000000000";
signal i:std_logic_vector(7 downto 0):="00000000";

-- Etats du controleur
type defetat is(e0,e1,e2);
signal etat,netat:defetat;

begin
	-- On vérifie que les commandes de chargement et de décalage
	-- des registres ne soient pas simultanément à 1
	assert not(shiftdec='1' and ldqi='1') report "pb reg Q ou I" severity error;
	assert not(shiftdec='1' and lda='1') report "pb reg A" severity error;
	assert not(razc='1' and ldc='1') report "pb reg C" severity error;

	-- On décrit le comportement des registres et du décompteur
	c<=cout when clk'event and clk='1' and ldc='1' else '0' when clk'event and clk='1' and razc='1';
	a<=multiplex when clk'event and clk='1' and lda='1' else (c & a(7 downto 1)) when clk'event and clk='1' and shiftdec='1';
	q<=multiplieur when clk'event and clk='1' and ldqi='1' else (a(0) & q(7 downto 1)) when clk'event and clk='1' and shiftdec='1';
	i<="00001000" when clk'event and clk='1' and ldqi='1' else i-"00000001" when clk'event and clk='1' and shiftdec='1';
	-- Il ne faut pas oublier d'adapter la valeur de I à la longueur des entrées

	-- Ensuite on décrit le comportement des composants asynchrones
	-- (multiplexeur, additionneur, comparateur à 0)
	multiplex<=somme when ldqi='0' else "00000000";
	v<=('0' & a)+('0' & multiplicande);
	-- Une fois que l'on obtient l'addition sur un bit supplémentaire dans V,
	-- on récupère le bit de poids fort pour la retenue et le reste pour le 
	-- résultat de la somme
	somme<=v(7 downto 0);
	cout<=v(8);
	z<='1' when i="00000000" else '0';
	
	-- On affecte la sortie
	S(15 downto 8)<=a;
	S(7 downto 0)<=q;

	-- Le process de mémorisation de l'unité de controle est toujours le meme
	-- Le reset est actif à l'état bas
	mem:process(rst, clk)
	begin
		if rst='0' then
			etat<=e0;
		elsif clk='1' and clk'event then
			etat<=netat;
		end if;
	end process;

	-- Et enfin on fait le process combinatoire
	-- La liste de sensibilité reçoit l'état courant et
	-- les signaux d'entrée de l'unité de controle
	comb:process(etat, go, z, q(0))					
	begin
		lda<='0';
		ldc<='0';
		ldqi<='0';
		razc<='0';
		shiftdec<='0';
		fin<='0';

		netat<=etat;
				
		-- Puis on décrit le comportement en fonction
		-- du diagramme d'état
		case etat is
			when e0 => 
				if go='1' then 
					netat<=e1; 
					lda<='1';
					ldqi<='1';
					razc<='1';
				end if;

			when e1 => 
				if z='1' then 
					netat<=e0;
					fin<='1';
				else
					netat<=e2;
					if q(0)='1' then
						lda<='1';
						ldc<='1';
					end if;
				end if;
			
			when e2 => 
				netat<=e1;
				razc<='1';
				shiftdec<='1';
		end case;
	end process;
end rtl;