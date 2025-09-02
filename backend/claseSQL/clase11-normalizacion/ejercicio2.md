# Ejercicio 2: Normalizando un Registro de Pedidos

## 🎯 Objetivo

Practicar la identificación y resolución de violaciones de la Segunda Forma Normal (2NF) y Tercera Forma Normal (3NF) en una tabla con una clave primaria compuesta.

---

## 📖 Escenario: Una Tabla de Detalles de Pedidos Problemática

Una tienda online tiene una tabla para registrar los productos dentro de cada pedido. El diseño actual tiene una clave primaria compuesta por `(pedido_id, producto_id)`, pero incluye más datos de los que debería, causando redundancia.

**Tabla `pedido_detalles_raw` (No Normalizada):**

| pedido_id | producto_id | producto_nombre | categoria_nombre | cliente_id | cliente_nombre | cantidad | precio_unitario |
|---|---|---|---|---|---|---|---|
| 1001 | P01 | Laptop Gamer | Computación | C01 | Juan Pérez | 1 | 1500.00 |
| 1001 | P02 | Mouse RGB | Accesorios | C01 | Juan Pérez | 1 | 50.00 |
| 1002 | P01 | Laptop Gamer | Computación | C02 | Ana Gómez | 2 | 1450.00 |
| 1003 | P03 | Teclado Mecánico | Accesorios | C01 | Juan Pérez | 1 | 120.00 |

**Clave Primaria Compuesta**: `(pedido_id, producto_id)`

---

## 🏋️‍♀️ Tu Tarea

### Parte 1: Análisis de Dependencias

1.  **Analizá cada columna** que no forma parte de la clave primaria.
2.  **Identificá las Dependencias Parciales (Violación de 2NF)**: ¿Qué columnas dependen solo de `producto_id` y no de la clave completa? ¿Qué columnas dependen solo de `pedido_id`?
3.  **Identificá las Dependencias Transitivas (Violación de 3NF)**: ¿Hay alguna columna que dependa de otra columna que no sea la clave? (En este ejemplo, no hay violaciones claras de 3NF, pero es bueno buscar).

### Parte 2: Diseño del Esquema Normalizado

Diseñá un esquema de base de datos que corrija los problemas. Deberías terminar con al menos cuatro tablas: una para los productos, una para los clientes, una para la cabecera de los pedidos y otra para los items de cada pedido.

*   **Tabla 1**: Para **Productos**.
*   **Tabla 2**: Para **Clientes**.
*   **Tabla 3**: Para **Pedidos** (la información general del pedido).
*   **Tabla 4**: Para **Pedido_Items** (la tabla de unión que resuelve la violación de 2NF).

### Parte 3: Creación de las Tablas

Escribí las sentencias `CREATE TABLE` para tu nuevo esquema normalizado. Presta especial atención a:

*   Definir las `PRIMARY KEY` correctas (simples o compuestas).
*   Establecer las `FOREIGN KEY` para conectar las tablas.
*   Usar `NOT NULL` y `UNIQUE` donde corresponda.

```sql
-- Tu CREATE TABLE para Productos


-- Tu CREATE TABLE para Clientes


-- Tu CREATE TABLE para Pedidos


-- Tu CREATE TABLE para Pedido_Items

```

---

## 💡 Solución Propuesta

<details>
<summary>Click para ver la solución</summary>

### Análisis del Problema (Solución)

1.  **Dependencias Parciales (Violación de 2NF)**:
    *   `producto_nombre` y `categoria_nombre` dependen **solo de `producto_id`**. No tiene sentido repetir "Laptop Gamer" en cada pedido que la incluya.
    *   `cliente_id` y `cliente_nombre` dependen **solo de `pedido_id`**. La información del cliente está relacionada con el pedido en general, no con cada producto individual dentro de él.
2.  **Dependencias Transitivas (Violación de 3NF)**: No hay dependencias transitivas obvias en este conjunto de datos. Por ejemplo, si tuviéramos `cliente_ciudad`, dependería de `cliente_id`, lo que sería una dependencia transitiva en la tabla original.

### Creación de Tablas (Solución)

```sql
-- Tabla para Productos (resuelve la dependencia parcial de producto)
CREATE TABLE productos (
    id TEXT PRIMARY KEY, -- P01, P02, etc.
    nombre TEXT NOT NULL,
    categoria TEXT NOT NULL,
    precio_actual REAL NOT NULL
);

-- Tabla para Clientes (se separa para evitar redundancia)
CREATE TABLE clientes (
    id TEXT PRIMARY KEY, -- C01, C02, etc.
    nombre TEXT NOT NULL
);

-- Tabla para Pedidos (la cabecera de la orden)
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY, -- 1001, 1002, etc.
    cliente_id TEXT NOT NULL,
    fecha_pedido DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Tabla para Pedido_Items (la tabla de unión, ahora en 2NF y 3NF)
CREATE TABLE pedido_items (
    pedido_id INTEGER NOT NULL,
    producto_id TEXT NOT NULL,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario REAL NOT NULL, -- Se guarda el precio al momento de la compra
    
    PRIMARY KEY (pedido_id, producto_id),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

```

</details>
