# ⚡ ÍNDICES Y OPTIMIZACIÓN DE PERFORMANCE - CLASE 14

> **Objetivo**: Dominar la optimización de bases de datos SQL mediante índices estratégicos, análisis de planes de ejecución y técnicas avanzadas de performance.

## 🎯 ¿Por qué es importante la performance?

Imaginate que tenés una biblioteca con 1 millón de libros y alguien te pide "Dame todos los libros de García Márquez". 

**Sin índice**: Revisás libro por libro = ⏰ **5 horas**  
**Con índice**: Consultás el catálogo por autor = ⚡ **30 segundos**

## 📚 ¿Qué son los Índices?

Un **índice** es una estructura de datos que **mejora la velocidad** de las consultas a costa de:
- 📈 **Espacio adicional** (10-15% más)  
- 🐌 **Escrituras más lentas** (INSERT, UPDATE, DELETE)
- 🔧 **Mantenimiento** automático

### 🔍 Conceptos clave

```sql
-- Tabla SIN índice: Buscar Pedro = revisar TODA la tabla
SELECT * FROM usuarios WHERE nombre = 'Pedro';  -- 😰 Scan completo

-- Tabla CON índice: Buscar Pedro = ir directo al registro
CREATE INDEX idx_usuarios_nombre ON usuarios(nombre);
SELECT * FROM usuarios WHERE nombre = 'Pedro';  -- ⚡ Búsqueda directa
```

## 🗂️ Tipos de Índices

### 1. 🔑 Índice de Clave Primaria (Automático)

```sql
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,  -- ✅ Índice automático
    nombre TEXT,
    email TEXT
);

-- SQLite automáticamente crea un índice para Primary Key
-- No necesitas hacer nada adicional
```

### 2. 🔍 Índice Simple (Una columna)

```sql
-- Crear índice para búsquedas frecuentes por email
CREATE INDEX idx_usuarios_email ON usuarios(email);

-- Ahora estas consultas son súper rápidas:
SELECT * FROM usuarios WHERE email = 'juan@email.com';  -- ⚡ Rápido
SELECT COUNT(*) FROM usuarios WHERE email LIKE '%gmail.com';  -- ⚡ Rápido
```

### 3. 🎯 Índice Compuesto (Múltiples columnas)

```sql
-- Índice compuesto: perfecto para consultas que filtran por ambos campos
CREATE INDEX idx_pedidos_cliente_fecha ON pedidos(cliente_id, fecha_pedido);

-- Estas consultas usan el índice eficientemente:
SELECT * FROM pedidos WHERE cliente_id = 5;  -- ✅ Usa el índice
SELECT * FROM pedidos WHERE cliente_id = 5 AND fecha_pedido = '2024-01-15';  -- ✅ Ideal
SELECT * FROM pedidos WHERE cliente_id = 5 AND fecha_pedido > '2024-01-01';  -- ✅ Perfecto

-- Esta consulta NO puede usar el índice eficientemente:
SELECT * FROM pedidos WHERE fecha_pedido = '2024-01-15';  -- ⚠️ Menos eficiente
```

### 4. 🎨 Índice Parcial (Con condiciones)

```sql
-- Índice solo para pedidos activos (los que más consultamos)
CREATE INDEX idx_pedidos_activos ON pedidos(fecha_pedido) 
WHERE estado IN ('pendiente', 'procesando');

-- Índice para productos en stock (evita indexar productos agotados)
CREATE INDEX idx_productos_disponibles ON productos(categoria_id, precio) 
WHERE stock > 0 AND activo = TRUE;
```

### 5. 📊 Índice de Expresión

```sql
-- Índice para búsquedas case-insensitive
CREATE INDEX idx_usuarios_nombre_lower ON usuarios(LOWER(nombre));

-- Ahora estas consultas son rápidas:
SELECT * FROM usuarios WHERE LOWER(nombre) = 'pedro';  -- ⚡ Usa índice
SELECT * FROM usuarios WHERE LOWER(nombre) LIKE 'ped%';  -- ⚡ Usa índice

-- Índice para cálculos comunes
CREATE INDEX idx_productos_margen ON productos((precio_venta - precio_costo));
SELECT * FROM productos WHERE (precio_venta - precio_costo) > 10000;  -- ⚡ Rápido
```

## 📈 EXPLAIN QUERY PLAN: Tu Mejor Herramienta

**EXPLAIN QUERY PLAN** te muestra cómo SQLite ejecutará tu consulta.

