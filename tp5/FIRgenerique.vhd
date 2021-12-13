library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.monpack.all;

entity FIRgenerique is
	generic(N:natural);
	port(x:real;
		y:out real;
		rst,h:std_logic);
	end FIRgenerique;

architecture beh of FIRgenerique is

	-- On définit maintenant des tableaux pour les échantillons
	-- et les coefficients
	signal xi:defmem(0 to N-1);
	signal bi:defmem(0 to N-1):=(others => 1.0/real(N));

	begin
		process(h,rst)
			variable Yb:real:=0.0;
			begin
				if rst='0' then
					-- On réinitialise les échantillons
					-- et la sortie
					for i in 0 to N-1 loop
						xi(i)<=0.0;
					end loop;
					y<=0.0;
				elsif h'event and h='1' then
					-- Sinon on fait les calculs
					xi(0)<=x;
					Yb:=xi(0)*bi(0);
					for i in 1 to N-1 loop
						xi(i)<=xi(i-1);
						Yb:=Yb+xi(i)*bi(i);
					end loop;
					Y<=Yb; -- Affectation de la sortie
				end if;
		end process;
end beh;
