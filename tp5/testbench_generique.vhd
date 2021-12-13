library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.monpack.all;
use std.textio.all;

entity test is
end test;

architecture bench of test is
	-- On recopie l'entit� du composant g�n�rique
	component FIRgenerique is
		generic(N:natural);
		port(x:real;
			y:out real;
			rst,h:std_logic);
	end component;

	constant Ndata:natural:=6144; -- Longueur du fichier
					-- des donn�es d'entr�e
	constant Fe:time:=400 ns; -- Fr�quence d'�chantillonnage
	signal x,y:real:=0.0; -- Signaux d'entr�e/sortie
	signal rst,h,he:std_logic:='0';
	signal fin:boolean:=false;
	signal x_data:defmem(0 to Ndata-1); -- Tableau qui va contenir les donn�es d'entr�e
	file resultat:text open write_mode is "resultat.dat"; -- Fichier dans lequel on
								-- �crit les r�sultats

	begin
		UUT:FIRgenerique generic map(N=>256) port map(x=>x,y=>y,rst=>rst,h=>h);
		h<=not h after 20 ns;
		he<=not he after 350 ns;
		rst<='1';
		x_data<=initmem("signal.txt",Ndata); -- Lecture des donn�es

		process(he) -- Process qui lit les donn�es � la Fe
			variable i:natural:=0;
			begin
				if he'event and he='1' then
					if i>=Ndata-1 then
						i:=0;
						fin<=true;
					end if;
					x<=x_data(i);
					i:=i+1;
				end if;
		end process;

		process(h) -- Process qui �crit le fichier r�sultat
			variable l:line;
			begin
				if h'event and h='1' then
					write(l,string'("Sortie du filtre"));
					while not fin loop
						write(l,now);
						write(l,string'(" : "));
						write(l,y);
						writeline(resultat,l);
					end loop;
					file_close(resultat);
				end if;
		end process;
end bench;
