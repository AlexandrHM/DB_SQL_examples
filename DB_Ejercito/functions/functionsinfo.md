#### Consultas SQL (Query)
<p>En este archivo se proporciona información acerca de las funciones realizadas
y el resultado. Ademas de informacion acerca de las palabras reservadas u sintaxis
de la misma.</p>

##### A. Palabra reservada CREATE OR REPLACE FUNCTION
+ Esta es la declaración que se utiliza para crear una nueva función o reemplazar una función existente.
  Si la función ya existe, la cláusula OR REPLACE la reemplazará por la nueva definición.

##### B. Palabra reservada RETURNS
+ Esto especifica el tipo de datos que la función devolverá como resultado.
Puede ser cualquier tipo de datos válido en PostgreSQL. 

##### c. Palabra reservada DECLARE
+ Esta sección es opcional y se utiliza para declarar variables locales que solo existen dentro del alcance de la función.

##### D. Palabra reservada BEGIN ... END
+ Este es el bloque principal de la función, donde se encuentra el código SQL que realiza las operaciones deseadas.
Debe estar contenido entre BEGIN y END.

##### E. Palabra reservada LANGUAGE plpgsql
+ Esto especifica el lenguaje en el que está escrita la función.
En este caso, plpgsql es el lenguaje de procedimientos almacenados de PostgreSQL.
  
##### Estructura general de una funcion en SQL:
```bash
CREATE OR REPLACE FUNCTION nombre_de_la_funcion(parametro1 tipo, parametro2 tipo)
RETURNS tipo_de_retorno AS
$$
DECLARE
    variable1 tipo;
    variable2 tipo;
BEGIN
    -- Cuerpo de la función
    -- Aquí va el código SQL que realiza las operaciones deseadas
    
    RETURN valor_de_retorno;
END;
$$
LANGUAGE plpgsql;

```

<br>

> [!NOTE]
>  Descripcion de las consultas:

##### 1.-Array
<p>Resultado</p>

##### 2.-ArrayQuery
<p>Resultado</p>

##### 3.-ArrayString
<p>Resultado</p>

##### 4.-CicloFor
<p>Resultado</p>

##### 6.-CicloWhile
<p>Resultado</p>

##### 3.-Positivo
<p>Resultado</p>

##### 7.-Sumar
<p>Resultado</p>

##### 8.-UbicarCursor
<p>Resultado</p>
