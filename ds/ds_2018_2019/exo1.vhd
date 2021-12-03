entity compteur is
port(rst,raz,inc,clk:bit;
	q:out natural range 0 to 999);
end compteur;

architecture beh of compteur is
begin
	process(rst,clk)
	variable s:natural range 0 to 999;

	begin
		if rst='1' then
			s:=0;
		elsif clk'event and clk='1' then
			assert not(inc='1' and raz='1') report "entree interdite" severity failure;
			if inc='0' and raz='1' then
				s:=0;
			elsif inc='1' and raz='0' then
				s:=(s+1) mod 1000;
			end if;
		end if;
		q<=s;
	end process;
end beh;