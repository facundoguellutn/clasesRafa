# Guía Completa: Constraints (Reglas de Integridad)

## 🎯 ¿Qué Son Los Constraints?

Los **constraints** son reglas que aplicás a tus tablas para:
- Mantener la integridad de los datos
- Prevenir errores comunes  
- Asegurar que la información sea coherente
- Evitar datos duplicados o inválidos

**Analogía**: Son como las reglas de un juego. Sin reglas, cualquier cosa puede pasar y se vuelve caótico.

---

## 🔑 PRIMARY KEY - Clave Primaria

### ¿Qué Hace?
- Crea un **identificador único** para cada fila
- **No puede repetirse** entre registros
- **No puede ser NULL** (vacío)
- En SQLite, se **auto-incrementa** automáticamente

### Sintaxis
```sql
CREATE TABLE tabla (
    id INTEGER PRIMARY KEY,  -- ← Siempre usar esto
    -- otros campos...
);
```

### Ejemplo Práctico
```sql
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,  -- 1, 2, 3, 4, 5...
    nombre TEXT,
    email TEXT
);

-- Al insertar no necesitás especificar el ID
INSERT INTO usuarios (nombre, email) VALUES ('Juan', 'juan@email.com');
-- SQLite automáticamente asigna id = 1

INSERT INTO usuarios (nombre, email) VALUES ('María', 'maria@email.com');  
-- SQLite automáticamente asigna id = 2
```

### ⚠️ Error Común
```sql
-- ❌ MAL: intentar insertar ID duplicado
INSERT INTO usuarios (id, nombre) VALUES (1, 'Carlos');
-- Error: UNIQUE constraint failed: usuarios.id
```

---

## 🚫 NOT NULL - Campo Obligatorio

### ¿Qué Hace?
- El campo **DEBE** tener un valor
- **No puede estar vacío** (NULL)
- Perfecto para campos críticos

### Sintaxis
```sql
nombre TEXT NOT NULL,
email TEXT NOT NULL,
precio REAL NOT NULL
```

### Ejemplo Práctico
```sql
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,        -- Obligatorio
    precio REAL NOT NULL,        -- Obligatorio  
    descripcion TEXT             -- Opcional (puede ser NULL)
);

-- ✅ BIEN: todos los campos obligatorios tienen valor
INSERT INTO productos (nombre, precio) VALUES ('iPhone', 50000);

-- ❌ MAL: falta el nombre (obligatorio)
INSERT INTO productos (precio) VALUES (30000);
-- Error: NOT NULL constraint failed: productos.nombre
```

### 💡 Cuándo Usarlo
```sql
-- ✅ SIEMPRE obligatorio
email TEXT NOT NULL,
contraseña TEXT NOT NULL,
nombre TEXT NOT NULL,
precio REAL NOT NULL

-- ❌ Opcional  
telefono TEXT,           -- No todos tienen teléfono
direccion TEXT,          -- Puede completarse después
observaciones TEXT       -- Campo opcional
```

---

## 🎯 UNIQUE - Valor Único

### ¿Qué Hace?
- El valor **no puede repetirse** en toda la tabla
- Pero **SÍ puede ser NULL** (a diferencia de PRIMARY KEY)
- Perfecto para emails, códigos, DNI

### Sintaxis
```sql
email TEXT UNIQUE,
dni TEXT UNIQUE,
codigo_producto TEXT UNIQUE
```

### Ejemplo Práctico
```sql
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,     -- Un email por usuario
    dni TEXT UNIQUE,                -- Un DNI por usuario (opcional)
    nombre TEXT NOT NULL
);

-- ✅ BIEN: email único
INSERT INTO usuarios (email, nombre) VALUES ('juan@email.com', 'Juan');

-- ❌ MAL: email repetido  
INSERT INTO usuarios (email, nombre) VALUES ('juan@email.com', 'Carlos');
-- Error: UNIQUE constraint failed: usuarios.email
```

### UNIQUE vs PRIMARY KEY
| PRIMARY KEY | UNIQUE |
|------------|---------|
| Solo uno por tabla | Puedes tener varios |
| NO puede ser NULL | SÍ puede ser NULL |
| Se auto-incrementa | No se auto-incrementa |
| Identificador principal | Identificador secundario |

---

