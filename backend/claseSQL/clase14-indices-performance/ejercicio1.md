# Ejercicio 1: Diagnóstico y Creación de Índices Simples

## 🎯 Objetivo

Utilizar `EXPLAIN QUERY PLAN` para diagnosticar consultas lentas que realizan un `SCAN` de tabla y solucionarlas creando el índice simple más adecuado.

---

## 🚀 Setup

1.  Abrí [sqlsandbox.com](https://sqlsandbox.com).
2.  Copiá y pegá el contenido completo de `sqlsandbox-setup.sql` de la Clase 14. Este script crea la base de datos de e-commerce pero **sin** los índices adicionales, para que puedas crearlos vos.
3.  Hacé click en "Run".

---

## 🏋️‍♀️ Ejercicios

Para cada una de las siguientes consultas, seguí estos 4 pasos:

1.  **Diagnóstico**: Escribí `EXPLAIN QUERY PLAN` antes de la consulta para ver su plan de ejecución. Verificá que está haciendo un `SCAN`.
2.  **Identificación**: Identificá la columna en la cláusula `WHERE` que está causando el escaneo completo.
3.  **Solución**: Escribí la sentencia `CREATE INDEX` para solucionar el problema.
4.  **Verificación**: Volvé a ejecutar `EXPLAIN QUERY PLAN` con la misma consulta y confirmá que ahora utiliza un `SEARCH` con tu nuevo índice.

### Consulta 1: Búsqueda de un Cliente por Email

Esta es una de las consultas más comunes en cualquier aplicación. Debe ser instantánea.

```sql
-- Paso 1: Diagnóstico
EXPLAIN QUERY PLAN
SELECT * FROM clientes WHERE email = 'juan.perez@email.com';

-- Paso 2: Identificación (la columna es 'email')

-- Paso 3: Solución (Creá el índice aquí)


-- Paso 4: Verificación
EXPLAIN QUERY PLAN
SELECT * FROM clientes WHERE email = 'juan.perez@email.com';
```

### Consulta 2: Búsqueda de Productos por Categoría

Un usuario hace clic en la categoría "Electrónicos" en la tienda online.

```sql
-- Paso 1: Diagnóstico
EXPLAIN QUERY PLAN
SELECT * FROM productos WHERE categoria_id = 1;

-- Paso 2: Identificación (la columna es 'categoria_id')

-- Paso 3: Solución (Creá el índice aquí)


-- Paso 4: Verificación
EXPLAIN QUERY PLAN
SELECT * FROM productos WHERE categoria_id = 1;
```

### Consulta 3: Búsqueda de Pedidos de un Cliente

Un usuario entra a su perfil para ver su historial de pedidos.

```sql
-- Paso 1: Diagnóstico
EXPLAIN QUERY PLAN
SELECT * FROM pedidos WHERE cliente_id = 5;

-- Paso 2: Identificación (la columna es 'cliente_id')

-- Paso 3: Solución (Creá el índice aquí)


-- Paso 4: Verificación
EXPLAIN QUERY PLAN
SELECT * FROM pedidos WHERE cliente_id = 5;
```

---

## 💡 Soluciones Propuestas

<details>
<summary>Click para ver la solución</summary>

```sql
-- --- Consulta 1: Solución ---
CREATE INDEX idx_clientes_email ON clientes(email);


-- --- Consulta 2: Solución ---
CREATE INDEX idx_productos_categoria_id ON productos(categoria_id);


-- --- Consulta 3: Solución ---
CREATE INDEX idx_pedidos_cliente_id ON pedidos(cliente_id);

```

**Resultados esperados en la verificación:**

Después de crear cada índice, el `EXPLAIN QUERY PLAN` debería cambiar de `SCAN TABLE ...` a algo como `SEARCH TABLE ... USING INDEX ...`.

</details>
