create or replace function sumafecha(date, interval) returns date as $$
declare
	fecha date;
begin
	fecha := $1 + $2;
	return fecha;
end;
$$ language plpgsql;
