# Clase 3: Creación de Tablas y Tipos de Datos

## 🎯 Objetivos de la Clase

Al finalizar esta clase, Rafa será capaz de:
- Crear tablas desde cero con CREATE TABLE
- Elegir el tipo de dato correcto para cada columna
- Aplicar constraints para mantener integridad de datos
- Modificar tablas existentes con ALTER TABLE
- Diseñar la estructura de una base de datos simple

---

## 🚗 Contexto Real: Sistema de Concesionaria

Imaginate que tenés que diseñar la base de datos para tu concesionaria. Necesitás guardar:
- **Vehículos**: marca, modelo, año, precio, kilometraje
- **Clientes**: nombre, teléfono, email, DNI
- **Ventas**: qué auto se vendió, a quién, cuándo, por cuánto

**Esto requiere pensar bien qué tipo de datos usar y cómo estructurar las tablas.**

---

## 📊 Tipos de Datos Fundamentales

### INTEGER - Números Enteros
```sql
-- Para cantidades, IDs, años, kilometraje
id INTEGER
año INTEGER
kilometraje INTEGER
cantidad_puertas INTEGER
```
**Ejemplos**: 1, 42, 2024, 50000, -5

### TEXT - Cadenas de Texto  
```sql
-- Para nombres, descripciones, emails
marca TEXT
nombre TEXT
email TEXT
descripcion TEXT
```
**Ejemplos**: 'Toyota', 'Juan Pérez', 'juan@email.com'

### REAL - Números Decimales
```sql
-- Para precios, pesos, medidas
precio REAL
peso REAL
combustible_por_100km REAL
```
**Ejemplos**: 25000.50, 1.2, 8.5

### DATE - Fechas
```sql
-- Para fechas de nacimiento, ventas, etc.
fecha_nacimiento DATE
fecha_venta DATE
```
**Ejemplos**: '2024-01-15', '1990-05-22'

### BOOLEAN - Verdadero/Falso
```sql
-- Para estados sí/no
vendido BOOLEAN
activo BOOLEAN
financiado BOOLEAN
```
**Ejemplos**: TRUE, FALSE, 1, 0

---

## 🏗️ CREATE TABLE: Crear Tablas

### Sintaxis Básica
```sql
CREATE TABLE nombre_tabla (
    columna1 TIPO_DATO,
    columna2 TIPO_DATO,
    columna3 TIPO_DATO
);
```

### Ejemplo: Tabla de Vehículos
```sql
CREATE TABLE vehiculos (
    id INTEGER,
    marca TEXT,
    modelo TEXT,
    año INTEGER,
    precio REAL,
    kilometraje INTEGER,
    combustible TEXT,
    vendido BOOLEAN
);
```

---

## 🔐 Constraints: Reglas de Integridad

### PRIMARY KEY - Clave Primaria
```sql
CREATE TABLE vehiculos (
    id INTEGER PRIMARY KEY,  -- Único identificador
    marca TEXT,
    modelo TEXT
);
```
**¿Qué hace?** 
- Hace que cada fila tenga un ID único
- No puede repetirse
- No puede ser NULL
- SQLite auto-incrementa automáticamente

### NOT NULL - Campo Obligatorio
```sql
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,      -- Obligatorio
    telefono TEXT NOT NULL,    -- Obligatorio  
    email TEXT                 -- Opcional
);
```

### UNIQUE - Valor Único
```sql
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE,         -- No puede repetirse
    dni TEXT UNIQUE            -- No puede repetirse
);
```

### DEFAULT - Valor Por Defecto
```sql
CREATE TABLE vehiculos (
    id INTEGER PRIMARY KEY,
    marca TEXT NOT NULL,
    precio REAL DEFAULT 0.0,   -- Si no se especifica, vale 0
    vendido BOOLEAN DEFAULT FALSE,  -- Por defecto no vendido
    fecha_ingreso DATE DEFAULT CURRENT_DATE  -- Fecha actual
);
```

### CHECK - Validaciones Personalizadas
```sql
CREATE TABLE vehiculos (
    id INTEGER PRIMARY KEY,
    marca TEXT NOT NULL,
    año INTEGER CHECK (año >= 1900 AND año <= 2025),  -- Años válidos
    precio REAL CHECK (precio > 0),                    -- Precio positivo
    kilometraje INTEGER CHECK (kilometraje >= 0)       -- No negativos
);
```

---

## 🔧 Ejemplo Completo: Sistema de Concesionaria

### Tabla 1: Vehículos
```sql
CREATE TABLE vehiculos (
    id INTEGER PRIMARY KEY,
    marca TEXT NOT NULL,
    modelo TEXT NOT NULL,
    año INTEGER CHECK (año >= 1990 AND año <= 2025),
    precio REAL CHECK (precio > 0),
    kilometraje INTEGER CHECK (kilometraje >= 0),
    combustible TEXT CHECK (combustible IN ('Nafta', 'Diesel', 'GNC', 'Eléctrico')),
    color TEXT,
    vendido BOOLEAN DEFAULT FALSE,
    fecha_ingreso DATE DEFAULT CURRENT_DATE,
    descripcion TEXT
);
```

