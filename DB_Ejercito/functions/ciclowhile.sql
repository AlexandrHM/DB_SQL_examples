CREATE OR REPLACE FUNCTION ciclowhile(int) RETURNS int as $$
DECLARE
	limite int:=$1;
	c int:=1;
	res int:=0;
BEGIN
	while(c <= limite)
		loop
			res=res+c;
			c:=c+1;
			raise notice 'Resultado:=(%)', res;
		end loop;
	return res;
END;
$$ language plpgsql;
