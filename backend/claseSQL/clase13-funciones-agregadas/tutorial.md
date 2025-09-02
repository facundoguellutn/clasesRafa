# Clase 13: Funciones Agregadas y GROUP BY - Análisis de Datos

## 🎯 Objetivos de la Clase

Al finalizar esta clase, Rafa será capaz de:
- Dominar las funciones agregadas (COUNT, SUM, AVG, MAX, MIN)
- Usar GROUP BY para agrupar datos y crear reportes
- Aplicar HAVING para filtrar grupos
- Combinar agregaciones con JOINs para análisis complejos
- Crear dashboards y KPIs con SQL

---

## 📊 ¿Qué Son Las Funciones Agregadas?

Las **funciones agregadas** toman **múltiples filas** y devuelven **un solo resultado**. Son fundamentales para:
- 📈 **Crear reportes de negocio**
- 📊 **Calcular métricas y KPIs**
- 🔍 **Analizar tendencias**
- 💰 **Sumar ventas, ingresos, cantidades**

### Analogía Simple
Imaginate que tenés una tabla de ventas diarias:
```
Día 1: $1000
Día 2: $1500  
Día 3: $800
```

Las funciones agregadas te permiten responder:
- **COUNT**: ¿Cuántos días vendimos? → 3 días
- **SUM**: ¿Total vendido? → $3300
- **AVG**: ¿Promedio diario? → $1100
- **MAX**: ¿Mejor día? → $1500
- **MIN**: ¿Peor día? → $800

---

## 🔢 Funciones Agregadas Fundamentales

### 1. COUNT() - Contar Registros

#### COUNT(*) - Contar todas las filas
```sql
-- ¿Cuántos pedidos hay en total?
SELECT COUNT(*) as total_pedidos FROM pedidos;
```

#### COUNT(columna) - Contar valores no NULL
```sql
-- ¿Cuántos pedidos tienen vendedor asignado?
SELECT COUNT(vendedor_id) as pedidos_con_vendedor FROM pedidos;
```

#### COUNT(DISTINCT) - Contar valores únicos
```sql
-- ¿Cuántos clientes diferentes compraron?
SELECT COUNT(DISTINCT cliente_id) as clientes_activos FROM pedidos;
```

### 2. SUM() - Sumar Valores Numéricos
```sql
-- ¿Cuáles son los ingresos totales?
SELECT SUM(total) as ingresos_totales FROM pedidos;

-- ¿Cuántas unidades se vendieron en total?
SELECT SUM(cantidad) as unidades_vendidas FROM pedido_items;
```

### 3. AVG() - Calcular Promedio
```sql
-- ¿Cuál es el ticket promedio?
SELECT AVG(total) as ticket_promedio FROM pedidos;

-- ¿Precio promedio de productos?
SELECT AVG(precio) as precio_promedio FROM productos;
```

### 4. MAX() - Valor Máximo
```sql
-- ¿Cuál es la venta más alta?
SELECT MAX(total) as venta_maxima FROM pedidos;

-- ¿Producto más caro?
SELECT MAX(precio) as producto_mas_caro FROM productos;
```

### 5. MIN() - Valor Mínimo
```sql
-- ¿Cuál es la venta más baja?
SELECT MIN(total) as venta_minima FROM pedidos;

-- ¿Producto más barato?
SELECT MIN(precio) as producto_mas_barato FROM productos;
```

---

## 🎯 GROUP BY: Agrupar Datos

**GROUP BY** divide los datos en **grupos** y aplica funciones agregadas a cada grupo.

### Sintaxis Básica
```sql
SELECT columna_agrupacion, FUNCION_AGREGADA(columna)
FROM tabla
GROUP BY columna_agrupacion;
```

### Ejemplo Fundamental
```sql
-- Ventas por cliente
SELECT 
    cliente_id,
    COUNT(*) as cantidad_pedidos,
    SUM(total) as total_gastado
FROM pedidos
GROUP BY cliente_id;
```

**¿Qué hace?**
1. Agrupa pedidos por `cliente_id`
2. Para cada grupo (cliente), cuenta pedidos y suma totales
3. Devuelve una fila por cliente

