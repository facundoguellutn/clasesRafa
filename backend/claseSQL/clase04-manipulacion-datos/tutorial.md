# Clase 4: Manipulación de Datos - INSERT, UPDATE, DELETE

## 🎯 Objetivos de la Clase

Al finalizar esta clase, Rafa será capaz de:
- Insertar nuevos registros con INSERT de forma segura
- Modificar registros existentes con UPDATE
- Eliminar registros con DELETE (con precauciones)
- Entender las implicaciones de cada operación
- Aplicar buenas prácticas de manipulación de datos

---

## 🚗 Contexto Real: Gestión de Inventario de Concesionaria

En tu concesionaria necesitás constantemente:
- **Agregar** nuevos vehículos que llegan
- **Actualizar** precios, kilometraje, estado de venta
- **Eliminar** registros de vehículos ya vendidos o dados de baja

**Estas operaciones son el corazón de cualquier sistema de gestión.**

---

## ➕ INSERT: Agregar Nuevos Registros

### Sintaxis Básica
```sql
INSERT INTO tabla (columna1, columna2, columna3) 
VALUES (valor1, valor2, valor3);
```

### Ejemplo Práctico
```sql
-- Agregar un nuevo vehículo a la concesionaria
INSERT INTO vehiculos (marca, modelo, año, precio, kilometraje, combustible, color) 
VALUES ('Toyota', 'Corolla', 2023, 25000.00, 0, 'Nafta', 'Blanco');
```

### Insertar Campos Específicos
```sql
-- Solo los campos obligatorios (los demás usan DEFAULT)
INSERT INTO vehiculos (marca, modelo, año, precio) 
VALUES ('Honda', 'Civic', 2022, 23000.00);
-- color será NULL, kilometraje será 0 (DEFAULT), vendido será FALSE (DEFAULT)
```

### Insertar Múltiples Registros
```sql
INSERT INTO vehiculos (marca, modelo, año, precio, kilometraje, combustible, color) VALUES 
('Ford', 'Focus', 2021, 19000.00, 25000, 'Nafta', 'Azul'),
('Chevrolet', 'Onix', 2022, 18500.00, 15000, 'Nafta', 'Rojo'),
('Volkswagen', 'Polo', 2020, 17000.00, 40000, 'Nafta', 'Gris');
```

### ⚠️ Errores Comunes con INSERT
```sql
-- ❌ MAL: No respetar constraints
INSERT INTO vehiculos (marca, modelo, año, precio) 
VALUES ('Tesla', 'Model 3', 2030, -5000);
-- Error: CHECK constraint failed (año > 2025, precio negativo)

-- ❌ MAL: Falta campo NOT NULL
INSERT INTO vehiculos (modelo, precio) 
VALUES ('Corolla', 20000);
-- Error: NOT NULL constraint failed: vehiculos.marca

-- ✅ BIEN: Respeta todas las reglas
INSERT INTO vehiculos (marca, modelo, año, precio) 
VALUES ('Tesla', 'Model 3', 2023, 45000);
```

---

## ✏️ UPDATE: Modificar Registros Existentes

### Sintaxis Básica
```sql
UPDATE tabla 
SET columna1 = valor1, columna2 = valor2 
WHERE condición;
```

### ⚠️ REGLA DE ORO: SIEMPRE USA WHERE
```sql
-- ❌ PELIGROSO: Actualiza TODOS los registros
UPDATE vehiculos SET precio = 15000;

-- ✅ SEGURO: Actualiza solo registros específicos
UPDATE vehiculos SET precio = 15000 WHERE id = 1;
```

### Ejemplos Prácticos

#### Actualizar Un Solo Campo
```sql
-- Cambiar el precio de un vehículo específico
UPDATE vehiculos 
SET precio = 16500.00 
WHERE id = 1;

-- Marcar un vehículo como vendido
UPDATE vehiculos 
SET vendido = TRUE 
WHERE id = 3;
```

