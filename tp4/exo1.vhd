entity cell is
port(Ai,Bi,Ci:bit; -- Op�randes
	S:bit_vector(1 downto 0); -- Entr�es de s�lection
	Gi,Co:out bit); -- Sorties (r�sultat)
end cell;

architecture dataflow of cell is
signal Y:bit; -- Signal interm�diaire � la sortie du OR
begin
	-- Description du OR et des deux AND
	Y<=(S(1) and (not Bi)) or (S(0) and Bi);
	-- Sortie du Full Adder
	Gi<=Ci xor Ai xor Y;
	-- Retenue du Full Adder
	Co<=(Ai and Y) or (Ci and (Ai xor Y));
end dataflow;
