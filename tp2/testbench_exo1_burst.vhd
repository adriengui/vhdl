entity test is
end test;

architecture bench of test is

component controleurburst is
port(H, rst, ready, readwrite, burst:bit;
	oe, we:out bit;
	adr:out bit_vector(1 downto 0));
end component;

signal H, rst, ready, readwrite, burst, oe, we:bit;
signal adr:bit_vector(1 downto 0);

begin
	UUT:controleurburst port map(H=>H, rst=>rst, ready=>ready, readwrite=>readwrite, burst=>burst, oe=>oe, we=>we, adr=>adr);
	H<=not H after 10 ns;
	rst<='1', '0' after 85 ns, '1' after 115 ns;--, '0' after 200 ns, '1' after 250 ns;
	ready<='1' after 25 ns, '0' after 55 ns, '1' after 125 ns, '0' after 135 ns, '1' after 150 ns, '0' after 168 ns, '1' after 195 ns, '0' after 300 ns, '1' after 400 ns;
	readwrite<='1' after 175 ns;
	burst<='1' after 235 ns, '0' after 310 ns;
end bench;