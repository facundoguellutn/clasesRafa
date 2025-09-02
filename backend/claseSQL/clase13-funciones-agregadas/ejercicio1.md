# Ejercicio 1: Consultas de Agregación Básicas

## 🎯 Objetivo

Familiarizarse con las cinco funciones de agregación principales (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`) aplicándolas a todo el conjunto de datos o a un subconjunto filtrado con `WHERE`.

---

## 🚀 Setup

1.  Abrí [sqlsandbox.com](https://sqlsandbox.com).
2.  Copiá y pegá el contenido completo de `sqlsandbox-setup.sql` de la Clase 13.
3.  Hacé click en "Run" para crear el esquema de e-commerce con datos de ventas, productos y clientes.

---

## 🏋️‍♀️ Ejercicios

### Parte 1: `COUNT` - Respondiendo "¿Cuántos?"

1.  **Total de Clientes**: ¿Cuántos clientes hay registrados en total?
2.  **Clientes Activos**: ¿Cuántos clientes tienen el estado `activo = TRUE`?
3.  **Productos en Stock**: ¿Cuántos productos tienen un `stock` mayor a 0?
4.  **Regiones Únicas**: ¿De cuántas regiones (`region_id`) diferentes provienen nuestros clientes? (Pista: `COUNT(DISTINCT ...)`).

```sql
-- Escribí tus 4 consultas aquí

```

### Parte 2: `SUM` - Calculando Totales

5.  **Ingresos Totales**: ¿Cuál es la suma total de la columna `total` de todos los pedidos con estado 'entregado'?
6.  **Valor del Inventario**: ¿Cuál es el valor total del inventario? (Suma de `precio_costo * stock` para todos los productos).
7.  **Total de Unidades Vendidas**: ¿Cuál es la suma de `cantidad` de todos los productos en la tabla `pedido_items`?

```sql
-- Escribí tus 3 consultas aquí

```

### Parte 3: `AVG` - Encontrando el Promedio

8.  **Ticket Promedio**: ¿Cuál es el `total` promedio de los pedidos 'entregado'?
9.  **Edad Promedio del Cliente**: ¿Cuál es la edad promedio de todos los clientes?
10. **Precio Promedio de Venta**: ¿Cuál es el precio de venta (`precio_venta`) promedio de todos los productos de la categoría 'Computación' (`categoria_id` = 2)?

```sql
-- Escribí tus 3 consultas aquí

```

### Parte 4: `MAX` y `MIN` - Encontrando los Extremos

11. **Pedido Más Caro**: ¿Cuál fue el `total` del pedido más caro que se ha 'entregado'?
12. **Producto Más Barato**: ¿Cuál es el `precio_venta` del producto más barato?
13. **Cliente Más Antiguo**: ¿Cuál es la `fecha_registro` más antigua de un cliente?
14. **Última Venta**: ¿Cuál es la `fecha_pedido` más reciente?

```sql
-- Escribí tus 4 consultas aquí

```

---

## 💡 Soluciones Propuestas

<details>
<summary>Click para ver la solución</summary>

```sql
-- 1. Total de Clientes
SELECT COUNT(*) as total_clientes FROM clientes;

-- 2. Clientes Activos
SELECT COUNT(*) as clientes_activos FROM clientes WHERE activo = TRUE;

-- 3. Productos en Stock
SELECT COUNT(*) as productos_con_stock FROM productos WHERE stock > 0;

-- 4. Regiones Únicas
SELECT COUNT(DISTINCT region_id) as regiones_unicas FROM clientes;


-- 5. Ingresos Totales
SELECT SUM(total) as ingresos_totales FROM pedidos WHERE estado = 'entregado';

-- 6. Valor del Inventario
SELECT SUM(precio_costo * stock) as valor_total_inventario FROM productos;

-- 7. Total de Unidades Vendidas
SELECT SUM(cantidad) as total_unidades_vendidas FROM pedido_items;


-- 8. Ticket Promedio
SELECT AVG(total) as ticket_promedio FROM pedidos WHERE estado = 'entregado';

-- 9. Edad Promedio del Cliente
SELECT AVG(edad) as edad_promedio_clientes FROM clientes;

-- 10. Precio Promedio de Venta (Computación)
SELECT AVG(precio_venta) as precio_promedio_computacion FROM productos WHERE categoria_id = 2;


-- 11. Pedido Más Caro
SELECT MAX(total) as pedido_mas_caro FROM pedidos WHERE estado = 'entregado';

-- 12. Producto Más Barato
SELECT MIN(precio_venta) as producto_mas_barato FROM productos;

-- 13. Cliente Más Antiguo
SELECT MIN(fecha_registro) as primer_cliente_registrado FROM clientes;

-- 14. Última Venta
SELECT MAX(fecha_pedido) as ultima_venta FROM pedidos;

```

</details>
