#### Funciones SQL (Query Functions)
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
<p>Función que crea un arreglo de enteros de tamaño determinado por el parámetro de entrada "t" y lo llena con valores enteros consecutivos, mostrando cada valor en una notificación antes de devolver un valor entero de 0</p>
<p>Resultado</p>
<img width="550" alt="PreviewArrayFunction" src="https://github.com/OyasumiiAlex/DB_SQL_examples/assets/44487342/6bdf3eb1-976e-4e26-8315-affe9aaa2eeb">

##### 2.-ArrayQuery
<p>Esta funcion realiza una consulta SQL en la tabla compania para obtener los valores distintos de la columna "acti_p", los almacena en un arreglo de cadenas de caracteres y muestra cada valor en una notificación</p>
<p>Resultado</p>
<img width="550" alt="PreviewArrayQueryFunction" src="https://github.com/OyasumiiAlex/DB_SQL_examples/assets/44487342/2ce2f935-f858-4ea2-ae09-dc93235c85ea">

##### 3.-ArrayString
<p>Se realiza una consulta SQL en la tabla "soldados" para obtener todos los nombres de los soldados,se almacena en un arreglo de cadenas de caracteres y  se muestra cada nombre en una notificación</p>
<p>Resultado</p>
<img width="550" alt="PreviewArrayString" src="https://github.com/OyasumiiAlex/DB_SQL_examples/assets/44487342/86dc6fb6-f3ad-47d0-bc4f-a0ae5a6ae482">

##### 4.-CicloFor
<p>Realiza un bucle "for" que itera desde 1 hasta 10, sumando el valor actual de "c" a una variable "res" en cada iteración. Luego, devolvemos el valor final de "res" al finalizar el bucle. Además, mostramos el valor actual de "res" en cada iteración mediante el mensaje de notificación</p>
<p>Resultado</p>
<img width="550" alt="PreviewCicloFor" src="https://github.com/OyasumiiAlex/DB_SQL_examples/assets/44487342/d3b1ed13-61f9-4fd8-9a97-0057e87b1afd">

##### 5.-CicloWhile
<p>Funncion del un cliclo while que se ejecuta mientras "c" sea menor o igual que el valor del parámetro "limite". En cada iteración, suma el valor actual de "c" a una variable "res" y muestra el valor actual de "res" en un mensaje de notificación. Finalmente, devuelve el valor final de "res" al finalizar el bucle</p>
<p>Resultado</p>
<img width="550" alt="PreviewCicloWhile" src="https://github.com/OyasumiiAlex/DB_SQL_examples/assets/44487342/0d648121-c90a-41be-a78d-53d6b4c9d75b">


##### 6.-Positivo
<p>Verifica si el número pasado como parámetro es positivo o cero, y devuelve "true" si lo es y "false" en caso contrario</p>
<p>Resultado</p>
<img width="550" alt="PreviewCicloWhile" src="https://github.com/OyasumiiAlex/DB_SQL_examples/assets/44487342/de9c344c-6b43-4953-bfda-db905124b63f">

##### 7.-Sumar
<p>Esta función toma dos parámetros enteros, los suma y devuelve el resultado como un entero. La variable r almacena el resultado de la suma de dato1 y dato2. Luego, este valor se devuelve usando 'RETURN r'</p>
<p>Resultado</p>
<img width="550" alt="PreviewCicloWhile" src="https://github.com/OyasumiiAlex/DB_SQL_examples/assets/44487342/46d66bad-01a6-416c-b7ec-7c00e3effcd8">

##### 8.-UbicarCursor
<p> Actualiza la ubicación de los registros en la tabla "cuartel" de 'No_definido' a 'Por_definir'. Recorre todos los registros que cumplen con la condición utilizando un cursor, actualizando cada uno de ellos.</p>
<p>Resultado</p>

<img width="550" alt="PreviewCicloWhile" src="https://github.com/OyasumiiAlex/DB_SQL_examples/assets/44487342/97724a98-286f-423c-87a8-84f9f6354623">

##### 9.-Cast Edad
<p>Esta función toma dos fechas como argumentos y devuelve la diferencia entre ellas en formato de texto (varchar). La función utiliza la función age() de PostgreSQL para calcular la diferencia entre las dos fechas proporcionadas y luego devuelve este resultado como una cadena de texto.</p>

##### 10.-Sumar Fecha
<p>Esta función toma una fecha y un intervalo como argumentos y devuelve una nueva fecha que resulta de sumar el intervalo a la fecha proporcionada. Dentro del bloque de código, la variable fecha se inicializa sumando el intervalo ($2) a la fecha ($1) y luego se devuelve esta nueva fecha. </p>

##### 11.-Cast Date
<p>Función que toma dos fechas como argumentos y devuelve la diferencia entre ellas en formato de texto (varchar) con una etiqueta personalizada para cada unidad (años, meses, días).

Después de calcular la diferencia entre las dos fechas utilizando la función age(), se utilizan las funciones replace() para reemplazar las etiquetas de las unidades de tiempo (years, mons, days, year, mon, day) por sus equivalentes en español (años, meses, días, año, mes, día). Y finalmente, la función devuelve la cadena de texto modificada con las etiquetas en español.</p>
