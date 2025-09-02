# Ejercicio 2: Normalización y Creación de un Esquema Relacional

## 🎯 Objetivo

Practicar el proceso de normalización de datos. A partir de una tabla "plana" (desnormalizada), diseñarás un esquema relacional correcto, crearás las tablas con sus claves primarias y foráneas, y añadirás los índices necesarios.

---

## 📖 Escenario: Datos de Ventas en una Sola Tabla

Imaginá que te dan un archivo CSV con datos de ventas y lo importas a una única tabla `ventas_raw`. La tabla se ve así:

```sql
CREATE TABLE ventas_raw (
    id_venta INTEGER,
    fecha TEXT,
    cliente_nombre TEXT,
    cliente_email TEXT,
    producto_nombre TEXT,
    producto_categoria TEXT,
    producto_precio REAL,
    cantidad INTEGER
);

INSERT INTO ventas_raw VALUES
(1, '2024-08-01', 'Juan Pérez', 'juan@email.com', 'Laptop Pro', 'Electrónica', 1200.00, 1),
(2, '2024-08-01', 'Ana Gómez', 'ana@email.com', 'Mouse Inalámbrico', 'Accesorios', 25.50, 2),
(3, '2024-08-02', 'Juan Pérez', 'juan@email.com', 'Teclado Mecánico', 'Accesorios', 95.00, 1),
(4, '2024-08-03', 'Carlos Ruiz', 'carlos@email.com', 'Laptop Pro', 'Electrónica', 1200.00, 1);
```

**Problemas de este diseño:**
*   **Redundancia**: El nombre y email de Juan Pérez están repetidos. El nombre y precio de la "Laptop Pro" están repetidos.
*   **Anomalías de Actualización**: Si Juan cambia su email, hay que actualizarlo en múltiples filas.
*   **Anomalías de Inserción**: No podés agregar un producto nuevo si no ha sido vendido todavía.
*   **Anomalías de Borrado**: Si borrás la única venta de Ana Gómez, perdés la información de Ana Gómez como clienta.

---

## 🏋️‍♀️ Tu Tarea

Tu trabajo es normalizar este diseño creando un esquema relacional correcto.

### Parte 1: Diseño y Creación de Tablas

1.  **Diseñá las tablas**: Identificá las entidades principales. Necesitarás al menos tres: `clientes`, `productos` y `ventas`.

2.  **Creá la tabla `clientes`**: Debe tener `id`, `nombre` y `email` (único).

3.  **Creá la tabla `productos`**: Debe tener `id`, `nombre` (único), `categoria` y `precio`.

4.  **Creá la tabla `ventas`**: Esta será la tabla principal que conecta todo. Debe tener `id`, `cliente_id` (FK), `fecha_venta` y `total_venta`.

5.  **Desafío - Tabla de Unión**: ¿Cómo manejás la cantidad y el producto específico en cada venta? Necesitarás una tabla de unión `ventas_items` para una relación N:M entre `ventas` y `productos`. Debería tener `id`, `venta_id` (FK), `producto_id` (FK) y `cantidad`.

Escribí las sentencias `CREATE TABLE` para todas estas tablas, incluyendo `PRIMARY KEY` y `FOREIGN KEY`.

```sql
-- Tu código para crear 'clientes'

-- Tu código para crear 'productos'

-- Tu código para crear 'ventas'

-- Tu código para crear 'ventas_items'

```

### Parte 2: Creación de Índices

Una vez creadas las tablas, decidí qué índices son necesarios para un buen rendimiento y escribí las sentencias `CREATE INDEX`.

*   **Pista**: Las claves foráneas son siempre buenas candidatas para tener un índice.
*   ¿Qué otras columnas se usarían frecuentemente en cláusulas `WHERE`?

```sql
-- Tus sentencias CREATE INDEX aquí

```

---

## 💡 Solución Propuesta

<details>
<summary>Click para ver la solución</summary>

```sql
-- --- PARTE 1: DISEÑO Y CREACIÓN DE TABLAS ---

-- Tabla de Clientes
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
);

-- Tabla de Productos
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    categoria TEXT NOT NULL,
    precio REAL NOT NULL CHECK (precio > 0)
);

-- Tabla de Ventas (representa una transacción única)
CREATE TABLE ventas (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    fecha_venta DATE DEFAULT CURRENT_DATE,
    total_venta REAL NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Tabla de Unión (los items dentro de cada venta)
CREATE TABLE ventas_items (
    id INTEGER PRIMARY KEY,
    venta_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario REAL NOT NULL, -- Guardamos el precio al momento de la venta
    FOREIGN KEY (venta_id) REFERENCES ventas(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);


-- --- PARTE 2: CREACIÓN DE ÍNDICES ---

-- Índices en las Foreign Keys para acelerar los JOINs
CREATE INDEX idx_ventas_cliente_id ON ventas(cliente_id);
CREATE INDEX idx_ventas_items_venta_id ON ventas_items(venta_id);
CREATE INDEX idx_ventas_items_producto_id ON ventas_items(producto_id);

-- Índices en columnas que probablemente se usarán para buscar
CREATE INDEX idx_clientes_email ON clientes(email);
CREATE INDEX idx_productos_nombre ON productos(nombre);
CREATE INDEX idx_productos_categoria ON productos(categoria);
CREATE INDEX idx_ventas_fecha ON ventas(fecha_venta);

```

</details>
