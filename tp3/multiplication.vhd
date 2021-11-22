library ieee;
use ieee.std_logic_1164.all; -- Il faut tout d'abord inclure le std_logic
use ieee.std_logic_unsigned.all;

entity mult is
-- Les entr�es seront de 8 bits et la sortie de 16 bits
port(multiplieur,multiplicande:std_logic_vector(7 downto 0);
	go,clk,rst:std_logic;
	S:out std_logic_vector(15 downto 0);
	fin:out std_logic);
end mult;

architecture rtl of mult is

-- On d�clare les signaux internes
signal z, ldc, razc, lda, shiftdec, ldqi, cout, c:std_logic:='0';

-- Somme et multiplex correspondent aux signaux en sortie d'additionneur
-- et de multiplexeur respectivement
signal a,q,somme,multiplex:std_logic_vector(7 downto 0):="00000000";

-- On doit utiliser un signal interne � l'additionneur de 9 bits
-- nous permettant de r�cup�rer la retenue sur le bit de poids fort
signal v:std_logic_vector(8 downto 0):="000000000";
signal i:std_logic_vector(7 downto 0):="00000000";

-- Etats du controleur
type defetat is(e0,e1,e2);
signal etat,netat:defetat;

begin
	-- On v�rifie que les commandes de chargement et de d�calage
	-- des registres ne soient pas simultan�ment � 1
	assert not(shiftdec='1' and ldqi='1') report "pb reg Q ou I" severity error;
	assert not(shiftdec='1' and lda='1') report "pb reg A" severity error;
	assert not(razc='1' and ldc='1') report "pb reg C" severity error;

	-- On d�crit le comportement des registres et du d�compteur
	c<=cout when clk'event and clk='1' and ldc='1' else '0' when clk'event and clk='1' and razc='1';
	a<=multiplex when clk'event and clk='1' and lda='1' else (c & a(7 downto 1)) when clk'event and clk='1' and shiftdec='1';
	q<=multiplieur when clk'event and clk='1' and ldqi='1' else (a(0) & q(7 downto 1)) when clk'event and clk='1' and shiftdec='1';
	i<="00001000" when clk'event and clk='1' and ldqi='1' else i-"00000001" when clk'event and clk='1' and shiftdec='1';
	-- Il ne faut pas oublier d'adapter la valeur de I � la longueur des entr�es

	-- Ensuite on d�crit le comportement des composants asynchrones
	-- (multiplexeur, additionneur, comparateur � 0)
	multiplex<=somme when ldqi='0' else "00000000";
	v<=('0' & a)+('0' & multiplicande);
	-- Une fois que l'on obtient l'addition sur un bit suppl�mentaire dans V,
	-- on r�cup�re le bit de poids fort pour la retenue et le reste pour le 
	-- r�sultat de la somme
	somme<=v(7 downto 0);
	cout<=v(8);
	z<='1' when i="00000000" else '0';
	
	-- On affecte la sortie
	S(15 downto 8)<=a;
	S(7 downto 0)<=q;

	-- Le process de m�morisation de l'unit� de controle est toujours le meme
	-- Le reset est actif � l'�tat bas
	mem:process(rst, clk)
	begin
		if rst='0' then
			etat<=e0;
		elsif clk='1' and clk'event then
			etat<=netat;
		end if;
	end process;

	-- Et enfin on fait le process combinatoire
	-- La liste de sensibilit� re�oit l'�tat courant et
	-- les signaux d'entr�e de l'unit� de controle
	comb:process(etat, go, z, q(0))					
	begin
		lda<='0';
		ldc<='0';
		ldqi<='0';
		razc<='0';
		shiftdec<='0';
		fin<='0';

		netat<=etat;
				
		-- Puis on d�crit le comportement en fonction
		-- du diagramme d'�tat
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