entity fsm is
port(rst,clk,x:bit;
	s0,s1,s2:out bit);
end fsm;

architecture beh of fsm is

type defetat is(f0,f1,e6,e7);
signal etat,netat:defetat;

begin
	mem:process(rst,clk)
	begin
		if rst='0' then
			etat<=f0;
		elsif clk'event and clk='1' then
			etat<=netat;
		end if;
	end process;

	comb:process(etat,x)
	begin
		s0<='0'; s1<='0'; s2<='0';
		netat<=etat;
		
		case etat is
			when f0 =>
				if x='0' then
					s0<='1';
					netat<=e7;
				end if;
			when e7 =>
				if x='1' then
					netat<=f0;
				else
					s1<='1';
					netat<=f1;
				end if;
			when f1 =>
				if x='1' then
					s0<='1';
					netat<=e7;
				else
					s0<='1'; s1<='1';
					netat<=e6;
				end if;
			when e6 =>
				if x='1' then
					s1<='1';
					netat<=f1;
				else
					s2<='1';
					netat<=f0;
				end if;
		end case;
	end process;
end beh;