### Ejemplo Visual
```
Datos originales:
| cliente_id | total |
|------------|-------|
| 1          | 1000  |
| 1          | 1500  |  
| 2          | 800   |
| 2          | 1200  |
| 3          | 2000  |

Después de GROUP BY cliente_id:
| cliente_id | cantidad_pedidos | total_gastado |
|------------|-----------------|---------------|
| 1          | 2               | 2500          |
| 2          | 2               | 2000          |  
| 3          | 1               | 2000          |
```

---

## 🚀 Ejemplos Prácticos Progresivos

### Nivel 1: Agregaciones Básicas
```sql
-- KPIs generales del negocio
SELECT 
    COUNT(*) as total_pedidos,
    COUNT(DISTINCT cliente_id) as clientes_unicos,
    SUM(total) as ingresos_totales,
    AVG(total) as ticket_promedio,
    MAX(total) as venta_maxima,
    MIN(total) as venta_minima
FROM pedidos
WHERE estado = 'completado';
```

### Nivel 2: Agrupaciones Simples
```sql
-- Ventas por estado de pedido
SELECT 
    estado,
    COUNT(*) as cantidad_pedidos,
    SUM(total) as ingresos_por_estado,
    AVG(total) as ticket_promedio_por_estado
FROM pedidos
GROUP BY estado
ORDER BY ingresos_por_estado DESC;
```

### Nivel 3: Agrupaciones por Fecha
```sql
-- Ventas por mes
SELECT 
    SUBSTR(fecha, 1, 7) as mes,  -- '2024-01' format
    COUNT(*) as pedidos_del_mes,
    SUM(total) as ingresos_del_mes,
    AVG(total) as ticket_promedio_mes
FROM pedidos
WHERE estado = 'completado'
GROUP BY SUBSTR(fecha, 1, 7)
ORDER BY mes DESC;
```

### Nivel 4: Combinando con JOINs
```sql
-- Ventas por ciudad de cliente
SELECT 
    c.ciudad,
    COUNT(p.id) as pedidos_por_ciudad,
    COUNT(DISTINCT c.id) as clientes_por_ciudad,
    SUM(p.total) as ingresos_por_ciudad,
    AVG(p.total) as ticket_promedio_ciudad
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
WHERE p.estado = 'completado'
GROUP BY c.ciudad
ORDER BY ingresos_por_ciudad DESC;
```

---

## 🔍 HAVING: Filtrar Grupos

**HAVING** es como **WHERE** pero para **grupos** (después de GROUP BY).

### Diferencia: WHERE vs HAVING
- **WHERE**: Filtra **filas individuales** ANTES de agrupar
- **HAVING**: Filtra **grupos** DESPUÉS de agrupar

```sql
-- ❌ INCORRECTO: WHERE no puede usar funciones agregadas
SELECT cliente_id, COUNT(*) as pedidos
FROM pedidos  
WHERE COUNT(*) > 2  -- ERROR!
GROUP BY cliente_id;

-- ✅ CORRECTO: HAVING filtra grupos
SELECT cliente_id, COUNT(*) as pedidos
FROM pedidos
GROUP BY cliente_id
HAVING COUNT(*) > 2;  -- Clientes con más de 2 pedidos
```

### Ejemplos Prácticos con HAVING
```sql
-- Clientes VIP (más de $100,000 en compras)
SELECT 
    c.nombre,
    COUNT(p.id) as total_pedidos,
    SUM(p.total) as total_gastado
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
WHERE p.estado = 'completado'
GROUP BY c.id, c.nombre
HAVING SUM(p.total) > 100000
ORDER BY total_gastado DESC;

-- Productos top (vendidos más de 5 veces)
SELECT 
    pr.nombre,
    SUM(pi.cantidad) as unidades_vendidas,
    COUNT(DISTINCT pi.pedido_id) as pedidos_con_producto
FROM productos pr
INNER JOIN pedido_items pi ON pr.id = pi.producto_id
INNER JOIN pedidos p ON pi.pedido_id = p.id
WHERE p.estado = 'completado'
GROUP BY pr.id, pr.nombre
HAVING COUNT(DISTINCT pi.pedido_id) > 5
ORDER BY unidades_vendidas DESC;
```

---

## 📈 Casos de Uso Reales para E-commerce

