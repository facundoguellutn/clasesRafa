# Ejercicio 2: Creación de Índices Compuestos

## 🎯 Objetivo

Entender cuándo y cómo crear índices compuestos para optimizar consultas que filtran y/u ordenan por múltiples columnas, prestando especial atención al orden de las columnas en el índice.

---

## 🚀 Setup

Continuá usando el esquema de e-commerce de la Clase 14 en [sqlsandbox.com](https://sqlsandbox.com). Si ya creaste los índices del ejercicio anterior, no hay problema.

---

## 🏋️‍♀️ Ejercicios

### Consulta 1: Filtrar Productos por Categoría y Precio

**Escenario**: Un usuario quiere ver todos los productos de la categoría 'Computación' (`categoria_id = 2`) que cuesten menos de $100,000, ordenados del más caro al más barato.

**Consulta Lenta:**
```sql
EXPLAIN QUERY PLAN
SELECT nombre, precio_venta 
FROM productos 
WHERE categoria_id = 2 AND precio_venta < 100000
ORDER BY precio_venta DESC;
```

**Tu Tarea:**

1.  **Análisis**: ¿Por qué un índice simple en `categoria_id` y otro en `precio_venta` no es lo más óptimo? (Pista: la base de datos solo puede usar un índice por búsqueda de tabla).
2.  **Solución**: Creá un único **índice compuesto** que optimice esta consulta de la mejor manera posible.
3.  **Justificación**: Explicá brevemente por qué elegiste el orden de las columnas en tu índice compuesto. ¿Qué columna va primero y por qué?
4.  **Verificación**: Ejecutá `EXPLAIN QUERY PLAN` de nuevo y observá cómo el plan de ejecución ha mejorado.

```sql
-- Tu sentencia CREATE INDEX aquí


-- Tu justificación aquí (en un comentario)

```

### Consulta 2: Búsqueda de Pedidos por Estado y Fecha

**Escenario**: El equipo de logística necesita ver todos los pedidos que están en estado 'enviado' y que se realizaron en el último mes para hacer un seguimiento.

**Consulta Lenta:**
```sql
EXPLAIN QUERY PLAN
SELECT numero_pedido, fecha_pedido, total
FROM pedidos
WHERE estado = 'enviado' AND fecha_pedido >= '2024-02-01';
```

**Tu Tarea:**

1.  **Solución**: Creá el índice compuesto más eficiente para esta consulta.
2.  **Pregunta de Seguimiento**: Si crearas el índice como `(fecha_pedido, estado)`, ¿sería igual de eficiente para esta consulta? ¿Y para una consulta que solo filtre por `estado`? ¿Por qué?

```sql
-- Tu sentencia CREATE INDEX aquí


-- Tu respuesta a la pregunta de seguimiento aquí (en un comentario)

```

### Desafío: Índice para JOIN y Filtro

**Escenario**: Queremos encontrar todos los items del producto 'Laptop Business Pro' (`producto_id = 5`) que se vendieron en pedidos realizados por el cliente 'Juan Carlos Pérez' (`cliente_id = 1`).

**Consulta Lenta:**
```sql
EXPLAIN QUERY PLAN
SELECT pi.cantidad, pi.precio_unitario
FROM pedido_items pi
INNER JOIN pedidos p ON pi.pedido_id = p.id
WHERE pi.producto_id = 5 AND p.cliente_id = 1;
```

**Tu Tarea:**

1.  **Análisis**: Esta consulta involucra dos tablas. ¿En qué columnas de qué tablas se están haciendo los filtros y las uniones?
2.  **Solución**: Creá los índices (pueden ser simples o compuestos) que creas necesarios en las tablas `pedido_items` y `pedidos` para hacer esta consulta lo más rápida posible.

```sql
-- Tus sentencias CREATE INDEX aquí

```

---

## 💡 Soluciones Propuestas

<details>
<summary>Click para ver la solución</summary>

```sql
-- --- Consulta 1: Solución ---
CREATE INDEX idx_productos_categoria_precio ON productos(categoria_id, precio_venta DESC);

-- Justificación: Se pone 'categoria_id' primero porque es una igualdad (=), lo que permite a la base de datos acotar el conjunto de búsqueda a un grupo muy pequeño de inmediato. Luego, dentro de ese grupo, el índice ya está ordenado por 'precio_venta', por lo que la parte de ORDER BY es casi instantánea y no requiere un paso de ordenamiento adicional.


-- --- Consulta 2: Solución ---
CREATE INDEX idx_pedidos_estado_fecha ON pedidos(estado, fecha_pedido);

-- Respuesta a la pregunta: Un índice en (fecha_pedido, estado) no sería tan eficiente. La consulta filtra primero por 'estado', que tiene una cardinalidad más baja (pocos valores únicos). El índice (estado, fecha_pedido) permite a la DB saltar directamente a las filas de 'enviado' y luego buscar por fecha. Un índice en (fecha_pedido, estado) no sería útil para una consulta que solo filtre por 'estado', debido al orden de las columnas.


-- --- Desafío: Solución ---
-- Análisis: El JOIN se hace sobre pedido_items.pedido_id y pedidos.id.
-- El filtro se hace sobre pedido_items.producto_id y pedidos.cliente_id.
-- Por lo tanto, necesitamos buenos índices en esas cuatro columnas.

-- Índice para encontrar rápidamente los pedidos del cliente
CREATE INDEX idx_pedidos_cliente_id ON pedidos(cliente_id);

-- Índice para encontrar rápidamente los items del producto
CREATE INDEX idx_pedido_items_producto_id ON pedido_items(producto_id);

-- Nota: Un índice en pedido_items.pedido_id también es crucial, pero ya debería existir por ser una FK.

```

</details>
