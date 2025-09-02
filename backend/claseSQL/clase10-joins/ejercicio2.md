# Ejercicio 2: JOINs con Múltiples Tablas y Búsqueda de Datos Huérfanos

## 🎯 Objetivo

Avanzar en la complejidad de los `JOINs`, uniendo más de dos tablas para crear reportes completos. Además, usar la técnica de `LEFT JOIN ... IS NULL` para encontrar registros que no tienen correspondencia.

---

## 🚀 Setup

Continuá usando el esquema de e-commerce de la Clase 10 en [sqlsandbox.com](https://sqlsandbox.com).

---

## 🏋️‍♀️ Ejercicios

### Parte 1: Uniendo Múltiples Tablas

Para responder preguntas de negocio complejas, a menudo necesitarás datos de 3, 4 o más tablas.

1.  **Reporte de Ventas Detallado**
    *   **Tarea**: Creá un reporte que muestre la información completa de cada item vendido. La consulta debe incluir:
        *   De la tabla `pedidos`: el `id` del pedido y la `fecha`.
        *   De la tabla `clientes`: el `nombre` del cliente.
        *   De la tabla `productos`: el `nombre` del producto.
        *   De la tabla `pedido_items`: la `cantidad` y el `precio_unitario`.
    *   **Pista**: Necesitarás empezar en `pedidos` y unir secuencialmente `clientes`, `pedido_items` y `productos`.

    ```sql
    -- Tu código aquí
    ```

2.  **Ingresos Totales por Categoría de Producto**
    *   **Tarea**: Calculá cuánto dinero ha generado cada categoría de producto.
    *   **Pista**: Necesitarás unir `productos` con `pedido_items`. Luego, agrupar por `categoria` y sumar el `subtotal` de cada item (`cantidad * precio_unitario`).

    ```sql
    -- Tu código aquí
    ```

### Parte 2: Encontrando lo que Falta (`LEFT JOIN ... IS NULL`)

Esta es una técnica fundamental para el análisis de datos y la limpieza de la base de datos.

3.  **Encontrar Productos que Nunca se Han Vendido**
    *   **Tarea**: Generá una lista de todos los productos que no aparecen en ningún `pedido_items`. Mostrá el `nombre`, `categoria` y `stock` de estos productos.
    *   **Pista**: Hacé un `LEFT JOIN` desde `productos` hacia `pedido_items` y luego filtrá donde el `id` de `pedido_items` sea `NULL`.

    ```sql
    -- Tu código aquí
    ```

4.  **Encontrar Clientes Sin Pedidos**
    *   **Tarea**: Generá una lista de "clientes inactivos" que se han registrado pero nunca han realizado un pedido. Mostrá su `nombre`, `email` y `fecha_registro`.
    *   **Pista**: `LEFT JOIN` desde `clientes` a `pedidos` y filtrá donde el `id` del pedido sea `NULL`.

    ```sql
    -- Tu código aquí
    ```

### Desafío

5.  **Reporte de Stock vs. Ventas**
    *   **Tarea**: Creá un reporte que muestre, para cada producto, su `nombre`, el `stock` actual y el `total de unidades vendidas`. La lista debe incluir **todos** los productos, incluso los que nunca se vendieron (para los cuales las unidades vendidas serán 0).
    *   **Pista**: Necesitarás un `LEFT JOIN` y usar `GROUP BY`. La función `COALESCE(SUM(columna), 0)` es útil para reemplazar los `NULL` de la suma con un `0`.

    ```sql
    -- Tu código aquí
    ```

---

## 💡 Soluciones Propuestas

<details>
<summary>Click para ver la solución</summary>

```sql
-- 1. Reporte de Ventas Detallado
SELECT
    p.id as pedido_id,
    p.fecha,
    c.nombre as cliente,
    pr.nombre as producto,
    pi.cantidad,
    pi.precio_unitario
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
INNER JOIN pedido_items pi ON p.id = pi.pedido_id
INNER JOIN productos pr ON pi.producto_id = pr.id
ORDER BY p.fecha DESC, p.id;


-- 2. Ingresos Totales por Categoría de Producto
SELECT
    pr.categoria,
    SUM(pi.cantidad * pi.precio_unitario) as ingresos_totales
FROM productos pr
INNER JOIN pedido_items pi ON pr.id = pi.producto_id
GROUP BY pr.categoria
ORDER BY ingresos_totales DESC;


-- 3. Encontrar Productos que Nunca se Han Vendido
SELECT
    pr.nombre,
    pr.categoria,
    pr.stock
FROM productos pr
LEFT JOIN pedido_items pi ON pr.id = pi.producto_id
WHERE pi.id IS NULL;


-- 4. Encontrar Clientes Sin Pedidos
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE p.id IS NULL;


-- 5. Desafío: Reporte de Stock vs. Ventas
SELECT
    pr.nombre,
    pr.stock,
    COALESCE(SUM(pi.cantidad), 0) as total_unidades_vendidas
FROM productos pr
LEFT JOIN pedido_items pi ON pr.id = pi.producto_id
GROUP BY pr.id, pr.nombre, pr.stock
ORDER BY total_unidades_vendidas DESC;

```

</details>
