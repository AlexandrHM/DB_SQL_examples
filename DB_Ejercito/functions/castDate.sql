create or replace function castdate(date, date) returns varchar(30) as $$
declare
	fecha varchar(30);
begin
	fecha:=age($1,$2);
	fecha := replace(fecha,'years','años');
	fecha := replace(fecha,'mons','meses');
	fecha := replace(fecha,'days','dias');
	fecha := replace(fecha,'year','año');
	fecha := replace(fecha,'mon','mes');
	fecha := replace(fecha,'day','dia');
	return fecha;
end;
$$ language plpgsql;
