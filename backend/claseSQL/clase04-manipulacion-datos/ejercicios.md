# Ejercicios Clase 4 - Manipulación de Datos

## 🚀 Setup Inicial
1. Abrir [sqlsandbox.com](https://sqlsandbox.com)
2. Copiar y pegar el contenido de `sqlsandbox-setup.sql`
3. Hacer click en "Run" para crear las tablas con datos

---

## 🏋️ Ejercicios Nivel Básico - INSERT

### Ejercicio 1: Insertar Productos Nuevos
```sql
-- 1.1 Agregar un smartwatch
INSERT INTO productos (nombre, categoria, precio, stock, descripcion) 
VALUES ('Apple Watch Series 8', 'Accesorios', 45000.00, 7, 'Smartwatch con monitoreo de salud');

-- 1.2 Agregar un producto solo con datos básicos
INSERT INTO productos (nombre, categoria, precio) 
VALUES ('Cargador Universal', 'Accesorios', 1500.00);

-- 1.3 Agregar múltiples productos de gaming
INSERT INTO productos (nombre, categoria, precio, stock, descripcion) VALUES 
('PlayStation 5', 'Gaming', 85000.00, 2, 'Consola de videojuegos última generación'),
('Xbox Series X', 'Gaming', 80000.00, 3, 'Consola Microsoft con 4K gaming'),
('Nintendo Switch', 'Gaming', 55000.00, 5, 'Consola híbrida portátil/sobremesa');
```

**Verificación:** Deberías tener 13 productos en total
```sql
SELECT COUNT(*) as total_productos FROM productos;
```

### Ejercicio 2: Intentar Inserciones Inválidas
```sql
-- 2.1 ¿Qué pasa con precio negativo?
INSERT INTO productos (nombre, precio) VALUES ('Producto Test', -100.00);

-- 2.2 ¿Qué pasa sin nombre (campo NOT NULL)?
INSERT INTO productos (categoria, precio) VALUES ('Test', 50.00);

-- 2.3 ¿Qué pasa con email duplicado en clientes?
INSERT INTO clientes (nombre, email) VALUES ('Juan Duplicado', 'juan@email.com');
```

---

## 🏋️ Ejercicios Nivel Intermedio - UPDATE

### Ejercicio 3: Actualizar Precios
```sql
-- 3.1 Subir precio del iPhone 13 a $125,000
UPDATE productos 
SET precio = 125000.00, fecha_actualizacion = CURRENT_DATE
WHERE nombre = 'iPhone 13';

-- 3.2 Aplicar descuento del 10% a todos los accesorios
UPDATE productos 
SET precio = precio * 0.9, fecha_actualizacion = CURRENT_DATE 
WHERE categoria = 'Accesorios';

-- 3.3 Actualizar stock después de ventas
UPDATE productos SET stock = stock - 1 WHERE nombre = 'MacBook Air';
UPDATE productos SET stock = stock - 2 WHERE nombre = 'AirPods Pro';
```

### Ejercicio 4: Actualizaciones Condicionales
```sql
-- 4.1 Marcar productos con stock bajo (<=2) como "Stock Crítico"
UPDATE productos 
SET descripcion = descripcion || ' - STOCK CRÍTICO'
WHERE stock <= 2;

-- 4.2 Aplicar descuento especial a productos caros (>$100,000)
UPDATE productos 
SET precio = precio * 0.95 
WHERE precio > 100000;

-- 4.3 Actualizar información de cliente
UPDATE clientes 
SET telefono = '11-0000-0000', activo = TRUE 
WHERE email = 'maria@email.com';
```

**Verificación:** Ver productos con descuentos aplicados
```sql
SELECT nombre, precio, descripcion FROM productos WHERE precio < 100000;
```

---

## 🏋️ Ejercicios Nivel Avanzado - DELETE

### Ejercicio 5: Eliminar Registros (Cuidadosamente)
```sql
-- 5.1 Primero, ver qué productos tienen stock 0
SELECT * FROM productos WHERE stock = 0;

-- 5.2 Eliminar productos sin stock (si los hay)
DELETE FROM productos WHERE stock = 0;

-- 5.3 Ver productos de una categoría específica antes de eliminar
SELECT * FROM productos WHERE categoria = 'Gaming';

-- 5.4 Eliminar un producto específico por ID
-- (Primero asegurate de ver cuál ID querés eliminar)
SELECT id, nombre FROM productos WHERE nombre LIKE '%Nintendo%';
-- Luego eliminar:
DELETE FROM productos WHERE id = [ID_QUE_VISTE];
```

### Ejercicio 6: Soft Delete (Alternativa Segura)
```sql
-- 6.1 En lugar de eliminar, marcar productos como inactivos
UPDATE productos 
SET activo = FALSE, fecha_actualizacion = CURRENT_DATE
WHERE precio < 2000;

-- 6.2 Ver productos activos vs inactivos
SELECT 'ACTIVOS' as estado, COUNT(*) as cantidad FROM productos WHERE activo = TRUE
UNION ALL
SELECT 'INACTIVOS' as estado, COUNT(*) as cantidad FROM productos WHERE activo = FALSE;

-- 6.3 "Reactivar" un producto
UPDATE productos 
SET activo = TRUE 
WHERE nombre = 'Cargador Universal';
```

---

## 🔥 Ejercicios Desafío

### Desafío 1: Simulación de Ventas
```sql
-- Simular la venta de 3 productos:
-- 1. Reducir stock
-- 2. Actualizar fecha de modificación
-- 3. Si el stock llega a 0, marcar como inactivo

-- Venta de 2 iPhone 13
UPDATE productos 
SET stock = stock - 2, fecha_actualizacion = CURRENT_DATE
WHERE nombre = 'iPhone 13';

-- Venta del último MacBook Air (stock era 2, vendemos 2)
UPDATE productos 
SET stock = stock - 2, fecha_actualizacion = CURRENT_DATE
WHERE nombre = 'MacBook Air';

-- Si stock = 0, marcar como inactivo
UPDATE productos 
SET activo = FALSE 
WHERE stock = 0;
```

### Desafío 2: Gestión de Clientes
```sql
-- Agregar 3 clientes nuevos con datos completos
INSERT INTO clientes (nombre, email, telefono) VALUES 
('Roberto Silva', 'roberto@email.com', '11-7777-7777'),
('Laura Torres', 'laura@email.com', '11-8888-8888'),
('Diego Fernández', 'diego@email.com', '11-6666-6666');

-- Actualizar información de contacto de un cliente existente
UPDATE clientes 
SET telefono = '11-1111-1111' 
WHERE nombre = 'Juan Pérez';

-- Marcar un cliente como inactivo (soft delete)
UPDATE clientes 
SET activo = FALSE 
WHERE email = 'carlos@email.com';
```

### Desafío 3: Operaciones Combinadas
```sql
-- Crear una "categoría nueva" con productos promocionales

-- 1. Insertar productos en promoción
INSERT INTO productos (nombre, categoria, precio, stock, descripcion) VALUES 
('Oferta Combo Mouse+Teclado', 'Promoción', 8000.00, 10, 'Pack especial con descuento'),
('Liquidación Tablet', 'Promoción', 25000.00, 3, 'Tablet Android en liquidación');

-- 2. Aplicar descuento adicional del 20%
UPDATE productos 
SET precio = precio * 0.8, descripcion = descripcion || ' - 20% OFF EXTRA'
WHERE categoria = 'Promoción';

-- 3. Ver el resultado
SELECT nombre, precio, descripcion FROM productos WHERE categoria = 'Promoción';
```

---

## 🧪 Ejercicios de Verificación

### Verificación 1: Integridad de Datos
```sql
-- Verificar que no hay productos con precio negativo
SELECT COUNT(*) as productos_precio_negativo 
FROM productos 
WHERE precio <= 0;
-- Debería ser 0

-- Verificar que no hay productos sin nombre
SELECT COUNT(*) as productos_sin_nombre 
FROM productos 
WHERE nombre IS NULL OR nombre = '';
-- Debería ser 0
```

### Verificación 2: Estado del Inventario
```sql
-- Resumen del inventario actual
SELECT 
    categoria,
    COUNT(*) as cantidad_productos,
    SUM(stock) as stock_total,
    AVG(precio) as precio_promedio
FROM productos 
WHERE activo = TRUE
GROUP BY categoria
ORDER BY cantidad_productos DESC;
```

### Verificación 3: Productos Críticos
```sql
-- Productos que necesitan restock (stock bajo)
SELECT nombre, categoria, stock, precio 
FROM productos 
WHERE stock <= 2 AND activo = TRUE
ORDER BY stock ASC;
```

---

## ✅ Auto-evaluación

**Marcá si podés hacer esto sin mirar:**
- [ ] Insertar un producto nuevo con todos los campos
- [ ] Insertar múltiples productos en una sola query
- [ ] Actualizar el precio de un producto específico
- [ ] Aplicar descuento porcentual a una categoría
- [ ] Eliminar productos con condiciones específicas
- [ ] Usar soft delete en lugar de DELETE
- [ ] Verificar cambios antes de confirmarlos

### Test Final
```sql
-- ¿Podés resolver esto paso a paso?

-- 1. Agregar un producto nuevo
INSERT INTO productos (nombre, categoria, precio, stock) 
VALUES ('Test Product', 'Test', 100.00, 5);

-- 2. Aplicarle un descuento del 50%
UPDATE productos SET precio = precio * 0.5 WHERE nombre = 'Test Product';

-- 3. Reducir su stock en 2 unidades
UPDATE productos SET stock = stock - 2 WHERE nombre = 'Test Product';

-- 4. Ver el resultado
SELECT * FROM productos WHERE nombre = 'Test Product';

-- 5. Eliminarlo (cleanup)
DELETE FROM productos WHERE nombre = 'Test Product';

-- 6. Verificar que se eliminó
SELECT COUNT(*) FROM productos WHERE nombre = 'Test Product'; -- Debería ser 0
```

---

## 🏠 Tarea Para Casa

### Proyecto: Sistema de Inventario Personal
Creá tu propio sistema para algo que te interese:

**Opción A: Equipamiento Deportivo (Volley)**
```sql
CREATE TABLE equipamiento (
    id INTEGER PRIMARY KEY,
    tipo TEXT NOT NULL, -- 'Pelota', 'Red', 'Uniforme', 'Protectores'
    marca TEXT,
    modelo TEXT,
    estado TEXT CHECK (estado IN ('Nuevo', 'Bueno', 'Regular', 'Malo')),
    precio REAL CHECK (precio > 0),
    fecha_compra DATE,
    activo BOOLEAN DEFAULT TRUE,
    observaciones TEXT
);
```

**Opción B: Biblioteca de Juegos**
```sql
CREATE TABLE juegos (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    plataforma TEXT, -- 'PC', 'PS5', 'Xbox', 'Switch'
    genero TEXT,
    precio REAL,
    completado BOOLEAN DEFAULT FALSE,
    calificacion INTEGER CHECK (calificacion >= 1 AND calificacion <= 10),
    fecha_compra DATE,
    tiempo_jugado INTEGER DEFAULT 0
);
```

**Tareas a completar:**
1. Insertar 15 elementos iniciales
2. Simular 5 actualizaciones diferentes
3. Hacer 2 eliminaciones (una hard delete, una soft delete)
4. Crear 3 consultas de análisis (productos más caros, por categoría, etc.)
5. Documentar cada paso que hiciste

---

## 🎯 Próxima Clase

En la **Clase 5** vamos a consolidar todo con un proyecto real de Biblioteca Personal, incluyendo:
- Relaciones entre tablas (libros ↔ autores)
- CRUD completo con validaciones
- Consultas complejas
- Buenas prácticas en un proyecto real

**¡Excelente progreso! Ya manejás todas las operaciones básicas de manipulación de datos.**