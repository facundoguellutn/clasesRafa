# Ejercicio 2: Ampliando la Biblioteca - Editoriales y Préstamos

## 🎯 Objetivo

Ampliar el modelo de datos existente para incluir nuevas funcionalidades (editoriales y préstamos), utilizando `ALTER TABLE` y creando nuevas tablas que se relacionen con las existentes.

---

## 📖 Escenario

Nuestra biblioteca personal está creciendo y ahora queremos registrar dos cosas más:

1.  **La editorial** de cada libro.
2.  Un sistema para registrar a quién le **prestamos** nuestros libros.

### Requisitos de la Ampliación:

1.  **Editoriales**:
    *   Necesitamos una nueva tabla `editoriales` con `id`, `nombre` (único y obligatorio) y `pais_origen`.
    *   La tabla `libros` debe ser modificada para incluir una referencia a la editorial (`editorial_id`).

2.  **Préstamos**:
    *   Necesitamos una nueva tabla `prestamos`.
    *   Debe registrar qué `libro_id` se prestó.
    *   A quién se le prestó (`prestado_a`, un campo de texto).
    *   La `fecha_prestamo` (por defecto, la actual).
    *   Una `fecha_devolucion` esperada.
    *   Un estado `devuelto` (booleano, por defecto `FALSE`).

---

## 🏋️‍♀️ Tu Tarea

### Parte 1: Implementar las Editoriales

1.  **Creá la tabla `editoriales`** con los campos y constraints requeridos.

    ```sql
    -- Tu código para crear la tabla 'editoriales' aquí
    ```

2.  **Modificá la tabla `libros`** para agregar la nueva columna `editorial_id` de tipo `INTEGER`.

    ```sql
    -- Tu código ALTER TABLE aquí
    ```

3.  **Insertá algunas editoriales** conocidas (ej: 'Anagrama', 'Penguin Random House', 'Planeta').

    ```sql
    -- Tus sentencias INSERT para editoriales
    ```

4.  **Asigná editoriales a tus libros existentes**. Usá `UPDATE` para establecer el `editorial_id` para algunos de los libros que ya tenés en la base de datos.

    ```sql
    -- Tus sentencias UPDATE para asignar editoriales
    ```

### Parte 2: Implementar el Sistema de Préstamos

5.  **Creá la tabla `prestamos`** con todos los campos y constraints necesarios.

    ```sql
    -- Tu código para crear la tabla 'prestamos' aquí
    ```

6.  **Registrá un préstamo**. Prestale el libro "1984" a tu amigo "Carlos". La fecha de devolución esperada es en 15 días (`DATE('now', '+15 days')`).

    ```sql
    -- Tu sentencia INSERT para el préstamo
    ```

### Parte 3: Consultas de la Nueva Funcionalidad

7.  **Escribí una consulta** que muestre los libros, sus autores y ahora también sus editoriales.

    ```sql
    -- Tu consulta con JOIN a las 4 tablas
    ```

8.  **Escribí una consulta** para ver todos los libros que están actualmente prestados y no han sido devueltos. Debe mostrar el título del libro, a quién se le prestó y cuándo debería ser devuelto.

    ```sql
    -- Tu consulta de préstamos activos
    ```

---

## 💡 Solución Propuesta

<details>
<summary>Click para ver la solución</summary>

```sql
-- --- PARTE 1: IMPLEMENTAR EDITORIALES ---

-- 1. Crear tabla 'editoriales'
CREATE TABLE editoriales (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    pais_origen TEXT
);

-- 2. Modificar tabla 'libros'
ALTER TABLE libros ADD COLUMN editorial_id INTEGER;
-- En un sistema real, aquí agregaríamos: REFERENCES editoriales(id)

-- 3. Insertar editoriales
INSERT INTO editoriales (nombre, pais_origen) VALUES
('Anagrama', 'España'),
('Penguin Random House', 'Internacional'),
('Planeta', 'España'),
('Siglo XXI Editores', 'Argentina');

-- 4. Asignar editoriales a libros existentes
UPDATE libros SET editorial_id = 2 WHERE titulo = '1984';
UPDATE libros SET editorial_id = 1 WHERE titulo = 'Cien años de soledad';
UPDATE libros SET editorial_id = 3 WHERE titulo = 'Sapiens: De animales a dioses';


-- --- PARTE 2: IMPLEMENTAR PRÉSTAMOS ---

-- 5. Crear tabla 'prestamos'
CREATE TABLE prestamos (
    id INTEGER PRIMARY KEY,
    libro_id INTEGER NOT NULL,
    prestado_a TEXT NOT NULL,
    fecha_prestamo DATE DEFAULT CURRENT_DATE,
    fecha_devolucion_esperada DATE,
    devuelto BOOLEAN DEFAULT FALSE
    -- FOREIGN KEY (libro_id) REFERENCES libros(id)
);

-- 6. Registrar un préstamo
INSERT INTO prestamos (libro_id, prestado_a, fecha_devolucion_esperada)
VALUES (
    (SELECT id FROM libros WHERE titulo = '1984'), 
    'Carlos', 
    DATE('now', '+15 days')
);


-- --- PARTE 3: CONSULTAS ---

-- 7. Libros con autores y editoriales
SELECT 
    l.titulo,
    a.nombre || ' ' || a.apellido as autor,
    e.nombre as editorial
FROM libros l
JOIN libros_autores la ON l.id = la.libro_id
JOIN autores a ON la.autor_id = a.id
LEFT JOIN editoriales e ON l.editorial_id = e.id
WHERE l.activo = TRUE;

-- 8. Libros prestados actualmente
SELECT
    l.titulo,
    p.prestado_a,
    p.fecha_devolucion_esperada
FROM prestamos p
JOIN libros l ON p.libro_id = l.id
WHERE p.devuelto = FALSE;

```

</details>
