/*1.-Nombre de los soldados y compañía han repetido en algún servicio.*/

SELECT nombre_sol, ape_sol, act_comp  FROM soldados JOIN companias ON id_comp_fk = id_comp JOIN serv_realz ON id_sol = id_sol_fk GROUP BY nombre_sol, ape_sol, act_comp, HAVING COUNT(DISTINCT id_serv_fk) > 1;

/*2.-Nombre del soldado que ha realizado más servicios.*/

SELECT nombre_sol, ape_sol from soldados JOIN serv_realz ON id_sol = id_sol_fk GROUP BY nombre_sol, ape_sol ORDER BY COUNT(id_serv_fk) DESC LIMIT 1;
/*3.-Nombre del servicio que se ha realizado más ocasiones*/

SELECT actividad FROM servicios JOIN serv_realz ON id_serv = id_serv_fk GROUP BY actividad ORDER BY COUNT(id_serv_fk) DESC LIMIT 1;