## ⚙️ DEFAULT - Valor Por Defecto

### ¿Qué Hace?
- Si no especificás un valor, **usa este por defecto**
- Simplifica las inserciones
- Útil para campos con valores comunes

### Sintaxis
```sql
activo BOOLEAN DEFAULT TRUE,
fecha_creacion DATE DEFAULT CURRENT_DATE,
stock INTEGER DEFAULT 0,
precio REAL DEFAULT 0.0
```

### Ejemplo Práctico
```sql
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    precio REAL DEFAULT 0.0,             -- Si no especificás, vale 0
    stock INTEGER DEFAULT 0,             -- Si no especificás, vale 0  
    disponible BOOLEAN DEFAULT TRUE,     -- Si no especificás, vale TRUE
    fecha_creacion DATE DEFAULT CURRENT_DATE  -- Fecha actual automática
);

-- Inserción mínima - usa todos los defaults
INSERT INTO productos (nombre) VALUES ('Producto Nuevo');
-- Resultado: precio=0.0, stock=0, disponible=TRUE, fecha_creacion=hoy

-- Inserción específica - overridea algunos defaults
INSERT INTO productos (nombre, precio, stock) VALUES ('iPhone', 50000, 10);
-- Resultado: precio=50000, stock=10, disponible=TRUE (default), fecha_creacion=hoy
```

### 💡 Defaults Útiles
```sql
-- Estados por defecto
activo BOOLEAN DEFAULT TRUE,
publicado BOOLEAN DEFAULT FALSE,
eliminado BOOLEAN DEFAULT FALSE,

-- Fechas automáticas  
fecha_creacion DATE DEFAULT CURRENT_DATE,
fecha_modificacion DATE DEFAULT CURRENT_DATE,

-- Valores numéricos  
stock INTEGER DEFAULT 0,
intentos_login INTEGER DEFAULT 0,
puntuacion REAL DEFAULT 0.0
```

---

## ✅ CHECK - Validaciones Personalizadas

### ¿Qué Hace?
- Permite crear **reglas de negocio personalizadas**
- Valida que el valor cumple una condición
- Muy poderoso para mantener integridad

### Sintaxis Básica
```sql
precio REAL CHECK (precio > 0),
edad INTEGER CHECK (edad >= 0 AND edad <= 120),
categoria TEXT CHECK (categoria IN ('A', 'B', 'C'))
```

### Ejemplos Prácticos

#### Rangos Numéricos
```sql
CREATE TABLE empleados (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    edad INTEGER CHECK (edad >= 18 AND edad <= 65),     -- Solo adultos trabajando
    salario REAL CHECK (salario > 0),                   -- Salario positivo
    calificacion INTEGER CHECK (calificacion >= 1 AND calificacion <= 10)  -- Del 1 al 10
);
```

#### Valores Específicos
```sql
CREATE TABLE vehiculos (
    id INTEGER PRIMARY KEY,
    marca TEXT NOT NULL,
    combustible TEXT CHECK (combustible IN ('Nafta', 'Diesel', 'GNC', 'Eléctrico')),
    transmision TEXT CHECK (transmision IN ('Manual', 'Automática')),
    estado TEXT CHECK (estado IN ('Nuevo', 'Usado', 'Seminuevo')) DEFAULT 'Usado'
);
```

#### Validaciones de Fechas
```sql
CREATE TABLE eventos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    fecha_inicio DATE CHECK (fecha_inicio >= DATE('now')),  -- No puede ser pasado
    fecha_fin DATE CHECK (fecha_fin > fecha_inicio)         -- Fin después de inicio
);
```

### ⚠️ Errores con CHECK
```sql
-- ❌ MAL: precio negativo
INSERT INTO vehiculos (marca, precio) VALUES ('Toyota', -5000);
-- Error: CHECK constraint failed: vehiculos

-- ❌ MAL: combustible inválido
INSERT INTO vehiculos (marca, combustible) VALUES ('Ford', 'Carbón');  
-- Error: CHECK constraint failed: vehiculos
```

---

## 🔄 Combinando Constraints

