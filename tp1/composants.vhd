entity Mux is
generic(N:natural:=2;
	tmux:time:=3 ns);
port(sel:bit;
	A,B:bit_vector(N downto 1);
	V:out bit_vector(N downto 1));
end Mux;

architecture beh of Mux is
begin
	process(sel,A,B)
	begin
		if sel='0' then 
			V<=A after tmux;
		else 
			V<=B after tmux;
		end if;
	end process;
end beh;
-------------------------------------------------------------------
entity Registre is
generic(N:natural:=2;
	tco:time:=2 ns);
port(H:bit;
	V:bit_vector(N downto 1);
	R:out bit_vector(N downto 1));
end Registre;

architecture beh of Registre is
begin
	process(H)
	begin
		if H'event and H='1' then 
			R<=V after tco;
		end if;
	end process;
end beh;
