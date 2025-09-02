# 🔍 SUBCONSULTAS Y CTEs - CLASE 12

> **Objetivo**: Dominar subconsultas, Common Table Expressions (CTEs) y window functions para crear consultas SQL avanzadas y resolver problemas complejos de análisis de datos.

## 📖 ¿Qué son las Subconsultas?

Una **subconsulta** (o subquery) es una consulta SQL dentro de otra consulta. Es como usar una función dentro de otra función en programación.

### 🤔 ¿Cuándo usarlas?

```sql
-- ❌ Problema: Quiero los libros más caros que el promedio
-- No puedo hacer esto directamente:
SELECT * FROM productos WHERE precio > AVG(precio); -- ERROR!

-- ✅ Solución con subconsulta:
SELECT * FROM productos 
WHERE precio > (SELECT AVG(precio) FROM productos);
```

## 🎯 Tipos de Subconsultas

### 1. 📊 Subconsultas Escalares (Retornan un solo valor)

```sql
-- Libros más caros que el precio promedio
SELECT 
    titulo,
    precio,
    (SELECT AVG(precio) FROM productos) as precio_promedio,
    precio - (SELECT AVG(precio) FROM productos) as diferencia_promedio
FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos)
ORDER BY precio DESC;
```

### 2. 📋 Subconsultas de Lista (Retornan múltiples valores)

```sql
-- Clientes que han hecho pedidos en enero 2024
SELECT nombre, email
FROM clientes
WHERE id IN (
    SELECT DISTINCT cliente_id 
    FROM pedidos 
    WHERE fecha_pedido BETWEEN '2024-01-01' AND '2024-01-31'
);

-- Productos que NUNCA se han vendido
SELECT nombre, precio
FROM productos
WHERE id NOT IN (
    SELECT DISTINCT producto_id 
    FROM pedido_items 
    WHERE producto_id IS NOT NULL
);
```

### 3. 🗂️ Subconsultas de Tabla (Retornan tablas completas)

```sql
-- Análisis de ventas por mes usando subconsulta como tabla
SELECT 
    mes,
    total_ventas,
    total_pedidos,
    ticket_promedio
FROM (
    SELECT 
        strftime('%Y-%m', fecha_pedido) as mes,
        SUM(total) as total_ventas,
        COUNT(*) as total_pedidos,
        ROUND(AVG(total), 2) as ticket_promedio
    FROM pedidos
    WHERE estado = 'completado'
    GROUP BY strftime('%Y-%m', fecha_pedido)
) as ventas_mensuales
ORDER BY mes;
```

### 4. 🔗 Subconsultas Correlacionadas

```sql
-- Productos con el precio más alto de su categoría
SELECT p1.nombre, p1.precio, c.nombre as categoria
FROM productos p1
JOIN categorias c ON p1.categoria_id = c.id
WHERE p1.precio = (
    SELECT MAX(p2.precio)
    FROM productos p2
    WHERE p2.categoria_id = p1.categoria_id
);

-- Clientes con sus pedidos más recientes
SELECT 
    c.nombre,
    c.email,
    p.fecha_pedido,
    p.total
FROM clientes c
JOIN pedidos p ON c.id = p.cliente_id
WHERE p.fecha_pedido = (
    SELECT MAX(p2.fecha_pedido)
    FROM pedidos p2
    WHERE p2.cliente_id = c.id
);
```

## 🏗️ Common Table Expressions (CTEs)

Los **CTEs** son como "variables temporales" que almacenan el resultado de una consulta para usarlo en la consulta principal.

### 📝 Sintaxis básica

```sql
WITH nombre_cte AS (
    -- Consulta que define el CTE
    SELECT columnas...
    FROM tabla
    WHERE condiciones
)
-- Consulta principal que usa el CTE
SELECT * 
FROM nombre_cte
WHERE más_condiciones;
```

### ✅ Ventajas de CTEs vs Subconsultas

