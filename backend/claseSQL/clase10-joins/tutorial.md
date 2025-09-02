# Clase 10: JOINS - Dominando las Relaciones entre Tablas

## 🎯 Objetivos de la Clase

Al finalizar esta clase, Rafa será capaz de:
- Entender los diferentes tipos de JOINs y cuándo usar cada uno
- Combinar datos de múltiples tablas eficientemente
- Escribir consultas complejas con varios JOINs
- Optimizar JOINs para mejor performance
- Resolver casos reales de análisis de datos

---

## 🔗 ¿Qué Son Los JOINs?

Los **JOINs** son la forma de **combinar datos de múltiples tablas** basándose en una relación entre ellas.

### ¿Por Qué Necesitás JOINs?
En bases de datos relacionales, la información se divide en múltiples tablas para evitar duplicación:

```sql
-- ❌ MAL: Todo en una tabla (duplicación)
pedidos_malo:
| id | cliente_nombre | cliente_email | producto_nombre | producto_precio |
|----|---------------|---------------|-----------------|------------------|
| 1  | Juan Pérez    | juan@email.com| iPhone 13       | 120000          |
| 2  | Juan Pérez    | juan@email.com| AirPods        | 25000           |
-- ¿Qué pasa si Juan cambia su email? Hay que actualizar múltiples filas

-- ✅ BIEN: Datos normalizados
clientes:                    productos:                   pedidos:
| id | nombre    | email |   | id | nombre  | precio |   | id | cliente_id | producto_id |
|----|-----------|-------|   |----|---------|--------|   |----|------------|-------------|
| 1  | Juan Pérez| juan@ |   | 1  | iPhone  | 120000 |   | 1  | 1          | 1           |
                             | 2  | AirPods | 25000  |   | 2  | 1          | 2           |
```

**Para obtener información completa, necesitás combinar las tablas con JOINs.**

---

## 🔄 Tipos de JOINs

### Analogía Visual: Conjuntos
Imaginate dos círculos que se superponen (Diagrama de Venn):

```
    Tabla A        Tabla B
      ●●●●●●●●●●●●●●●●●
     ●●●●●●●●●●●●●●●●●●●
    ●●●●●●    ●●●●●●●●●●●
   ●●●●●●●●  ●●●●●●●●●●●●
  ●●●●●●●●●●●●●●●●●●●●●●●●
   ●●●●●●●●  ●●●●●●●●●●●●
    ●●●●●●    ●●●●●●●●●●●
     ●●●●●●●●●●●●●●●●●●●
      ●●●●●●●●●●●●●●●●●

  A solo    Ambos    B solo
```

---

## 🎯 INNER JOIN: Solo Lo Que Coincide

### Concepto
**INNER JOIN** devuelve solo los registros que **tienen coincidencia en ambas tablas**.

### Sintaxis
```sql
SELECT columnas
FROM tabla_a
INNER JOIN tabla_b ON tabla_a.campo_id = tabla_b.id;
```

### Ejemplo Práctico: E-commerce
```sql
-- Ver pedidos CON información del cliente (solo pedidos que tienen cliente válido)
SELECT 
    p.id as pedido_id,
    c.nombre as cliente,
    c.email,
    p.total,
    p.fecha
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id;
```

**Resultado**: Solo pedidos que tienen un cliente asociado válido.

### Cuándo Usar INNER JOIN
- ✅ Cuando necesitás **solo registros completos**
- ✅ Para **análisis de datos válidos**
- ✅ Cuando la relación es **obligatoria**

**Ejemplo real**: Reporte de ventas (solo pedidos con clientes válidos).

---

## ⬅️ LEFT JOIN: Todo de la Izquierda

### Concepto
**LEFT JOIN** devuelve **todos los registros de la tabla izquierda**, y las coincidencias de la derecha (NULL si no hay coincidencia).

### Sintaxis
```sql
SELECT columnas
FROM tabla_izquierda
LEFT JOIN tabla_derecha ON tabla_izquierda.campo_id = tabla_derecha.id;
```

### Ejemplo Práctico: Clientes y Pedidos
```sql
-- Ver TODOS los clientes, tengan pedidos o no
SELECT 
    c.nombre as cliente,
    c.email,
    COUNT(p.id) as cantidad_pedidos,
    COALESCE(SUM(p.total), 0) as total_gastado
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, c.email;
```

