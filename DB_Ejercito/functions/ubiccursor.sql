CREATE OR REPLACE FUNCTION ubicursor() RETURNS void as $$
DECLARE
	cursorcuartel cursor for select *from cuartel where ubicacion='No_definido' for update;
	auxcuartel cuartel%rowtype;
BEGIN
	open cursorcuartel;
		loop
			fetch cursorcuartel into auxcuartel;
			if cursorcuartel in null then exit;
			end if;
			update cuartel set ubicacion='Por_definir' where current of cursorcuartel;
		end loop;
	close cursorcuartel;
END;
$$ language plpgsql;