### 🔍 Análisis básico

```sql
-- Consulta sin índice
EXPLAIN QUERY PLAN
SELECT * FROM productos WHERE categoria_id = 1;

-- Resultado típico SIN índice:
-- SCAN productos  (~100,000 filas analizadas)

-- Después de crear índice:
CREATE INDEX idx_productos_categoria ON productos(categoria_id);

EXPLAIN QUERY PLAN
SELECT * FROM productos WHERE categoria_id = 1;

-- Resultado CON índice:
-- SEARCH productos USING INDEX idx_productos_categoria (categoria_id=?)  (~50 filas)
```

### 📊 Interpretando los resultados

```sql
-- Ejemplos de diferentes planes de ejecución:

-- ✅ EXCELENTE: Búsqueda por índice
EXPLAIN QUERY PLAN
SELECT * FROM usuarios WHERE id = 123;
-- RESULTADO: "SEARCH usuarios USING INTEGER PRIMARY KEY (rowid=?)"

-- ⚡ BUENO: Índice con pocas filas
EXPLAIN QUERY PLAN  
SELECT * FROM productos WHERE categoria_id = 1;
-- RESULTADO: "SEARCH productos USING INDEX idx_categoria (categoria_id=?)"

-- ⚠️ CUIDADO: Scan parcial
EXPLAIN QUERY PLAN
SELECT * FROM pedidos WHERE total > 50000;
-- RESULTADO: "SCAN pedidos"  -- Analiza toda la tabla

-- ❌ MALO: Scan completo de tabla grande
EXPLAIN QUERY PLAN
SELECT * FROM productos WHERE descripcion LIKE '%laptop%';
-- RESULTADO: "SCAN productos"  -- ¡Sin índice para texto!
```

## 🎯 Estrategias de Indexación

### 1. 🔍 Índices para Consultas Frecuentes

```sql
-- Analizar las consultas más comunes de tu aplicación:

-- ✅ Login de usuarios (muy frecuente)
CREATE INDEX idx_usuarios_email ON usuarios(email);
SELECT * FROM usuarios WHERE email = ?;  -- ⚡ Rápido

-- ✅ Búsqueda de pedidos por cliente (frecuente)
CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
SELECT * FROM pedidos WHERE cliente_id = ?;  -- ⚡ Rápido

-- ✅ Productos por categoría (muy frecuente en e-commerce)
CREATE INDEX idx_productos_categoria_precio ON productos(categoria_id, precio);
SELECT * FROM productos WHERE categoria_id = ? ORDER BY precio;  -- ⚡ Perfecto
```

### 2. 📊 Índices para ORDER BY

```sql
-- Sin índice: SQLite debe ordenar todos los resultados en memoria
SELECT * FROM pedidos ORDER BY fecha_pedido DESC LIMIT 10;  -- 😰 Lento

-- Con índice: Los datos ya están ordenados
CREATE INDEX idx_pedidos_fecha_desc ON pedidos(fecha_pedido DESC);
SELECT * FROM pedidos ORDER BY fecha_pedido DESC LIMIT 10;  -- ⚡ Súper rápido

-- Índice compuesto para ORDER BY complejo
CREATE INDEX idx_productos_categoria_precio_nombre ON productos(categoria_id, precio DESC, nombre);
SELECT * FROM productos WHERE categoria_id = 1 ORDER BY precio DESC, nombre;  -- ⚡ Perfecto
```

### 3. 🔗 Índices para JOINs

```sql
-- Los JOINs son MÁS rápidos con índices en ambas tablas
CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);        -- Tabla pedidos
CREATE INDEX idx_clientes_id ON clientes(id);                   -- Ya existe (PK)
CREATE INDEX idx_pedido_items_pedido ON pedido_items(pedido_id); -- Tabla items

-- Ahora este JOIN es súper eficiente:
SELECT 
    c.nombre,
    p.fecha_pedido,
    SUM(pi.cantidad * pi.precio_unitario) as total
FROM clientes c
JOIN pedidos p ON c.id = p.cliente_id          -- ⚡ Usa índices
JOIN pedido_items pi ON p.id = pi.pedido_id    -- ⚡ Usa índices  
WHERE p.fecha_pedido >= '2024-01-01'
GROUP BY c.id, c.nombre, p.id;
```

### 4. 📈 Índices para Agregaciones