**Resultado**: Todos los clientes, incluyendo los que nunca compraron (con 0 pedidos).

### Cuándo Usar LEFT JOIN
- ✅ Cuando necesitás **todos los registros de la tabla principal**
- ✅ Para **encontrar registros sin relación**
- ✅ En **reportes completos**

**Ejemplo real**: Lista de todos los empleados, incluyendo los que no tienen ventas asignadas.

---

## ➡️ RIGHT JOIN: Todo de la Derecha

### Concepto
**RIGHT JOIN** devuelve **todos los registros de la tabla derecha**, y las coincidencias de la izquierda (NULL si no hay coincidencia).

### Sintaxis
```sql
SELECT columnas
FROM tabla_izquierda
RIGHT JOIN tabla_derecha ON tabla_izquierda.campo_id = tabla_derecha.id;
```

### Ejemplo Práctico
```sql
-- Ver TODOS los productos, se hayan vendido o no
SELECT 
    pr.nombre as producto,
    pr.precio,
    COUNT(p.id) as veces_vendido
FROM pedidos p
RIGHT JOIN productos pr ON p.producto_id = pr.id
GROUP BY pr.id, pr.nombre, pr.precio;
```

### ⚠️ Nota Importante
**SQLite NO soporta RIGHT JOIN**, pero podés simular cambiando el orden:
```sql
-- En lugar de RIGHT JOIN, usar LEFT JOIN cambiando el orden
SELECT columnas
FROM tabla_derecha
LEFT JOIN tabla_izquierda ON tabla_derecha.id = tabla_izquierda.campo_id;
```

---

## 🔄 FULL OUTER JOIN: Todo de Ambas

### Concepto
Combina LEFT JOIN + RIGHT JOIN: **todos los registros de ambas tablas**.

### ⚠️ Limitación en SQLite
SQLite tampoco soporta FULL OUTER JOIN, pero podés simular con UNION:

```sql
-- Simular FULL OUTER JOIN
SELECT * FROM tabla_a LEFT JOIN tabla_b ON tabla_a.id = tabla_b.tabla_a_id
UNION
SELECT * FROM tabla_a RIGHT JOIN tabla_b ON tabla_a.id = tabla_b.tabla_a_id;
```

---

## 🚀 Ejemplos Prácticos Paso a Paso

### Setup: Base de Datos de E-commerce
```sql
-- Clientes
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    ciudad TEXT,
    fecha_registro DATE DEFAULT CURRENT_DATE
);

-- Productos
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    categoria TEXT,
    precio REAL NOT NULL,
    stock INTEGER DEFAULT 0
);

-- Pedidos
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    fecha DATE DEFAULT CURRENT_DATE,
    total REAL NOT NULL,
    estado TEXT DEFAULT 'pendiente',
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Detalles de pedidos (relación N:M)
CREATE TABLE pedido_items (
    id INTEGER PRIMARY KEY,
    pedido_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario REAL NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);
```

### Ejemplo 1: INNER JOIN Básico
```sql
-- Pedidos con información del cliente
SELECT 
    p.id as pedido_num,
    c.nombre as cliente,
    c.ciudad,
    p.fecha,
    p.total,
    p.estado
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
ORDER BY p.fecha DESC;
```

### Ejemplo 2: LEFT JOIN para Análisis Completo
```sql
-- Todos los clientes con su actividad de compra
SELECT 
    c.nombre,
    c.email,
    c.ciudad,
    COUNT(p.id) as total_pedidos,
    COALESCE(SUM(p.total), 0) as total_gastado,
    MAX(p.fecha) as ultima_compra,
    CASE 
        WHEN COUNT(p.id) = 0 THEN 'Sin compras'
        WHEN MAX(p.fecha) < DATE('now', '-30 days') THEN 'Inactivo'
        ELSE 'Activo'
    END as estado_cliente
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, c.email, c.ciudad
ORDER BY total_gastado DESC;
```