#### Actualizar Múltiples Campos
```sql
-- Un cliente compró el auto: actualizar precio final y marcarlo como vendido
UPDATE vehiculos 
SET precio = 17000.00, vendido = TRUE, fecha_venta = CURRENT_DATE
WHERE id = 5;

-- Actualizar datos de un vehículo usado que llegó
UPDATE vehiculos 
SET kilometraje = 45000, precio = 14000.00, descripcion = 'Buen estado, único dueño'
WHERE marca = 'Ford' AND modelo = 'Focus' AND año = 2019;
```

#### Actualizaciones Condicionales
```sql
-- Aplicar descuento del 10% a vehículos con más de 2 años
UPDATE vehiculos 
SET precio = precio * 0.9 
WHERE año <= 2022;

-- Actualizar estado de vehículos con mucho kilometraje
UPDATE vehiculos 
SET descripcion = 'Alto kilometraje - precio negociable' 
WHERE kilometraje > 100000;
```

### Verificar Antes de Actualizar
```sql
-- 1. Primero ver qué registros vas a afectar
SELECT * FROM vehiculos WHERE año <= 2022;

-- 2. Si está bien, hacer la actualización
UPDATE vehiculos SET precio = precio * 0.9 WHERE año <= 2022;

-- 3. Verificar el resultado
SELECT id, marca, modelo, año, precio FROM vehiculos WHERE año <= 2022;
```

---

## 🗑️ DELETE: Eliminar Registros

### Sintaxis Básica
```sql
DELETE FROM tabla WHERE condición;
```

### ⚠️ REGLA DE ORO: SIEMPRE USA WHERE
```sql
-- ❌ CATASTRÓFICO: Elimina TODOS los registros
DELETE FROM vehiculos;

-- ✅ SEGURO: Elimina solo registros específicos
DELETE FROM vehiculos WHERE id = 1;
```

### Ejemplos Prácticos

#### Eliminar Por ID
```sql
-- Eliminar un vehículo específico
DELETE FROM vehiculos WHERE id = 10;
```

#### Eliminar Por Condiciones
```sql
-- Eliminar vehículos vendidos (para limpiar el inventario)
DELETE FROM vehiculos WHERE vendido = TRUE;

-- Eliminar vehículos muy viejos sin valor comercial
DELETE FROM vehiculos WHERE año < 2000 AND precio < 1000;
```

### Verificar Antes de Eliminar
```sql
-- 1. Primero ver qué registros vas a eliminar
SELECT * FROM vehiculos WHERE vendido = TRUE;

-- 2. Contar cuántos son
SELECT COUNT(*) FROM vehiculos WHERE vendido = TRUE;

-- 3. Si estás seguro, eliminar
DELETE FROM vehiculos WHERE vendido = TRUE;

-- 4. Verificar que se eliminaron
SELECT COUNT(*) FROM vehiculos; -- Debería ser menos que antes
```

---

## 🛡️ Alternativa Segura: Soft Delete

En lugar de eliminar registros, es común **marcarlos como inactivos**:

```sql
-- En lugar de DELETE, usar UPDATE para "eliminar suavemente"
UPDATE vehiculos 
SET activo = FALSE, fecha_baja = CURRENT_DATE 
WHERE id = 5;

-- Para consultas normales, filtrar solo los activos
SELECT * FROM vehiculos WHERE activo = TRUE;

-- Para ver histórico completo
SELECT * FROM vehiculos; -- Incluye activos e inactivos
```

### Ventajas del Soft Delete
- ✅ No se pierden datos históricos
- ✅ Se puede "deshacer" la eliminación
- ✅ Mantiene integridad referencial
- ✅ Permite auditorías completas

---

## 🚀 Práctica en SQLSandbox

### Setup Inicial
```sql
-- 🏪 SISTEMA DE INVENTARIO SIMPLE

CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    categoria TEXT,
    precio REAL CHECK (precio > 0),
    stock INTEGER DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion DATE DEFAULT CURRENT_DATE,
    fecha_actualizacion DATE
);

-- Insertar productos iniciales
INSERT INTO productos (nombre, categoria, precio, stock) VALUES 
('iPhone 13', 'Electrónica', 120000.00, 5),
('Samsung Galaxy S22', 'Electrónica', 95000.00, 3),
('MacBook Air', 'Computación', 180000.00, 2),
('iPad Pro', 'Electrónica', 85000.00, 4),
('AirPods', 'Accesorios', 25000.00, 10);
```