```sql
-- GROUP BY es más rápido con índices
CREATE INDEX idx_pedidos_cliente_fecha ON pedidos(cliente_id, fecha_pedido);

-- Esta consulta usa el índice eficientemente:
SELECT 
    cliente_id,
    COUNT(*) as total_pedidos,
    SUM(total) as total_gastado
FROM pedidos
GROUP BY cliente_id;  -- ⚡ Rápido con índice

-- HAVING también se beneficia:
SELECT cliente_id, COUNT(*) as pedidos
FROM pedidos
GROUP BY cliente_id
HAVING COUNT(*) > 5;  -- ⚡ Eficiente
```

## ⚠️ Problemas Comunes de Performance

### 1. 🐌 Consultas que NO usan índices

```sql
-- ❌ Funciones en WHERE impiden uso de índices
CREATE INDEX idx_usuarios_nombre ON usuarios(nombre);  -- ✅ Índice existe
SELECT * FROM usuarios WHERE UPPER(nombre) = 'PEDRO';  -- ❌ No usa el índice

-- ✅ Solución: Índice de expresión
CREATE INDEX idx_usuarios_nombre_upper ON usuarios(UPPER(nombre));
SELECT * FROM usuarios WHERE UPPER(nombre) = 'PEDRO';  -- ⚡ Ahora sí!

-- ❌ LIKE con wildcard al inicio
SELECT * FROM productos WHERE nombre LIKE '%laptop%';  -- ❌ Scan completo

-- ✅ LIKE sin wildcard al inicio SÍ usa índice
SELECT * FROM productos WHERE nombre LIKE 'laptop%';  -- ⚡ Usa índice
```

### 2. 🔍 Selectividad de Índices

```sql
-- ❌ Índice en columna con pocos valores únicos (baja selectividad)
CREATE INDEX idx_usuarios_activo ON usuarios(activo);  -- Solo TRUE/FALSE
SELECT * FROM usuarios WHERE activo = TRUE;  -- ⚠️ Puede no ser eficiente

-- ✅ Índice en columna con muchos valores únicos (alta selectividad)  
CREATE INDEX idx_usuarios_email ON usuarios(email);  -- Emails únicos
SELECT * FROM usuarios WHERE email = 'juan@email.com';  -- ⚡ Muy eficiente

-- 📊 Cómo verificar selectividad:
SELECT 
    COUNT(*) as total_registros,
    COUNT(DISTINCT activo) as valores_unicos_activo,
    COUNT(DISTINCT email) as valores_unicos_email,
    ROUND(COUNT(DISTINCT email) * 100.0 / COUNT(*), 2) as selectividad_email
FROM usuarios;
```

### 3. 🔄 Orden de Columnas en Índices Compuestos

```sql
-- ❌ Orden incorrecto
CREATE INDEX idx_pedidos_fecha_cliente ON pedidos(fecha_pedido, cliente_id);

-- Esta consulta usa el índice parcialmente:
SELECT * FROM pedidos WHERE cliente_id = 5;  -- ⚠️ No puede usar índice eficientemente

-- ✅ Orden correcto (columna más selectiva primero)
CREATE INDEX idx_pedidos_cliente_fecha ON pedidos(cliente_id, fecha_pedido);

-- Ahora ambas consultas son eficientes:
SELECT * FROM pedidos WHERE cliente_id = 5;  -- ⚡ Perfecto
SELECT * FROM pedidos WHERE cliente_id = 5 AND fecha_pedido > '2024-01-01';  -- ⚡ Ideal
```

## 🛠️ Herramientas de Optimización

### 📊 Análisis de Performance

```sql
-- 1. Identificar consultas lentas con EXPLAIN QUERY PLAN
EXPLAIN QUERY PLAN
SELECT p.*, c.nombre as cliente_nombre
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.id
WHERE p.fecha_pedido > '2024-01-01'
ORDER BY p.total DESC;

-- 2. Análizar estadísticas de tabla
SELECT 
    name as tabla,
    sql as definicion
FROM sqlite_master 
WHERE type = 'index' AND tbl_name = 'pedidos';

-- 3. Verificar tamaño de índices
.schema pedidos  -- En SQLite CLI muestra todos los índices
```

### 🔧 Optimización de Consultas Específicas

