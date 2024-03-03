CREATE OR REPLACE FUNCTION arrayquery() RETURNS void as $$
DECLARE
	matriz varchar[];
	c int:=1;
	i record;
BEGIN
	for i in select acti_p from compania group by acti_p
		loop
			matriz[c]:=i.acti_p;
			raise notice 'compañia=%',matriz[c];
			c:=c+1;
		end loop;
END;
$$ language plpgsql;


