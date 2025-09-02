# Clase 1: ¿Qué es SQL? Introducción y Conceptos Clave

## 🎯 Objetivos de la Clase

Al finalizar esta clase, Rafa será capaz de:
- Entender qué es SQL y para qué se usa en el mundo real
- Conocer las diferencias fundamentales entre SQL y MongoDB
- Identificar cuándo usar cada tipo de base de datos
- Ejecutar sus primeras consultas SQL en SQLSandbox

---

## 🤔 ¿Para Qué Sirve SQL en el Mundo Real?

### Casos de Uso Cotidianos

**¿Alguna vez te preguntaste cómo funcionan estas aplicaciones?**

- **Instagram**: Cuando buscás fotos por hashtag → SQL busca en millones de registros
- **Netflix**: "Películas que te pueden gustar" → SQL analiza tus gustos vs otros usuarios
- **Banco**: Cuando consultás tu saldo → SQL suma todos tus movimientos
- **Mercado Libre**: "Productos más vendidos" → SQL cuenta y ordena ventas
- **Tu concesionaria**: Buscar autos por marca, modelo, precio → SQL filtra el inventario

> **Para Rafa**: Imaginate que en tu concesionaria tenés 500 autos. SQL te permite preguntar: *"Mostrame todos los Toyota de menos de $20,000 ordenados por año"* y obtienes la respuesta en milisegundos.

---

## 🆚 SQL vs MongoDB: ¿Cuál Elegir?

### MongoDB (NoSQL) - Lo que ya conocés

```javascript
// En MongoDB guardás documentos como objetos
{
  _id: "64f8...",
  nombre: "Toyota Corolla",
  precio: 18000,
  especificaciones: {
    motor: "1.8L",
    combustible: "Nafta",
    año: 2020
  },
  fotos: ["foto1.jpg", "foto2.jpg"]
}
```

**Ventajas de MongoDB:**
- ✅ Flexible: Podés agregar campos sin problema
- ✅ Fácil para objetos complejos (arrays, objetos anidados)
- ✅ Ideal para prototipos rápidos

### SQL (Relacional) - Lo que vamos a aprender

```sql
-- En SQL organizás datos en tablas relacionadas
TABLA: vehiculos
| id | marca  | modelo  | precio | año  |
|----|--------|---------|---------|------|
| 1  | Toyota | Corolla | 18000   | 2020 |
| 2  | Ford   | Focus   | 16500   | 2019 |

TABLA: especificaciones  
| vehiculo_id | motor | combustible |
|-------------|-------|-------------|
| 1          | 1.8L  | Nafta       |
| 2          | 2.0L  | Nafta       |
```

**Ventajas de SQL:**
- ✅ Estructura clara y predecible
- ✅ Elimina duplicación de datos (normalización)
- ✅ Consultas complejas súper potentes
- ✅ Integridad de datos garantizada
- ✅ Usado en el 80% de aplicaciones empresariales

---

## ⚖️ ¿Cuándo Usar Cada Uno?

### Usá **MongoDB** cuando:
- Tenés datos muy flexibles (no sabés qué campos vas a necesitar)
- Trabajás con objetos complejos (arrays, objetos anidados)
- Necesitás prototipado rápido
- Los datos no tienen relaciones complejas

### Usá **SQL** cuando:
- Los datos tienen estructura clara y consistente
- Necesitás relaciones entre entidades (usuarios → pedidos → productos)
- Requerís consultas complejas y analíticas
- La integridad de datos es crítica
- Trabajás en equipo (SQL es estándar universal)

> **Ejemplo Real**: Una app de ecommerce usa SQL para productos, usuarios, pedidos (estructura fija) pero MongoDB para logs de navegación (datos flexibles).

---

## 🗃️ Conceptos Fundamentales de SQL

### 1. Base de Datos (Database)
Es como una **carpeta principal** que contiene todas tus tablas relacionadas.
```sql
-- Ejemplo: base de datos "concesionaria_rafa"
```

### 2. Tabla (Table)
Es como una **hoja de Excel** con filas y columnas.
```sql
-- Ejemplo: tabla "vehiculos", tabla "clientes", tabla "ventas"
```

### 3. Registro/Fila (Row/Record)
Es **un elemento específico** en tu tabla.
```sql
-- Ejemplo: Un Toyota Corolla específico
```