### Tabla 2: Clientes
```sql
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    dni TEXT UNIQUE NOT NULL,
    telefono TEXT NOT NULL,
    email TEXT UNIQUE,
    direccion TEXT,
    fecha_nacimiento DATE,
    activo BOOLEAN DEFAULT TRUE
);
```

### Tabla 3: Ventas
```sql
CREATE TABLE ventas (
    id INTEGER PRIMARY KEY,
    vehiculo_id INTEGER NOT NULL,
    cliente_id INTEGER NOT NULL,
    fecha_venta DATE DEFAULT CURRENT_DATE,
    precio_final REAL NOT NULL,
    forma_pago TEXT CHECK (forma_pago IN ('Efectivo', 'Financiado', 'Tarjeta')),
    observaciones TEXT
);
```

---

## ➕ INSERT: Agregar Datos

### Insertar Todos los Campos
```sql
INSERT INTO vehiculos (marca, modelo, año, precio, kilometraje, combustible, color) 
VALUES ('Toyota', 'Corolla', 2020, 18000.00, 45000, 'Nafta', 'Blanco');
```

### Insertar Campos Específicos
```sql
-- Los campos con DEFAULT o que permiten NULL se pueden omitir
INSERT INTO vehiculos (marca, modelo, año, precio, kilometraje) 
VALUES ('Ford', 'Focus', 2019, 16500.50, 32000);
```

### Insertar Múltiples Registros
```sql
INSERT INTO vehiculos (marca, modelo, año, precio, kilometraje, combustible) VALUES 
('Honda', 'Civic', 2021, 22000.00, 15000, 'Nafta'),
('Volkswagen', 'Golf', 2018, 14500.00, 68000, 'Nafta'),
('Chevrolet', 'Cruze', 2019, 17800.00, 41000, 'Nafta');
```

---

## ✏️ ALTER TABLE: Modificar Tablas

### Agregar Nueva Columna
```sql
ALTER TABLE vehiculos 
ADD COLUMN transmision TEXT DEFAULT 'Manual';
```

### Renombrar Tabla
```sql
ALTER TABLE vehiculos 
RENAME TO autos;
```

### Renombrar Columna
```sql
ALTER TABLE vehiculos 
RENAME COLUMN color TO pintura;
```

---

## 🚀 Práctica en SQLSandbox

### Ejercicio Guiado: Crear Sistema de Concesionaria

```sql
-- 🚗 SISTEMA DE CONCESIONARIA COMPLETO

-- 1. Crear tabla de vehículos
CREATE TABLE vehiculos (
    id INTEGER PRIMARY KEY,
    marca TEXT NOT NULL,
    modelo TEXT NOT NULL,
    año INTEGER CHECK (año >= 1990 AND año <= 2025),
    precio REAL CHECK (precio > 0),
    kilometraje INTEGER CHECK (kilometraje >= 0) DEFAULT 0,
    combustible TEXT CHECK (combustible IN ('Nafta', 'Diesel', 'GNC', 'Eléctrico')),
    color TEXT,
    transmision TEXT DEFAULT 'Manual',
    vendido BOOLEAN DEFAULT FALSE,
    fecha_ingreso DATE DEFAULT CURRENT_DATE,
    descripcion TEXT
);

-- 2. Insertar datos de ejemplo
INSERT INTO vehiculos (marca, modelo, año, precio, kilometraje, combustible, color) VALUES 
('Toyota', 'Corolla', 2020, 18000.00, 45000, 'Nafta', 'Blanco'),
('Ford', 'Focus', 2019, 16500.50, 32000, 'Nafta', 'Azul'),
('Honda', 'Civic', 2021, 22000.00, 15000, 'Nafta', 'Gris'),
('Volkswagen', 'Golf', 2018, 14500.00, 68000, 'Nafta', 'Rojo'),
('Chevrolet', 'Cruze', 2019, 17800.00, 41000, 'Nafta', 'Negro'),
('Peugeot', '208', 2020, 15200.00, 28000, 'Nafta', 'Blanco'),
('Fiat', 'Cronos', 2021, 16800.00, 12000, 'Nafta', 'Plata'),
('Renault', 'Logan', 2018, 12500.00, 55000, 'GNC', 'Azul');

-- 3. Crear tabla de clientes
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    dni TEXT UNIQUE NOT NULL,
    telefono TEXT NOT NULL,
    email TEXT UNIQUE,
    direccion TEXT,
    activo BOOLEAN DEFAULT TRUE
);

-- 4. Insertar clientes de ejemplo
INSERT INTO clientes (nombre, apellido, dni, telefono, email, direccion) VALUES 
('Juan', 'Pérez', '12345678', '11-1234-5678', 'juan@email.com', 'Av. Libertador 1234'),
('María', 'García', '87654321', '11-8765-4321', 'maria@email.com', 'San Martín 567'),
('Carlos', 'López', '11111111', '11-1111-1111', 'carlos@email.com', 'Belgrano 890');
```

---

## 🏋️ Ejercicios Prácticos

