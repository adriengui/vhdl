entity registredouble is
generic(N:natural:=4;
	tmux:time:=3 ns;
	tco:time:=2 ns);
port(sel,H:bit;
	A,B:bit_vector(N downto 1);
	R:out bit_vector(N downto 1));
end registredouble;
-------------------------------------------------------------------
architecture structure of registredouble is

component Mux is
generic(N:natural:=2;
	tmux:time:=3 ns);
port(sel:bit;
	A,B:bit_vector(1 to N);
	V:out bit_vector(1 to N));
end component;

component Registre is
generic(N:natural:=2;
	tco:time:=2 ns);
port(H:bit;
	V:bit_vector(1 to N);
	R:out bit_vector(1 to N));
end component;

	signal V:bit_vector(1 to N);

begin

	muxx:Mux generic map(N,tmux) port map(sel,A,B,V);
	reg:Registre generic map(N,tco) port map(H,V,R);

end structure;
-------------------------------------------------------------------
architecture beh of registredouble is
begin
	process(H)
	begin
		if H='1' then
			if sel='0' then 
				R<=A after tco;
			else 
				R<=B after tco;
			end if;
		end if;
	end process;
end beh;
-------------------------------------------------------------------
architecture dflow of registredouble is
signal V:bit_vector(1 to N);
begin
	V<=A after tmux when sel='0' else B after tmux;
	R<=V after tco when H='1' and H'event;
end dflow;