### Dashboard Ejecutivo
```sql
-- KPIs principales últimos 30 días
SELECT 
    'Últimos 30 días' as periodo,
    COUNT(*) as total_pedidos,
    COUNT(DISTINCT cliente_id) as clientes_activos,
    SUM(total) as ingresos,
    AVG(total) as ticket_promedio,
    SUM(total) / COUNT(DISTINCT cliente_id) as valor_por_cliente
FROM pedidos
WHERE fecha >= DATE('now', '-30 days') 
  AND estado = 'completado';
```

### Análisis de Vendedores
```sql
-- Performance de vendedores
SELECT 
    v.nombre as vendedor,
    COUNT(p.id) as pedidos_gestionados,
    SUM(p.total) as ventas_totales,
    AVG(p.total) as ticket_promedio,
    SUM(p.total) * (v.comision_porcentaje / 100) as comision_ganada
FROM vendedores v
LEFT JOIN pedidos p ON v.id = p.vendedor_id AND p.estado = 'completado'
WHERE v.activo = TRUE
GROUP BY v.id, v.nombre, v.comision_porcentaje
ORDER BY ventas_totales DESC;
```

### Análisis de Productos por Categoría
```sql
-- Rendimiento por categoría
SELECT 
    cat.nombre as categoria,
    COUNT(DISTINCT pr.id) as productos_en_categoria,
    COUNT(pi.id) as items_vendidos,
    SUM(pi.cantidad) as unidades_vendidas,
    SUM(pi.cantidad * pi.precio_unitario) as ingresos_categoria,
    AVG(pi.precio_unitario) as precio_promedio,
    SUM(pi.cantidad * pi.precio_unitario) / SUM(pi.cantidad) as precio_ponderado
FROM categorias cat
LEFT JOIN productos pr ON cat.id = pr.categoria_id
LEFT JOIN pedido_items pi ON pr.id = pi.producto_id
LEFT JOIN pedidos p ON pi.pedido_id = p.id AND p.estado = 'completado'
GROUP BY cat.id, cat.nombre
HAVING ingresos_categoria > 0  -- Solo categorías con ventas
ORDER BY ingresos_categoria DESC;
```

### Análisis de Clientes (Segmentación RFM Básica)
```sql
-- Segmentación de clientes por comportamiento
SELECT 
    c.nombre,
    c.ciudad,
    COUNT(p.id) as frecuencia_compra,
    SUM(p.total) as valor_total_cliente,
    AVG(p.total) as ticket_promedio_cliente,
    MAX(p.fecha) as ultima_compra,
    ROUND(julianday('now') - julianday(MAX(p.fecha))) as dias_sin_comprar,
    CASE 
        WHEN SUM(p.total) > 200000 AND COUNT(p.id) > 3 THEN 'VIP'
        WHEN SUM(p.total) > 100000 THEN 'Premium'
        WHEN COUNT(p.id) > 2 THEN 'Regular'
        ELSE 'Nuevo'
    END as segmento_cliente
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id AND p.estado = 'completado'
GROUP BY c.id, c.nombre, c.ciudad
ORDER BY valor_total_cliente DESC;
```

---

## 🎯 Análisis Temporal

### Ventas por Día de la Semana
```sql
-- ¿Qué días de la semana vendemos más?
SELECT 
    CASE CAST(strftime('%w', fecha) AS INTEGER)
        WHEN 0 THEN 'Domingo'
        WHEN 1 THEN 'Lunes'
        WHEN 2 THEN 'Martes'
        WHEN 3 THEN 'Miércoles'
        WHEN 4 THEN 'Jueves'
        WHEN 5 THEN 'Viernes'
        WHEN 6 THEN 'Sábado'
    END as dia_semana,
    COUNT(*) as pedidos,
    SUM(total) as ingresos,
    AVG(total) as ticket_promedio
FROM pedidos
WHERE estado = 'completado'
GROUP BY strftime('%w', fecha)
ORDER BY ingresos DESC;
```

### Tendencia Mensual
```sql
-- Crecimiento mes a mes
SELECT 
    SUBSTR(fecha, 1, 7) as mes,
    COUNT(*) as pedidos,
    SUM(total) as ingresos,
    AVG(total) as ticket_promedio,
    LAG(SUM(total)) OVER (ORDER BY SUBSTR(fecha, 1, 7)) as ingresos_mes_anterior,
    ROUND(
        ((SUM(total) - LAG(SUM(total)) OVER (ORDER BY SUBSTR(fecha, 1, 7))) * 100.0) / 
        LAG(SUM(total)) OVER (ORDER BY SUBSTR(fecha, 1, 7)), 1
    ) as crecimiento_porcentual
FROM pedidos
WHERE estado = 'completado'
GROUP BY SUBSTR(fecha, 1, 7)
ORDER BY mes;
```

