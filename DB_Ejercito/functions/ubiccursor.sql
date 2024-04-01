CREATE OR REPLACE FUNCTION ubicursor() RETURNS void as $$
DECLARE
	cursorcuartel cursor for select *from cuarteles where ubi_crtl='Sin_asignar' for update;
	auxcuartel cuarteles%rowtype;
BEGIN
	open cursorcuartel;
		loop
			fetch cursorcuartel into auxcuartel;
			exit when not found;
			update cuarteles set ubi_crtl='Por_definir' where current of cursorcuartel;
		end loop;
	close cursorcuartel;
END;
$$ language plpgsql;