---

## 🏋️ Ejercicios Prácticos

### Ejercicio 1: INSERT - Agregar Productos
```sql
-- 1.1 Agregar un producto nuevo
INSERT INTO productos (nombre, categoria, precio, stock) 
VALUES ('Apple Watch', 'Accesorios', 45000.00, 7);

-- 1.2 Agregar múltiples productos de una vez
INSERT INTO productos (nombre, categoria, precio, stock) VALUES 
('Dell XPS 13', 'Computación', 150000.00, 3),
('Logitech Mouse', 'Accesorios', 3500.00, 25),
('Monitor 24"', 'Accesorios', 35000.00, 8);

-- 1.3 Intentar insertar algo inválido (¿qué pasa?)
INSERT INTO productos (nombre, precio) VALUES ('Producto Test', -100);
```

### Ejercicio 2: UPDATE - Actualizar Precios y Stock
```sql
-- 2.1 Actualizar precio de un producto específico
UPDATE productos 
SET precio = 115000.00 
WHERE nombre = 'iPhone 13';

-- 2.2 Actualizar stock después de una venta
UPDATE productos 
SET stock = stock - 1 
WHERE id = 1;

-- 2.3 Aplicar descuento del 15% a productos de electrónica
UPDATE productos 
SET precio = precio * 0.85 
WHERE categoria = 'Electrónica';

-- 2.4 Actualizar fecha de modificación
UPDATE productos 
SET fecha_actualizacion = CURRENT_DATE 
WHERE id = 2;
```

### Ejercicio 3: DELETE - Eliminar Productos
```sql
-- 3.1 Ver productos con stock 0 (candidatos a eliminar)
SELECT * FROM productos WHERE stock = 0;

-- 3.2 Eliminar productos sin stock
DELETE FROM productos WHERE stock = 0;

-- 3.3 Soft delete - marcar como inactivo en lugar de eliminar
UPDATE productos 
SET activo = FALSE 
WHERE precio < 5000;
```

### Ejercicio 4: Operaciones Combinadas
```sql
-- 4.1 Agregar un producto en oferta
INSERT INTO productos (nombre, categoria, precio, stock) 
VALUES ('Oferta Especial - Teclado Gaming', 'Accesorios', 8500.00, 15);

-- 4.2 Aplicar descuento adicional a la oferta
UPDATE productos 
SET precio = precio * 0.8 
WHERE nombre LIKE '%Oferta Especial%';

-- 4.3 Ver el resultado final
SELECT * FROM productos WHERE nombre LIKE '%Oferta%';
```

---

## 🔄 Transacciones Básicas (Concepto)

Aunque SQLSandbox no soporta transacciones completas, es importante entender el concepto:

```sql
-- Concepto de transacción (para entender)
BEGIN TRANSACTION;

-- Transferir stock entre productos
UPDATE productos SET stock = stock - 1 WHERE id = 1;
UPDATE productos SET stock = stock + 1 WHERE id = 2;

-- Si todo está bien, confirmar cambios
COMMIT;

-- Si algo salió mal, deshacer cambios
-- ROLLBACK;
```

**¿Para qué sirven?**
- Asegurar que operaciones relacionadas se ejecuten completamente o no se ejecuten
- Mantener consistencia de datos
- Poder deshacer cambios si hay errores

---

## 🎯 Patrones Comunes de Manipulación

### Patrón 1: Insertar con Validación
```sql
-- Verificar si ya existe antes de insertar
SELECT COUNT(*) FROM productos WHERE nombre = 'Nuevo Producto';
-- Si devuelve 0, entonces insertar
INSERT INTO productos (nombre, categoria, precio) VALUES ('Nuevo Producto', 'Test', 100.00);
```

