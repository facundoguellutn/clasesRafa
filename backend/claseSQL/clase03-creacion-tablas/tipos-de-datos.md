# Guía Completa: Tipos de Datos en SQL

## 📋 Tipos de Datos Principales

### 🔢 INTEGER - Números Enteros

**¿Cuándo usarlo?**
- IDs (identificadores únicos)
- Cantidades (stock, personas, etc.)
- Años
- Edades
- Códigos numéricos

**Ejemplos prácticos:**
```sql
id INTEGER PRIMARY KEY,
año INTEGER,
cantidad_puertas INTEGER,
stock INTEGER,
edad INTEGER
```

**Valores válidos:** -2,147,483,648 a 2,147,483,647

---

### 📝 TEXT - Cadenas de Texto

**¿Cuándo usarlo?**
- Nombres y apellidos
- Direcciones
- Emails
- Descripciones
- Cualquier texto de longitud variable

**Ejemplos prácticos:**
```sql
nombre TEXT NOT NULL,
email TEXT UNIQUE,
direccion TEXT,
descripcion TEXT,
observaciones TEXT
```

**Nota importante:** En SQLite, TEXT no tiene límite de longitud

---

### 💰 REAL - Números Decimales

**¿Cuándo usarlo?**
- Precios
- Pesos y medidas
- Porcentajes
- Coordenadas
- Cualquier número con decimales

**Ejemplos prácticos:**
```sql
precio REAL CHECK (precio > 0),
peso REAL,
altura_metros REAL,
porcentaje_descuento REAL,
coordenada_lat REAL
```

**Precisión:** Hasta 15 dígitos significativos

---

### 📅 DATE - Fechas

**¿Cuándo usarlo?**
- Fechas de nacimiento
- Fechas de transacciones
- Fechas de vencimiento
- Timestamps de eventos

**Formatos aceptados:**
```sql
-- Formato ISO (recomendado)
'2024-01-15'
'2024-12-31'

-- Con tiempo
'2024-01-15 14:30:25'
```

**Ejemplos prácticos:**
```sql
fecha_nacimiento DATE,
fecha_venta DATE DEFAULT CURRENT_DATE,
fecha_vencimiento DATE,
created_at DATE DEFAULT CURRENT_DATE
```

---

### ✅ BOOLEAN - Verdadero/Falso

**¿Cuándo usarlo?**
- Estados sí/no
- Flags de activación
- Permisos
- Estados de procesos

**Valores válidos:**
- `TRUE` / `FALSE`
- `1` / `0`
- `'true'` / `'false'`

**Ejemplos prácticos:**
```sql
activo BOOLEAN DEFAULT TRUE,
vendido BOOLEAN DEFAULT FALSE,
es_admin BOOLEAN DEFAULT FALSE,
disponible BOOLEAN DEFAULT TRUE
```

---

## 🎯 Cómo Elegir el Tipo Correcto

### Preguntas para hacerte:

1. **¿Es un número?**
   - ¿Entero? → `INTEGER`
   - ¿Con decimales? → `REAL`

2. **¿Es texto?** → `TEXT`

3. **¿Es una fecha?** → `DATE`

4. **¿Es sí/no?** → `BOOLEAN`

### Ejemplos de Aplicación

```sql
-- ❌ MAL: usar TEXT para números
precio TEXT  -- '18000.50' como texto

-- ✅ BIEN: usar REAL para precios
precio REAL  -- 18000.50 como número

-- ❌ MAL: usar INTEGER para fechas
fecha INTEGER  -- 20240115 como número

-- ✅ BIEN: usar DATE para fechas  
fecha DATE     -- '2024-01-15' como fecha

-- ❌ MAL: usar TEXT para booleanos
activo TEXT    -- 'true'/'false' como texto

-- ✅ BIEN: usar BOOLEAN para estados
activo BOOLEAN -- TRUE/FALSE como booleano
```

---

## 🏗️ Tipos de Datos por Contexto

### Sistema de Concesionaria
```sql
CREATE TABLE vehiculos (
    id INTEGER PRIMARY KEY,           -- Identificador único
    marca TEXT NOT NULL,              -- Texto corto
    modelo TEXT NOT NULL,             -- Texto corto
    año INTEGER,                      -- Número entero
    precio REAL,                      -- Número con decimales
    kilometraje INTEGER,              -- Número entero
    vendido BOOLEAN DEFAULT FALSE,    -- Estado sí/no
    fecha_ingreso DATE,               -- Fecha
    descripcion TEXT                  -- Texto largo
);
```

### Sistema de Usuarios
```sql
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,           -- ID único
    username TEXT UNIQUE NOT NULL,    -- Texto único
    email TEXT UNIQUE NOT NULL,       -- Texto único  
    edad INTEGER,                     -- Número entero
    salario REAL,                     -- Número decimal
    activo BOOLEAN DEFAULT TRUE,      -- Estado
    fecha_registro DATE,              -- Fecha
    biografia TEXT                    -- Texto largo opcional
);
```