```sql
-- ❌ Consulta lenta original
SELECT 
    p.*,
    c.nombre,
    COUNT(pi.id) as items
FROM pedidos p
LEFT JOIN clientes c ON p.cliente_id = c.id
LEFT JOIN pedido_items pi ON p.id = pi.pedido_id
WHERE p.fecha_pedido BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY p.id
ORDER BY p.total DESC;

-- ✅ Índices necesarios para optimizar:
CREATE INDEX idx_pedidos_fecha_total ON pedidos(fecha_pedido, total DESC);
CREATE INDEX idx_pedido_items_pedido ON pedido_items(pedido_id);

-- ✅ Consulta optimizada (mismo resultado, mucho más rápida)
WITH pedidos_2024 AS (
    SELECT p.*, c.nombre as cliente_nombre
    FROM pedidos p
    JOIN clientes c ON p.cliente_id = c.id
    WHERE p.fecha_pedido BETWEEN '2024-01-01' AND '2024-12-31'
),
items_por_pedido AS (
    SELECT 
        pedido_id,
        COUNT(*) as items
    FROM pedido_items
    WHERE pedido_id IN (SELECT id FROM pedidos_2024)
    GROUP BY pedido_id
)
SELECT 
    p.*,
    COALESCE(i.items, 0) as items
FROM pedidos_2024 p
LEFT JOIN items_por_pedido i ON p.id = i.pedido_id
ORDER BY p.total DESC;
```

## 📋 Estrategia Completa de Indexación

### 🎯 Metodología paso a paso

```sql
-- 1. IDENTIFICAR consultas críticas (las más frecuentes)
-- Ejemplo: Sistema de e-commerce

-- 2. CREAR índices para consultas de autenticación
CREATE INDEX idx_usuarios_email ON usuarios(email);                    -- Login
CREATE INDEX idx_usuarios_activo ON usuarios(activo) WHERE activo = TRUE; -- Solo activos

-- 3. CREAR índices para búsqueda de productos  
CREATE INDEX idx_productos_categoria_precio ON productos(categoria_id, precio);
CREATE INDEX idx_productos_nombre ON productos(nombre);                 -- Búsqueda por nombre
CREATE INDEX idx_productos_activo_stock ON productos(activo, stock) WHERE activo = TRUE; -- Solo disponibles

-- 4. CREAR índices para sistema de pedidos
CREATE INDEX idx_pedidos_cliente_fecha ON pedidos(cliente_id, fecha_pedido DESC);
CREATE INDEX idx_pedidos_estado_fecha ON pedidos(estado, fecha_pedido) WHERE estado != 'cancelado';
CREATE INDEX idx_pedido_items_pedido ON pedido_items(pedido_id);
CREATE INDEX idx_pedido_items_producto ON pedido_items(producto_id);

-- 5. CREAR índices para reportes y analytics
CREATE INDEX idx_pedidos_fecha_total ON pedidos(fecha_pedido, total) WHERE estado = 'completado';
CREATE INDEX idx_productos_categoria_ventas ON productos(categoria_id, stock);

-- 6. VERIFICAR con EXPLAIN QUERY PLAN
EXPLAIN QUERY PLAN
SELECT p.*, c.nombre
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.id
WHERE p.estado = 'completado' 
  AND p.fecha_pedido > '2024-01-01'
ORDER BY p.total DESC
LIMIT 10;
```

### 🧪 Testing y Monitoreo

```sql
-- Crear datos de prueba para testing
INSERT INTO productos (nombre, categoria_id, precio_venta, precio_costo, stock)
WITH RECURSIVE numeros(x) AS (
    SELECT 1
    UNION ALL
    SELECT x + 1 FROM numeros WHERE x < 10000
)
SELECT 
    'Producto ' || x,
    (x % 5) + 1,  -- Categorías 1-5
    RANDOM() % 50000 + 1000,  -- Precio entre 1000-51000
    (RANDOM() % 50000 + 1000) * 0.7,  -- Costo 70% del precio
    RANDOM() % 100  -- Stock 0-100
FROM numeros;

-- Comparar performance antes/después de índices
.timer ON  -- En SQLite CLI
SELECT COUNT(*) FROM productos WHERE categoria_id = 3 AND precio_venta > 20000;
```

## 🚨 Mantenimiento de Índices

### 🔄 Índices que se actualizan automáticamente

```sql
-- SQLite mantiene índices automáticamente, pero puedes optimizar:

-- Recopilar estadísticas para mejor optimización
ANALYZE;  -- Actualiza estadísticas de todas las tablas

-- Reorganizar después de muchas modificaciones
VACUUM;   -- Compacta la base de datos

-- Verificar integridad
PRAGMA integrity_check;
```