### Patrón 2: Actualizar con Timestamp
```sql
UPDATE productos 
SET precio = 25000.00, fecha_actualizacion = CURRENT_DATE 
WHERE id = 1;
```

### Patrón 3: Soft Delete con Auditoría
```sql
UPDATE productos 
SET activo = FALSE, 
    fecha_baja = CURRENT_DATE,
    motivo_baja = 'Descontinuado por fabricante'
WHERE id = 5;
```

### Patrón 4: Upsert Simulado (Insertar o Actualizar)
```sql
-- Si existe, actualizar; si no, insertar (concepto)
-- En SQLite se haría con INSERT OR REPLACE, pero es avanzado
```

---

## 🆚 Comparación con MongoDB

| **Operación** | **SQL** | **MongoDB** |
|--------------|---------|-------------|
| Insertar uno | `INSERT INTO tabla VALUES (...)` | `db.collection.insertOne({...})` |
| Insertar varios | `INSERT INTO tabla VALUES (...), (...)` | `db.collection.insertMany([{...}, {...}])` |
| Actualizar | `UPDATE tabla SET ... WHERE ...` | `db.collection.updateOne({filtro}, {$set: {...}})` |
| Eliminar | `DELETE FROM tabla WHERE ...` | `db.collection.deleteOne({filtro})` |

**Ventajas de SQL:**
- Sintaxis más declarativa y legible
- Constraints automáticos previenen errores
- Transacciones más robustas
- Operaciones atómicas garantizadas

---

## ✅ Verificaciones de la Clase

**Antes de terminar, asegurate de poder:**
- [ ] Insertar registros respetando constraints
- [ ] Actualizar registros específicos con WHERE
- [ ] Eliminar registros de forma segura
- [ ] Entender la diferencia entre DELETE y soft delete
- [ ] Verificar cambios antes de confirmarlos

### Auto-evaluación
```sql
-- ¿Podés hacer esto sin errores?

-- 1. Agregar 3 productos nuevos
INSERT INTO productos (nombre, categoria, precio, stock) VALUES 
('Producto A', 'Test', 100.00, 5),
('Producto B', 'Test', 200.00, 3),
('Producto C', 'Test', 300.00, 1);

-- 2. Actualizar precios con 20% de descuento
UPDATE productos SET precio = precio * 0.8 WHERE categoria = 'Test';

-- 3. Eliminar productos de prueba
DELETE FROM productos WHERE categoria = 'Test';

-- 4. Verificar que se eliminaron
SELECT COUNT(*) FROM productos WHERE categoria = 'Test'; -- Debería ser 0
```

---

## 🏠 Tarea Para Casa

### Ejercicio: Sistema de Inventario de Volley
Creá un sistema simple para gestionar equipamiento del equipo:

```sql
-- Crear tabla
CREATE TABLE equipamiento (
    id INTEGER PRIMARY KEY,
    tipo TEXT NOT NULL, -- 'Pelota', 'Red', 'Uniforme', etc.
    marca TEXT,
    estado TEXT CHECK (estado IN ('Nuevo', 'Bueno', 'Regular', 'Malo')),
    precio REAL,
    fecha_compra DATE,
    activo BOOLEAN DEFAULT TRUE
);

-- Insertar equipamiento inicial
-- Actualizar estado de equipos viejos
-- Marcar como inactivo el equipamiento en mal estado
-- Calcular valor total del inventario
```

### Tareas Específicas:
1. **INSERT**: Agregar 10 elementos diferentes de equipamiento
2. **UPDATE**: Simular desgaste (cambiar estado de algunos elementos)
3. **DELETE/Soft Delete**: Dar de baja equipamiento en mal estado
4. **Consultas**: Ver valor total, cantidad por estado, etc.

---

## 🎯 Próxima Clase: Proyecto Biblioteca Personal

En la **Clase 5** vamos a:
- Aplicar todo lo aprendido en un proyecto real
- Crear sistema completo de biblioteca personal
- Relacionar libros con autores
- Implementar CRUD completo con validaciones

**¡Excelente! Ya dominás las operaciones fundamentales de manipulación de datos en SQL.**