### Sistema de Inventario
```sql
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,           -- ID único
    nombre TEXT NOT NULL,             -- Nombre del producto
    codigo_barras TEXT UNIQUE,        -- Código como texto
    precio REAL NOT NULL,             -- Precio con decimales
    stock INTEGER DEFAULT 0,          -- Cantidad entera
    peso_kg REAL,                     -- Peso con decimales
    disponible BOOLEAN DEFAULT TRUE,  -- Disponibilidad
    fecha_ingreso DATE,               -- Cuándo ingresó
    descripcion TEXT                  -- Descripción detallada
);
```

---

## ⚠️ Errores Comunes y Cómo Evitarlos

### Error 1: Usar TEXT para Números
```sql
-- ❌ MAL
CREATE TABLE productos (
    precio TEXT  -- '1500.50'
);

-- Problema: no podés hacer cálculos matemáticos
-- SELECT precio * 0.9 FROM productos; -- Error!

-- ✅ BIEN  
CREATE TABLE productos (
    precio REAL  -- 1500.50
);

-- Ahora sí podés hacer cálculos
-- SELECT precio * 0.9 as precio_descuento FROM productos; -- ✓
```

### Error 2: Usar INTEGER para Decimales
```sql
-- ❌ MAL
CREATE TABLE medidas (
    altura INTEGER  -- Se pierde la precisión: 1.75 → 1
);

-- ✅ BIEN
CREATE TABLE medidas (
    altura REAL     -- Mantiene decimales: 1.75
);
```

### Error 3: Usar TEXT para Fechas
```sql
-- ❌ MAL
CREATE TABLE eventos (
    fecha TEXT  -- '15/01/2024' - formato inconsistente
);

-- ✅ BIEN
CREATE TABLE eventos (
    fecha DATE  -- '2024-01-15' - formato estándar
);
-- Bonus: podés hacer comparaciones de fechas fácilmente
```

---

## 💡 Tips Prácticos

### Tip 1: IDs Siempre INTEGER PRIMARY KEY
```sql
-- ✅ SIEMPRE así
id INTEGER PRIMARY KEY
-- SQLite auto-incrementa automáticamente
```

### Tip 2: Precios Siempre REAL
```sql
-- ✅ Para dinero
precio REAL CHECK (precio >= 0)
descuento REAL CHECK (descuento >= 0 AND descuento <= 100)
```

### Tip 3: Estados Como BOOLEAN
```sql
-- ✅ Para estados sí/no
activo BOOLEAN DEFAULT TRUE,
vendido BOOLEAN DEFAULT FALSE,
publicado BOOLEAN DEFAULT FALSE
```

### Tip 4: Fechas en Formato ISO
```sql
-- ✅ Siempre YYYY-MM-DD
fecha DATE DEFAULT CURRENT_DATE
-- Ejemplos: '2024-01-15', '2023-12-31'
```

### Tip 5: Longitud de Texto
```sql
-- Para textos cortos y largos, usar TEXT
nombre TEXT,          -- Corto: "Juan Pérez"
descripcion TEXT,     -- Largo: párrafos completos
observaciones TEXT    -- Variable: puede ser corto o largo
```

---

## 🧪 Ejercicio Práctico: Identificar Tipos

**¿Qué tipo de dato usarías para cada campo?**

```sql
CREATE TABLE empleados (
    -- ¿Qué tipo para cada campo?
    id ?,                    -- Identificador único
    nombre ?,                -- "Juan Pérez"  
    edad ?,                  -- 25
    salario ?,               -- 45000.50
    fecha_ingreso ?,         -- 15 de enero 2024
    es_supervisor ?,         -- sí/no
    telefono ?,              -- "11-1234-5678"
    altura_metros ?,         -- 1.75
    hijos ?,                 -- 2
    activo ?                 -- sí/no
);
```

**Respuestas:**
```sql
CREATE TABLE empleados (
    id INTEGER PRIMARY KEY,           -- Identificador → INTEGER
    nombre TEXT NOT NULL,             -- Texto → TEXT
    edad INTEGER,                     -- Número entero → INTEGER  
    salario REAL,                     -- Decimales → REAL
    fecha_ingreso DATE,               -- Fecha → DATE
    es_supervisor BOOLEAN DEFAULT FALSE, -- Sí/No → BOOLEAN
    telefono TEXT,                    -- Texto (puede tener guiones) → TEXT
    altura_metros REAL,               -- Decimales → REAL
    hijos INTEGER DEFAULT 0,          -- Entero → INTEGER
    activo BOOLEAN DEFAULT TRUE       -- Sí/No → BOOLEAN
);
```