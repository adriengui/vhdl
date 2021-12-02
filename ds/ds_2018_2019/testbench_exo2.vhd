library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test is
end test;

architecture bench of test is

component aff7seg is
port(data:unsigned(12 downto 0);
	aff3,aff2,aff1,aff0:out unsigned(6 downto 0));
end component;

signal data:unsigned(12 downto 0);
signal aff3,aff2,aff1,aff0:unsigned(6 downto 0);

begin
	UUT:aff7seg port map(data,aff3,aff2,aff1,aff0);
	data<="0111010110100";
end bench;
