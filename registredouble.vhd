entity registredouble is
generic(N:natural:=4;
	tco:time);
port(sel,H:bit;
	A,B:bit_vector(N downto 1);
	R:out bit_vector(N downto 1));
end registredouble;
-------------------------------------------------------------------
architecture beh of registredouble is
begin
	process(H)
	begin
		if H'event and H='1' then
			if sel='0' then 
				R<=A after tco;
			else 
				R<=B after tco;
			end if;
		end if;
	end process;
end beh;
-------------------------------------------------------------------
architecture structure of registredouble is

component Mux is
generic(N:natural:=2;
	tmux:time:=3 ns);
port(sel:bit;
	A,B:bit_vector(N downto 1);
	V:out bit_vector(N downto 1));
end component;

component Registre is
generic(N:natural:=2;
	tco:time:=2 ns);
port(H:bit;
	V:bit_vector(N downto 1);
	R:out bit_vector(N downto 1));
end component;

	signal V:bit_vector(N downto 1);

begin

	mux1:Mux generic map(N=>N) port map(sel=>sel,A=>A,B=>B,V=>V);
	reg1:Registre generic map(N=>N) port map(H=>H,V=>V,R=>R);

end structure;
-------------------------------------------------------------------
architecture dflow of registredouble is
signal V:bit_vector(N downto 1);
constant tmux:time:=3 ns;
begin
	V<=A after tmux when sel='0' else B after tmux;
	R<=V after tco when H='1' and H'event;
end dflow;
