entity fai is
port(a,b,ci:bit;
	s,co:out bit);
end fai;

architecture beh of fai is
begin
	process(a,b,ci)
	begin
		case (a&b&ci) is
			when "000" => s<='0'; co<='0';
			when "111" => s<='1'; co<='1';
			when "001" | "010" | "100" => s<='1'; co<='0';
			when "011" | "101" | "110" => s<='0'; co<='1';
		end case;
	end process;
end beh;