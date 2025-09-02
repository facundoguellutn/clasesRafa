# Ejercicio 3: Índices Avanzados - Cobertores y de Expresión

## 🎯 Objetivo

Explorar dos técnicas de indexación avanzadas: los índices cobertores (`Covering Indexes`) para evitar lecturas de tabla, y los índices de expresión para optimizar búsquedas que usan funciones.

---

## 🚀 Setup

Continuá usando el esquema de e-commerce de la Clase 14 en [sqlsandbox.com](https://sqlsandbox.com).

---

## 🏋️‍♀️ Ejercicios

### Parte 1: El Índice Cobertor (`Covering Index`)

Un índice cobertor es un índice que contiene todas las columnas necesarias para una consulta. Esto permite a la base de datos responder la consulta leyendo **únicamente el índice**, sin tener que acceder a la tabla principal, lo cual es extremadamente rápido.

**Escenario**: Tenemos una consulta muy frecuente que muestra el nombre y el precio de los productos de una categoría para renderizar una lista en la tienda.

**Consulta:**
```sql
SELECT nombre, precio_venta 
FROM productos 
WHERE categoria_id = 2;
```

**Tu Tarea:**

1.  **Diagnóstico Inicial**: Ejecutá `EXPLAIN QUERY PLAN` sobre la consulta. Si ya tenés un índice en `(categoria_id)`, el plan probablemente será `SEARCH TABLE productos USING INDEX ...`.
2.  **Creación del Índice Cobertor**: Creá un índice compuesto que incluya no solo la columna del `WHERE` (`categoria_id`), sino también las columnas del `SELECT` (`nombre`, `precio_venta`).
3.  **Verificación Final**: Volvé a ejecutar `EXPLAIN QUERY PLAN`. El resultado ahora debería incluir el texto `USING COVERING INDEX`, confirmando que la base de datos no necesita tocar la tabla `productos`.

```sql
-- Tu sentencia CREATE INDEX para el índice cobertor aquí


-- Ejecutá EXPLAIN QUERY PLAN de nuevo para ver el cambio
EXPLAIN QUERY PLAN
SELECT nombre, precio_venta 
FROM productos 
WHERE categoria_id = 2;
```

### Parte 2: Índices de Expresión

Los índices normales no funcionan si aplicas una función a la columna en la cláusula `WHERE`. Los índices de expresión resuelven este problema.

**Escenario**: El sistema permite a los usuarios buscar clientes por su email, pero la búsqueda no debe ser sensible a mayúsculas/minúsculas.

**Consulta Lenta:**
```sql
-- Aunque exista un índice en 'email', esta consulta no lo usará
-- porque se está aplicando la función LOWER() a la columna.
EXPLAIN QUERY PLAN
SELECT * FROM clientes WHERE LOWER(email) = 'juan.perez@email.com';
```

**Tu Tarea:**

1.  **Diagnóstico**: Confirmá que la consulta anterior realiza un `SCAN`.
2.  **Solución**: Creá un **índice de expresión** sobre la función `LOWER(email)`.
3.  **Verificación**: Ejecutá `EXPLAIN QUERY PLAN` de nuevo sobre la misma consulta. Ahora debería usar tu nuevo índice y realizar un `SEARCH`.

```sql
-- Tu sentencia CREATE INDEX de expresión aquí


-- Ejecutá EXPLAIN QUERY PLAN de nuevo para ver el cambio
EXPLAIN QUERY PLAN
SELECT * FROM clientes WHERE LOWER(email) = 'juan.perez@email.com';
```

### Desafío: Combinando Conceptos

**Escenario**: Queremos encontrar rápidamente todos los pedidos realizados en el año 2023.

**Consulta Lenta:**
```sql
EXPLAIN QUERY PLAN
SELECT numero_pedido, total
FROM pedidos
WHERE STRFTIME('%Y', fecha_pedido) = '2023';
```

**Tu Tarea:**

1.  **Creá un índice de expresión** que permita a la base de datos buscar eficientemente por el año de `fecha_pedido`.
2.  **Mejora (Opcional)**: ¿Podrías convertirlo en un índice cobertor para esta consulta específica?

```sql
-- Tu sentencia CREATE INDEX aquí

```

---

## 💡 Soluciones Propuestas

<details>
<summary>Click para ver la solución</summary>

```sql
-- --- Parte 1: Índice Cobertor ---
CREATE INDEX idx_productos_covering_cat_nombre_precio ON productos(categoria_id, nombre, precio_venta);

-- Al ejecutar EXPLAIN QUERY PLAN de nuevo, el plan debería ser:
-- SEARCH TABLE productos USING COVERING INDEX idx_productos_covering_cat_nombre_precio (categoria_id=?)


-- --- Parte 2: Índice de Expresión ---
CREATE INDEX idx_clientes_email_lower ON clientes(LOWER(email));

-- Al ejecutar EXPLAIN QUERY PLAN de nuevo, el plan debería ser:
-- SEARCH TABLE clientes USING INDEX idx_clientes_email_lower (lower(email)=?)


-- --- Desafío: Combinando Conceptos ---

-- Solución 1: Índice de expresión simple
CREATE INDEX idx_pedidos_año ON pedidos(STRFTIME('%Y', fecha_pedido));

-- Solución 2: Índice de expresión y cobertor
CREATE INDEX idx_pedidos_covering_año_num_total ON pedidos(STRFTIME('%Y', fecha_pedido), numero_pedido, total);

```

</details>
