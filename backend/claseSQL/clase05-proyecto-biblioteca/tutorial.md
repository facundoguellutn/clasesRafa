# Clase 5: Proyecto de Consolidación - Biblioteca Personal

## 🎯 Objetivos de la Clase

Al finalizar esta clase, Rafa será capaz de:
- Integrar todos los conceptos aprendidos en un proyecto real
- Diseñar un sistema con múltiples tablas relacionadas
- Implementar CRUD completo con validaciones
- Crear consultas útiles para análisis de datos
- Aplicar buenas prácticas de diseño de base de datos

---

## 📚 Contexto del Proyecto: Mi Biblioteca Personal

Vas a crear un sistema para gestionar tu biblioteca personal que permita:
- **Registrar libros** con toda su información
- **Gestionar autores** y sus datos
- **Relacionar libros con autores** (un libro puede tener múltiples autores)
- **Hacer seguimiento de lectura** (leído/no leído, calificación, notas)
- **Consultas útiles** (libros por leer, autores favoritos, estadísticas)

**Este proyecto simula un sistema real que podrías usar en tu día a día.**

---

## 🏗️ Diseño de la Base de Datos

### Tablas Principales

#### 1. Autores - Información de escritores
```sql
CREATE TABLE autores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    nacionalidad TEXT,
    fecha_nacimiento DATE,
    biografia TEXT,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion DATE DEFAULT CURRENT_DATE
);
```

#### 2. Géneros - Categorías de libros
```sql
CREATE TABLE generos (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    descripcion TEXT
);
```

#### 3. Libros - El corazón del sistema
```sql
CREATE TABLE libros (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    isbn TEXT UNIQUE,
    año_publicacion INTEGER CHECK (año_publicacion >= 1000 AND año_publicacion <= 2030),
    paginas INTEGER CHECK (paginas > 0),
    idioma TEXT DEFAULT 'Español',
    genero_id INTEGER,
    precio REAL CHECK (precio >= 0),
    fecha_adquisicion DATE DEFAULT CURRENT_DATE,
    
    -- Estado de lectura
    leido BOOLEAN DEFAULT FALSE,
    fecha_lectura DATE,
    calificacion INTEGER CHECK (calificacion >= 1 AND calificacion <= 10),
    notas TEXT,
    
    -- Metadatos
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (genero_id) REFERENCES generos(id)
);
```

#### 4. Libros_Autores - Relación muchos a muchos
```sql
CREATE TABLE libros_autores (
    id INTEGER PRIMARY KEY,
    libro_id INTEGER NOT NULL,
    autor_id INTEGER NOT NULL,
    rol TEXT DEFAULT 'Autor', -- 'Autor', 'Coautor', 'Editor'
    FOREIGN KEY (libro_id) REFERENCES libros(id),
    FOREIGN KEY (autor_id) REFERENCES autores(id),
    UNIQUE(libro_id, autor_id, rol) -- No duplicar la misma relación
);
```

---

## 🚀 Implementación Paso a Paso

### Paso 1: Crear las Tablas
```sql
-- 🏗️ SISTEMA DE BIBLIOTECA PERSONAL

-- Tabla de géneros literarios
CREATE TABLE generos (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    descripcion TEXT
);

-- Tabla de autores
CREATE TABLE autores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    nacionalidad TEXT,
    fecha_nacimiento DATE,
    biografia TEXT,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion DATE DEFAULT CURRENT_DATE
);

-- Tabla principal de libros
CREATE TABLE libros (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    isbn TEXT UNIQUE,
    año_publicacion INTEGER CHECK (año_publicacion >= 1000 AND año_publicacion <= 2030),
    paginas INTEGER CHECK (paginas > 0),
    idioma TEXT DEFAULT 'Español',
    genero_id INTEGER,
    precio REAL CHECK (precio >= 0),
    fecha_adquisicion DATE DEFAULT CURRENT_DATE,
    
    -- Estado de lectura
    leido BOOLEAN DEFAULT FALSE,
    fecha_lectura DATE,
    calificacion INTEGER CHECK (calificacion >= 1 AND calificacion <= 10),
    notas TEXT,
    
    -- Metadatos
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (genero_id) REFERENCES generos(id)
);

-- Tabla de relación muchos a muchos
CREATE TABLE libros_autores (
    id INTEGER PRIMARY KEY,
    libro_id INTEGER NOT NULL,
    autor_id INTEGER NOT NULL,
    rol TEXT DEFAULT 'Autor',
    FOREIGN KEY (libro_id) REFERENCES libros(id),
    FOREIGN KEY (autor_id) REFERENCES autores(id),
    UNIQUE(libro_id, autor_id, rol)
);
```