### 4. Campo/Columna (Column/Field)
Es **una propiedad** que tienen todos los elementos.
```sql
-- Ejemplo: marca, modelo, precio, año
```

### 5. Clave Primaria (Primary Key)
Es el **ID único** que identifica cada registro.
```sql
-- Ejemplo: cada auto tiene un id único (1, 2, 3, ...)
```

---

## 🚀 Primeras Consultas en SQLSandbox

### Paso 1: Entrá a SQLSandbox
1. Abrir [sqlsandbox.com](https://sqlsandbox.com) en el navegador
2. Vas a ver un editor de SQL listo para usar

### Paso 2: Crear Tu Primera Base de Datos
Copiá y pegá este código en SQLSandbox:

```sql
-- 🎬 CREAMOS UNA BASE DE DATOS DE PELÍCULAS PARA PRACTICAR

-- Crear la tabla
CREATE TABLE peliculas (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    año INTEGER,
    genero TEXT,
    calificacion REAL,
    director TEXT
);

-- Insertar datos de ejemplo
INSERT INTO peliculas (id, titulo, año, genero, calificacion, director) VALUES 
(1, 'El Padrino', 1972, 'Drama', 9.2, 'Francis Ford Coppola'),
(2, 'Pulp Fiction', 1994, 'Crime', 8.9, 'Quentin Tarantino'),
(3, 'Forrest Gump', 1994, 'Drama', 8.8, 'Robert Zemeckis'),
(4, 'El Señor de los Anillos', 2001, 'Fantasy', 8.8, 'Peter Jackson'),
(5, 'Matrix', 1999, 'Sci-Fi', 8.7, 'Lana Wachowski'),
(6, 'Goodfellas', 1990, 'Crime', 8.7, 'Martin Scorsese'),
(7, 'Titanic', 1997, 'Romance', 7.8, 'James Cameron'),
(8, 'Avatar', 2009, 'Sci-Fi', 7.8, 'James Cameron');
```

### Paso 3: Tu Primera Consulta
```sql
-- Ver todas las películas
SELECT * FROM peliculas;
```

**¡Presioná "Run" y deberías ver todas las películas en una tabla!**

---

## 🏋️ Ejercicios Prácticos

### Ejercicio 1: Explorá los Datos
```sql
-- 1. Ver todas las películas (ya lo hicimos)
SELECT * FROM peliculas;

-- 2. Ver solo los títulos
SELECT titulo FROM peliculas;

-- 3. Ver títulos y años
SELECT titulo, año FROM peliculas;
```

### Ejercicio 2: Entendé la Estructura
**Preguntás para reflexionar mientras hacés las consultas:**
1. ¿Cuántas películas hay en total?
2. ¿Qué campos (columnas) tiene cada película?
3. ¿Cuál es la película más antigua? ¿Y la más nueva?

---

## 🤓 Conceptos Clave para Recordar

### Diferencias con MongoDB
| MongoDB | SQL |
|---------|-----|
| `db.peliculas.find()` | `SELECT * FROM peliculas` |
| Documentos flexibles | Tablas con estructura fija |
| Sin relaciones forzadas | Relaciones definidas |
| Objeto JavaScript | Filas y columnas |

### Terminología SQL
- **SELECT**: "Mostrame..."
- **FROM**: "...de la tabla..."
- **WHERE**: "...donde se cumple la condición..."
- **ORDER BY**: "...ordenado por..."

---

## 🎯 Lo Que Viene en la Próxima Clase

En la **Clase 2** vamos a aprender:
- Filtrar datos con `WHERE`
- Ordenar resultados con `ORDER BY`
- Limitar cantidad de resultados
- Buscar con patrones de texto

**Tarea para practicar en casa:**
1. Jugá con las consultas de hoy en SQLSandbox
2. Tratá de cambiar los datos de las películas
3. Pensá: ¿Qué otras consultas te gustaría hacer?

---

## 📚 Recursos Adicionales

- **SQLSandbox**: [sqlsandbox.com](https://sqlsandbox.com) - Para practicar sin instalar nada
- **W3Schools SQL**: Tutorial interactivo básico
- **SQLBolt**: Ejercicios paso a paso

---

**¡Felicitaciones! Ya diste tu primer paso en el mundo de SQL. En la próxima clase vamos a hacer consultas más interesantes y poderosas.**