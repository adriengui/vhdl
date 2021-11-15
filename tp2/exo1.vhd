entity controleur is
port(H, rst, ready, readwrite:bit; -- On définit ici tous les ports d'entrée de type bit
	oe, we:out bit); -- Et ici tous les ports de sortie de type bit
end controleur;
--------------------------------------------------------------------------------------------------------------------
architecture monoprocess of controleur is
begin
	process(rst, H) -- S'agissant d'une machine synchrone avec reset asynchrone, la liste de sensibilité ne prend que H et rst
	-- Avec un seul process, on peut déclarer la variable d'état dans le process car elle ne sera utilisée qu'à l'intérieur de celui-ci
	type defetat is(idle, decision, rea, writ);
	variable etat:defetat;

	begin
		if rst='0' then -- Le reset doit etre actif à l'état bas
			etat:=idle; -- Lors du reset, on revient à l'état initial
		elsif H='1' and H'event then
			oe<='0'; -- Avant toute chose, on remet à chaque fois toutes les sorties à 0
			we<='0';

			case etat is -- Puis on fait un case sur l'état puis on décrit le comportement de chacun d'entre eux
				when idle => 
					if ready='1' then 
						etat:=decision; 
					end if;
				when decision => 
					if readwrite='1' then 
						etat:=rea; 
					else 
						etat:=writ; 
					end if;
				when rea => 
					oe<='1'; -- On allume la sortie oe dès qu'on est sur l'état read, c'est une machine de Moore
					if ready='1' then 
						etat:=idle; 
					end if;
				when writ => 
					we<='1'; -- Idem avec la sortie we
					if ready='1' then 
						etat:=idle; 
					end if;
			end case;
		end if;
	end process;
end monoprocess;
--------------------------------------------------------------------------------------------------------------------
architecture biprocess of controleur is

type defetat is(idle, decision, rea, writ);
signal etat,netat:defetat; -- On a maintenant besoin d'un signal nétat qui va contenir le nouvel état

begin
	mem:process(rst, H) -- Dans cette version, il y a un process qui va mémoriser l'état et un autre qui va effectuer les opérations combinatoires
	begin -- Dans le process de mémorisation, la liste de sensibilité ne prend que H et rst, car les opérations de mémorisation de l'état
		-- doivent etre synchrones, et le reset toujours asynchrone
		if rst='0' then
			etat<=idle;
		elsif H='1' and H'event then
			etat<=netat;
		end if;
	end process;

	comb:process(etat, ready, readwrite) -- Le process combinatoire contient quant à lui dans sa liste de sensibilité le signal d'état,
						-- ainsi que les entrées car c'est justement ces-dernières qui doivent modifier le nétat
	begin
		oe<='0';
		we<='0';
		netat<=etat; -- En plus de remettre les sorties à 0, il faut aussi affecter l'état au nétat car sinon, le système pourra
				-- avoir un comportement non cohérent
		case etat is
			when idle => -- Le fonctionnement du case est le meme, mis à part que l'on modifie maintenant nétat et non plus état 
				if ready='1' then 
					netat<=decision; 
					end if;
			when decision => 
				if readwrite='1' then 
					netat<=rea; 
				else 
					netat<=writ; 
				end if;
			when rea => 
				oe<='1'; 
				if ready='1' then 
					netat<=idle; 
				end if;
			when writ => 
				we<='1'; 
				if ready='1' then 
					netat<=idle; 
				end if;
		end case;
	end process;
end biprocess;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
entity controleurburst is
port(H, rst, ready, readwrite, burst:bit; -- Dans l'entité de la version burst, il faut rajouter l'entrée burst
	oe, we:out bit;
	adr:out bit_vector(1 downto 0)); -- Ainsi que la sortie adr
end controleurburst;
--------------------------------------------------------------------------------------------------------------------
architecture burst of controleurburst is

type defetat is(idle, decision, writ, read0, read1, read2, read3); -- Il faut ajouter les 3 états de lecture constituant le mode burst
signal etat,netat:defetat;

begin
	mem:process(rst, H) -- Le process de mémorisation reste identique
	begin
		if rst='0' then
			etat<=idle;
		elsif H='1' and H'event then
			etat<=netat;
		end if;
	end process;

	comb:process(etat, ready, readwrite, burst) -- Dans la liste de sensibilité du process combinatoire, il faut ajouter l'entrée burst
	begin
		oe<='0';
		we<='0';
		adr<="00"; -- Il est aussi nécessaire de remettre la sortie adr à 00
		netat<=etat;

		case etat is
			when idle => -- Les états idle, decision et write sont identiques
				if ready='1' then 
					netat<=decision; 
				end if;
			when decision => 
				if readwrite='1' then 
					netat<=read0; 
				else 
					netat<=writ; 
				end if;
			when writ => 
				we<='1'; 
				if ready='1' then 
					netat<=idle; 
				end if;
			when read0 => 
				oe<='1'; 
				if ready='1' then 
					if burst='1' then -- En revanche il faut ajouter un test sur l'état read0 afin de
							-- prendre en compte le mode burst
						netat<=read1; 
					else 
						netat<=idle; 
					end if; 
				end if;
			when read1 => -- Et enfin les 3 autres états du mode burst sont assez simples
				oe<='1'; 
				adr<="01"; -- Il faut bien penser à incrémenter la valeur de l'adr à chaque fois
				if ready='1' then 
					netat<=read2; 
				end if;
			when read2 => 
				oe<='1'; 
				adr<="10"; 
				if ready='1' then 
					netat<=read3; 
				end if;
			when read3 => 
				oe<='1'; 
				adr<="11"; 
				if ready='1' then 
					netat<=idle; 
				end if;
		end case;
	end process;
end burst;
