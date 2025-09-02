# Ejercicio 3: Análisis Avanzado y Mantenimiento de la Biblioteca

## 🎯 Objetivo

Realizar tareas de análisis de datos y mantenimiento sobre el proyecto de la biblioteca, escribiendo consultas complejas y sentencias de actualización para resolver problemas específicos.

---

## 📖 Escenario

Con nuestra biblioteca ya en funcionamiento, queremos sacar más provecho de los datos que hemos acumulado y realizar algunas tareas de mantenimiento para mantener la calidad de la información.

---

## 🏋️‍♀️ Tu Tarea

### Parte 1: Consultas de Análisis Avanzado

1.  **Autores Más Prolíficos**: Escribí una consulta para encontrar los 5 autores con más libros en nuestra biblioteca. El resultado debe mostrar el nombre del autor y la cantidad de libros.

    ```sql
    -- Tu código aquí
    ```

2.  **Análisis de Inversión por Género**: Calculá cuánto dinero hemos invertido en cada género. La consulta debe mostrar el nombre del género, la cantidad de libros de ese género y la suma total de sus precios.

    ```sql
    -- Tu código aquí
    ```

3.  **Joyas Ocultas**: Queremos encontrar libros que podrían ser "joyas ocultas". Definimos una joya oculta como un libro con una calificación de 9 o más, pero de un autor que solo tiene 1 libro en nuestra biblioteca. La consulta debe mostrar el título del libro, el nombre del autor y la calificación.

    ```sql
    -- Tu código aquí (Pista: necesitarás subconsultas o CTEs, que veremos más adelante, pero podés intentarlo con GROUP BY y HAVING)
    ```

### Parte 2: Tareas de Mantenimiento de Datos

4.  **Corregir Títulos**: Nos dimos cuenta de que algunos títulos se insertaron con espacios extra al principio o al final. Escribí una sentencia `UPDATE` que elimine estos espacios para todos los libros. SQLite tiene la función `TRIM()`.

    ```sql
    -- Pista: UPDATE libros SET titulo = TRIM(titulo);
    -- Tu código aquí
    ```

5.  **Estandarizar Nacionalidades**: Las nacionalidades de los autores se han escrito de varias formas (ej: 'Británica', 'britanica'). Escribí una sentencia `UPDATE` para estandarizar todas a que empiecen con mayúscula (`INITCAP()`).

    ```sql
    -- Tu código aquí
    ```

6.  **Archivar Libros Antiguos no Leídos**: Queremos hacer espacio. Vamos a "archivar" (soft delete) los libros que fueron publicados antes del año 2000 y que todavía no hemos leído. Escribí un `UPDATE` para poner su campo `activo` en `FALSE`.

    ```sql
    -- Primero, verificá con SELECT cuántos libros cumplen la condición

    -- Luego, escribí tu sentencia UPDATE
    ```

### Parte 3: Desafío - Manejo de Ediciones

7.  **Escenario**: Compramos una nueva edición de "1984". No queremos borrar el antiguo, sino manejarlo como una edición diferente.
    *   **Paso A**: Agregá una columna `edicion` a la tabla `libros` de tipo `TEXT`.
    *   **Paso B**: Usá `UPDATE` para darle a la entrada existente de "1984" el valor de edición 'Primera Edición'.
    *   **Paso C**: Usá `INSERT` para agregar el nuevo libro "1984", pero en el campo `edicion` ponele 'Edición de Aniversario'. Copiá los demás datos del original.

    ```sql
    -- Tu código para el Paso A (ALTER TABLE)

    -- Tu código para el Paso B (UPDATE)

    -- Tu código para el Paso C (INSERT)
    ```

---

## 💡 Solución Propuesta

<details>
<summary>Click para ver la solución</summary>

```sql
-- --- PARTE 1: ANÁLISIS AVANZADO ---

-- 1. Autores Más Prolíficos
SELECT
    a.nombre || ' ' || a.apellido as autor,
    COUNT(la.libro_id) as cantidad_libros
FROM autores a
JOIN libros_autores la ON a.id = la.autor_id
GROUP BY a.id
ORDER BY cantidad_libros DESC
LIMIT 5;

-- 2. Análisis de Inversión por Género
SELECT
    g.nombre as genero,
    COUNT(l.id) as cantidad_libros,
    SUM(l.precio) as inversion_total
FROM generos g
JOIN libros l ON g.id = l.genero_id
WHERE l.activo = TRUE
GROUP BY g.id
ORDER BY inversion_total DESC;

-- 3. Joyas Ocultas (una forma de resolverlo)
SELECT 
    l.titulo, 
    a.nombre || ' ' || a.apellido as autor, 
    l.calificacion
FROM libros l
JOIN libros_autores la ON l.id = la.libro_id
JOIN autores a ON la.autor_id = a.id
WHERE l.calificacion >= 9 AND a.id IN (
    SELECT autor_id
    FROM libros_autores
    GROUP BY autor_id
    HAVING COUNT(libro_id) = 1
);


-- --- PARTE 2: MANTENIMIENTO ---

-- 4. Corregir Títulos
UPDATE libros SET titulo = TRIM(titulo);

-- 5. Estandarizar Nacionalidades
UPDATE autores SET nacionalidad = INITCAP(nacionalidad);

-- 6. Archivar Libros Antiguos no Leídos
-- Verificación:
-- SELECT * FROM libros WHERE año_publicacion < 2000 AND leido = FALSE AND activo = TRUE;
-- Actualización:
UPDATE libros SET activo = FALSE WHERE año_publicacion < 2000 AND leido = FALSE;


-- --- PARTE 3: MANEJO DE EDICIONES ---

-- Paso A: Agregar columna
ALTER TABLE libros ADD COLUMN edicion TEXT;

-- Paso B: Actualizar edición existente
UPDATE libros SET edicion = 'Primera Edición' WHERE titulo = '1984';

-- Paso C: Insertar nueva edición (asumiendo que los datos son similares)
INSERT INTO libros (titulo, isbn, año_publicacion, paginas, genero_id, precio, edicion, leido, calificacion)
SELECT titulo, isbn || '-2', año_publicacion, paginas, genero_id, precio * 1.2, 'Edición de Aniversario', FALSE, NULL
FROM libros
WHERE titulo = '1984' AND edicion = 'Primera Edición';
-- Nota: Se necesita un INSERT más complejo para también duplicar la relación en libros_autores.

```

</details>
