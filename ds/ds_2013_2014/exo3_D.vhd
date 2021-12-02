entity faf is
port(a,b,ci:bit;
	s:out bit);
end faf;

architecture dflow of faf is
begin
	s<=a xor b xor ci;
end dflow;
