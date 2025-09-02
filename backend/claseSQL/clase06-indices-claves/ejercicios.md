# Ejercicios Clase 6 - Índices, Claves Primarias y Foráneas

## 🚀 Setup Inicial
1. Abrir [sqlsandbox.com](https://sqlsandbox.com)
2. Copiar y pegar el contenido completo de `sqlsandbox-setup.sql`
3. Hacer click en "Run" para crear el sistema de e-learning
4. Verificar que se crearon 4 tablas y datos: `SELECT name FROM sqlite_master WHERE type='table';`

---

## 🔑 Ejercicios Básicos - Entender las Relaciones

### Ejercicio 1: Explorar la Estructura
```sql
-- 1.1 Ver todas las tablas creadas
SELECT name FROM sqlite_master WHERE type='table';

-- 1.2 Ver la estructura de la tabla cursos
PRAGMA table_info(cursos);

-- 1.3 Ver todos los índices creados
SELECT name FROM sqlite_master WHERE type='index';

-- 1.4 Ver las foreign keys de inscripciones
PRAGMA foreign_key_list(inscripciones);
```

### Ejercicio 2: Consultas Básicas con Relaciones
```sql
-- 2.1 Cursos con información del instructor
SELECT 
    c.titulo as curso,
    u.nombre || ' ' || u.apellido as instructor,
    c.precio,
    c.duracion_horas,
    c.nivel
FROM cursos c
JOIN usuarios u ON c.instructor_id = u.id
WHERE c.activo = TRUE
ORDER BY c.precio DESC;

-- 2.2 Contar cuántos cursos tiene cada instructor
SELECT 
    u.nombre || ' ' || u.apellido as instructor,
    COUNT(c.id) as cantidad_cursos,
    SUM(c.duracion_horas) as horas_totales
FROM usuarios u
JOIN cursos c ON u.id = c.instructor_id
WHERE u.rol = 'instructor'
GROUP BY u.id, u.nombre, u.apellido
ORDER BY cantidad_cursos DESC;

-- 2.3 Ver lecciones de un curso específico
SELECT 
    c.titulo as curso,
    l.orden,
    l.titulo as leccion,
    l.duracion_minutos
FROM cursos c
JOIN lecciones l ON c.id = l.curso_id
WHERE c.id = 1  -- JavaScript Moderno
ORDER BY l.orden;
```

---

## 🔗 Ejercicios Intermedios - Trabajar con Foreign Keys

### Ejercicio 3: Inscripciones y Relaciones N:M
```sql
-- 3.1 Ver todas las inscripciones con detalles completos
SELECT 
    u.nombre || ' ' || u.apellido as estudiante,
    c.titulo as curso,
    i.fecha_inscripcion,
    i.progreso || '%' as progreso,
    CASE 
        WHEN i.fecha_completado IS NOT NULL THEN 'Completado'
        WHEN i.progreso > 50 THEN 'En progreso avanzado'
        WHEN i.progreso > 0 THEN 'En progreso'
        ELSE 'No iniciado'
    END as estado,
    i.calificacion
FROM inscripciones i
JOIN usuarios u ON i.estudiante_id = u.id
JOIN cursos c ON i.curso_id = c.id
ORDER BY i.fecha_inscripcion DESC;

-- 3.2 Estudiantes más activos (más inscripciones)
SELECT 
    u.nombre || ' ' || u.apellido as estudiante,
    COUNT(i.id) as cursos_inscritos,
    COUNT(i.fecha_completado) as cursos_completados,
    ROUND(AVG(i.progreso), 1) as progreso_promedio
FROM usuarios u
JOIN inscripciones i ON u.id = i.estudiante_id
WHERE u.rol = 'estudiante'
GROUP BY u.id, u.nombre, u.apellido
ORDER BY cursos_inscritos DESC;

-- 3.3 Cursos más populares
SELECT 
    c.titulo,
    COUNT(i.id) as inscripciones,
    COUNT(i.fecha_completado) as completados,
    ROUND(
        (COUNT(i.fecha_completado) * 100.0 / COUNT(i.id)), 1
    ) as tasa_completado
FROM cursos c
LEFT JOIN inscripciones i ON c.id = i.curso_id
GROUP BY c.id, c.titulo
HAVING inscripciones > 0
ORDER BY inscripciones DESC;
```

### Ejercicio 4: Pruebas de Integridad Referencial
```sql
-- 4.1 Intentar crear un curso con instructor inexistente (debería fallar)
INSERT INTO cursos (titulo, instructor_id, precio) 
VALUES ('Curso Test', 999, 1000.00);
-- ¿Qué error obtenés?

-- 4.2 Intentar inscribir estudiante a curso inexistente (debería fallar) 
INSERT INTO inscripciones (estudiante_id, curso_id) 
VALUES (5, 999);
-- ¿Qué error obtenés?

-- 4.3 Intentar insertar inscripción duplicada (debería fallar)
INSERT INTO inscripciones (estudiante_id, curso_id) 
VALUES (5, 1);  -- Pedro ya está inscrito en JavaScript
-- ¿Qué error obtenés?

-- 4.4 Verificar integridad: buscar datos huérfanos
-- Cursos sin instructor válido
SELECT c.* 
FROM cursos c 
LEFT JOIN usuarios u ON c.instructor_id = u.id 
WHERE u.id IS NULL;

-- Inscripciones sin estudiante válido  
SELECT i.* 
FROM inscripciones i 
LEFT JOIN usuarios u ON i.estudiante_id = u.id 
WHERE u.id IS NULL;
```

---

## ⚡ Ejercicios Avanzados - Performance y Índices

### Ejercicio 5: Analizar Performance (Conceptual)
```sql
-- 5.1 Consulta que se beneficia de índice
-- Esta consulta usa el índice idx_inscripciones_estudiante
SELECT * FROM inscripciones WHERE estudiante_id = 5;

-- 5.2 Consulta que usa índice compuesto
-- Esta consulta usa el índice idx_lecciones_orden (curso_id, orden)
SELECT * FROM lecciones WHERE curso_id = 1 ORDER BY orden;

-- 5.3 Consulta que podría necesitar índice adicional
-- Si esta consulta fuera muy frecuente, necesitaríamos índice en fecha_inscripcion
SELECT * FROM inscripciones WHERE fecha_inscripcion > '2024-01-01';
```

### Ejercicio 6: Crear Índices Adicionales
```sql
-- 6.1 Crear índice para búsquedas por fecha
CREATE INDEX idx_inscripciones_fecha ON inscripciones(fecha_inscripcion);

-- 6.2 Crear índice compuesto para consultas complejas
CREATE INDEX idx_cursos_nivel_precio ON cursos(nivel, precio);

-- 6.3 Crear índice para filtros frecuentes
CREATE INDEX idx_usuarios_rol_activo ON usuarios(rol, activo);

-- 6.4 Verificar que se crearon
SELECT name FROM sqlite_master WHERE type='index' AND name LIKE 'idx_%';
```

---

## 🔧 Ejercicios de Manipulación

### Ejercicio 7: Operaciones CRUD Respetando Relaciones
```sql
-- 7.1 Agregar nuevo instructor
INSERT INTO usuarios (email, nombre, apellido, rol) 
VALUES ('nuevo.instructor@email.com', 'Ricardo', 'Pérez', 'instructor');

-- 7.2 Crear curso para el nuevo instructor
INSERT INTO cursos (titulo, descripcion, instructor_id, precio, duracion_horas, nivel)
VALUES (
    'Python para Principiantes', 
    'Introducción al lenguaje de programación Python', 
    (SELECT id FROM usuarios WHERE email = 'nuevo.instructor@email.com'),
    3800.00, 
    30, 
    'Principiante'
);

-- 7.3 Agregar lecciones al nuevo curso
INSERT INTO lecciones (curso_id, titulo, contenido, orden, duracion_minutos) VALUES 
((SELECT MAX(id) FROM cursos), 'Variables y Tipos de Datos', 'Conceptos básicos de Python', 1, 45),
((SELECT MAX(id) FROM cursos), 'Estructuras de Control', 'If, for, while en Python', 2, 50),
((SELECT MAX(id) FROM cursos), 'Funciones', 'Definición y uso de funciones', 3, 55);

-- 7.4 Inscribir estudiante al nuevo curso
INSERT INTO inscripciones (estudiante_id, curso_id, progreso) 
VALUES (6, (SELECT MAX(id) FROM cursos), 0);  -- Laura se inscribe a Python
```

### Ejercicio 8: Actualizar Progreso de Estudiantes
```sql
-- 8.1 Actualizar progreso de un estudiante
UPDATE inscripciones 
SET progreso = 85, fecha_completado = NULL 
WHERE estudiante_id = 6 AND curso_id = 3;  -- Laura progresa en Node.js

-- 8.2 Marcar curso como completado
UPDATE inscripciones 
SET progreso = 100, fecha_completado = CURRENT_DATE, calificacion = 9
WHERE estudiante_id = 8 AND curso_id = 1;  -- Sofia completa JavaScript

-- 8.3 Actualizar información de curso
UPDATE cursos 
SET precio = precio * 1.1  -- Subir precios 10%
WHERE nivel = 'Avanzado';

-- 8.4 Desactivar curso temporalmente
UPDATE cursos 
SET activo = FALSE 
WHERE titulo = 'MongoDB y Base de Datos';
```

---

## 📊 Ejercicios de Análisis Complejo

### Ejercicio 9: Reportes de Negocio
```sql
-- 9.1 Reporte de ingresos por instructor
SELECT 
    u.nombre || ' ' || u.apellido as instructor,
    COUNT(DISTINCT c.id) as cursos_creados,
    COUNT(i.id) as total_inscripciones,
    SUM(c.precio) as ingresos_potenciales,
    ROUND(AVG(i.calificacion), 1) as calificacion_promedio
FROM usuarios u
JOIN cursos c ON u.id = c.instructor_id
LEFT JOIN inscripciones i ON c.id = i.curso_id
WHERE u.rol = 'instructor'
GROUP BY u.id, u.nombre, u.apellido
ORDER BY ingresos_potenciales DESC;

-- 9.2 Análisis de retención por nivel de curso
SELECT 
    c.nivel,
    COUNT(i.id) as inscripciones,
    COUNT(i.fecha_completado) as completados,
    ROUND(AVG(i.progreso), 1) as progreso_promedio,
    ROUND(
        (COUNT(i.fecha_completado) * 100.0 / COUNT(i.id)), 1
    ) as tasa_completado
FROM cursos c
LEFT JOIN inscripciones i ON c.id = i.curso_id
WHERE c.activo = TRUE
GROUP BY c.nivel
ORDER BY tasa_completado DESC;

-- 9.3 Estudiantes con mejor rendimiento
SELECT 
    u.nombre || ' ' || u.apellido as estudiante,
    COUNT(i.id) as cursos_inscritos,
    COUNT(i.fecha_completado) as cursos_completados,
    ROUND(AVG(CASE WHEN i.calificacion IS NOT NULL THEN i.calificacion END), 1) as calificacion_promedio,
    SUM(CASE WHEN i.fecha_completado IS NOT NULL THEN c.duracion_horas ELSE 0 END) as horas_completadas
FROM usuarios u
JOIN inscripciones i ON u.id = i.estudiante_id
JOIN cursos c ON i.curso_id = c.id
WHERE u.rol = 'estudiante'
GROUP BY u.id, u.nombre, u.apellido
HAVING cursos_completados > 0
ORDER BY calificacion_promedio DESC, horas_completadas DESC;
```

### Ejercicio 10: Dashboard Ejecutivo
```sql
-- 10.1 KPIs principales de la plataforma
SELECT 
    'DASHBOARD PLATAFORMA E-LEARNING' as titulo,
    '' as valor
UNION ALL
SELECT 
    'Total usuarios activos',
    CAST(COUNT(*) as TEXT)
FROM usuarios WHERE activo = TRUE
UNION ALL
SELECT 
    'Total cursos disponibles',
    CAST(COUNT(*) as TEXT)
FROM cursos WHERE activo = TRUE
UNION ALL
SELECT 
    'Total inscripciones',
    CAST(COUNT(*) as TEXT)
FROM inscripciones
UNION ALL
SELECT 
    'Tasa de completado general',
    CAST(ROUND(
        (SELECT COUNT(*) FROM inscripciones WHERE fecha_completado IS NOT NULL) * 100.0 / 
        COUNT(*), 1
    ) as TEXT) || '%'
FROM inscripciones
UNION ALL
SELECT 
    'Ingresos totales estimados',
    '$' || CAST(SUM(c.precio) as TEXT)
FROM inscripciones i
JOIN cursos c ON i.curso_id = c.id
UNION ALL
SELECT 
    'Calificación promedio',
    CAST(ROUND(AVG(calificacion), 1) as TEXT) || '/10'
FROM inscripciones WHERE calificacion IS NOT NULL;
```

---

## 🛠️ Ejercicios de Mantenimiento

### Ejercicio 11: Limpieza y Optimización
```sql
-- 11.1 Identificar inscripciones sin progreso después de 30 días
SELECT 
    u.nombre || ' ' || u.apellido as estudiante,
    c.titulo as curso,
    i.fecha_inscripcion,
    i.progreso,
    'Sin actividad' as estado
FROM inscripciones i
JOIN usuarios u ON i.estudiante_id = u.id
JOIN cursos c ON i.curso_id = c.id
WHERE i.progreso = 0 
  AND DATE(i.fecha_inscripcion) < DATE('now', '-30 days');

-- 11.2 Verificar consistencia de datos
-- Inscripciones con progreso 100% pero sin fecha de completado
SELECT 
    i.id,
    u.nombre || ' ' || u.apellido as estudiante,
    c.titulo as curso,
    'Inconsistencia: 100% sin fecha' as problema
FROM inscripciones i
JOIN usuarios u ON i.estudiante_id = u.id
JOIN cursos c ON i.curso_id = c.id
WHERE i.progreso = 100 AND i.fecha_completado IS NULL;

-- 11.3 Cursos sin lecciones (problemas de contenido)
SELECT 
    c.titulo,
    'Sin lecciones creadas' as problema
FROM cursos c
LEFT JOIN lecciones l ON c.id = l.curso_id
WHERE l.id IS NULL AND c.activo = TRUE;
```

---

## ✅ Verificaciones Finales

### Test 1: Integridad de Foreign Keys
```sql
-- Verificar que todas las FKs son válidas
SELECT 
    'VERIFICACIÓN DE INTEGRIDAD' as test,
    CASE 
        WHEN (SELECT COUNT(*) FROM cursos c LEFT JOIN usuarios u ON c.instructor_id = u.id WHERE u.id IS NULL) = 0
        THEN 'PASS: Todos los cursos tienen instructor válido'
        ELSE 'FAIL: Hay cursos con instructor inválido'
    END as resultado_instructores,
    CASE 
        WHEN (SELECT COUNT(*) FROM inscripciones i LEFT JOIN usuarios u ON i.estudiante_id = u.id WHERE u.id IS NULL) = 0
        THEN 'PASS: Todas las inscripciones tienen estudiante válido'
        ELSE 'FAIL: Hay inscripciones con estudiante inválido'
    END as resultado_estudiantes;
```

### Test 2: Verificar Índices Creados
```sql
-- Contar índices por tabla
SELECT 
    SUBSTR(name, 5, INSTR(name, '_', 5) - 5) as tabla,
    COUNT(*) as indices_creados
FROM sqlite_master 
WHERE type = 'index' 
  AND name LIKE 'idx_%'
GROUP BY SUBSTR(name, 5, INSTR(name, '_', 5) - 5)
ORDER BY tabla;
```

### Auto-evaluación
- [ ] Entiendo qué son las claves primarias y por qué son importantes
- [ ] Sé crear relaciones con foreign keys correctamente
- [ ] Puedo identificar los tipos de relaciones (1:1, 1:N, N:M)
- [ ] Entiendo para qué sirven los índices y cuándo crearlos
- [ ] Puedo hacer consultas que usen múltiples tablas relacionadas
- [ ] Sé detectar problemas de integridad referencial

---

## 🏠 Proyecto Para Casa

### Sistema de Reservas de Hotel
Diseñá un sistema completo con estas entidades:

**Tablas requeridas:**
- `huespedes` (id, nombre, email, telefono, documento)
- `habitaciones` (id, numero, tipo, precio_noche, capacidad)
- `reservas` (id, huesped_id, habitacion_id, fecha_entrada, fecha_salida, total)
- `servicios` (id, nombre, precio)
- `reservas_servicios` (reserva_id, servicio_id, cantidad)

**Requisitos técnicos:**
1. Todas las PKs y FKs correctas
2. Índices estratégicos (mínimo 5)
3. Constraints de negocio apropiadas
4. Relación N:M entre reservas y servicios

**Consultas obligatorias:**
1. Reservas activas con información completa
2. Ingresos por habitación en el último mes
3. Servicios más solicitados
4. Huéspedes más frecuentes
5. Disponibilidad de habitaciones para fechas específicas

**Bonus:**
- Agregar tabla `pagos` con diferentes métodos
- Implementar sistema de descuentos
- Crear vista para dashboard de ocupación

---

## 🎯 Próxima Clase: Setup con Turso

En la **Clase 8** vamos a:
- Migrar este sistema a Turso (base de datos real)
- Configurar entorno de desarrollo
- Conectar con herramientas locales
- Preparar para integración con Express.js

**¡Excelente! Ya dominás el diseño de bases de datos relacionales. Ahora vamos a llevarlo a producción.**