#### Consultas SQL (Query)
<p>En este archivo se proporciona información acerca de consultas realizadas
y el resultado. Ademas de informacion acerca de las palabras reservadas</p>

##### A. Palabra reservada "SELECT"
+ Selecciona datos de una o varias tablas en una base de datos.

##### B. Palabra reservada "JOIN"
+ Combina datos de dos o más tablas en función de una condición relacionada.

##### c. Palabra reservada "GROUP BY"
+ Agrupa filas que tienen valores idénticos en una o más columnas especificadas.

##### D. Palabra reservada "ORDER BY"
+ Ordena el resultado de una consulta según una o más columnas especificadas, ya sea de forma ascendente (ASC) o descendente (DESC).

##### E. Palabra reservada "HAVING"
+ Se utiliza junto con GROUP BY para filtrar el resultado de una consulta basado en una condición de grupo.

##### F. Palabra reservada "LIMIT"
+ Limita el número de filas devueltas por una consulta.
<br>

> [!NOTE]
>  Descripcion de las consultas:

##### 1.-Nombre de los soldados y compañía han repetido en algún servicio.

```bash
SELECT columns  FROM table1 JOIN table2 ON columntable1 = columntable2 JOIN table3 ON columntable2 = columntable3 GROUP BY columns HAVING COUNT(DISTINCT columntable3) > 1;
```
<p>Resultado</p>
<img width="450" alt="ejercicio1IMG" src="https://github.com/OyasumiiAlex/DB_SQL_examples/assets/44487342/3493597c-cbc2-4dd2-bbd5-b6cd1352bd8d">

##### 2.-Nombre del soldado que ha realizado más servicios.

```bash
SELECT columns from table1 JOIN table2 ON columntable1= columntable2 GROUP BY columns ORDER BY COUNT(columntable2) DESC LIMIT 1;
```
<p>Resultado</p>
<img width="450" alt="ejercicio2IMG" src="https://github.com/OyasumiiAlex/DB_SQL_examples/assets/44487342/3d841710-4e0e-41e8-8c08-17707c21d8ed">

##### 3.-Nombre del servicio que se ha realizado más ocasiones

```bash
SELECT columntable1 FROM table1 JOIN table2 ON column2table1 = columntable2 GROUP BY columntable1 ORDER BY COUNT(columntable2) DESC LIMIT 1;
```
<p>Resultado</p>
<img width="450" alt="ejercicio3IMG" src="https://github.com/OyasumiiAlex/DB_SQL_examples/assets/44487342/4695c050-6511-4616-b310-48a43932ceb4">



