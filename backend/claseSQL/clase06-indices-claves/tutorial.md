# Clase 6: Índices, Claves Primarias y Foráneas - Performance e Integridad

## 🎯 Objetivos de la Clase

Al finalizar esta clase, Rafa será capaz de:
- Entender qué son los índices y para qué sirven
- Conocer las claves primarias y foráneas en profundidad
- Aplicar integridad referencial entre tablas
- Optimizar consultas con índices estratégicos
- Diseñar relaciones robustas entre entidades

---

## 🔑 Claves Primarias: El Fundamento de la Integridad

### ¿Qué es una Clave Primaria?
Una **Primary Key (PK)** es el **identificador único** de cada fila en una tabla. Es como el **DNI** de cada registro.

### Características Esenciales
```sql
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,  -- ✅ Identificador único
    email TEXT UNIQUE NOT NULL,
    nombre TEXT NOT NULL
);
```

**Reglas inquebrantables:**
- ✅ **Única**: No puede repetirse
- ✅ **NOT NULL**: Siempre tiene valor
- ✅ **Inmutable**: No debería cambiar nunca
- ✅ **Una por tabla**: Solo puede haber una PK por tabla

### ¿Por Qué Son Importantes?
```sql
-- Sin PK: ¿Cómo identificás exactamente ESTE Juan?
SELECT * FROM usuarios WHERE nombre = 'Juan';  -- Puede haber varios Juan

-- Con PK: Identificación precisa
SELECT * FROM usuarios WHERE id = 1;  -- Exactamente ESE usuario
UPDATE usuarios SET email = 'nuevo@email.com' WHERE id = 1;  -- Seguro y preciso
```

### Tipos de Claves Primarias

#### 1. Natural Keys (Claves Naturales)
```sql
CREATE TABLE paises (
    codigo_iso TEXT PRIMARY KEY,  -- 'AR', 'BR', 'US'
    nombre TEXT NOT NULL
);

CREATE TABLE productos (
    codigo_barras TEXT PRIMARY KEY,  -- '7790123456789'
    nombre TEXT NOT NULL
);
```
**Ventajas**: Significativo para humanos
**Desventajas**: Puede cambiar, complejo de manejar

#### 2. Surrogate Keys (Claves Artificiales) - **RECOMENDADO**
```sql
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,  -- 1, 2, 3, 4...
    dni TEXT UNIQUE,         -- Dato natural pero no PK
    nombre TEXT NOT NULL
);
```
**Ventajas**: Simple, inmutable, rápido
**Desventajas**: No tiene significado de negocio

> **Recomendación**: Usar siempre `id INTEGER PRIMARY KEY` como patrón estándar.

---

## 🔗 Claves Foráneas: Conectando Tablas

### ¿Qué es una Clave Foránea?
Una **Foreign Key (FK)** es un campo que **referencia la PK de otra tabla**, creando una relación entre tablas.

### Ejemplo Básico: Blog
```sql
-- Tabla padre (referenciada)
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
);

-- Tabla hija (que referencia)
CREATE TABLE posts (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    contenido TEXT,
    autor_id INTEGER,  -- ← Clave foránea
    fecha DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (autor_id) REFERENCES usuarios(id)
);
```

### ¿Qué Garantiza la FK?
```sql
-- ✅ VÁLIDO: El usuario 1 existe
INSERT INTO posts (titulo, contenido, autor_id) 
VALUES ('Mi primer post', 'Contenido...', 1);

-- ❌ ERROR: El usuario 999 no existe
INSERT INTO posts (titulo, contenido, autor_id) 
VALUES ('Post huérfano', 'Contenido...', 999);
-- Error: FOREIGN KEY constraint failed
```

**Integridad Referencial**: La FK garantiza que **no puedas crear posts de usuarios inexistentes**.

---

## 🏗️ Tipos de Relaciones

### 1. Relación 1:N (Uno a Muchos)
```sql
-- Un usuario puede tener muchos posts
-- Un post pertenece a un solo usuario

CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

CREATE TABLE posts (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    autor_id INTEGER,
    FOREIGN KEY (autor_id) REFERENCES usuarios(id)
);
```

**Ejemplos reales:**
- Cliente → Pedidos
- Categoría → Productos  
- Autor → Libros
- Equipo → Jugadores

### 2. Relación 1:1 (Uno a Uno)
```sql
-- Un usuario tiene un solo perfil
-- Un perfil pertenece a un solo usuario

CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    email TEXT UNIQUE NOT NULL
);

CREATE TABLE perfiles (
    id INTEGER PRIMARY KEY,
    usuario_id INTEGER UNIQUE,  -- ← UNIQUE hace que sea 1:1
    biografia TEXT,
    foto_url TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);
```

