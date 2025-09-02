# Ejercicio 3: Filtrando Grupos con `HAVING` y Análisis Complejo

## 🎯 Objetivo

Dominar el uso de la cláusula `HAVING` para filtrar resultados después de la agregación y combinar `JOIN`, `WHERE`, `GROUP BY` y `HAVING` para responder preguntas de negocio complejas.

---

## 🚀 Setup

Continuá usando el esquema de e-commerce de la Clase 13 en [sqlsandbox.com](https://sqlsandbox.com).

---

## 🏋️‍♀️ Ejercicios

### Parte 1: `HAVING` - El Filtro de los Grupos

1.  **Clientes VIP**: Encontrá a todos los clientes que han gastado más de $250,000 en total. Mostrá el nombre del cliente y su gasto total.

    ```sql
    -- Tu código aquí
    ```

2.  **Categorías con Pocos Productos**: Identificá las categorías que tienen 3 o menos productos. Mostrá el nombre de la categoría y la cantidad de productos.

    ```sql
    -- Tu código aquí
    ```

3.  **Vendedores con Bajas Ventas**: Encontrá a los vendedores que generaron menos de $250,000 en ventas totales durante el mes de Enero de 2024. Mostrá el nombre del vendedor y su total de ventas en ese mes.

    ```sql
    -- Pista: Necesitarás WHERE para filtrar por fecha y HAVING para filtrar por la suma.
    -- Tu código aquí
    ```

### Parte 2: Combinando Todo para Análisis de Negocio

4.  **Análisis de Rentabilidad por Categoría**: Calculá la ganancia total para cada categoría (ganancia = `(precio_venta - precio_costo)` de cada producto vendido). Mostrá solo las categorías que hayan generado más de $100,000 de ganancia.

    ```sql
    -- Pista: Uní productos y pedido_items. Agrupá por categoría. Sumá la ganancia por item (ganancia_item * cantidad) y filtrá con HAVING.
    -- Tu código aquí
    ```

5.  **Clientes Frecuentes por Región**: Encontrá, para cada región, el número de clientes que han realizado 2 o más pedidos. El reporte debe mostrar el nombre de la región y la cantidad de clientes frecuentes.

    ```sql
    -- Pista: Esto es un desafío. Necesitarás una subconsulta o una Tabla de Expresión Común (CTE) para primero contar los pedidos por cliente y luego contar los clientes que cumplen la condición por región.
    -- Ejemplo con subconsulta:
    -- SELECT region, COUNT(*) FROM (subconsulta_que_encuentra_clientes_frecuentes) GROUP BY region;
    -- Tu código aquí
    ```

### Desafío Final

6.  **El Mes Más Rentable**: Encontrá el mes (`YYYY-MM`) que tuvo la mayor ganancia total. La ganancia de un pedido es la suma de las ganancias de sus items (`(precio_unitario - precio_costo) * cantidad`).

    ```sql
    -- Pista: Uní las 4 tablas principales. Agrupá por mes. Calculá la ganancia total por grupo. Ordená de forma descendente y limitá a 1.
    -- Tu código aquí
    ```

---

## 💡 Soluciones Propuestas

<details>
<summary>Click para ver la solución</summary>

```sql
-- 1. Clientes VIP
SELECT
    c.nombre as cliente,
    SUM(p.total) as gasto_total
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
WHERE p.estado = 'entregado'
GROUP BY c.id, c.nombre
HAVING SUM(p.total) > 250000
ORDER BY gasto_total DESC;


-- 2. Categorías con Pocos Productos
SELECT
    cat.nombre as categoria,
    COUNT(p.id) as cantidad_productos
FROM categorias cat
LEFT JOIN productos p ON cat.id = p.categoria_id
GROUP BY cat.id, cat.nombre
HAVING COUNT(p.id) <= 3;


-- 3. Vendedores con Bajas Ventas en Enero
SELECT
    v.nombre as vendedor,
    SUM(p.total) as ventas_enero
FROM vendedores v
INNER JOIN pedidos p ON v.id = p.vendedor_id
WHERE p.fecha_pedido >= '2024-01-01' AND p.fecha_pedido < '2024-02-01' AND p.estado = 'entregado'
GROUP BY v.id, v.nombre
HAVING SUM(p.total) < 250000;


-- 4. Análisis de Rentabilidad por Categoría
SELECT
    cat.nombre as categoria,
    SUM((pi.precio_unitario - pr.precio_costo) * pi.cantidad) as ganancia_total
FROM categorias cat
INNER JOIN productos pr ON cat.id = pr.categoria_id
INNER JOIN pedido_items pi ON pr.id = pi.producto_id
INNER JOIN pedidos p ON pi.pedido_id = p.id
WHERE p.estado = 'entregado'
GROUP BY cat.id, cat.nombre
HAVING ganancia_total > 100000
ORDER BY ganancia_total DESC;


-- 5. Clientes Frecuentes por Región (usando subconsulta en FROM)
SELECT
    r.nombre as region,
    COUNT(*) as cantidad_clientes_frecuentes
FROM (
    SELECT c.id, c.region_id
    FROM clientes c
    INNER JOIN pedidos p ON c.id = p.cliente_id
    WHERE p.estado = 'entregado'
    GROUP BY c.id, c.region_id
    HAVING COUNT(p.id) >= 2
) as clientes_frecuentes
INNER JOIN regiones r ON clientes_frecuentes.region_id = r.id
GROUP BY r.nombre;


-- 6. Desafío: El Mes Más Rentable
SELECT
    SUBSTR(p.fecha_pedido, 1, 7) as mes,
    SUM((pi.precio_unitario - pr.precio_costo) * pi.cantidad) as ganancia_mensual
FROM pedidos p
INNER JOIN pedido_items pi ON p.id = pi.pedido_id
INNER JOIN productos pr ON pi.producto_id = pr.id
WHERE p.estado = 'entregado'
GROUP BY mes
ORDER BY ganancia_mensual DESC
LIMIT 1;

```

</details>