### Paso 2: Insertar Datos Maestros (Géneros)
```sql
-- Insertar géneros literarios básicos
INSERT INTO generos (nombre, descripcion) VALUES 
('Ficción', 'Narrativa de historias imaginarias'),
('No Ficción', 'Textos basados en hechos reales'),
('Ciencia Ficción', 'Literatura especulativa y futurista'),
('Fantasía', 'Mundos imaginarios con elementos mágicos'),
('Misterio', 'Novelas de suspenso e investigación'),
('Romance', 'Historias centradas en relaciones amorosas'),
('Biografía', 'Relatos de vidas reales'),
('Historia', 'Textos sobre eventos históricos'),
('Tecnología', 'Libros sobre informática y programación'),
('Autoayuda', 'Libros de desarrollo personal');
```

### Paso 3: Insertar Autores Famosos
```sql
-- Insertar autores reconocidos
INSERT INTO autores (nombre, apellido, nacionalidad, fecha_nacimiento, biografia) VALUES 
('Gabriel', 'García Márquez', 'Colombiana', '1927-03-06', 'Premio Nobel de Literatura, maestro del realismo mágico'),
('Isabel', 'Allende', 'Chilena', '1942-08-02', 'Una de las escritoras más leídas del mundo en español'),
('Jorge Luis', 'Borges', 'Argentina', '1899-08-24', 'Escritor y poeta, maestro de la literatura fantástica'),
('George', 'Orwell', 'Británica', '1903-06-25', 'Autor de 1984 y Rebelión en la granja'),
('J.K.', 'Rowling', 'Británica', '1965-07-31', 'Creadora de la saga Harry Potter'),
('Stephen', 'King', 'Estadounidense', '1947-09-21', 'Maestro del horror y suspenso contemporáneo'),
('Agatha', 'Christie', 'Británica', '1890-09-15', 'La reina del misterio, creadora de Hercule Poirot'),
('Dan', 'Brown', 'Estadounidense', '1964-06-22', 'Autor de El Código Da Vinci y thrillers históricos'),
('Paulo', 'Coelho', 'Brasileña', '1947-08-24', 'Autor de El Alquimista y literatura espiritual'),
('Yuval Noah', 'Harari', 'Israelí', '1976-02-24', 'Historiador, autor de Sapiens y Homo Deus');
```

### Paso 4: Insertar Libros Populares
```sql
-- Insertar una colección diversa de libros
INSERT INTO libros (titulo, isbn, año_publicacion, paginas, genero_id, precio, leido, calificacion) VALUES 
('Cien años de soledad', '978-0307474728', 1967, 417, 1, 2500.00, TRUE, 10),
('1984', '978-0451524935', 1949, 328, 3, 2200.00, TRUE, 9),
('Harry Potter y la Piedra Filosofal', '978-0439708180', 1997, 309, 4, 3000.00, TRUE, 9),
('El Código Da Vinci', '978-0307474278', 2003, 689, 5, 2800.00, TRUE, 8),
('El Alquimista', '978-0061122415', 1988, 163, 1, 1800.00, TRUE, 7),
('Sapiens: De animales a dioses', '978-8499926223', 2011, 496, 8, 4200.00, FALSE, NULL),
('La casa de los espíritus', '978-8497592598', 1982, 433, 1, 3200.00, FALSE, NULL),
('El laberinto de la soledad', '978-9681607357', 1950, 351, 2, 2100.00, FALSE, NULL),
('It (Eso)', '978-1501142970', 1986, 1138, 5, 3500.00, TRUE, 8),
('Asesinato en el Orient Express', '978-0062693662', 1934, 256, 5, 1900.00, TRUE, 9);
```

