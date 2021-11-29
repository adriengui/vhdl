entity cell is
port(Ai,Bi,Ci:bit;
	Sc:bit_vector(1 downto 0);
	Gi,Co:out bit);
end cell;

architecture dataflow of cell is
signal Y:bit;
begin
	Y<=(Sc(1) and (not Bi)) or (Sc(0) and Bi);
	Gi<=Ci xor Ai xor Y;
	Co<=(Ai and Y) or (Ci and (Ai xor Y));
end dataflow;
