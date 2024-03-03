CREATE OR REPLACE FUNCTION array(int) RETURNS int as $$
DECLARE
	matriz int[];
	c int;
	t int:=$1;
BEGIN
	for c in 1..t
		loop
			matriz[c]:=c;
			raise notice 'matriz [%]', matriz[c];
		end loop;
	return 0;
END;
$$ language plpsgsql;