### Paso 5: Relacionar Libros con Autores
```sql
-- Conectar libros con sus autores
INSERT INTO libros_autores (libro_id, autor_id, rol) VALUES 
(1, 1, 'Autor'),        -- Cien años de soledad - García Márquez
(2, 4, 'Autor'),        -- 1984 - George Orwell
(3, 5, 'Autor'),        -- Harry Potter - J.K. Rowling
(4, 8, 'Autor'),        -- El Código Da Vinci - Dan Brown
(5, 9, 'Autor'),        -- El Alquimista - Paulo Coelho
(6, 10, 'Autor'),       -- Sapiens - Yuval Noah Harari
(7, 2, 'Autor'),        -- La casa de los espíritus - Isabel Allende
(8, 1, 'Autor'),        -- El laberinto de la soledad - Octavio Paz (usamos García Márquez como ejemplo)
(9, 6, 'Autor'),        -- It - Stephen King
(10, 7, 'Autor');       -- Asesinato en el Orient Express - Agatha Christie
```

---

## 📊 Consultas Útiles del Sistema

### Consultas Básicas

#### Ver todos los libros con información completa
```sql
SELECT 
    l.titulo,
    l.año_publicacion,
    g.nombre as genero,
    l.paginas,
    l.precio,
    CASE 
        WHEN l.leido THEN 'Leído'
        ELSE 'Por leer'
    END as estado_lectura,
    l.calificacion
FROM libros l
LEFT JOIN generos g ON l.genero_id = g.id
WHERE l.activo = TRUE
ORDER BY l.titulo;
```

#### Libros con sus autores
```sql
SELECT 
    l.titulo,
    a.nombre || ' ' || a.apellido as autor,
    l.año_publicacion,
    g.nombre as genero
FROM libros l
JOIN libros_autores la ON l.id = la.libro_id
JOIN autores a ON la.autor_id = a.id
LEFT JOIN generos g ON l.genero_id = g.id
WHERE l.activo = TRUE
ORDER BY l.titulo;
```

### Consultas de Análisis

#### Estadísticas de lectura
```sql
SELECT 
    COUNT(*) as total_libros,
    SUM(CASE WHEN leido THEN 1 ELSE 0 END) as libros_leidos,
    SUM(CASE WHEN NOT leido THEN 1 ELSE 0 END) as libros_por_leer,
    ROUND(AVG(CASE WHEN leido THEN calificacion END), 1) as calificacion_promedio,
    SUM(precio) as valor_total_biblioteca
FROM libros 
WHERE activo = TRUE;
```

#### Top 5 géneros más populares
```sql
SELECT 
    g.nombre as genero,
    COUNT(l.id) as cantidad_libros,
    SUM(CASE WHEN l.leido THEN 1 ELSE 0 END) as leidos,
    ROUND(AVG(l.precio), 0) as precio_promedio
FROM generos g
LEFT JOIN libros l ON g.id = l.genero_id AND l.activo = TRUE
GROUP BY g.id, g.nombre
HAVING cantidad_libros > 0
ORDER BY cantidad_libros DESC
LIMIT 5;
```

#### Autores más leídos
```sql
SELECT 
    a.nombre || ' ' || a.apellido as autor,
    COUNT(l.id) as libros_en_biblioteca,
    SUM(CASE WHEN l.leido THEN 1 ELSE 0 END) as libros_leidos,
    ROUND(AVG(CASE WHEN l.leido THEN l.calificacion END), 1) as calificacion_promedio
FROM autores a
JOIN libros_autores la ON a.id = la.autor_id
JOIN libros l ON la.libro_id = l.id
WHERE l.activo = TRUE
GROUP BY a.id, a.nombre, a.apellido
HAVING libros_en_biblioteca > 0
ORDER BY libros_leidos DESC, libros_en_biblioteca DESC;
```

---

## 🏋️ Ejercicios Prácticos

### Ejercicio 1: Agregar Nuevos Libros
```sql
-- 1.1 Agregar un libro de programación
INSERT INTO libros (titulo, isbn, año_publicacion, paginas, genero_id, precio) 
VALUES ('Clean Code', '978-0132350884', 2008, 464, 9, 4500.00);

-- 1.2 Crear el autor si no existe
INSERT INTO autores (nombre, apellido, nacionalidad, biografia) 
VALUES ('Robert', 'Martin', 'Estadounidense', 'Ingeniero de software y autor de libros técnicos');

-- 1.3 Relacionar libro con autor
INSERT INTO libros_autores (libro_id, autor_id) 
VALUES (11, 11); -- Asumiendo que son los IDs 11
```