**Ejemplos reales:**
- Usuario → Perfil
- Empleado → Credencial de seguridad
- Vehículo → Título de propiedad

### 3. Relación N:M (Muchos a Muchos)
```sql
-- Un estudiante puede tomar muchas materias
-- Una materia puede tener muchos estudiantes
-- Se resuelve con una tabla intermedia

CREATE TABLE estudiantes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

CREATE TABLE materias (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

-- Tabla de unión/intermedia
CREATE TABLE estudiantes_materias (
    id INTEGER PRIMARY KEY,
    estudiante_id INTEGER,
    materia_id INTEGER,
    fecha_inscripcion DATE DEFAULT CURRENT_DATE,
    calificacion INTEGER,
    FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
    FOREIGN KEY (materia_id) REFERENCES materias(id),
    UNIQUE(estudiante_id, materia_id)  -- Un estudiante no puede inscribirse 2 veces a la misma materia
);
```

**Ejemplos reales:**
- Estudiantes ↔ Materias
- Actores ↔ Películas
- Libros ↔ Autores
- Jugadores ↔ Equipos (si pueden jugar en varios)

---

## ⚡ Índices: Acelerando Consultas

### ¿Qué es un Índice?
Un **índice** es como el **índice de un libro**: te permite encontrar información rápidamente sin leer todo.

### Sin Índice vs Con Índice
```sql
-- Sin índice: SQLite revisa TODOS los registros
SELECT * FROM usuarios WHERE email = 'juan@email.com';
-- En una tabla de 1 millón de usuarios: ~500ms

-- Con índice en email: SQLite va directo al registro
CREATE INDEX idx_usuarios_email ON usuarios(email);
SELECT * FROM usuarios WHERE email = 'juan@email.com';
-- Mismo resultado: ~1ms
```

### Tipos de Índices

#### 1. Índice Simple
```sql
-- Índice en una sola columna
CREATE INDEX idx_posts_fecha ON posts(fecha);
CREATE INDEX idx_productos_precio ON productos(precio);
```

#### 2. Índice Compuesto (Múltiples columnas)
```sql
-- Índice en múltiples columnas (orden importa!)
CREATE INDEX idx_posts_autor_fecha ON posts(autor_id, fecha);
```

**Regla del orden**: El índice compuesto es útil para consultas que filtren por:
- Solo `autor_id` ✅
- `autor_id` AND `fecha` ✅  
- Solo `fecha` ❌ (no es útil)

#### 3. Índice Único (UNIQUE)
```sql
-- Garantiza que no haya duplicados + acelera búsquedas
CREATE UNIQUE INDEX idx_usuarios_email ON usuarios(email);
-- Equivale a: ALTER TABLE usuarios ADD CONSTRAINT ... UNIQUE(email)
```

### ¿Cuándo Crear Índices?

#### ✅ CREAR cuando:
- Columnas usadas frecuentemente en WHERE
- Columnas usadas en JOINs
- Columnas usadas en ORDER BY
- Claves foráneas (mejor performance en JOINs)

#### ❌ NO CREAR cuando:
- Tablas muy pequeñas (< 1000 registros)
- Columnas que cambian mucho (INSERT/UPDATE se vuelve lento)
- Columnas con pocos valores únicos (ej: género M/F)

### Ejemplo Práctico: E-commerce
```sql
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    categoria_id INTEGER,
    precio REAL,
    stock INTEGER,
    activo BOOLEAN DEFAULT TRUE
);

-- Índices estratégicos
CREATE INDEX idx_productos_categoria ON productos(categoria_id);  -- Para filtrar por categoría
CREATE INDEX idx_productos_precio ON productos(precio);          -- Para ordenar por precio
CREATE INDEX idx_productos_activo ON productos(activo);          -- Para filtrar activos
CREATE INDEX idx_productos_stock ON productos(stock);            -- Para productos sin stock
```

---

## 🚀 Práctica: Sistema de E-learning

