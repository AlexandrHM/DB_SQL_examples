CREATE OR REPLACE FUNCTION positivo(numeric) RETURNS boolean as $$
DECLARE
	dato numeric:=0;
	res boolean:=false;
BEGIN
	dato:=$1;
	if(dato>0)then
		res:=true;
	else
		if(dato = 0)then
			res:=true;
		end if;
	end if;
	return res;
END;
$$ language plpgsql;