### Ejercicio 2: Marcar Libros como Leídos
```sql
-- 2.1 Marcar "Sapiens" como leído con calificación
UPDATE libros 
SET leido = TRUE, 
    fecha_lectura = '2024-01-15',
    calificacion = 9,
    notas = 'Excelente perspectiva sobre la evolución humana'
WHERE titulo = 'Sapiens: De animales a dioses';

-- 2.2 Marcar varios libros como leídos
UPDATE libros 
SET leido = TRUE, 
    fecha_lectura = CURRENT_DATE,
    calificacion = 8
WHERE titulo IN ('La casa de los espíritus', 'El laberinto de la soledad');
```

### Ejercicio 3: Consultas Personalizadas
```sql
-- 3.1 Libros por leer ordenados por prioridad (más nuevos primero)
SELECT titulo, año_publicacion, precio
FROM libros 
WHERE leido = FALSE AND activo = TRUE
ORDER BY año_publicacion DESC;

-- 3.2 Libros favoritos (calificación >= 9)
SELECT 
    l.titulo,
    a.nombre || ' ' || a.apellido as autor,
    l.calificacion,
    l.notas
FROM libros l
JOIN libros_autores la ON l.id = la.libro_id
JOIN autores a ON la.autor_id = a.id
WHERE l.calificacion >= 9
ORDER BY l.calificacion DESC;

-- 3.3 Inversión total por género
SELECT 
    g.nombre as genero,
    SUM(l.precio) as inversion_total,
    COUNT(l.id) as cantidad_libros
FROM generos g
JOIN libros l ON g.id = l.genero_id
WHERE l.activo = TRUE
GROUP BY g.id, g.nombre
ORDER BY inversion_total DESC;
```

---

## 🔧 Operaciones de Mantenimiento

### Actualizar Información de Autores
```sql
-- Completar información de autores
UPDATE autores 
SET biografia = 'Escritor colombiano, Premio Nobel de Literatura 1982, padre del realismo mágico'
WHERE nombre = 'Gabriel' AND apellido = 'García Márquez';

UPDATE autores 
SET fecha_nacimiento = '1949-08-24'
WHERE nombre = 'Paulo' AND apellido = 'Coelho';
```

### Gestión de Biblioteca
```sql
-- Soft delete de libros que ya no queremos
UPDATE libros 
SET activo = FALSE 
WHERE calificacion <= 5 AND leido = TRUE;

-- Actualizar precios (inflación del 10%)
UPDATE libros 
SET precio = precio * 1.10 
WHERE fecha_adquisicion < '2023-01-01';

-- Agregar notas a libros ya leídos
UPDATE libros 
SET notas = 'Clásico imprescindible de la literatura latinoamericana'
WHERE titulo = 'Cien años de soledad';
```

---

## 📈 Reportes Avanzados

### Reporte de Progreso de Lectura
```sql
SELECT 
    'RESUMEN DE BIBLIOTECA' as seccion,
    '' as detalle,
    '' as valor
UNION ALL
SELECT 
    'Total de libros', 
    '', 
    CAST(COUNT(*) as TEXT) 
FROM libros WHERE activo = TRUE
UNION ALL
SELECT 
    'Libros leídos', 
    '', 
    CAST(SUM(CASE WHEN leido THEN 1 ELSE 0 END) as TEXT)
FROM libros WHERE activo = TRUE
UNION ALL
SELECT 
    'Porcentaje leído', 
    '', 
    CAST(ROUND(SUM(CASE WHEN leido THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 1) as TEXT) || '%'
FROM libros WHERE activo = TRUE
UNION ALL
SELECT 
    'Valor total', 
    '$', 
    CAST(SUM(precio) as TEXT)
FROM libros WHERE activo = TRUE;
```

### Top 10 Libros por Calificación
```sql
SELECT 
    ROW_NUMBER() OVER (ORDER BY l.calificacion DESC) as ranking,
    l.titulo,
    a.nombre || ' ' || a.apellido as autor,
    l.calificacion,
    g.nombre as genero
FROM libros l
JOIN libros_autores la ON l.id = la.libro_id
JOIN autores a ON la.autor_id = a.id
LEFT JOIN generos g ON l.genero_id = g.id
WHERE l.leido = TRUE AND l.activo = TRUE
ORDER BY l.calificacion DESC, l.titulo
LIMIT 10;
```

---

