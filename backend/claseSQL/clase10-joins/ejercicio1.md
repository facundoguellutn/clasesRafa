# Ejercicios Clase 10 - JOINs Básicos

## 🎯 Objetivo

Practicar las uniones más comunes, `INNER JOIN` y `LEFT JOIN`, para combinar datos de dos tablas y empezar a responder preguntas de negocio que requieren información combinada.

---

## 🚀 Setup

1.  Abrí [sqlsandbox.com](https://sqlsandbox.com).
2.  Copiá y pegá el contenido completo de `sqlsandbox-setup.sql` de la Clase 10.
3.  Hacé click en "Run" para crear el esquema de e-commerce con clientes, productos, y pedidos.

---

## 🏋️‍♀️ Ejercicios

### Parte 1: `INNER JOIN` - Solo los Datos que Coinciden

El `INNER JOIN` es perfecto para cuando necesitás un reporte con datos completos y válidos de ambas tablas.

1.  **Reporte de Pedidos con Nombres de Clientes**
    *   **Tarea**: Escribí una consulta que muestre el `id` del pedido, la `fecha`, el `total` y el `nombre` del cliente que lo realizó.
    *   **Pregunta**: ¿Por qué un pedido podría no aparecer en este reporte si usáramos `INNER JOIN`? (Respuesta: si su `cliente_id` no corresponde a ningún cliente en la tabla `clientes`).

    ```sql
    -- Tu código aquí
    ```

2.  **Items Vendidos con Nombre de Producto**
    *   **Tarea**: La tabla `pedido_items` solo tiene `producto_id`. Escribí una consulta que la una con la tabla `productos` para mostrar el `nombre` del producto, la `cantidad` vendida y el `precio_unitario`.

    ```sql
    -- Tu código aquí
    ```

3.  **Pedidos de una Ciudad Específica**
    *   **Tarea**: Obtené una lista de todos los pedidos (`id`, `fecha`, `total`) realizados por clientes que son de la ciudad de 'Buenos Aires'.
    *   **Pista**: Necesitás unir `pedidos` y `clientes` y luego filtrar con `WHERE`.

    ```sql
    -- Tu código aquí
    ```

### Parte 2: `LEFT JOIN` - Incluyendo Todo Desde la Izquierda

El `LEFT JOIN` es ideal para cuando querés asegurarte de no perder ningún registro de tu tabla principal (la de la izquierda).

4.  **Todos los Clientes y sus Pedidos**
    *   **Tarea**: Escribí una consulta que liste a **TODOS** los clientes (`nombre` y `email`). Para cada cliente, mostrá el `id` y la `fecha` de cada pedido que haya realizado. Los clientes sin pedidos deben aparecer en la lista.

    ```sql
    -- Tu código aquí
    ```

5.  **Todos los Productos y sus Ventas**
    *   **Tarea**: Escribí una consulta que liste **TODOS** los productos (`nombre` y `precio`). Para cada producto, mostrá la `cantidad` de unidades vendidas de la tabla `pedido_items`. Los productos que nunca se han vendido deben aparecer.

    ```sql
    -- Tu código aquí
    ```

6.  **Contando Pedidos por Cliente**
    *   **Tarea**: Mejorá la consulta del ejercicio 4. En lugar de mostrar cada pedido, contá cuántos pedidos ha hecho cada cliente. La lista debe incluir a todos los clientes, incluso a los que tienen 0 pedidos.
    *   **Pista**: Necesitarás `GROUP BY` y `COUNT()`.

    ```sql
    -- Tu código aquí
    ```

---

## 💡 Soluciones Propuestas

<details>
<summary>Click para ver la solución</summary>

```sql
-- 1. Reporte de Pedidos con Nombres de Clientes
SELECT 
    p.id as pedido_id,
    p.fecha,
    p.total,
    c.nombre as cliente_nombre
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id;


-- 2. Items Vendidos con Nombre de Producto
SELECT 
    pr.nombre as producto,
    pi.cantidad,
    pi.precio_unitario
FROM pedido_items pi
INNER JOIN productos pr ON pi.producto_id = pr.id;


-- 3. Pedidos de una Ciudad Específica
SELECT 
    p.id as pedido_id,
    p.fecha,
    p.total
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
WHERE c.ciudad = 'Buenos Aires';


-- 4. Todos los Clientes y sus Pedidos
SELECT
    c.nombre,
    c.email,
    p.id as pedido_id,
    p.fecha
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id;


-- 5. Todos los Productos y sus Ventas
SELECT
    pr.nombre,
    pr.precio,
    pi.cantidad
FROM productos pr
LEFT JOIN pedido_items pi ON pr.id = pi.producto_id;


-- 6. Contando Pedidos por Cliente
SELECT
    c.nombre,
    c.email,
    COUNT(p.id) as cantidad_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, c.email
ORDER BY cantidad_pedidos DESC;

```

</details>
