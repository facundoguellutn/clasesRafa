# 🏗️ NORMALIZACIÓN Y DISEÑO DE SCHEMAS - CLASE 11

> **Objetivo**: Aprender a diseñar bases de datos eficientes aplicando las reglas de normalización para evitar redundancia y problemas de integridad.

## 📖 ¿Qué es la Normalización?

La normalización es el proceso de organizar los datos en una base de datos para **reducir la redundancia y mejorar la integridad**. Es como organizar tu casa: cada cosa tiene su lugar específico.

### 🤔 ¿Por qué es importante?

**Sin normalización:**
```sql
-- Tabla MAL DISEÑADA ❌
CREATE TABLE pedidos_mal (
    id INTEGER PRIMARY KEY,
    cliente_nombre TEXT,
    cliente_email TEXT,
    cliente_telefono TEXT,
    producto_nombre TEXT,
    producto_precio REAL,
    categoria_nombre TEXT,
    cantidad INTEGER,
    total REAL
);

-- Problemas:
-- 1. Si Juan cambia su teléfono, hay que actualizar MUCHAS filas
-- 2. Si escribimos mal "Electrónicos" en una fila, inconsistencia
-- 3. Desperdicio de espacio: repetimos info del cliente en cada pedido
```

**Con normalización:**
```sql
-- Tablas BIEN DISEÑADAS ✅
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT,
    email TEXT,
    telefono TEXT
);

CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT,
    precio REAL,
    categoria_id INTEGER
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER,
    fecha DATE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);
```

## 🎯 Las Formas Normales (Paso a Paso)

### 📝 Primera Forma Normal (1FN)

**Regla**: Cada celda debe contener un solo valor (no listas ni arrays).

**❌ Mal diseño:**
```sql
CREATE TABLE estudiantes_mal (
    id INTEGER PRIMARY KEY,
    nombre TEXT,
    materias TEXT  -- "Matemática, Física, Química" ❌
);
```

**✅ Buen diseño:**
```sql
CREATE TABLE estudiantes (
    id INTEGER PRIMARY KEY,
    nombre TEXT
);

CREATE TABLE materias (
    id INTEGER PRIMARY KEY,
    nombre TEXT
);

CREATE TABLE estudiante_materias (
    estudiante_id INTEGER,
    materia_id INTEGER,
    FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
    FOREIGN KEY (materia_id) REFERENCES materias(id)
);
```

### 🔑 Segunda Forma Normal (2FN)

**Reglas**: 
1. Debe estar en 1FN
2. Todos los campos no clave deben depender de la clave primaria COMPLETA

**❌ Problema típico:**
```sql
-- Clave primaria compuesta: (pedido_id, producto_id)
CREATE TABLE pedido_items_mal (
    pedido_id INTEGER,
    producto_id INTEGER,
    cantidad INTEGER,
    precio_unitario REAL,
    producto_nombre TEXT,  -- ❌ Solo depende de producto_id
    categoria_nombre TEXT, -- ❌ Solo depende de producto_id
    PRIMARY KEY (pedido_id, producto_id)
);
```

**✅ Solución:**
```sql
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT,
    categoria_nombre TEXT
);

CREATE TABLE pedido_items (
    pedido_id INTEGER,
    producto_id INTEGER,
    cantidad INTEGER,
    precio_unitario REAL,
    PRIMARY KEY (pedido_id, producto_id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);
```

### 🔄 Tercera Forma Normal (3FN)

**Reglas**:
1. Debe estar en 2FN
2. No debe haber dependencias transitivas (A → B → C)

**❌ Problema:**
```sql
CREATE TABLE empleados_mal (
    id INTEGER PRIMARY KEY,
    nombre TEXT,
    departamento_codigo TEXT,
    departamento_nombre TEXT,  -- ❌ Depende de departamento_codigo
    departamento_jefe TEXT     -- ❌ Depende de departamento_codigo
);
```

**✅ Solución:**
```sql
CREATE TABLE departamentos (
    codigo TEXT PRIMARY KEY,
    nombre TEXT,
    jefe TEXT
);

CREATE TABLE empleados (
    id INTEGER PRIMARY KEY,
    nombre TEXT,
    departamento_codigo TEXT,
    FOREIGN KEY (departamento_codigo) REFERENCES departamentos(codigo)
);
```