### Ejemplo 3: JOIN con Múltiples Tablas
```sql
-- Detalle completo de pedidos (4 tablas)
SELECT 
    p.id as pedido_num,
    c.nombre as cliente,
    c.email,
    pr.nombre as producto,
    pr.categoria,
    pi.cantidad,
    pi.precio_unitario,
    (pi.cantidad * pi.precio_unitario) as subtotal,
    p.fecha
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
INNER JOIN pedido_items pi ON p.id = pi.pedido_id
INNER JOIN productos pr ON pi.producto_id = pr.id
WHERE p.fecha >= '2024-01-01'
ORDER BY p.fecha DESC, p.id, pr.nombre;
```

---

## 📊 Casos de Uso Reales

### Caso 1: Dashboard de Ventas
```sql
-- KPIs principales del negocio
SELECT 
    COUNT(DISTINCT c.id) as clientes_activos,
    COUNT(DISTINCT p.id) as total_pedidos,
    SUM(p.total) as ingresos_totales,
    AVG(p.total) as ticket_promedio,
    COUNT(DISTINCT DATE(p.fecha)) as dias_con_ventas
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
WHERE p.fecha >= '2024-01-01' 
  AND p.estado = 'completado';
```

### Caso 2: Análisis de Inventario
```sql
-- Productos más y menos vendidos
SELECT 
    pr.nombre,
    pr.categoria,
    pr.precio,
    pr.stock,
    COALESCE(SUM(pi.cantidad), 0) as unidades_vendidas,
    COALESCE(SUM(pi.cantidad * pi.precio_unitario), 0) as ingresos_producto,
    CASE 
        WHEN SUM(pi.cantidad) IS NULL THEN 'Sin ventas'
        WHEN SUM(pi.cantidad) > 50 THEN 'Top seller'
        WHEN SUM(pi.cantidad) > 20 THEN 'Buen rendimiento'
        ELSE 'Bajo rendimiento'
    END as clasificacion
FROM productos pr
LEFT JOIN pedido_items pi ON pr.id = pi.producto_id
LEFT JOIN pedidos p ON pi.pedido_id = p.id AND p.estado = 'completado'
GROUP BY pr.id, pr.nombre, pr.categoria, pr.precio, pr.stock
ORDER BY unidades_vendidas DESC;
```

### Caso 3: Segmentación de Clientes
```sql
-- Clientes por valor y frecuencia (análisis RFM básico)
SELECT 
    c.nombre,
    c.ciudad,
    COUNT(p.id) as frecuencia_compra,
    SUM(p.total) as valor_total,
    MAX(p.fecha) as ultima_compra,
    ROUND(julianday('now') - julianday(MAX(p.fecha))) as dias_sin_comprar,
    CASE 
        WHEN SUM(p.total) > 50000 AND COUNT(p.id) > 5 THEN 'VIP'
        WHEN SUM(p.total) > 20000 THEN 'Premium'  
        WHEN COUNT(p.id) > 3 THEN 'Regular'
        ELSE 'Nuevo'
    END as segmento
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, c.ciudad
ORDER BY valor_total DESC;
```

---

## ⚡ Optimización de JOINs

### 1. Índices en Claves Foráneas
```sql
-- SIEMPRE crear índices en campos de JOIN
CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX idx_pedido_items_pedido ON pedido_items(pedido_id);
CREATE INDEX idx_pedido_items_producto ON pedido_items(producto_id);
```

### 2. Filtrar Antes de JOIN
```sql
-- ❌ LENTO: JOIN primero, filtrar después
SELECT c.nombre, p.total
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
WHERE p.fecha > '2024-01-01';

-- ✅ RÁPIDO: Filtrar antes del JOIN
SELECT c.nombre, p.total
FROM clientes c
INNER JOIN (
    SELECT cliente_id, total 
    FROM pedidos 
    WHERE fecha > '2024-01-01'
) p ON c.id = p.cliente_id;
```

### 3. Usar Alias Claros
```sql
-- ✅ Fácil de leer y mantener
SELECT 
    cli.nombre as cliente,
    ped.fecha,
    prod.nombre as producto
FROM clientes cli
INNER JOIN pedidos ped ON cli.id = ped.cliente_id
INNER JOIN pedido_items pi ON ped.id = pi.pedido_id
INNER JOIN productos prod ON pi.producto_id = prod.id;
```

---

## 🔧 Patrones Comunes de JOINs

