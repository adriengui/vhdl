library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mult is
port(multiplieur,multiplicande:std_logic_vector(4 downto 0);
	go,clk,rst:std_logic;
	S:out std_logic_vector(9 downto 0);
	fin:out std_logic);
end mult;

architecture rtl of mult is

signal z, ldc, razc, lda, shiftdec, ldqi, cout, c:std_logic:='0';
signal a,q,somme,multiplex:std_logic_vector(4 downto 0):="00000";
signal v:std_logic_vector(5 downto 0):="000000";
signal i:std_logic_vector(3 downto 0):="0000";

type defetat is(e0,e1,e2);
signal etat,netat:defetat;

begin
	assert not(shiftdec='1' and ldqi='1') report "pb reg Q ou I" severity error;
	assert not(shiftdec='1' and lda='1') report "pb reg A" severity error;
	assert not(razc='1' and ldc='1') report "pb reg C" severity error;

	c<=cout when clk'event and clk='1' and ldc='1' else '0' when clk'event and clk='1' and razc='1';
	a<=multiplex when clk'event and clk='1' and lda='1' else (c & a(4 downto 1)) when clk'event and clk='1' and shiftdec='1';
	q<=multiplieur when clk'event and clk='1' and ldqi='1' else (a(0) & q(4 downto 1)) when clk'event and clk='1' and shiftdec='1';
	i<="0101" when clk'event and clk='1' and ldqi='1' else i-"0001" when clk'event and clk='1' and shiftdec='1';

	multiplex<=somme when ldqi='0' else "00000";
	v<=('0' & a)+('0' & multiplicande);
	somme<=v(4 downto 0);
	cout<=v(5);
	z<='1' when i="0000" else '0';
	
	S(9 downto 5)<=a;
	S(4 downto 0)<=q;

	mem:process(rst, clk)
	begin
		if rst='1' then
			etat<=e0;
		elsif clk='1' and clk'event then
			etat<=netat;
		end if;
	end process;

	comb:process(etat, go, z, q(0))					
	begin
		lda<='0';
		ldc<='0';
		ldqi<='0';
		razc<='0';
		shiftdec<='0';
		fin<='0';

		netat<=etat;
				
		case etat is
			when e0 => 
				if go='1' then 
					netat<=e1; 
					lda<='1';
					ldqi<='1';
					razc<='1';
				end if;

			when e1 => 
				if z='1' then 
					netat<=e0;
					fin<='1';
				else
					netat<=e2;
					if q(0)='1' then
						lda<='1';
						ldc<='1';
					end if;
				end if;
			
			when e2 => 
				netat<=e1;
				razc<='1';
				shiftdec<='1';
		end case;
	end process;
end rtl;