use std.textio.all;

-- Déclarations du package
package monpack is
	type defmem is array(natural range <>) of real;
	impure function initmem(s:string; N:natural) return defmem;
end monpack;

-- Implémentation de la fonction initmem
package body monpack is
	impure function initmem(s:string; N:natural) return defmem is
		variable data:defmem(0 to N-1);
		variable l:line;
		variable i:natural:=0;
		file fic:text open read_mode is s;

		begin
			-- Lecture des lignes du fichier
			while not endfile(fic) loop
				readline(fic,l);
				if l'length > 0 then
					read(l,data(i));
					i:=i+1;
				end if;
			end loop;
			file_close(fic); -- Fermeture du fichier
			return data;
	end function;
end monpack; 