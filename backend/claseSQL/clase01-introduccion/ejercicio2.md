# Ejercicio 2: Profundizando en SELECT

## 🎯 Objetivo

Practicar la selección de datos específicos y aprender a identificar valores únicos en una columna.

---

## 🚀 Setup

Asegurate de tener la tabla `peliculas` creada en [sqlsandbox.com](https://sqlsandbox.com) usando el script de `sqlsandbox-setup.sql`.

---

## 🏋️‍♀️ Ejercicios

### Parte 1: Selección de Columnas Combinadas

Escribí consultas para obtener la siguiente información. Pensá en qué columnas necesitás para cada pregunta.

1.  **Ficha de Película**: Mostrame el `titulo`, `director` y `año` de todas las películas.
    ```sql
    -- Tu código aquí
    ```

2.  **Ranking de Películas**: Mostrame el `titulo` y su `calificacion`.
    ```sql
    -- Tu código aquí
    ```

3.  **Catálogo por Género**: Mostrame el `genero` y el `titulo` de cada película.
    ```sql
    -- Tu código aquí
    ```

### Parte 2: Descubriendo Valores Únicos con `DISTINCT`

A veces, solo queremos saber qué valores diferentes existen en una columna. Para eso usamos `SELECT DISTINCT`.

**Ejemplo**: Para ver todos los géneros sin repetir:
```sql
SELECT DISTINCT genero FROM peliculas;
```
Fijate que "Drama" y "Sci-Fi" aparecen una sola vez, aunque haya varias películas de esos géneros.

**Ahora te toca a vos:**

4.  **Directores Únicos**: Mostrame una lista de todos los directores que aparecen en la base de datos, sin repetir ninguno.
    ```sql
    -- Tu código aquí
    ```

5.  **Años de Lanzamiento**: Mostrame una lista de los años en que se lanzaron estas películas, sin repetir.
    ```sql
    -- Tu código aquí
    ```

### Parte 3: Desafío de Reflexión

Observá los resultados de tus consultas y respondé:

6.  ¿Qué director tiene más de una película en esta lista? (Podés responderlo simplemente mirando el resultado de la consulta del ejercicio 4 y la tabla completa).

7.  Si quisieras agregar una columna `pais_origen` a la tabla, ¿qué tipo de dato (`TEXT`, `INTEGER`, `REAL`) usarías y por qué?

---
## 💡 Soluciones

<details>
<summary>Click para ver las soluciones</summary>

1.  **Ficha de Película**:
    ```sql
    SELECT titulo, director, año FROM peliculas;
    ```

2.  **Ranking de Películas**:
    ```sql
    SELECT titulo, calificacion FROM peliculas;
    ```

3.  **Catálogo por Género**:
    ```sql
    SELECT genero, titulo FROM peliculas;
    ```

4.  **Directores Únicos**:
    ```sql
    SELECT DISTINCT director FROM peliculas;
    ```

5.  **Años de Lanzamiento**:
    ```sql
    SELECT DISTINCT año FROM peliculas;
    ```

6.  **Director con más de una película**: James Cameron.

7.  **Nueva columna `pais_origen`**: Usaríamos `TEXT`, porque el nombre de un país es una cadena de texto (ej: 'USA', 'Argentina').

</details>