---

## 📊 Funciones Agregadas Avanzadas

### Concatenación de Strings
```sql
-- Productos vendidos por cliente
SELECT 
    c.nombre as cliente,
    COUNT(DISTINCT pr.id) as productos_diferentes,
    GROUP_CONCAT(DISTINCT pr.nombre, ', ') as productos_comprados
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
INNER JOIN pedido_items pi ON p.id = pi.pedido_id
INNER JOIN productos pr ON pi.producto_id = pr.id
WHERE p.estado = 'completado'
GROUP BY c.id, c.nombre
ORDER BY productos_diferentes DESC;
```

### Percentiles y Distribución
```sql
-- Análisis de distribución de ventas
SELECT 
    COUNT(*) as total_pedidos,
    MIN(total) as minimo,
    MAX(total) as maximo,
    AVG(total) as promedio,
    -- Aproximación a percentiles usando ORDER BY y LIMIT
    (SELECT total FROM pedidos WHERE estado = 'completado' ORDER BY total LIMIT 1 OFFSET (
        SELECT COUNT(*) * 25 / 100 FROM pedidos WHERE estado = 'completado'
    )) as percentil_25,
    (SELECT total FROM pedidos WHERE estado = 'completado' ORDER BY total LIMIT 1 OFFSET (
        SELECT COUNT(*) * 50 / 100 FROM pedidos WHERE estado = 'completado'  
    )) as mediana,
    (SELECT total FROM pedidos WHERE estado = 'completado' ORDER BY total LIMIT 1 OFFSET (
        SELECT COUNT(*) * 75 / 100 FROM pedidos WHERE estado = 'completado'
    )) as percentil_75
FROM pedidos 
WHERE estado = 'completado';
```

---

## ⚡ Optimización de Consultas Agregadas

### 1. Índices en Columnas de Agrupación
```sql
-- Si hacés GROUP BY frecuentemente por estas columnas:
CREATE INDEX idx_pedidos_estado_fecha ON pedidos(estado, fecha);
CREATE INDEX idx_pedidos_cliente_estado ON pedidos(cliente_id, estado);
```

### 2. Filtrar Antes de Agregar
```sql
-- ❌ LENTO: Agrupar todo, después filtrar
SELECT cliente_id, COUNT(*) 
FROM pedidos 
GROUP BY cliente_id 
HAVING MAX(fecha) > '2024-01-01';

-- ✅ RÁPIDO: Filtrar primero, después agrupar
SELECT cliente_id, COUNT(*) 
FROM pedidos 
WHERE fecha > '2024-01-01'
GROUP BY cliente_id;
```

### 3. Usar Subconsultas para Cálculos Complejos
```sql
-- Clientes con compras arriba del promedio
SELECT 
    c.nombre,
    total_cliente
FROM (
    SELECT 
        cliente_id,
        SUM(total) as total_cliente
    FROM pedidos 
    WHERE estado = 'completado'
    GROUP BY cliente_id
) cliente_totales
INNER JOIN clientes c ON cliente_totales.cliente_id = c.id
WHERE total_cliente > (
    SELECT AVG(total) FROM pedidos WHERE estado = 'completado'
);
```

---

## 🎯 Patrones de Reporting Común

### Patrón 1: Top N con Porcentaje
```sql
-- Top 5 productos con % del total
SELECT 
    pr.nombre,
    SUM(pi.cantidad * pi.precio_unitario) as ingresos_producto,
    ROUND(
        SUM(pi.cantidad * pi.precio_unitario) * 100.0 / 
        (SELECT SUM(pi2.cantidad * pi2.precio_unitario) 
         FROM pedido_items pi2 
         INNER JOIN pedidos p2 ON pi2.pedido_id = p2.id 
         WHERE p2.estado = 'completado'), 2
    ) as porcentaje_del_total
FROM productos pr
INNER JOIN pedido_items pi ON pr.id = pi.producto_id
INNER JOIN pedidos p ON pi.pedido_id = p.id
WHERE p.estado = 'completado'
GROUP BY pr.id, pr.nombre
ORDER BY ingresos_producto DESC
LIMIT 5;
```

