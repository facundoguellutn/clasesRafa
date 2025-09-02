# Ejercicio 3: JOINs Avanzados y Casos de Uso Analíticos

## 🎯 Objetivo

Utilizar `JOINs` para resolver problemas de negocio más complejos, incluyendo el análisis de rendimiento, la segmentación de clientes y la técnica de `SELF JOIN` para analizar relaciones dentro de una misma tabla.

---

## 🚀 Setup

Continuá usando el esquema de e-commerce de la Clase 10 en [sqlsandbox.com](https://sqlsandbox.com). Para el ejercicio de `SELF JOIN`, copiaremos y pegaremos una nueva tabla de empleados.

---

## 🏋️‍♀️ Ejercicios

### Parte 1: Consultas Analíticas

1.  **Ranking de Clientes por Gasto Total**
    *   **Tarea**: Generá un "Top 5" de clientes que más han gastado en la tienda. El reporte debe mostrar el `nombre` del cliente, su `ciudad`, la `cantidad de pedidos` que ha realizado y el `total gastado`.
    *   **Pista**: Necesitarás unir `clientes` y `pedidos`, agrupar por cliente, y luego ordenar y limitar los resultados.

    ```sql
    -- Tu código aquí
    ```

2.  **Análisis de Productos por Pedido**
    *   **Tarea**: Para cada pedido, calculá el número de productos diferentes (`items`) y la cantidad total de unidades. Mostrá el `id` del pedido, el `nombre` del cliente, el `número de items distintos` y la `cantidad total de unidades`.
    *   **Pista**: Uní `pedidos`, `clientes` y `pedido_items`. Agrupá por pedido y usá `COUNT(DISTINCT ...)` y `SUM()`.

    ```sql
    -- Tu código aquí
    ```

### Parte 2: El `SELF JOIN`

Imaginá que tenemos una tabla de empleados con una estructura jerárquica.

**Setup para este ejercicio**: Copiá y pegá esta tabla en SQLSandbox.
```sql
CREATE TABLE empleados (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    puesto TEXT NOT NULL,
    manager_id INTEGER REFERENCES empleados(id) -- Clave foránea a sí misma
);

INSERT INTO empleados (id, nombre, puesto, manager_id) VALUES
(1, 'Carlos Director', 'CEO', NULL),
(2, 'Ana Gerente', 'Gerente de Ventas', 1),
(3, 'Luis Vendedor', 'Vendedor', 2),
(4, 'Maria Vendedora', 'Vendedor', 2),
(5, 'Pedro Gerente', 'Gerente de Marketing', 1);
```

3.  **Listar Empleados con sus Jefes**
    *   **Tarea**: Escribí una consulta que muestre el `nombre` de cada empleado y, al lado, el `nombre` de su jefe (manager). El CEO, que no tiene jefe, también debe aparecer en la lista (con su jefe como `NULL`).
    *   **Pista**: Necesitás hacer un `LEFT JOIN` de la tabla `empleados` consigo misma, usando alias diferentes (ej: `e` para empleado y `j` para jefe).

    ```sql
    -- Tu código aquí
    ```

### Desafío Final

4.  **Clientes que Compraron un Producto Específico**
    *   **Tarea**: Obtené una lista de todos los clientes (`nombre` y `email`) que han comprado el producto con el nombre 'Laptop Pro'.
    *   **Pista**: Esta es una consulta de "embudo" que requiere unir 4 tablas. Empezá en `productos`, filtrá por el nombre, y luego uní hacia `pedido_items`, `pedidos` y finalmente `clientes`.

    ```sql
    -- Tu código aquí
    ```

---

## 💡 Soluciones Propuestas

<details>
<summary>Click para ver la solución</summary>

```sql
-- 1. Ranking de Clientes por Gasto Total
SELECT
    c.nombre as cliente,
    c.ciudad,
    COUNT(p.id) as cantidad_pedidos,
    SUM(p.total) as total_gastado
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, c.ciudad
ORDER BY total_gastado DESC
LIMIT 5;


-- 2. Análisis de Productos por Pedido
SELECT
    p.id as pedido_id,
    c.nombre as cliente,
    COUNT(DISTINCT pi.producto_id) as items_distintos,
    SUM(pi.cantidad) as total_unidades
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
INNER JOIN pedido_items pi ON p.id = pi.pedido_id
GROUP BY p.id, c.nombre
ORDER BY total_unidades DESC;


-- 3. Listar Empleados con sus Jefes (SELF JOIN)
SELECT
    e.nombre as empleado,
    j.nombre as jefe
FROM empleados e
LEFT JOIN empleados j ON e.manager_id = j.id;


-- 4. Desafío: Clientes que Compraron un Producto Específico
SELECT DISTINCT
    c.nombre,
    c.email
FROM productos pr
INNER JOIN pedido_items pi ON pr.id = pi.producto_id
INNER JOIN pedidos p ON pi.pedido_id = p.id
INNER JOIN clientes c ON p.cliente_id = c.id
WHERE pr.nombre = 'Laptop Pro';

```

</details>