## 🛠️ Proceso de Normalización: Ejemplo Práctico

### 📋 Escenario: Sistema de Biblioteca

**Datos sin normalizar:**

| libro_id | titulo | autor_nombre | autor_nacionalidad | genero | usuario_nombre | usuario_email | fecha_prestamo | fecha_devolucion |
|----------|--------|-------------|-------------------|---------|---------------|---------------|----------------|------------------|
| 1 | Cien años de soledad | Gabriel García Márquez | Colombiana | Novela | Ana García | ana@email.com | 2024-01-15 | 2024-01-29 |
| 2 | El Quijote | Miguel de Cervantes | Española | Novela | Ana García | ana@email.com | 2024-02-01 | 2024-02-15 |
| 1 | Cien años de soledad | Gabriel García Márquez | Colombiana | Novela | Carlos López | carlos@email.com | 2024-02-10 | NULL |

### 🔍 Problemas identificados:

1. **Redundancia**: Info del libro se repite
2. **Inconsistencia**: Si cambiamos el email de Ana, hay que actualizar varias filas
3. **Anomalías de inserción**: No podemos agregar un libro sin préstamo

### ✅ Diseño normalizado:

```sql
-- 1. Tabla de autores
CREATE TABLE autores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    nacionalidad TEXT
);

-- 2. Tabla de géneros
CREATE TABLE generos (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL
);

-- 3. Tabla de libros
CREATE TABLE libros (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    autor_id INTEGER NOT NULL,
    genero_id INTEGER NOT NULL,
    isbn TEXT UNIQUE,
    disponible BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (autor_id) REFERENCES autores(id),
    FOREIGN KEY (genero_id) REFERENCES generos(id)
);

-- 4. Tabla de usuarios
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    telefono TEXT,
    fecha_registro DATE DEFAULT CURRENT_DATE
);

-- 5. Tabla de préstamos
CREATE TABLE prestamos (
    id INTEGER PRIMARY KEY,
    libro_id INTEGER NOT NULL,
    usuario_id INTEGER NOT NULL,
    fecha_prestamo DATE DEFAULT CURRENT_DATE,
    fecha_devolucion_esperada DATE NOT NULL,
    fecha_devolucion_real DATE,
    estado TEXT DEFAULT 'activo' CHECK (estado IN ('activo', 'devuelto', 'vencido')),
    FOREIGN KEY (libro_id) REFERENCES libros(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);
```

## 📊 Ventajas de la Normalización

### ✅ Beneficios

1. **Reduce redundancia**
   ```sql
   -- Antes: 1000 préstamos = 1000 veces los datos del autor
   -- Después: 1000 préstamos + 1 registro del autor
   ```

2. **Facilita mantenimiento**
   ```sql
   -- Cambiar nacionalidad del autor:
   UPDATE autores SET nacionalidad = 'Argentina' WHERE id = 1;
   -- ¡Se actualiza automáticamente en todos los libros!
   ```

3. **Mejora integridad**
   ```sql
   -- No puedo crear un préstamo con un libro inexistente
   -- Foreign key lo impide automáticamente
   ```

### ⚠️ Desventajas (cuándo no normalizar tanto)

1. **Consultas más complejas**
   ```sql
   -- Para obtener préstamos con info completa:
   SELECT 
       l.titulo,
       a.nombre as autor,
       u.nombre as usuario,
       p.fecha_prestamo
   FROM prestamos p
   JOIN libros l ON p.libro_id = l.id
   JOIN autores a ON l.autor_id = a.id
   JOIN usuarios u ON p.usuario_id = u.id;
   ```

2. **Más tablas para gestionar**

3. **Posible impacto en performance** (se compensa con índices)

## 🎯 Ejercicio Práctico

### 📝 Normaliza esta tabla

```sql
-- Tabla sin normalizar
CREATE TABLE tienda_mal (
    venta_id INTEGER,
    fecha DATE,
    vendedor_nombre TEXT,
    vendedor_email TEXT,
    vendedor_comision REAL,
    cliente_nombre TEXT,
    cliente_ciudad TEXT,
    producto_nombre TEXT,
    categoria_producto TEXT,
    precio_producto REAL,
    cantidad INTEGER,
    subtotal REAL
);
```

### 🤔 Preguntas para reflexionar:

