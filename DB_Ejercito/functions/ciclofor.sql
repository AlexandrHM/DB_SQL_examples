CREATE OR REPLACE FUNCTION ciclofor() RETURNS int as $$
DECLARE
	c int:=0;
	res int:=0;
BEGIN
	for c in 1..10
		loop
			reaise notice 'El resultado es (%):', res;
			res:=res+c;
		end loop;
	return res;
END;
$$ language plpgsql;
