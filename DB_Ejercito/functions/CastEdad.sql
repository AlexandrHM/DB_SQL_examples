Create or replace function edadcastvar(date,date) returns varchar as $$
declare
	fecha varchar(20);
begin
	fecha:= age($1,$2);
	return fecha;
end;
$$ language plpgsql;