### Diseño Completo con Relaciones
```sql
-- 👥 USUARIOS (tabla principal)
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    rol TEXT CHECK (rol IN ('estudiante', 'instructor', 'admin')) DEFAULT 'estudiante',
    activo BOOLEAN DEFAULT TRUE,
    fecha_registro DATE DEFAULT CURRENT_DATE
);

-- 📚 CURSOS
CREATE TABLE cursos (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    descripcion TEXT,
    instructor_id INTEGER NOT NULL,
    precio REAL CHECK (precio >= 0),
    duracion_horas INTEGER,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (instructor_id) REFERENCES usuarios(id)
);

-- 📖 LECCIONES (1:N con cursos)
CREATE TABLE lecciones (
    id INTEGER PRIMARY KEY,
    curso_id INTEGER NOT NULL,
    titulo TEXT NOT NULL,
    contenido TEXT,
    video_url TEXT,
    orden INTEGER NOT NULL,
    duracion_minutos INTEGER,
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);

-- 🎓 INSCRIPCIONES (N:M entre usuarios y cursos)
CREATE TABLE inscripciones (
    id INTEGER PRIMARY KEY,
    estudiante_id INTEGER NOT NULL,
    curso_id INTEGER NOT NULL,
    fecha_inscripcion DATE DEFAULT CURRENT_DATE,
    fecha_completado DATE,
    progreso INTEGER DEFAULT 0 CHECK (progreso >= 0 AND progreso <= 100),
    calificacion INTEGER CHECK (calificacion >= 1 AND calificacion <= 10),
    FOREIGN KEY (estudiante_id) REFERENCES usuarios(id),
    FOREIGN KEY (curso_id) REFERENCES cursos(id),
    UNIQUE(estudiante_id, curso_id)  -- Un estudiante no puede inscribirse 2 veces
);

-- 📊 PROGRESO LECCIONES (seguimiento detallado)
CREATE TABLE progreso_lecciones (
    id INTEGER PRIMARY KEY,
    inscripcion_id INTEGER NOT NULL,
    leccion_id INTEGER NOT NULL,
    completada BOOLEAN DEFAULT FALSE,
    tiempo_visto INTEGER DEFAULT 0,  -- en minutos
    fecha_completado DATE,
    FOREIGN KEY (inscripcion_id) REFERENCES inscripciones(id),
    FOREIGN KEY (leccion_id) REFERENCES lecciones(id),
    UNIQUE(inscripcion_id, leccion_id)
);
```

### Índices Estratégicos
```sql
-- Índices para mejorar performance
CREATE INDEX idx_cursos_instructor ON cursos(instructor_id);
CREATE INDEX idx_cursos_activo ON cursos(activo);
CREATE INDEX idx_lecciones_curso ON lecciones(curso_id);
CREATE INDEX idx_lecciones_orden ON lecciones(curso_id, orden);
CREATE INDEX idx_inscripciones_estudiante ON inscripciones(estudiante_id);
CREATE INDEX idx_inscripciones_curso ON inscripciones(curso_id);
CREATE INDEX idx_progreso_inscripcion ON progreso_lecciones(inscripcion_id);
```

---

## 📊 Consultas con Relaciones

### Consultas Básicas con JOINs
```sql
-- Cursos con información del instructor
SELECT 
    c.titulo as curso,
    u.nombre || ' ' || u.apellido as instructor,
    c.precio,
    c.duracion_horas
FROM cursos c
JOIN usuarios u ON c.instructor_id = u.id
WHERE c.activo = TRUE
ORDER BY c.titulo;

-- Estudiantes inscritos en un curso específico
SELECT 
    u.nombre || ' ' || u.apellido as estudiante,
    i.fecha_inscripcion,
    i.progreso,
    CASE 
        WHEN i.fecha_completado IS NOT NULL THEN 'Completado'
        WHEN i.progreso > 0 THEN 'En progreso'
        ELSE 'No iniciado'
    END as estado
FROM inscripciones i
JOIN usuarios u ON i.estudiante_id = u.id
WHERE i.curso_id = 1  -- Curso específico
ORDER BY i.fecha_inscripcion;
```

### Consultas de Análisis
```sql
-- Instructores más populares (por cantidad de estudiantes)
SELECT 
    u.nombre || ' ' || u.apellido as instructor,
    COUNT(DISTINCT c.id) as cursos_creados,
    COUNT(DISTINCT i.estudiante_id) as total_estudiantes,
    ROUND(AVG(i.progreso), 1) as progreso_promedio
FROM usuarios u
JOIN cursos c ON u.id = c.instructor_id
LEFT JOIN inscripciones i ON c.id = i.curso_id
WHERE u.rol = 'instructor'
GROUP BY u.id, u.nombre, u.apellido
HAVING cursos_creados > 0
ORDER BY total_estudiantes DESC;

-- Cursos con mejor tasa de completado
SELECT 
    c.titulo,
    COUNT(i.id) as total_inscripciones,
    COUNT(i.fecha_completado) as completados,
    ROUND(
        (COUNT(i.fecha_completado) * 100.0 / COUNT(i.id)), 1
    ) as tasa_completado_porcentaje
FROM cursos c
LEFT JOIN inscripciones i ON c.id = i.curso_id
WHERE c.activo = TRUE
GROUP BY c.id, c.titulo
HAVING total_inscripciones > 0
ORDER BY tasa_completado_porcentaje DESC;
```

---

## ⚠️ Problemas Comunes y Soluciones

