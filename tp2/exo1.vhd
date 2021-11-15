entity controleur is
port(H, rst, ready, readwrite:bit;
	oe, we:out bit);
end controleur;
--------------------------------------------------------------------------------------------------------------------
architecture monoprocess of controleur is
begin
	process(rst, H)
	type defetat is(idle, decision, rea, writ);
	variable etat:defetat;
	begin
		if rst='0' then
			etat:=idle;
		elsif H='1' and H'event then
			oe<='0';
			we<='0';

			case etat is
				when idle => if ready='1' then etat:=decision; end if;
				when decision => if readwrite='1' then etat:=rea; else etat:=writ; end if;
				when rea => oe<='1'; if ready='1' then etat:=idle; end if;
				when writ => we<='1'; if ready='1' then etat:=idle; end if;
			end case;
		end if;
	end process;
end monoprocess;
--------------------------------------------------------------------------------------------------------------------
architecture biprocess of controleur is
type defetat is(idle, decision, rea, writ);
signal etat,netat:defetat;
begin
	mem:process(rst, H)
	begin
		if rst='0' then
			etat<=idle;
		elsif H='1' and H'event then
			etat<=netat;
		end if;
	end process;

	comb:process(etat, ready, readwrite)
	begin
		oe<='0';
		we<='0';

		netat<=etat;
		case etat is
			when idle => if ready='1' then netat<=decision; end if;
			when decision => if readwrite='1' then netat<=rea; else netat<=writ; end if;
			when rea => oe<='1'; if ready='1' then netat<=idle; end if;
			when writ => we<='1'; if ready='1' then netat<=idle; end if;
		end case;
	end process;
end biprocess;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
entity controleurburst is
port(H, rst, ready, readwrite, burst:bit;
	oe, we:out bit;
	adr:out bit_vector(1 downto 0));
end controleurburst;
--------------------------------------------------------------------------------------------------------------------
architecture burst of controleurburst is
type defetat is(idle, decision, writ, read0, read1, read2, read3);
signal etat,netat:defetat;
begin
	mem:process(rst, H)
	begin
		if rst='0' then
			etat<=idle;
		elsif H='1' and H'event then
			etat<=netat;
		end if;
	end process;

	comb:process(etat, ready, readwrite, burst)
	begin
		oe<='0';
		we<='0';
		adr<="00";

		netat<=etat;
		case etat is
			when idle => if ready='1' then netat<=decision; end if;
			when decision => if readwrite='1' then netat<=read0; else netat<=writ; end if;
			when writ => we<='1'; if ready='1' then netat<=idle; end if;
			when read0 => oe<='1'; if ready='1' then 
				if burst='1' then netat<=read1; else netat<=idle; end if; 
			end if;
			when read1 => oe<='1'; adr<="01"; if ready='1' then netat<=read2; end if;
			when read2 => oe<='1'; adr<="10"; if ready='1' then netat<=read3; end if;
			when read3 => oe<='1'; adr<="11"; if ready='1' then netat<=idle; end if;
		end case;
	end process;
end burst;
