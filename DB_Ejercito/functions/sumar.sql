CREATE OR REPLACE FUNCTION suma(int, int) returns int as $$
declare
	dato1 int;
	dato1 int;
	r int;
BEGIN
	dato1:=$1;
	dato1:=$2;
	r:=dato1+dato2;
	return r;
END;
$$ language plpgsql;
