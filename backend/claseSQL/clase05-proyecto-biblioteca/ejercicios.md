# Ejercicios Clase 5 - Proyecto Biblioteca Personal

## 🚀 Setup Inicial
1. Abrir [sqlsandbox.com](https://sqlsandbox.com)
2. Copiar y pegar el contenido completo de `sqlsandbox-setup.sql`
3. Hacer click en "Run" para crear todo el sistema
4. Verificar que se crearon las tablas con: `SELECT name FROM sqlite_master WHERE type='table';`

---

## 📊 Ejercicios de Consulta Básica

### Ejercicio 1: Explorar la Biblioteca
```sql
-- 1.1 Ver todos los libros con información básica
SELECT titulo, año_publicacion, precio, 
       CASE WHEN leido THEN 'Leído' ELSE 'Por leer' END as estado
FROM libros 
WHERE activo = TRUE
ORDER BY titulo;

-- 1.2 Ver todos los autores ordenados alfabéticamente
SELECT nombre, apellido, nacionalidad, 
       CASE 
           WHEN fecha_nacimiento IS NOT NULL 
           THEN (2024 - CAST(SUBSTR(fecha_nacimiento, 1, 4) AS INTEGER)) || ' años'
           ELSE 'Edad desconocida'
       END as edad_aprox
FROM autores 
WHERE activo = TRUE
ORDER BY apellido, nombre;

-- 1.3 Ver géneros disponibles con descripción
SELECT nombre, descripcion FROM generos ORDER BY nombre;
```

### Ejercicio 2: Consultas con Relaciones
```sql
-- 2.1 Libros con sus autores (información completa)
SELECT 
    l.titulo,
    a.nombre || ' ' || a.apellido as autor,
    g.nombre as genero,
    l.año_publicacion,
    l.precio
FROM libros l
JOIN libros_autores la ON l.id = la.libro_id
JOIN autores a ON la.autor_id = a.id
LEFT JOIN generos g ON l.genero_id = g.id
WHERE l.activo = TRUE
ORDER BY l.titulo;

-- 2.2 Autores con cantidad de libros en la biblioteca
SELECT 
    a.nombre || ' ' || a.apellido as autor,
    COUNT(l.id) as cantidad_libros,
    GROUP_CONCAT(l.titulo, ', ') as titulos
FROM autores a
JOIN libros_autores la ON a.id = la.autor_id
JOIN libros l ON la.libro_id = l.id
WHERE l.activo = TRUE
GROUP BY a.id, a.nombre, a.apellido
ORDER BY cantidad_libros DESC, autor;
```

---

## 🎯 Ejercicios de Análisis

### Ejercicio 3: Estadísticas de Lectura
```sql
-- 3.1 Resumen general de la biblioteca
SELECT 
    COUNT(*) as total_libros,
    SUM(CASE WHEN leido THEN 1 ELSE 0 END) as libros_leidos,
    SUM(CASE WHEN NOT leido THEN 1 ELSE 0 END) as libros_por_leer,
    ROUND(
        (SUM(CASE WHEN leido THEN 1.0 ELSE 0 END) / COUNT(*)) * 100, 1
    ) as porcentaje_leido,
    SUM(precio) as valor_total_biblioteca
FROM libros 
WHERE activo = TRUE;

-- 3.2 Calificación promedio de libros leídos
SELECT 
    ROUND(AVG(calificacion), 1) as calificacion_promedio,
    COUNT(*) as libros_calificados,
    MAX(calificacion) as mejor_calificacion,
    MIN(calificacion) as peor_calificacion
FROM libros 
WHERE leido = TRUE AND calificacion IS NOT NULL;

-- 3.3 Libros leídos por mes (del año actual)
SELECT 
    SUBSTR(fecha_lectura, 1, 7) as mes_año,
    COUNT(*) as libros_leidos_en_mes
FROM libros 
WHERE fecha_lectura IS NOT NULL 
  AND fecha_lectura >= '2023-01-01'
GROUP BY SUBSTR(fecha_lectura, 1, 7)
ORDER BY mes_año DESC;
```

### Ejercicio 4: Rankings y Tops
```sql
-- 4.1 Top 5 libros mejor calificados
SELECT 
    ROW_NUMBER() OVER (ORDER BY l.calificacion DESC, l.titulo) as ranking,
    l.titulo,
    a.nombre || ' ' || a.apellido as autor,
    l.calificacion,
    g.nombre as genero
FROM libros l
JOIN libros_autores la ON l.id = la.libro_id
JOIN autores a ON la.autor_id = a.id
LEFT JOIN generos g ON l.genero_id = g.id
WHERE l.leido = TRUE AND l.calificacion IS NOT NULL
ORDER BY l.calificacion DESC, l.titulo
LIMIT 5;

-- 4.2 Géneros más populares (por cantidad de libros)
SELECT 
    g.nombre as genero,
    COUNT(l.id) as cantidad_libros,
    SUM(CASE WHEN l.leido THEN 1 ELSE 0 END) as leidos,
    ROUND(AVG(l.precio), 0) as precio_promedio,
    SUM(l.precio) as inversion_total
FROM generos g
LEFT JOIN libros l ON g.id = l.genero_id AND l.activo = TRUE
GROUP BY g.id, g.nombre
HAVING cantidad_libros > 0
ORDER BY cantidad_libros DESC;

-- 4.3 Libros más caros por género
SELECT 
    g.nombre as genero,
    l.titulo,
    a.nombre || ' ' || a.apellido as autor,
    l.precio
FROM (
    SELECT genero_id, MAX(precio) as max_precio
    FROM libros 
    WHERE activo = TRUE
    GROUP BY genero_id
) max_precios
JOIN libros l ON l.genero_id = max_precios.genero_id AND l.precio = max_precios.max_precio
JOIN generos g ON l.genero_id = g.id
JOIN libros_autores la ON l.id = la.libro_id
JOIN autores a ON la.autor_id = a.id
ORDER BY l.precio DESC;
```

---

## ✏️ Ejercicios de Modificación

### Ejercicio 5: Actualizar Estados de Lectura
```sql
-- 5.1 Marcar "Sapiens" como leído con calificación
UPDATE libros 
SET leido = TRUE, 
    fecha_lectura = '2024-01-20',
    calificacion = 9,
    notas = 'Fascinante análisis de la evolución humana. Muy recomendable.'
WHERE titulo = 'Sapiens: De animales a dioses';

-- 5.2 Marcar "Clean Code" como leído
UPDATE libros 
SET leido = TRUE, 
    fecha_lectura = '2024-02-15',
    calificacion = 8,
    notas = 'Excelente para mejorar habilidades de programación.'
WHERE titulo = 'Clean Code';

-- 5.3 Marcar varios libros como en progreso (leído=FALSE pero con notas)
UPDATE libros 
SET notas = 'Empezado - muy interesante hasta ahora'
WHERE titulo IN ('La casa de los espíritus', 'El laberinto de la soledad');
```

### Ejercicio 6: Agregar Nuevos Contenidos
```sql
-- 6.1 Agregar un nuevo género
INSERT INTO generos (nombre, descripcion) 
VALUES ('Filosofía', 'Textos sobre pensamiento y reflexión filosófica');

-- 6.2 Agregar un autor nuevo
INSERT INTO autores (nombre, apellido, nacionalidad, fecha_nacimiento, biografia) 
VALUES ('Haruki', 'Murakami', 'Japonesa', '1949-01-12', 'Escritor japonés de novelas surrealistas y contemporáneas');

-- 6.3 Agregar un libro nuevo
INSERT INTO libros (titulo, isbn, año_publicacion, paginas, genero_id, precio, notas) 
VALUES ('Kafka en la orilla', '978-1400079278', 2002, 436, 1, 3500.00, 'Próximo a leer - muy recomendado');

-- 6.4 Relacionar el nuevo libro con el autor
INSERT INTO libros_autores (libro_id, autor_id) 
VALUES ((SELECT MAX(id) FROM libros), (SELECT MAX(id) FROM autores));
```

### Ejercicio 7: Actualizaciones Masivas
```sql
-- 7.1 Actualizar precios por inflación (10% aumento)
UPDATE libros 
SET precio = precio * 1.10 
WHERE fecha_adquisicion < '2023-01-01';

-- 7.2 Completar información faltante de autores
UPDATE autores 
SET biografia = 'Información biográfica pendiente de actualizar'
WHERE biografia IS NULL OR biografia = '';

-- 7.3 Marcar libros muy viejos como "clásicos" en las notas
UPDATE libros 
SET notas = COALESCE(notas || ' - ', '') || 'CLÁSICO LITERARIO'
WHERE año_publicacion < 1980 AND leido = TRUE;
```

---

## 🔥 Ejercicios Avanzados

### Ejercicio 8: Consultas Complejas
```sql
-- 8.1 Autores más prolíficos con mejor promedio de calificación
SELECT 
    a.nombre || ' ' || a.apellido as autor,
    COUNT(l.id) as total_libros,
    SUM(CASE WHEN l.leido THEN 1 ELSE 0 END) as libros_leidos,
    ROUND(AVG(CASE WHEN l.leido THEN l.calificacion END), 1) as promedio_calificacion,
    GROUP_CONCAT(
        CASE WHEN l.leido THEN l.titulo || ' (' || l.calificacion || ')' END, 
        ', '
    ) as libros_leidos_con_nota
FROM autores a
JOIN libros_autores la ON a.id = la.autor_id
JOIN libros l ON la.libro_id = l.id
WHERE l.activo = TRUE
GROUP BY a.id, a.nombre, a.apellido
HAVING libros_leidos > 0
ORDER BY promedio_calificacion DESC, total_libros DESC;

-- 8.2 Análisis de inversión por período
SELECT 
    CASE 
        WHEN año_publicacion < 1950 THEN 'Clásicos (Pre-1950)'
        WHEN año_publicacion < 1990 THEN 'Modernos (1950-1989)'
        WHEN año_publicacion < 2010 THEN 'Contemporáneos (1990-2009)'
        ELSE 'Actuales (2010+)'
    END as epoca,
    COUNT(*) as cantidad_libros,
    SUM(precio) as inversion_total,
    ROUND(AVG(precio), 0) as precio_promedio,
    SUM(CASE WHEN leido THEN 1 ELSE 0 END) as leidos
FROM libros 
WHERE activo = TRUE
GROUP BY 
    CASE 
        WHEN año_publicacion < 1950 THEN 1
        WHEN año_publicacion < 1990 THEN 2
        WHEN año_publicacion < 2010 THEN 3
        ELSE 4
    END
ORDER BY inversion_total DESC;

-- 8.3 Recomendaciones basadas en gustos (libros similares a los mejor calificados)
SELECT DISTINCT
    l2.titulo as recomendacion,
    a.nombre || ' ' || a.apellido as autor,
    g.nombre as genero,
    l2.año_publicacion,
    l2.precio
FROM libros l1
JOIN libros l2 ON l1.genero_id = l2.genero_id
JOIN libros_autores la ON l2.id = la.libro_id
JOIN autores a ON la.autor_id = a.id
LEFT JOIN generos g ON l2.genero_id = g.id
WHERE l1.calificacion >= 9  -- Libros que me gustaron mucho
  AND l2.leido = FALSE      -- Que aún no leí
  AND l1.id != l2.id        -- Que no sean el mismo libro
  AND l2.activo = TRUE
ORDER BY l2.año_publicacion DESC;
```

### Ejercicio 9: Gestión Avanzada
```sql
-- 9.1 Identificar libros candidatos para regalar (calificación baja)
SELECT 
    l.titulo,
    a.nombre || ' ' || a.apellido as autor,
    l.calificacion,
    l.notas,
    'Candidato a regalar' as accion_sugerida
FROM libros l
JOIN libros_autores la ON l.id = la.libro_id
JOIN autores a ON la.autor_id = a.id
WHERE l.leido = TRUE 
  AND l.calificacion <= 6 
  AND l.activo = TRUE
ORDER BY l.calificacion ASC;

-- 9.2 Lista de compras prioritarias (próximos a leer por género)
SELECT 
    g.nombre as genero_favorito,
    COUNT(l.id) as libros_en_genero,
    SUM(CASE WHEN l.leido THEN 1 ELSE 0 END) as leidos_en_genero,
    'Buscar más libros de este género' as sugerencia
FROM generos g
JOIN libros l ON g.id = l.genero_id
WHERE l.activo = TRUE
GROUP BY g.id, g.nombre
HAVING AVG(CASE WHEN l.leido AND l.calificacion IS NOT NULL THEN l.calificacion END) >= 8
ORDER BY COUNT(l.id) DESC
LIMIT 3;
```

---

## 📈 Ejercicios de Reportes

### Ejercicio 10: Dashboard Completo
```sql
-- 10.1 Reporte ejecutivo de la biblioteca
SELECT 
    'BIBLIOTECA PERSONAL - DASHBOARD' as seccion,
    '' as metrica,
    '' as valor
UNION ALL
SELECT 
    'INVENTARIO',
    'Total de libros',
    CAST(COUNT(*) as TEXT)
FROM libros WHERE activo = TRUE
UNION ALL
SELECT 
    '',
    'Libros leídos',
    CAST(SUM(CASE WHEN leido THEN 1 ELSE 0 END) as TEXT)
FROM libros WHERE activo = TRUE
UNION ALL
SELECT 
    '',
    'Progreso de lectura',
    CAST(ROUND(SUM(CASE WHEN leido THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 1) as TEXT) || '%'
FROM libros WHERE activo = TRUE
UNION ALL
SELECT 
    '',
    'Valor total biblioteca',
    '$' || CAST(SUM(precio) as TEXT)
FROM libros WHERE activo = TRUE
UNION ALL
SELECT 
    'CALIDAD',
    'Calificación promedio',
    CAST(ROUND(AVG(calificacion), 1) as TEXT) || '/10'
FROM libros WHERE leido = TRUE AND calificacion IS NOT NULL
UNION ALL
SELECT 
    '',
    'Autores en biblioteca',
    CAST(COUNT(DISTINCT a.id) as TEXT)
FROM autores a
JOIN libros_autores la ON a.id = la.autor_id
JOIN libros l ON la.libro_id = l.id
WHERE l.activo = TRUE
UNION ALL
SELECT 
    '',
    'Géneros representados',
    CAST(COUNT(DISTINCT genero_id) as TEXT)
FROM libros WHERE activo = TRUE AND genero_id IS NOT NULL;
```

---

## ✅ Verificaciones y Tests

### Test 1: Integridad de Datos
```sql
-- Verificar que todos los libros tienen autor
SELECT 
    l.titulo,
    'SIN AUTOR' as problema
FROM libros l
LEFT JOIN libros_autores la ON l.id = la.libro_id
WHERE la.libro_id IS NULL AND l.activo = TRUE;

-- Verificar que no hay calificaciones inválidas
SELECT titulo, calificacion, 'CALIFICACIÓN INVÁLIDA' as problema
FROM libros 
WHERE calificacion IS NOT NULL 
  AND (calificacion < 1 OR calificacion > 10);

-- Verificar consistencia de fechas
SELECT titulo, fecha_adquisicion, fecha_lectura, 'FECHAS INCONSISTENTES' as problema
FROM libros 
WHERE fecha_lectura IS NOT NULL 
  AND fecha_lectura < fecha_adquisicion;
```

### Test 2: Verificar Operaciones Realizadas
```sql
-- Contar libros marcados como leídos en los ejercicios
SELECT 
    COUNT(*) as libros_leidos_total,
    COUNT(CASE WHEN fecha_lectura >= '2024-01-01' THEN 1 END) as leidos_este_año
FROM libros 
WHERE leido = TRUE;

-- Verificar que se agregaron los nuevos contenidos
SELECT 'Nuevos géneros', COUNT(*) FROM generos WHERE nombre = 'Filosofía'
UNION ALL
SELECT 'Nuevos autores', COUNT(*) FROM autores WHERE apellido = 'Murakami'
UNION ALL  
SELECT 'Nuevos libros', COUNT(*) FROM libros WHERE titulo = 'Kafka en la orilla';
```

---

## 🏠 Proyecto Personal

### Misión: Expande Tu Biblioteca Digital
**Objetivo**: Personalizar completamente el sistema con tus propios gustos literarios.

### Tareas Obligatorias:
1. **Agregar 10 libros reales** que te interesen o ya hayas leído
2. **Crear 5 autores nuevos** con información completa
3. **Inventar 2 géneros personalizados** (ej: "Sci-Fi Cyberpunk", "Filosofía Oriental")
4. **Marcar 8 libros como leídos** con calificaciones honestas
5. **Escribir notas personales** en al menos 5 libros

### Consultas Desafío:
Crear queries para responder:
- ¿Cuál es tu género favorito basado en calificaciones?
- ¿Qué autor tiene el mejor promedio en tu biblioteca?
- ¿Cuánto has invertido en libros este año?
- ¿Cuál es tu velocidad de lectura (libros por mes)?
- ¿Qué libros deberías leer próximamente?

### Bonus Challenge:
Crear una **tabla de metas de lectura** personal:
```sql
CREATE TABLE metas_lectura (
    id INTEGER PRIMARY KEY,
    año INTEGER,
    meta_libros INTEGER,
    libros_leidos INTEGER DEFAULT 0,
    cumplida BOOLEAN DEFAULT FALSE
);
```

---

## 🎯 Próxima Clase: Índices y Claves Foráneas

En la **Clase 6** profundizaremos en:
- Performance de consultas con índices
- Integridad referencial avanzada
- Optimización de base de datos
- Mejores prácticas de diseño

**¡Excelente trabajo! Completaste tu primer proyecto SQL real. Este sistema demuestra que ya podés crear aplicaciones completas con bases de datos relacionales.**