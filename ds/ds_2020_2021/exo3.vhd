entity alarme is
generic(nb:natural;
	tbip,ts:time);
port(ma:bit;
	al:out boolean);
end alarme;

architecture beh of alarme is
begin
	process
	begin
		wait until ma='1';
		loop
			for i in 1 to nb loop
				al<=true;
				wait for tbip/2;
				al<=false;
				wait for tbip/2;
				exit when ma='0'; -- Modification Question C
			end loop;
		
			wait for ts;
			exit when ma='0'; -- Celui-la doit rester meme dans la Question C
		end loop;

	end process;
end beh;