```sql
-- ❌ Con subconsultas (repetitivo y difícil de leer)
SELECT 
    cliente_id,
    total_compras,
    promedio_global,
    total_compras - promedio_global as diferencia_promedio
FROM (
    SELECT 
        cliente_id,
        SUM(total) as total_compras
    FROM pedidos
    GROUP BY cliente_id
) AS compras_cliente
CROSS JOIN (
    SELECT AVG(cliente_total) as promedio_global
    FROM (
        SELECT SUM(total) as cliente_total
        FROM pedidos
        GROUP BY cliente_id
    ) AS totales_por_cliente
) AS promedio;

-- ✅ Con CTEs (más claro y reutilizable)
WITH compras_por_cliente AS (
    SELECT 
        cliente_id,
        SUM(total) as total_compras,
        COUNT(*) as cantidad_pedidos
    FROM pedidos
    GROUP BY cliente_id
),
promedio_general AS (
    SELECT AVG(total_compras) as promedio_global
    FROM compras_por_cliente
)
SELECT 
    c.cliente_id,
    cl.nombre as cliente_nombre,
    c.total_compras,
    c.cantidad_pedidos,
    p.promedio_global,
    c.total_compras - p.promedio_global as diferencia_promedio,
    CASE 
        WHEN c.total_compras > p.promedio_global THEN 'Arriba del promedio'
        ELSE 'Abajo del promedio'
    END as categoria_cliente
FROM compras_por_cliente c
CROSS JOIN promedio_general p
JOIN clientes cl ON c.cliente_id = cl.id
ORDER BY c.total_compras DESC;
```

## 🔄 CTEs Recursivos

Los CTEs recursivos permiten consultas que se llaman a sí mismas (útil para jerarquías, árboles, series).

### 📊 Ejemplo: Generar serie de fechas

```sql
-- Generar todos los días de enero 2024
WITH RECURSIVE fechas_enero AS (
    -- Caso base: primer día
    SELECT DATE('2024-01-01') as fecha
    
    UNION ALL
    
    -- Caso recursivo: agregar un día
    SELECT DATE(fecha, '+1 day')
    FROM fechas_enero
    WHERE fecha < '2024-01-31'
)
SELECT 
    f.fecha,
    strftime('%W', f.fecha) as dia_semana,
    COALESCE(COUNT(p.id), 0) as pedidos_dia,
    COALESCE(SUM(p.total), 0) as ingresos_dia
FROM fechas_enero f
LEFT JOIN pedidos p ON DATE(p.fecha_pedido) = f.fecha
GROUP BY f.fecha
ORDER BY f.fecha;
```

### 🌳 Ejemplo: Estructura organizacional

```sql
-- Crear tabla de empleados con jerarquía
CREATE TABLE empleados (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    jefe_id INTEGER,
    cargo TEXT,
    FOREIGN KEY (jefe_id) REFERENCES empleados(id)
);

-- CTE recursivo para obtener toda la jerarquía
WITH RECURSIVE jerarquia AS (
    -- Caso base: CEO (sin jefe)
    SELECT 
        id, 
        nombre, 
        cargo,
        0 as nivel,
        nombre as ruta_jerarquica
    FROM empleados 
    WHERE jefe_id IS NULL
    
    UNION ALL
    
    -- Caso recursivo: subordinados
    SELECT 
        e.id, 
        e.nombre, 
        e.cargo,
        j.nivel + 1,
        j.ruta_jerarquica || ' > ' || e.nombre
    FROM empleados e
    JOIN jerarquia j ON e.jefe_id = j.id
)
SELECT 
    nombre,
    cargo,
    nivel,
    ruta_jerarquica
FROM jerarquia
ORDER BY nivel, nombre;
```

## 📊 Window Functions (Funciones de Ventana)

Las **window functions** permiten hacer cálculos sobre un conjunto de filas relacionadas sin necesidad de GROUP BY.

### 🏆 Funciones de Ranking

```sql
-- Ranking de productos por precio dentro de cada categoría
SELECT 
    nombre,
    categoria_id,
    precio,
    ROW_NUMBER() OVER (PARTITION BY categoria_id ORDER BY precio DESC) as ranking,
    RANK() OVER (PARTITION BY categoria_id ORDER BY precio DESC) as rank_con_empates,
    DENSE_RANK() OVER (PARTITION BY categoria_id ORDER BY precio DESC) as dense_ranking
FROM productos
ORDER BY categoria_id, precio DESC;
```

### 📈 Funciones de Agregación con Ventana

```sql
-- Análisis de ventas con totales acumulados y promedios móviles
WITH ventas_diarias AS (
    SELECT 
        DATE(fecha_pedido) as fecha,
        COUNT(*) as pedidos,
        SUM(total) as ingresos
    FROM pedidos
    WHERE estado = 'completado'
    GROUP BY DATE(fecha_pedido)
)
SELECT 
    fecha,
    pedidos,
    ingresos,
    -- Total acumulado
    SUM(ingresos) OVER (ORDER BY fecha) as ingresos_acumulados,
    -- Promedio móvil de 7 días
    AVG(ingresos) OVER (ORDER BY fecha ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as promedio_7_dias,
    -- Comparación con día anterior
    LAG(ingresos) OVER (ORDER BY fecha) as ingresos_dia_anterior,
    ingresos - LAG(ingresos) OVER (ORDER BY fecha) as diferencia_dia_anterior,
    -- Comparación con mismo día semana anterior
    LAG(ingresos, 7) OVER (ORDER BY fecha) as ingresos_semana_anterior
FROM ventas_diarias
ORDER BY fecha;
```

