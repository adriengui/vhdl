library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity recepteur is
port(rst,rxd,h:std_logic;
	rxrdy,p:out std_logic;
	di:out std_logic_vector(7 downto 0));
end recepteur;

architecture mixte of recepteur is

signal rxrd,ldi,deci,zi,shd,ldt,dect,zt,lddirp,xorr:std_logic:='0';
signal d:std_logic_vector(8 downto 0):="000000000";
signal t:std_logic_vector(1 downto 0):="00";
signal i:std_logic_vector(3 downto 0):="0000";

type defetat is(t0,t1);
signal etat,netat:defetat;

constant tco:time:=5 ns;
constant tcomp:time:=10 ns;

begin
	zi<='1' after tcomp when i="0000" else '0' after tcomp;
	zt<='1' after tcomp when t="00" else '0' after tcomp;
	t<=(shd & '1') after tco when h'event and h='1' and ldt='1' else t-1 after tco when h'event and h='1' and dect='1';
	i<="1010" after tco when h'event and h='1' and ldi='1' else i-1 after tco when h'event and h='1' and deci='1';
	xorr<=d(8) xor d(7) xor d(6) xor d(5) xor d(4) xor d(3) xor d(2) xor d(1) xor d(0);
	d<=(rxd & d(8 downto 1)) after tco when h'event and h='1' and shd='1';
	di<=d(7 downto 0) after tco when h'event and h='1' and lddirp='1';
	p<=xorr after tco when h'event and h='1' and lddirp='1';
	rxrd<=not rxrd when h'event and h='1' and lddirp='1' else '0' when rst='1';
	rxrdy<=rxrd after tco;

	mem:process(rst,h)
	begin
		if rst='1' then
			etat<=t0 after tco;
		elsif h'event and h='1' then
			etat<=netat after tco;
		end if;
	end process;

	comb:process(etat,rxd,zt,zi)
	begin
		lddirp<='0';
		deci<='0';
		dect<='0';
		ldt<='0';
		shd<='0';
		ldi<='0';

		netat<=etat;

		case etat is
			when t0=>
				if rxd='0' then
					ldt<='1';
					ldi<='1';
					netat<=t1;
				end if;
			
			when t1=>
				if zt='0' then
					dect<='1';
				else
					ldt<='1';
					shd<='1';
					if zi='0' then
						deci<='1';
					else
						lddirp<='1';
						netat<=t0;
					end if;
				end if;
		end case;
	end process;
end mixte;