### Patrón 2: Comparación Periodo Anterior
```sql
-- Ventas este mes vs mes anterior
SELECT 
    'Este mes' as periodo,
    COUNT(*) as pedidos,
    SUM(total) as ingresos
FROM pedidos 
WHERE fecha >= DATE('now', 'start of month') 
  AND estado = 'completado'
UNION ALL
SELECT 
    'Mes anterior' as periodo,
    COUNT(*) as pedidos,
    SUM(total) as ingresos
FROM pedidos 
WHERE fecha >= DATE('now', 'start of month', '-1 month')
  AND fecha < DATE('now', 'start of month')
  AND estado = 'completado';
```

### Patrón 3: Cohort Analysis Básico
```sql
-- Clientes por mes de registro y su comportamiento
SELECT 
    SUBSTR(c.fecha_registro, 1, 7) as mes_registro,
    COUNT(DISTINCT c.id) as clientes_registrados,
    COUNT(DISTINCT p.cliente_id) as clientes_que_compraron,
    ROUND(
        COUNT(DISTINCT p.cliente_id) * 100.0 / COUNT(DISTINCT c.id), 1
    ) as tasa_conversion_porcentaje
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id AND p.estado = 'completado'
GROUP BY SUBSTR(c.fecha_registro, 1, 7)
ORDER BY mes_registro;
```

---

## 🏋️ Ejercicios de Auto-Evaluación

### Ejercicio Mental 1: Interpretación
```sql
SELECT COUNT(DISTINCT cliente_id) FROM pedidos WHERE total > 50000;
```
**¿Qué devuelve esta consulta?**
<details>
<summary>Respuesta</summary>
La cantidad de clientes únicos que hicieron al menos un pedido de más de $50,000.
</details>

### Ejercicio Mental 2: GROUP BY Logic  
```sql
SELECT cliente_id, AVG(total) FROM pedidos GROUP BY cliente_id;
```
**¿Qué devuelve esta consulta?**
<details>
<summary>Respuesta</summary>
Para cada cliente, el ticket promedio (promedio de todos sus pedidos).
</details>

### Ejercicio Mental 3: HAVING vs WHERE
¿Cuál es la diferencia entre estas dos consultas?
```sql
-- Query A
SELECT cliente_id, COUNT(*) FROM pedidos WHERE total > 1000 GROUP BY cliente_id;

-- Query B  
SELECT cliente_id, COUNT(*) FROM pedidos GROUP BY cliente_id HAVING COUNT(*) > 2;
```
<details>
<summary>Respuesta</summary>
Query A: Cuenta pedidos >$1000 por cliente (filtra pedidos individuales).
Query B: Muestra clientes con más de 2 pedidos (filtra grupos de clientes).
</details>

---

## 🏠 Proyecto Para Casa: Dashboard de Biblioteca

Usando tu proyecto biblioteca personal, crear estas consultas agregadas:

### Análisis Básico:
1. **Estadísticas generales** (total libros, leídos, por leer, inversión total)
2. **Análisis por género** (cantidad, promedio calificación, inversión por género)  
3. **Análisis por autor** (autor más leído, mejor calificado, más caro)
4. **Progreso temporal** (libros leídos por mes, tendencia)

### Análisis Avanzado:
5. **Libros por rango de precio** (0-1000, 1000-3000, 3000+)
6. **Velocidad de lectura** (páginas promedio por libro leído)
7. **ROI de lectura** (relación calificación/precio por género)
8. **Top autores** (mejor promedio con mínimo 2 libros leídos)

### Dashboard Final:
```sql
-- Crear un reporte ejecutivo estilo dashboard
-- que resuma toda tu actividad de lectura
-- con métricas clave y recomendaciones
```

---

## 🎯 Próxima Clase: Normalización

En la **Clase 11** vamos a aprender:
- Formas normales (1NF, 2NF, 3NF) 
- Cómo diseñar esquemas eficientes
- Cuándo normalizar vs desnormalizar
- Optimización de estructura de datos

**¡Excelente! Ya dominás el análisis de datos con SQL. Las funciones agregadas son tu herramienta más poderosa para crear reportes y dashboards útiles.**