### 🎯 Funciones de Posición

```sql
-- Análisis de clientes con funciones de posición
SELECT 
    nombre,
    total_compras,
    -- Posición en ranking general
    ROW_NUMBER() OVER (ORDER BY total_compras DESC) as posicion_ranking,
    -- Percentil del cliente
    PERCENT_RANK() OVER (ORDER BY total_compras) as percentil,
    -- Primer y último cliente
    FIRST_VALUE(nombre) OVER (ORDER BY total_compras DESC) as top_cliente,
    LAST_VALUE(nombre) OVER (ORDER BY total_compras DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as cliente_menor_compras,
    -- Cliente anterior y siguiente en ranking
    LAG(nombre) OVER (ORDER BY total_compras DESC) as cliente_superior,
    LEAD(nombre) OVER (ORDER BY total_compras DESC) as cliente_inferior
FROM (
    SELECT 
        c.nombre,
        COALESCE(SUM(p.total), 0) as total_compras
    FROM clientes c
    LEFT JOIN pedidos p ON c.id = p.cliente_id AND p.estado = 'completado'
    GROUP BY c.id, c.nombre
) AS compras_cliente
ORDER BY total_compras DESC;
```

## 🎯 Casos de Uso Prácticos

### 📊 Dashboard de KPIs

```sql
-- CTE para métricas principales del negocio
WITH metricas_generales AS (
    SELECT 
        COUNT(DISTINCT c.id) as total_clientes,
        COUNT(DISTINCT p.id) as total_pedidos,
        COUNT(DISTINCT pr.id) as total_productos,
        AVG(p.total) as ticket_promedio,
        SUM(p.total) as ingresos_totales
    FROM clientes c
    LEFT JOIN pedidos p ON c.id = p.cliente_id AND p.estado = 'completado'
    LEFT JOIN pedido_items pi ON p.id = pi.pedido_id
    LEFT JOIN productos pr ON pi.producto_id = pr.id
),
top_productos AS (
    SELECT 
        pr.nombre,
        SUM(pi.cantidad) as cantidad_vendida,
        SUM(pi.cantidad * pi.precio_unitario) as ingresos_producto,
        ROW_NUMBER() OVER (ORDER BY SUM(pi.cantidad) DESC) as ranking
    FROM productos pr
    JOIN pedido_items pi ON pr.id = pi.producto_id
    JOIN pedidos p ON pi.pedido_id = p.id AND p.estado = 'completado'
    GROUP BY pr.id, pr.nombre
),
clientes_vip AS (
    SELECT 
        c.nombre,
        COUNT(p.id) as total_pedidos,
        SUM(p.total) as total_gastado,
        ROW_NUMBER() OVER (ORDER BY SUM(p.total) DESC) as ranking_cliente
    FROM clientes c
    JOIN pedidos p ON c.id = p.cliente_id AND p.estado = 'completado'
    GROUP BY c.id, c.nombre
    HAVING COUNT(p.id) >= 2 -- Clientes con al menos 2 pedidos
)
SELECT 
    'MÉTRICAS GENERALES' as categoria,
    'Total Clientes: ' || m.total_clientes as valor
FROM metricas_generales m
UNION ALL
SELECT 
    'MÉTRICAS GENERALES',
    'Total Pedidos: ' || m.total_pedidos
FROM metricas_generales m
UNION ALL
SELECT 
    'MÉTRICAS GENERALES',
    'Ticket Promedio: $' || ROUND(m.ticket_promedio, 2)
FROM metricas_generales m
UNION ALL
SELECT 
    'TOP PRODUCTOS',
    '#' || tp.ranking || ' - ' || tp.nombre || ' (' || tp.cantidad_vendida || ' unidades)'
FROM top_productos tp
WHERE tp.ranking <= 5
UNION ALL
SELECT 
    'CLIENTES VIP',
    '#' || cv.ranking_cliente || ' - ' || cv.nombre || ' ($' || ROUND(cv.total_gastado, 2) || ')'
FROM clientes_vip cv
WHERE cv.ranking_cliente <= 5
ORDER BY categoria, valor;
```

### 🔍 Análisis de Cohortes

