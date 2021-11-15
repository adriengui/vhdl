entity compteur is
port(clk, rst, E, S:bit; -- L'entité du composant est très simple
	cup:out bit);
end compteur;

architecture biprocess of compteur is

type defetat is(q0, q1, q2); -- Comme on utilise deux process, on définit toujours état et nétat comme des signaux
signal etat,netat:defetat;

begin
	mem:process(rst, clk) -- Le process de mémorisation est toujours le meme
	begin
		if rst='0' then
			etat<=q0; -- Sur le rst on revient à l'état initial Q0
		elsif clk='1' and clk'event then
			etat<=netat;
		end if;
	end process;

	comb:process(etat, E, S) -- Ici en plus de l'état, on met les signaux d'entrée E et S
	begin
		cup<='0'; -- On réinitialise les sorties et on met à jour le nétat
		netat<=etat;

		case etat is -- Puis enfin on décrit le fonctionnement de la machine avec un case
			when q0 => 
				if E='1' then 
					if S='1' then 
						netat<=q2; 
						cup<='1'; -- S'agissant d'une machine de Mealy, les sorties dépendant de l'état interne
							-- et des entrées, contrairement au controleur précédent.
						-- Dans Q0, on allume la sortie lors du décomptage car on passe à Q2
					else 
						netat<=q1; 
					end if; 
				end if;
			when q1 => 
				if E='1' then -- A chaque fois, on teste donc en premier E, puis S car si enable est désactivé,
						-- il ne faut rien faire
					if S='1' then 
						netat<=q0; 
					else 
						netat<=q2; 
					end if; 
				end if;
			when q2 => 
				if E='1' then
					if S='1' then 
						netat<=q1; 
					else 
						netat<=q0; 
						cup<='1'; -- Dans Q2, allume la sortie lors du comptage car on passe à Q0
					end if;
				end if;
		end case;
	end process;
end biprocess;
