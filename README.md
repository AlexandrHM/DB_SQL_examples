![DB_Postgresql](https://github.com/OyasumiiAlex/DB_SQL_examples/assets/44487342/1d4b3409-289c-4153-b3ac-13dbdf5d33d7)
#  Ejemplos de implementacion, diseño y consultas de una base de datos SQL

#### Descripción
<p>Este repositorio es una recopilación de los aspectos mas importantes relacionados con el diseño, implementación y consultas de una base de datos utilizando PostgreSQL como administrador; para el apartado de consultas, todo se realizó por medio de la linea de comandos, tambien como objetivo: Practicar los comandos más comunes para la manipulación de una base de datos.
Para cada ejemplo se presenta una pequeña introduccion de la problematica la cual explica los puntos importantes a tomar en cuenta en dicho diseño.</p>

## Sobre los temas a tratar

##### A. Diseño de la Base de Datos:
+ Diagramas entidad-relación
+ Diagrama relacional.
+ Definición de la estructura de la base de datos.

##### B. Implementación en PostgreSQL:
+ Creación de tablas según el diseño propuesto.
+ Inserción de datos de ejemplo para pruebas y demostración.
  
##### C. Consultas:
+ Ejemplos de consultas SQL para realizar operaciones comunes.
+ Consultas avanzadas para análisis de datos y generación de reportes.

##### D. Funciones y Procedimientos Almacenados:
+ Implementación de funciones y procedimientos almacenados para automatizar tareas recurrentes o complejas.

#### Estado del Proyecto
- <p> En desarrollo </p>

> [!IMPORTANT]
> Tomar en cuenta estos aspectos antes de hacer uso de este proyecto.

#### Proceso de instalación 
<p>Para el uso y prueba de los comandos u ejemplos de consultas, tomar en cuenta que es necesario realizar una instalacion 
previa del administrador de base de datos PostgreSQL, esto puede variar su sistema operativo, por lo que debe tomar en cuenta
dicha proceso de instalación</p>

> [!NOTE]
>  Comandos para exportar e importar un archivo SQl (Distribuciones Linux)

#### Exportar

```bash
pg_dump -U user_db -W -h localhost name_db > name_backup.sql
```
#### Importar

```bash
psql -U user_db -d name_db -h localhost -f name_backup.sql
```

## Listado de base de datos

##### B. Base de datos "ejercito"
###### Diagrama E-R

<img width="650" alt="ER-Ejercito" src="https://github.com/OyasumiiAlex/DB_SQL_examples/assets/44487342/82777e6f-396b-4f2b-a23e-552de92bf6ed">

###### Modelo relacional

<img width="650" alt="MR-Ejercito" src="https://github.com/OyasumiiAlex/DB_SQL_examples/assets/44487342/23706c5e-cd9a-441f-80fa-e7d51de685d9">

##### A. Base de datos "Tienda"
###### Diagrama E-R

###### Modelo relacional