```sql
-- Análisis de cohortes de clientes por mes de registro
WITH cohortes_clientes AS (
    SELECT 
        c.id,
        c.nombre,
        strftime('%Y-%m', c.fecha_registro) as cohorte_mes,
        MIN(DATE(p.fecha_pedido)) as primera_compra,
        COUNT(p.id) as total_pedidos,
        SUM(p.total) as valor_total_vida
    FROM clientes c
    LEFT JOIN pedidos p ON c.id = p.cliente_id AND p.estado = 'completado'
    GROUP BY c.id, c.nombre, strftime('%Y-%m', c.fecha_registro)
),
metricas_cohorte AS (
    SELECT 
        cohorte_mes,
        COUNT(*) as clientes_registrados,
        COUNT(primera_compra) as clientes_compradores,
        ROUND(COUNT(primera_compra) * 100.0 / COUNT(*), 2) as tasa_conversion,
        ROUND(AVG(valor_total_vida), 2) as ltv_promedio,
        ROUND(AVG(total_pedidos), 2) as pedidos_promedio_cliente
    FROM cohortes_clientes
    GROUP BY cohorte_mes
)
SELECT 
    cohorte_mes,
    clientes_registrados,
    clientes_compradores,
    tasa_conversion || '%' as conversion_rate,
    '$' || ltv_promedio as customer_ltv,
    pedidos_promedio_cliente as avg_orders_per_customer
FROM metricas_cohorte
ORDER BY cohorte_mes;
```

## ⚡ Performance: Subconsultas vs JOINs vs CTEs

### 🏃‍♂️ Comparación de rendimiento

```sql
-- ❌ Subconsulta correlacionada (LENTA)
SELECT 
    c.nombre,
    (SELECT COUNT(*) FROM pedidos p WHERE p.cliente_id = c.id) as total_pedidos
FROM clientes c;

-- ✅ JOIN (RÁPIDA)
SELECT 
    c.nombre,
    COUNT(p.id) as total_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre;

-- ✅ Window Function (RÁPIDA y más funcionalidades)
SELECT DISTINCT
    c.nombre,
    COUNT(p.id) OVER (PARTITION BY c.id) as total_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id;
```

### 📋 Cuándo usar cada técnica:

| Técnica | Cuándo usar | Rendimiento | Legibilidad |
|---------|-------------|-------------|-------------|
| **Subconsultas** | Valores únicos, EXISTS, IN | ⭐⭐ | ⭐⭐⭐ |
| **JOINs** | Relacionar tablas, agregaciones | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **CTEs** | Consultas complejas, reutilización | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Window Functions** | Rankings, análisis temporal | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

## 🎓 Ejercicios Prácticos

### 🤔 Desafío 1: Análisis de Ventas Avanzado

```sql
-- Encuentra:
-- 1. Los 3 productos más vendidos por categoría
-- 2. El cliente que más gastó en cada mes
-- 3. La tendencia de crecimiento mensual de ventas
-- 4. Productos que vendieron arriba del promedio de su categoría

-- Tu turno: ¿Cómo lo resolverías usando CTEs y Window Functions?
```

### 🎯 Desafío 2: Detección de Patrones

```sql
-- Detecta:
-- 1. Clientes que compraron productos similares a otros clientes
-- 2. Productos que siempre se venden juntos
-- 3. Clientes que abandonaron (no compraron en 90 días)
-- 4. Estacionalidad en las ventas por categoría

-- Pista: Usar CTEs recursivos y funciones de ventana
```

## 📝 Mejores Prácticas

### ✅ DO (Hacer)

1. **Usar CTEs para consultas complejas** - Mejora legibilidad
2. **Aplicar filtros temprano** - Reduce datos procesados  
3. **Usar EXISTS en lugar de IN** - Mejor performance
4. **Aprovechar window functions** - Más poderosas que GROUP BY

### ❌ DON'T (No hacer)

1. **Subconsultas correlacionadas en loops** - Muy lento
2. **CTEs sin filtros** - Procesa datos innecesarios
3. **Window functions sin PARTITION** - Puede ser lento
4. **Múltiples niveles de subconsultas** - Difícil mantenimiento

## 🚀 Próxima Clase: Índices y Optimización

En la siguiente clase aprenderemos:
- Cómo optimizar estas consultas complejas
- Índices estratégicos para subconsultas y CTEs
- EXPLAIN QUERY PLAN para analizar performance
- Técnicas avanzadas de optimización

---

## 📋 Resumen

1. **Subconsultas**: Consultas dentro de consultas (escalares, lista, tabla, correlacionadas)
2. **CTEs**: "Variables temporales" que mejoran legibilidad y reutilización
3. **CTEs Recursivos**: Para jerarquías y series de datos
4. **Window Functions**: Cálculos sobre ventanas de datos sin GROUP BY
5. **Performance**: JOINs y Window Functions generalmente más rápidos

**¡Ahora podés resolver problemas SQL complejos con elegancia!** 🎯