1. ¿Qué información se repite innecesariamente?
2. ¿Qué pasa si un vendedor cambia su email?
3. ¿Cómo separarias en diferentes tablas?
4. ¿Qué foreign keys necesitarías?

### ✅ Mi propuesta de solución:

```sql
-- Vendedores
CREATE TABLE vendedores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    comision_porcentaje REAL DEFAULT 5.0
);

-- Ciudades (para evitar inconsistencias como "Bs As", "Buenos Aires")
CREATE TABLE ciudades (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    provincia TEXT
);

-- Clientes
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    ciudad_id INTEGER,
    FOREIGN KEY (ciudad_id) REFERENCES ciudades(id)
);

-- Categorías
CREATE TABLE categorias (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL
);

-- Productos
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    categoria_id INTEGER,
    precio REAL NOT NULL,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- Ventas (cabecera)
CREATE TABLE ventas (
    id INTEGER PRIMARY KEY,
    fecha DATE DEFAULT CURRENT_DATE,
    vendedor_id INTEGER NOT NULL,
    cliente_id INTEGER NOT NULL,
    total REAL NOT NULL,
    FOREIGN KEY (vendedor_id) REFERENCES vendedores(id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Items de venta (detalle)
CREATE TABLE venta_items (
    venta_id INTEGER,
    producto_id INTEGER,
    cantidad INTEGER NOT NULL,
    precio_unitario REAL NOT NULL,
    subtotal REAL NOT NULL,
    PRIMARY KEY (venta_id, producto_id),
    FOREIGN KEY (venta_id) REFERENCES ventas(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);
```

## 📈 Optimización Post-Normalización

### 🔍 Índices estratégicos

```sql
-- Para consultas frecuentes
CREATE INDEX idx_prestamos_usuario ON prestamos(usuario_id);
CREATE INDEX idx_prestamos_libro ON prestamos(libro_id);
CREATE INDEX idx_prestamos_fecha ON prestamos(fecha_prestamo);
CREATE INDEX idx_libros_autor ON libros(autor_id);

-- Índice compuesto para consultas específicas
CREATE INDEX idx_prestamos_activos ON prestamos(estado, fecha_prestamo);
```

### 📊 Vistas para simplificar consultas

```sql
-- Vista que "desnormaliza" para consultas frecuentes
CREATE VIEW vista_prestamos_completa AS
SELECT 
    p.id,
    l.titulo,
    a.nombre as autor,
    g.nombre as genero,
    u.nombre as usuario,
    u.email,
    p.fecha_prestamo,
    p.fecha_devolucion_esperada,
    p.estado
FROM prestamos p
JOIN libros l ON p.libro_id = l.id
JOIN autores a ON l.autor_id = a.id
JOIN generos g ON l.genero_id = g.id
JOIN usuarios u ON p.usuario_id = u.id;

-- Ahora las consultas son más simples:
SELECT * FROM vista_prestamos_completa 
WHERE estado = 'activo' AND usuario = 'Ana García';
```

## 🎓 Consejos Finales

### ✅ Cuándo normalizar completamente:
- Sistemas transaccionales (muchas escrituras)
- Datos que cambian frecuentemente
- Múltiples usuarios modificando simultáneamente

### ⚡ Cuándo considerar desnormalización:
- Sistemas de reportes (principalmente lecturas)
- Data warehouses
- Aplicaciones con requisitos de performance extremos

### 🔑 Regla de oro:
**"Normaliza hasta la 3FN por defecto, luego desnormaliza solo si tienes problemas de performance comprobados"**

## 📝 Resumen

1. **1FN**: Un valor por celda
2. **2FN**: Dependencia total de la clave primaria
3. **3FN**: Sin dependencias transitivas
4. **Beneficios**: Menos redundancia, mejor integridad, fácil mantenimiento
5. **Costos**: Más JOINs, más complejidad
6. **Herramientas**: Índices y vistas para optimizar

En la próxima clase veremos cómo implementar estos diseños usando **Express.js** para crear APIs que trabajen con nuestras bases de datos normalizadas.

---

## 🚀 Próxima Clase: Express.js + SQL

Aprenderemos a:
- Conectar Express con bases de datos SQL
- Crear APIs RESTful con operaciones CRUD
- Implementar validaciones y manejo de errores
- Usar los diseños normalizados en aplicaciones reales