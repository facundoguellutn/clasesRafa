# Ejercicio 3: Consultas Basadas en Preguntas y Creación de Datos

## 🎯 Objetivo

Practicar la formulación de consultas `SELECT` para responder preguntas específicas y familiarizarse con la inserción de nuevos datos con `INSERT`.

---

## 🚀 Setup

Asegurate de tener la tabla `peliculas` creada en [sqlsandbox.com](https://sqlsandbox.com) usando el script de `sqlsandbox-setup.sql`.

---

## 🏋️‍♀️ Ejercicios

### Parte 1: Respondiendo Preguntas con Consultas

Imaginá que un usuario te hace las siguientes preguntas. Escribí la consulta SQL necesaria para obtener la respuesta.

1.  **Pregunta**: "Quiero ver los títulos de las películas y el director que las hizo, nada más."
    ```sql
    -- Tu código aquí
    ```

2.  **Pregunta**: "Necesito un listado de películas con su año de estreno para un timeline."
    ```sql
    -- Tu código aquí
    ```

3.  **Pregunta**: "Estamos analizando géneros y directores. ¿Podés darme una lista que muestre el título, el género y el director de cada película?"
    ```sql
    -- Tu código aquí
    ```

### Parte 2: Agregando tus Propios Datos

La base de datos actual es pequeña. Vamos a agregarle más información.

4.  **Agregá tu película favorita**: Usá una sentencia `INSERT INTO` para agregar tu película preferida. Asegurate de completar todos los campos: `id`, `titulo`, `año`, `genero`, `calificacion`, `director`. El `id` debe ser único, así que usá un número que no esté en la lista (ej: 9, 10, 11...).
    ```sql
    -- Tu código aquí
    -- Ejemplo:
    -- INSERT INTO peliculas (id, titulo, año, genero, calificacion, director) 
    -- VALUES (9, 'Interestelar', 2014, 'Sci-Fi', 8.6, 'Christopher Nolan');
    ```

5.  **Verificá tu adición**: Después de ejecutar el `INSERT`, escribí una consulta `SELECT` para asegurarte de que tu película se haya agregado correctamente.
    ```sql
    -- Tu código aquí
    ```

6.  **Agregá dos películas más**: Repetí el proceso para agregar otras dos películas que te gusten. Pueden ser del mismo director o de géneros que ya existen.
    ```sql
    -- Tu código para la primera película adicional
    
    -- Tu código para la segunda película adicional
    ```

### Parte 3: Desafío Final de la Clase 1

7.  **Consulta Post-Adición**: Escribí una consulta que muestre la lista de **todos los directores únicos** de la tabla `peliculas` *después* de haber agregado tus tres películas. ¿Aparecen los nuevos directores?
    ```sql
    -- Tu código aquí
    ```

---
## 💡 Soluciones

<details>
<summary>Click para ver las soluciones</summary>

1.  **Títulos y directores**:
    ```sql
    SELECT titulo, director FROM peliculas;
    ```

2.  **Timeline de películas**:
    ```sql
    SELECT titulo, año FROM peliculas;
    ```

3.  **Análisis de género y director**:
    ```sql
    SELECT titulo, genero, director FROM peliculas;
    ```

4.  **Agregar película favorita (ejemplo)**:
    ```sql
    INSERT INTO peliculas (id, titulo, año, genero, calificacion, director) 
    VALUES (9, 'Interestelar', 2014, 'Sci-Fi', 8.6, 'Christopher Nolan');
    ```

5.  **Verificar adición**:
    ```sql
    SELECT * FROM peliculas;
    ```
    (Deberías ver "Interestelar" al final de la lista).

6.  **Agregar dos películas más (ejemplo)**:
    ```sql
    INSERT INTO peliculas (id, titulo, año, genero, calificacion, director) 
    VALUES (10, 'El Origen', 2010, 'Sci-Fi', 8.8, 'Christopher Nolan');

    INSERT INTO peliculas (id, titulo, año, genero, calificacion, director) 
    VALUES (11, 'La La Land', 2016, 'Musical', 8.0, 'Damien Chazelle');
    ```

7.  **Directores únicos post-adición**:
    ```sql
    SELECT DISTINCT director FROM peliculas;
    ```
    (Deberías ver a 'Christopher Nolan' y 'Damien Chazelle' en la lista si usaste los ejemplos).

</details>