## 🎯 Desafíos Avanzados

### Desafío 1: Sistema de Préstamos
```sql
-- Agregar tabla para préstamos a amigos
CREATE TABLE prestamos (
    id INTEGER PRIMARY KEY,
    libro_id INTEGER NOT NULL,
    prestado_a TEXT NOT NULL,
    fecha_prestamo DATE DEFAULT CURRENT_DATE,
    fecha_devolucion_esperada DATE,
    fecha_devolucion_real DATE,
    devuelto BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (libro_id) REFERENCES libros(id)
);

-- Prestar un libro
INSERT INTO prestamos (libro_id, prestado_a, fecha_devolucion_esperada) 
VALUES (3, 'Juan Pérez', DATE('now', '+30 days'));

-- Ver libros prestados
SELECT 
    l.titulo,
    p.prestado_a,
    p.fecha_prestamo,
    p.fecha_devolucion_esperada,
    CASE 
        WHEN p.devuelto THEN 'Devuelto'
        WHEN DATE('now') > p.fecha_devolucion_esperada THEN 'Vencido'
        ELSE 'Vigente'
    END as estado
FROM prestamos p
JOIN libros l ON p.libro_id = l.id
WHERE p.devuelto = FALSE;
```

### Desafío 2: Sistema de Reseñas
```sql
-- Agregar tabla para reseñas detalladas
CREATE TABLE reseñas (
    id INTEGER PRIMARY KEY,
    libro_id INTEGER NOT NULL,
    titulo_reseña TEXT,
    contenido TEXT,
    fecha_reseña DATE DEFAULT CURRENT_DATE,
    publica BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (libro_id) REFERENCES libros(id)
);

-- Agregar reseña a un libro favorito
INSERT INTO reseñas (libro_id, titulo_reseña, contenido, publica) 
VALUES (1, 'Una obra maestra del realismo mágico', 
        'García Márquez construye un universo único donde lo fantástico se mezcla naturalmente con la realidad...', 
        TRUE);
```

---

## ✅ Verificaciones Finales

### Integridad de Datos
```sql
-- Verificar que no hay libros sin género
SELECT COUNT(*) as libros_sin_genero 
FROM libros 
WHERE genero_id IS NULL AND activo = TRUE;

-- Verificar que no hay libros sin autor
SELECT l.titulo 
FROM libros l
LEFT JOIN libros_autores la ON l.id = la.libro_id
WHERE la.libro_id IS NULL AND l.activo = TRUE;

-- Verificar calificaciones válidas
SELECT COUNT(*) as calificaciones_invalidas
FROM libros 
WHERE calificacion IS NOT NULL 
  AND (calificacion < 1 OR calificacion > 10);
```

### Estado de la Biblioteca
```sql
-- Dashboard final
SELECT 
    'DASHBOARD BIBLIOTECA' as titulo,
    COUNT(*) as total_libros,
    SUM(CASE WHEN leido THEN 1 ELSE 0 END) as leidos,
    COUNT(DISTINCT genero_id) as generos_diferentes,
    COUNT(DISTINCT la.autor_id) as autores_diferentes,
    CAST(SUM(precio) as INTEGER) as valor_total
FROM libros l
LEFT JOIN libros_autores la ON l.id = la.libro_id
WHERE l.activo = TRUE;
```

---

## 🏠 Tarea Para Casa

### Proyecto Personal: Expande Tu Biblioteca
1. **Agregar 10 libros más** de diferentes géneros
2. **Crear 3 autores nuevos** con biografías completas
3. **Marcar 5 libros como leídos** con calificaciones y notas
4. **Crear 2 géneros nuevos** que te interesen
5. **Escribir 5 consultas personalizadas** que te den información útil

### Consultas Desafío
Escribí queries para:
- Libros más caros por género
- Autores más prolíficos en tu biblioteca
- Progreso de lectura mensual
- Recomendaciones basadas en calificaciones altas
- Análisis de inversión por año de adquisición

---

## 🎯 Próxima Clase: Índices y Claves Foráneas

En la **Clase 6** profundizaremos en:
- Cómo funcionan los índices para mejorar performance
- Claves primarias y foráneas en detalle
- Integridad referencial
- Optimización de consultas

**¡Felicitaciones! Ya creaste tu primer sistema completo con SQL. Este proyecto demuestra que dominás los conceptos fundamentales.**