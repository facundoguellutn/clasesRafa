# Ejercicio 2: Agrupando Datos con `GROUP BY`

## 🎯 Objetivo

Utilizar la cláusula `GROUP BY` para segmentar datos y aplicar funciones de agregación a cada grupo, una habilidad fundamental para crear reportes y análisis de negocio.

---

## 🚀 Setup

Continuá usando el esquema de e-commerce de la Clase 13 en [sqlsandbox.com](https://sqlsandbox.com).

---

## 🏋️‍♀️ Ejercicios

### Parte 1: Agrupaciones Simples

1.  **Pedidos por Estado**: Contá cuántos pedidos hay en cada `estado` (`pendiente`, `entregado`, etc.).

    ```sql
    -- Tu código aquí
    ```

2.  **Clientes por Plan**: Contá cuántos clientes hay en cada tipo de `plan` (`Basic`, `Premium`, `VIP`).

    ```sql
    -- Tu código aquí
    ```

3.  **Productos por Categoría**: Contá cuántos productos diferentes pertenecen a cada `categoria_id`.

    ```sql
    -- Tu código aquí
    ```

### Parte 2: Agregaciones con Cálculos

4.  **Ingresos por Canal de Venta**: Calculá la suma total de `total` de los pedidos 'entregado' para cada `canal` de venta (`Online`, `Tienda`, etc.).

    ```sql
    -- Tu código aquí
    ```

5.  **Stock Total por Categoría**: Calculá la suma total de `stock` para cada categoría de producto. La consulta debe mostrar el nombre de la categoría, no solo el id.

    ```sql
    -- Pista: Necesitarás un JOIN entre productos y categorias.
    -- Tu código aquí
    ```

6.  **Gasto Promedio por Cliente**: Calculá el `total` promedio de los pedidos para cada `cliente_id`.

    ```sql
    -- Tu código aquí
    ```

### Parte 3: Agrupaciones por Múltiples Columnas

7.  **Análisis de Clientes por Región y Plan**: Contá cuántos clientes hay para cada combinación de `region_id` y `plan`.

    ```sql
    -- Pista: GROUP BY region_id, plan
    -- Tu código aquí
    ```

8.  **Ventas Mensuales por Vendedor**: Para cada vendedor, calculá sus ingresos totales (`SUM(total)`) por mes. La consulta debe mostrar el nombre del vendedor y el mes de la venta (ej: '2024-01').

    ```sql
    -- Pista: Necesitarás unir vendedores y pedidos, y agrupar por vendedor y mes.
    -- La función SUBSTR(fecha_pedido, 1, 7) es útil para obtener el mes.
    -- Tu código aquí
    ```

---

## 💡 Soluciones Propuestas

<details>
<summary>Click para ver la solución</summary>

```sql
-- 1. Pedidos por Estado
SELECT estado, COUNT(*) as cantidad
FROM pedidos
GROUP BY estado;


-- 2. Clientes por Plan
SELECT plan, COUNT(*) as cantidad_clientes
FROM clientes
GROUP BY plan;


-- 3. Productos por Categoría
SELECT categoria_id, COUNT(*) as cantidad_productos
FROM productos
GROUP BY categoria_id;


-- 4. Ingresos por Canal de Venta
SELECT canal, SUM(total) as ingresos_totales
FROM pedidos
WHERE estado = 'entregado'
GROUP BY canal
ORDER BY ingresos_totales DESC;


-- 5. Stock Total por Categoría
SELECT 
    c.nombre as categoria,
    SUM(p.stock) as stock_total
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
GROUP BY c.nombre
ORDER BY stock_total DESC;


-- 6. Gasto Promedio por Cliente
SELECT 
    cliente_id,
    AVG(total) as gasto_promedio
FROM pedidos
WHERE estado = 'entregado'
GROUP BY cliente_id;


-- 7. Análisis de Clientes por Región y Plan
SELECT 
    r.nombre as region,
    c.plan,
    COUNT(c.id) as cantidad_clientes
FROM clientes c
INNER JOIN regiones r ON c.region_id = r.id
GROUP BY r.nombre, c.plan
ORDER BY r.nombre, c.plan;


-- 8. Ventas Mensuales por Vendedor
SELECT
    v.nombre as vendedor,
    SUBSTR(p.fecha_pedido, 1, 7) as mes,
    SUM(p.total) as ventas_del_mes
FROM vendedores v
INNER JOIN pedidos p ON v.id = p.vendedor_id
WHERE p.estado = 'entregado'
GROUP BY v.nombre, mes
ORDER BY v.nombre, mes;

```

</details>
