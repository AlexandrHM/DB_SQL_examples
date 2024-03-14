CREATE OR REPLACE FUNCTION arraystr() RETURNS void as $$
DECLARE
	matriz varchar[];
	i record;
	c int:=1;
BEGIN
	for i in select *from soldados
		loop
			matriz[c]:=i.nombre_sol;
			raise notice 'El nombre del soldado es %', matriz[c];
			c:=c+1;
		end loop;
END;
$$ language plpgsql;

