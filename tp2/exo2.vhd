entity compteur is
port(clk, rst, E, S:bit;
	cup:out bit);
end compteur;

architecture biprocess of compteur is

type defetat is(q0, q1, q2);
signal etat,netat:defetat;

begin
	mem:process(rst, clk)
	begin
		if rst='0' then
			etat<=q0;
		elsif clk='1' and clk'event then
			etat<=netat;
		end if;
	end process;

	comb:process(etat, E, S)
	begin
		cup<='0';
		netat<=etat;

		case etat is
			when q0 => 
				if E='1' then 
					if S='1' then 
						netat<=q2; 
						cup<='1'; 
					else 
						netat<=q1; 
					end if; 
				end if;
			when q1 => 
				if E='1' then 
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
						cup<='1'; 
					end if;
				end if;
		end case;
	end process;
end biprocess;
