#### Consultas SQL
<p>En este archivo se proporciona información acerca de consultas realizadas
y el resultado. Ademas de informacion acerca de las palabras reservadas</p>

##### A. Palabra reservada "SELECT"
##### A. Palabra reservada "JOIN"

> [!NOTE]
>  Descripcion de las consultas:

##### 1.-Nombre de los soldados y compañía han repetido en algún servicio.

```bash
SELECT columns  FROM table1 JOIN table2 ON columntable1 = columntable2 JOIN table3 ON columntable2 = columntable3 GROUP BY columns HAVING COUNT(DISTINCT columntable3) > 1;

```

##### 2.-Nombre del soldado que ha realizado más servicios.

##### 3.-Nombre del servicio que se ha realizado más ocasiones