### Patrón 1: Maestro-Detalle
```sql
-- Pedidos con sus items
SELECT 
    p.id,
    p.fecha,
    COUNT(pi.id) as cantidad_items,
    SUM(pi.cantidad * pi.precio_unitario) as total_calculado
FROM pedidos p
LEFT JOIN pedido_items pi ON p.id = pi.pedido_id
GROUP BY p.id, p.fecha;
```

### Patrón 2: Buscar Registros Sin Relación
```sql
-- Productos que nunca se vendieron
SELECT pr.nombre, pr.precio, pr.stock
FROM productos pr
LEFT JOIN pedido_items pi ON pr.id = pi.producto_id
WHERE pi.producto_id IS NULL;

-- Clientes sin pedidos
SELECT c.nombre, c.email, c.fecha_registro
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE p.cliente_id IS NULL;
```

### Patrón 3: Aggregación con Múltiples Tablas
```sql
-- Resumen por categoría
SELECT 
    pr.categoria,
    COUNT(DISTINCT pr.id) as productos_en_categoria,
    COUNT(DISTINCT pi.pedido_id) as pedidos_con_categoria,
    SUM(pi.cantidad) as unidades_vendidas,
    SUM(pi.cantidad * pi.precio_unitario) as ingresos_categoria
FROM productos pr
LEFT JOIN pedido_items pi ON pr.id = pi.producto_id  
LEFT JOIN pedidos p ON pi.pedido_id = p.id AND p.estado = 'completado'
GROUP BY pr.categoria
ORDER BY ingresos_categoria DESC;
```

---

## 🧪 Ejercicios de Auto-Evaluación

### Ejercicio Mental 1
**Problema**: Necesitás un reporte de todos los productos, incluyendo cuáles nunca se vendieron.
**¿Qué JOIN usarías?**
<details>
<summary>Respuesta</summary>
LEFT JOIN de productos a pedido_items, porque querés todos los productos (izquierda) y puede que algunos no tengan ventas (NULL en derecha).
</details>

### Ejercicio Mental 2
**Problema**: Querés solo los clientes que hicieron al menos un pedido.
**¿Qué JOIN usarías?**
<details>
<summary>Respuesta</summary>
INNER JOIN, porque solo necesitás clientes que tienen pedidos (relación existe en ambas tablas).
</details>

### Ejercicio Mental 3
**Problema**: Dashboard que muestre el rendimiento de cada vendedor, incluyendo vendedores sin ventas.
**¿Qué JOIN usarías?**
<details>
<summary>Respuesta</summary>
LEFT JOIN de vendedores a ventas, para incluir todos los vendedores incluso sin ventas.
</details>

---

## 🏠 Proyecto Para Casa: Análisis de Biblioteca

Usando tu proyecto de biblioteca personal, implementar estas consultas con JOINs:

### Consultas Requeridas:

1. **Libros con Autores** (INNER JOIN)
```sql
-- Todos los libros con información completa del autor
-- Incluir: título, año, autor completo, nacionalidad, género
```

2. **Autores Productivos** (LEFT JOIN)  
```sql
-- Todos los autores y cuántos libros tienen en tu biblioteca
-- Incluir autores sin libros en tu colección
```

3. **Análisis de Géneros** (LEFT JOIN + GROUP BY)
```sql
-- Por cada género: cantidad de libros, promedio de calificación, precio total invertido
```

4. **Libros Sin Leer por Género** (INNER JOIN + WHERE)
```sql  
-- Libros pendientes de leer agrupados por género
```

5. **Dashboard Personal** (Múltiples JOINs)
```sql
-- Reporte completo: autor, libro, género, estado de lectura, calificación
-- Solo libros activos, ordenados por fecha de adquisición
```

### Bonus Challenge:
Crear una consulta que identifique:
- Autores con mejor promedio de calificación
- Géneros más caros vs más baratos  
- Libros que deberías leer próximamente (basado en tus gustos)

---

## 🎯 Próxima Clase: Normalización

En la **Clase 11** vamos a aprender:
- Formas normales (1NF, 2NF, 3NF)
- Cómo diseñar esquemas eficientes
- Cuándo normalizar vs desnormalizar
- Optimización de estructura de datos

**¡Excelente! Ya podés combinar datos de múltiples tablas como un pro. Los JOINs son una de las habilidades más poderosas en SQL.**