### Problema 1: Violación de FK
```sql
-- ❌ Error común
DELETE FROM usuarios WHERE id = 1;
-- Error: FOREIGN KEY constraint failed (si tiene cursos asociados)

-- ✅ Solución 1: Eliminar dependencias primero
DELETE FROM inscripciones WHERE estudiante_id = 1;
DELETE FROM cursos WHERE instructor_id = 1;
DELETE FROM usuarios WHERE id = 1;

-- ✅ Solución 2: Usar CASCADE (avanzado)
-- Se configura al crear la tabla
FOREIGN KEY (instructor_id) REFERENCES usuarios(id) ON DELETE CASCADE
```

### Problema 2: Performance Lenta
```sql
-- ❌ Consulta lenta (sin índice)
SELECT * FROM inscripciones WHERE estudiante_id = 123;

-- ✅ Solución: Crear índice
CREATE INDEX idx_inscripciones_estudiante ON inscripciones(estudiante_id);
-- Ahora la misma consulta es 100x más rápida
```

### Problema 3: Datos Huérfanos
```sql
-- ❌ Datos inconsistentes
-- Curso con instructor_id = 999, pero el usuario 999 no existe

-- ✅ Prevención: FOREIGN KEY constraints
-- ✅ Detección: Consulta de verificación
SELECT c.* 
FROM cursos c 
LEFT JOIN usuarios u ON c.instructor_id = u.id 
WHERE u.id IS NULL;
```

---

## 🎯 Buenas Prácticas

### Para Claves Primarias
1. **Siempre usar `id INTEGER PRIMARY KEY`**
2. **Nunca cambiar el valor de una PK**
3. **No usar datos de negocio como PK** (email, DNI, etc.)
4. **Una PK por tabla, siempre**

### Para Claves Foráneas
1. **Siempre agregar índice en FK** para mejor performance
2. **Usar nombres descriptivos**: `autor_id`, `categoria_id`
3. **Considerar ON DELETE CASCADE** para relaciones padre-hijo
4. **Validar integridad regularmente**

### Para Índices
1. **Crear índices en columnas WHERE frecuentes**
2. **Índices compuestos**: columna más selectiva primero
3. **No abusar**: cada índice ralentiza INSERT/UPDATE
4. **Monitor performance**: crear solo si es necesario

### Patrones de Naming
```sql
-- ✅ Consistente y claro
CREATE TABLE usuarios (id, email, nombre);
CREATE TABLE posts (id, titulo, autor_id);  -- FK claramente identificada
CREATE INDEX idx_posts_autor ON posts(autor_id);  -- Índice descriptivo

-- ❌ Inconsistente y confuso
CREATE TABLE user (user_id, mail, name);
CREATE TABLE post (post_id, title, user);  -- ¿FK?
CREATE INDEX i1 ON post(user);  -- ¿Qué indexa?
```

---

## 🏋️ Ejercicios Prácticos

### Ejercicio 1: Detectar Problemas
```sql
-- Dado este diseño, ¿qué problemas detectás?
CREATE TABLE pedidos (
    numero_pedido TEXT,  -- ¿PK?
    cliente_email TEXT,  -- ¿FK?
    total REAL
);

CREATE TABLE clientes (
    email TEXT,
    nombre TEXT
);
```

**Problemas detectados:**
1. ❌ No hay PK explícita
2. ❌ No hay FK definida
3. ❌ No hay constraints de integridad

**Solución:**
```sql
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    nombre TEXT NOT NULL
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    numero_pedido TEXT UNIQUE NOT NULL,
    cliente_id INTEGER NOT NULL,
    total REAL CHECK (total > 0),
    fecha DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
```

---

## 🏠 Tarea Para Casa

### Proyecto: Sistema de Reservas de Restaurante
Diseñá un sistema completo con estas entidades:

1. **Clientes** (id, nombre, teléfono, email)
2. **Mesas** (id, numero, capacidad, ubicación)
3. **Reservas** (id, cliente_id, mesa_id, fecha, hora, personas)
4. **Estados** (pendiente, confirmada, completada, cancelada)

**Requisitos:**
- Todas las tablas con PK apropiada
- Relaciones con FK correctas
- Índices estratégicos
- Constraints de negocio
- 5 consultas útiles del sistema

**Bonus**: Agregar tabla de **Comentarios** y **Calificaciones**.

---

## 🎯 Próxima Clase: Setup de Entorno Real

En la **Clase 8** vamos a:
- Configurar Turso paso a paso
- Migrar nuestros proyectos de SQLSandbox
- Conectar con herramientas de desarrollo
- Preparar para integración con Express.js

**¡Excelente! Ya tenés las bases sólidas de diseño de base de datos. Ahora vamos a llevarlo a un entorno real de desarrollo.**