### 📊 Monitoreo de uso de índices

```sql
-- Ver todos los índices de una tabla
SELECT name, sql 
FROM sqlite_master 
WHERE type = 'index' AND tbl_name = 'productos';

-- Estadísticas de índices (requiere ANALYZE previo)
SELECT * FROM sqlite_stat1 WHERE tbl = 'productos';
```

## 🎯 Casos de Uso Avanzados

### 📈 Dashboard en Tiempo Real

```sql
-- Índices optimizados para dashboard de administración
CREATE INDEX idx_pedidos_dashboard ON pedidos(fecha_pedido, estado, total) 
    WHERE fecha_pedido >= date('now', '-30 days');

CREATE INDEX idx_productos_dashboard ON productos(categoria_id, stock, activo) 
    WHERE activo = TRUE;

-- Consulta super optimizada para métricas del día
WITH metricas_hoy AS (
    SELECT 
        COUNT(*) as pedidos_hoy,
        SUM(total) as ingresos_hoy,
        AVG(total) as ticket_promedio
    FROM pedidos 
    WHERE fecha_pedido = date('now') 
      AND estado IN ('completado', 'enviado')
),
productos_bajo_stock AS (
    SELECT COUNT(*) as productos_bajo_stock
    FROM productos 
    WHERE activo = TRUE AND stock <= stock_minimo
)
SELECT 
    m.pedidos_hoy,
    '$' || ROUND(m.ingresos_hoy, 2) as ingresos_hoy,
    '$' || ROUND(m.ticket_promedio, 2) as ticket_promedio,
    p.productos_bajo_stock
FROM metricas_hoy m, productos_bajo_stock p;
```

## 📝 Mejores Prácticas

### ✅ DO (Hacer)

1. **Crear índices basado en consultas reales** - No adivines, mide
2. **Usar EXPLAIN QUERY PLAN** - Siempre verifica que se usen
3. **Índices compuestos con orden correcto** - Más selectivo primero
4. **Índices parciales para grandes tablas** - Solo lo que necesitas
5. **ANALYZE regularmente** - Estadísticas actualizadas

### ❌ DON'T (No hacer)

1. **Crear índices "por si acaso"** - Cada índice cuesta espacio y tiempo
2. **Índices en todas las columnas** - Overkill y contraproducente
3. **Ignorar el plan de ejecución** - Si no lo verificas, puede que no funcione
4. **Índices en columnas con pocos valores únicos** - Baja efectividad
5. **Olvidar el mantenimiento** - VACUUM y ANALYZE periódicamente

## 🎓 Ejercicio Final: Optimización Completa

```sql
-- Tienes esta consulta lenta. Optimizala:

SELECT 
    c.nombre as cliente,
    COUNT(p.id) as total_pedidos,
    SUM(p.total) as total_gastado,
    AVG(p.total) as ticket_promedio,
    MAX(p.fecha_pedido) as ultima_compra,
    STRING_AGG(pr.nombre, ', ') as productos_comprados
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
LEFT JOIN pedido_items pi ON p.id = pi.pedido_id  
LEFT JOIN productos pr ON pi.producto_id = pr.id
WHERE c.activo = TRUE
  AND p.estado = 'completado'
  AND p.fecha_pedido >= '2023-01-01'
GROUP BY c.id, c.nombre
HAVING COUNT(p.id) >= 2
ORDER BY total_gastado DESC
LIMIT 50;

-- Tu tarea:
-- 1. Analizar con EXPLAIN QUERY PLAN
-- 2. Crear los índices necesarios  
-- 3. Reescribir si es necesario con CTEs
-- 4. Verificar la mejora de performance
```

## 🚀 Próxima Etapa: Express.js Integration

Con SQL optimizado, ya podés:
- **Crear APIs rápidas** que escalen a miles de usuarios
- **Implementar búsquedas instantáneas** en tu frontend
- **Generar reportes complejos** sin impactar performance
- **Monitorear y ajustar** consultas en producción

---

## 📋 Resumen

1. **Índices**: Aceleran consultas a costa de espacio y escrituras
2. **EXPLAIN QUERY PLAN**: Tu herramienta de diagnóstico principal  
3. **Tipos**: Simple, compuesto, parcial, de expresión
4. **Estrategia**: Analiza consultas reales antes de crear índices
5. **Monitoreo**: ANALYZE y VACUUM para mantener performance

**¡Ahora podés crear bases de datos que escalen profesionalmente! ⚡**