### Ejemplo Real: Sistema de Usuarios
```sql
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,                    -- Único, auto-incrementa
    email TEXT UNIQUE NOT NULL,                -- Único y obligatorio
    username TEXT UNIQUE NOT NULL,             -- Único y obligatorio
    contraseña TEXT NOT NULL,                  -- Obligatorio
    edad INTEGER CHECK (edad >= 13),           -- Mínimo 13 años
    estado TEXT CHECK (estado IN ('activo', 'inactivo', 'suspendido')) DEFAULT 'activo',
    intentos_fallidos INTEGER DEFAULT 0 CHECK (intentos_fallidos >= 0),
    fecha_registro DATE DEFAULT CURRENT_DATE,
    ultimo_login DATE
);
```

### Ejemplo Real: E-commerce
```sql
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    codigo TEXT UNIQUE NOT NULL,               -- Código único obligatorio  
    nombre TEXT NOT NULL,                      -- Nombre obligatorio
    precio REAL NOT NULL CHECK (precio > 0),  -- Precio positivo obligatorio
    stock INTEGER DEFAULT 0 CHECK (stock >= 0), -- Stock no negativo  
    categoria TEXT CHECK (categoria IN ('Electrónica', 'Ropa', 'Hogar', 'Deportes')),
    descuento REAL DEFAULT 0 CHECK (descuento >= 0 AND descuento <= 100), -- 0-100%
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion DATE DEFAULT CURRENT_DATE
);
```

---

## 🎯 Estrategias por Tipo de Campo

### Para IDs
```sql
id INTEGER PRIMARY KEY  -- SIEMPRE así
```

### Para Emails
```sql
email TEXT UNIQUE NOT NULL  -- Único y obligatorio
```

### Para Precios/Dinero
```sql
precio REAL NOT NULL CHECK (precio > 0)  -- Positivo y obligatorio
```

### Para Estados/Flags
```sql
activo BOOLEAN DEFAULT TRUE,
publicado BOOLEAN DEFAULT FALSE
```

### Para Fechas
```sql
fecha_nacimiento DATE CHECK (fecha_nacimiento <= DATE('now')),  -- No futuro
fecha_creacion DATE DEFAULT CURRENT_DATE                        -- Automática
```

### Para Categorías/Opciones
```sql
categoria TEXT CHECK (categoria IN ('opcion1', 'opcion2', 'opcion3'))
```

---

## 🧪 Ejercicio Práctico: Validar Constraints

**¿Qué pasaría con estos INSERT?**

```sql
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    precio REAL CHECK (precio > 0),
    categoria TEXT CHECK (categoria IN ('A', 'B', 'C')) DEFAULT 'A',
    email_contacto TEXT UNIQUE,
    activo BOOLEAN DEFAULT TRUE
);

-- ¿Cuáles funcionan y cuáles dan error?

-- 1.
INSERT INTO productos (nombre, precio) VALUES ('Producto 1', 100);

-- 2.  
INSERT INTO productos (nombre, precio) VALUES (NULL, 50);

-- 3.
INSERT INTO productos (nombre, precio, categoria) VALUES ('Producto 2', -10, 'A');

-- 4.
INSERT INTO productos (nombre, precio, categoria) VALUES ('Producto 3', 75, 'Z');

-- 5.
INSERT INTO productos (nombre, precio, email_contacto) VALUES ('Producto 4', 200, 'test@email.com');
INSERT INTO productos (nombre, precio, email_contacto) VALUES ('Producto 5', 150, 'test@email.com');
```

**Respuestas:**
1. ✅ **Funciona** - todos los constraints se cumplen, categoria usa default 'A'
2. ❌ **Error** - nombre es NOT NULL
3. ❌ **Error** - precio debe ser > 0  
4. ❌ **Error** - categoria debe ser 'A', 'B' o 'C'
5. ❌ **Error** - el segundo INSERT viola UNIQUE en email_contacto

---

## 💡 Tips de Buenas Prácticas

### ✅ DO (Hacer)
- Usar PRIMARY KEY en todas las tablas
- NOT NULL para campos críticos
- UNIQUE para identificadores secundarios (email, DNI)
- CHECK para validar reglas de negocio
- DEFAULT para valores comunes

### ❌ DON'T (No hacer)  
- Tablas sin PRIMARY KEY
- Permitir NULL en campos críticos
- Validaciones solo en el código (también en la DB)
- Constraints muy complejos que afecten performance
- Olvidar documentar las reglas de negocio