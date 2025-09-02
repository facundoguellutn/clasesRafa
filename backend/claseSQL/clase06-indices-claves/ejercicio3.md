# Ejercicio 3: Optimización de Consultas con Índices

## 🎯 Objetivo

Aplicar el conocimiento sobre índices para optimizar un conjunto de consultas realistas sobre el proyecto de la biblioteca. Aprenderás a analizar una consulta, identificar los cuellos de botella y proponer el índice más adecuado.

---

## 📖 Escenario

El proyecto de la biblioteca de la clase anterior funciona, pero a medida que crece, algunas consultas se vuelven lentas. Tu tarea es actuar como un "DBA" (Administrador de Base de Datos) y optimizar el rendimiento creando los índices correctos.

**Recordatorio del Esquema:**
*   `autores` (id, nombre, apellido, ...)
*   `generos` (id, nombre, ...)
*   `libros` (id, titulo, genero_id, leido, calificacion, ...)
*   `libros_autores` (libro_id, autor_id)

---

## 🏋️‍♀️ Tu Tarea

Para cada una de las siguientes consultas, determiná cuál sería el índice más efectivo para acelerarla y escribí la sentencia `CREATE INDEX`.

### Consulta 1: Búsqueda de libros por título

Un usuario usa la barra de búsqueda del sistema para encontrar un libro por su título.

```sql
SELECT * FROM libros WHERE titulo LIKE 'Cien años%';
```

**Tu índice:**
```sql
-- Tu sentencia CREATE INDEX aquí

```

### Consulta 2: Encontrar todos los libros de un autor

Al hacer clic en el nombre de un autor, la aplicación muestra todos sus libros.

```sql
SELECT l.titulo FROM libros l
JOIN libros_autores la ON l.id = la.libro_id
WHERE la.autor_id = 5;
```

**Tu índice:** (Pista: ¿En qué tabla se hace el `WHERE`?)
```sql
-- Tu sentencia CREATE INDEX aquí

```

### Consulta 3: Filtrar libros por género y estado de lectura

Un usuario quiere ver todos los libros de 'Fantasía' que todavía no ha leído.

```sql
SELECT titulo FROM libros 
WHERE genero_id = 4 AND leido = FALSE;
```

**Tu índice:** (Pista: Un índice compuesto es ideal aquí. ¿Cuál es el orden correcto de las columnas?)
```sql
-- Tu sentencia CREATE INDEX aquí

```

### Consulta 4: Ordenar libros por calificación

La página de "Mejores Libros" ordena todos los libros leídos por su calificación de forma descendente.

```sql
SELECT titulo, calificacion FROM libros
WHERE leido = TRUE
ORDER BY calificacion DESC;
```

**Tu índice:**
```sql
-- Tu sentencia CREATE INDEX aquí

```

### Desafío: Consulta de Préstamos

En el ejercicio anterior, creamos una tabla `prestamos`. Ahora, queremos optimizar la búsqueda de préstamos vencidos.

```sql
SELECT l.titulo, p.prestado_a, p.fecha_devolucion_esperada
FROM prestamos p
JOIN libros l ON p.libro_id = l.id
WHERE p.devuelto = FALSE AND p.fecha_devolucion_esperada < CURRENT_DATE;
```

**Tu índice:** (Pista: Es un índice compuesto en la tabla `prestamos`. Pensá en el orden).
```sql
-- Tu sentencia CREATE INDEX aquí

```

### Extra: `EXPLAIN QUERY PLAN`

Si tu entorno de SQL lo soporta (SQLite sí lo hace), podés ver cómo la base de datos planea ejecutar tu consulta. Probá correr esto antes y después de crear un índice y observá la diferencia.

```sql
EXPLAIN QUERY PLAN SELECT * FROM libros WHERE titulo = '1984';

-- Antes del índice, probablemente dirá: SCAN TABLE libros

CREATE INDEX idx_libros_titulo ON libros(titulo);

EXPLAIN QUERY PLAN SELECT * FROM libros WHERE titulo = '1984';

-- Después del índice, debería decir: SEARCH TABLE libros USING INDEX idx_libros_titulo
```

---

## 💡 Solución Propuesta

<details>
<summary>Click para ver la solución</summary>

```sql
-- Consulta 1: Búsqueda por título
-- Un índice simple en la columna 'titulo' es perfecto.
CREATE INDEX idx_libros_titulo ON libros(titulo);


-- Consulta 2: Libros de un autor
-- El filtro se hace en la tabla 'libros_autores' sobre la columna 'autor_id'.
-- Este índice es crucial para acelerar los JOINs cuando partimos desde un autor.
CREATE INDEX idx_libros_autores_autor_id ON libros_autores(autor_id);


-- Consulta 3: Filtrar por género y estado
-- Un índice compuesto. Ponemos 'genero_id' primero porque probablemente es más selectivo
-- (hay menos libros de un género que libros no leídos en total).
CREATE INDEX idx_libros_genero_leido ON libros(genero_id, leido);


-- Consulta 4: Ordenar por calificación
-- El filtro es sobre 'leido' y el orden sobre 'calificacion'. Un índice compuesto
-- que incluya ambas es ideal para que la base de datos no tenga que ordenar los resultados
-- después de filtrarlos.
CREATE INDEX idx_libros_leido_calificacion ON libros(leido, calificacion DESC);


-- Desafío: Préstamos vencidos
-- El filtro principal es sobre 'devuelto'. Dentro de los no devueltos, filtramos por fecha.
-- Por lo tanto, el orden correcto para el índice compuesto es (devuelto, fecha_devolucion_esperada).
CREATE INDEX idx_prestamos_vencidos ON prestamos(devuelto, fecha_devolucion_esperada);

```

</details>