### Ejercicio 1: Verificar Constraints
```sql
-- ¿Qué pasa si intentás esto? (debería dar error)
INSERT INTO vehiculos (marca, modelo, año, precio) 
VALUES ('Tesla', 'Model 3', 2030, -5000);

-- ¿Y esto? (debería funcionar)
INSERT INTO vehiculos (marca, modelo, año, precio, combustible) 
VALUES ('Tesla', 'Model 3', 2023, 45000, 'Eléctrico');
```

### Ejercicio 2: Consultas en Tu Nueva Tabla
```sql
-- 2.1 Ver todos los vehículos
SELECT * FROM vehiculos;

-- 2.2 Vehículos no vendidos
SELECT marca, modelo, precio FROM vehiculos WHERE vendido = FALSE;

-- 2.3 Vehículos ordenados por precio (menor a mayor)
SELECT marca, modelo, precio FROM vehiculos ORDER BY precio;

-- 2.4 Los 3 autos más baratos
SELECT marca, modelo, precio FROM vehiculos ORDER BY precio LIMIT 3;
```

### Ejercicio 3: Modificar Tabla
```sql
-- 3.1 Agregar columna para cantidad de puertas
ALTER TABLE vehiculos ADD COLUMN puertas INTEGER DEFAULT 4;

-- 3.2 Actualizar algunos registros (lo vemos en próxima clase)
```

---

## 🎯 Patrones de Diseño de Tablas

### Patrón 1: Campos Básicos Obligatorios
```sql
CREATE TABLE entidad (
    id INTEGER PRIMARY KEY,          -- Siempre tener ID
    nombre TEXT NOT NULL,            -- Campo principal
    activo BOOLEAN DEFAULT TRUE,     -- Para soft delete
    fecha_creacion DATE DEFAULT CURRENT_DATE
);
```

### Patrón 2: Validaciones de Negocio
```sql
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    precio REAL CHECK (precio > 0),                    -- Precio positivo
    categoria TEXT CHECK (categoria IN ('A', 'B', 'C')), -- Valores fijos
    stock INTEGER CHECK (stock >= 0)                   -- No stock negativo
);
```

### Patrón 3: Campos Opcionales vs Obligatorios
```sql
CREATE TABLE usuario (
    -- OBLIGATORIOS para funcionar
    id INTEGER PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    contraseña TEXT NOT NULL,
    
    -- OPCIONALES para completar perfil
    nombre TEXT,
    telefono TEXT,
    direccion TEXT
);
```

---

## 🆚 Comparación con MongoDB

### MongoDB (Esquemas Flexibles)
```javascript
// Cada documento puede tener campos diferentes
{
  _id: ObjectId("..."),
  marca: "Toyota",
  modelo: "Corolla",
  precio: 18000
}

{
  _id: ObjectId("..."), 
  marca: "Ford",
  modelo: "Focus",
  precio: 16500,
  extras: ["GPS", "Bluetooth"], // Campo que otros no tienen
  vendedor: {                   // Objeto anidado
    nombre: "Juan",
    comision: 500
  }
}
```

### SQL (Esquemas Fijos)
```sql
-- TODOS los registros tienen la misma estructura
CREATE TABLE vehiculos (
    id INTEGER PRIMARY KEY,
    marca TEXT NOT NULL,
    modelo TEXT NOT NULL, 
    precio REAL NOT NULL
    -- Todos los autos DEBEN tener estos campos
);
```

**¿Cuándo usar cada uno?**
- **SQL**: Cuando sabés exactamente qué datos necesitás (concesionaria, sistema de ventas)
- **MongoDB**: Cuando los datos pueden variar mucho (configuraciones, logs, prototipos)

---

## ✅ Verificaciones de la Clase

**Antes de terminar, asegurate de poder:**
- [ ] Crear una tabla con diferentes tipos de datos
- [ ] Usar constraints como NOT NULL, UNIQUE, CHECK
- [ ] Insertar datos respetando las reglas definidas
- [ ] Entender qué pasa cuando se violan los constraints
- [ ] Modificar una tabla existente con ALTER TABLE

---

## 🏠 Tarea Para Casa

### Ejercicio: Diseñar Base de Datos para App de Volley
Creá las tablas necesarias para una app de estadísticas de volley:

```sql
-- 1. Tabla de equipos
-- Campos: id, nombre, ciudad, división, activo

-- 2. Tabla de jugadores  
-- Campos: id, nombre, posicion, altura, peso, equipo_id, activo

-- 3. Tabla de partidos
-- Campos: id, equipo_local, equipo_visitante, fecha, resultado_local, resultado_visitante

-- 4. Tabla de estadísticas
-- Campos: id, jugador_id, partido_id, puntos, ataques_exitosos, errores
```

**Requisitos:**
- Usar tipos de datos apropiados
- Agregar constraints necesarios
- Insertar datos de ejemplo
- Probar con consultas SELECT

---

## 🎯 Próxima Clase: Manipulación de Datos

En la **Clase 4** vamos a aprender:
- UPDATE: Modificar registros existentes
- DELETE: Eliminar registros
- Transacciones básicas
- Buenas prácticas de seguridad

**¡Excelente! Ya podés diseñar y crear la estructura de una base de datos completa.**