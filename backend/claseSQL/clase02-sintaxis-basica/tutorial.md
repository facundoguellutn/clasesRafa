# Clase 2: Sintaxis Básica SQL - Filtros, Orden y Límites

## 🎯 Objetivos de la Clase

Al finalizar esta clase, Rafa será capaz de:
- Filtrar datos con WHERE usando diferentes condiciones
- Ordenar resultados con ORDER BY (ascendente y descendente)
- Limitar la cantidad de resultados con LIMIT
- Buscar patrones de texto con LIKE
- Combinar múltiples condiciones con AND/OR

---

## 🏐 Contexto Real: Estadísticas de Volley

Imaginate que tenés una app para tu equipo de volley y querés hacer consultas como:
- *"Mostrame los 5 jugadores con más puntos"*
- *"¿Cuáles son los liberos del equipo?"*
- *"Jugadores que miden más de 180cm ordenados por altura"*

**Esto es exactamente lo que vamos a aprender hoy con SQL.**

---

## 🔍 WHERE: Filtrar Datos

### Sintaxis Básica
```sql
SELECT columnas 
FROM tabla 
WHERE condición;
```

### Operadores de Comparación
```sql
-- Igualdad
WHERE nombre = 'Juan'

-- Diferente  
WHERE posicion != 'Libero'
-- o también:
WHERE posicion <> 'Libero'

-- Mayor que
WHERE altura > 180

-- Mayor o igual
WHERE puntos >= 100

-- Menor que  
WHERE peso < 80

-- Menor o igual
WHERE edad <= 25
```

### Ejemplos Prácticos con Jugadores de Volley
```sql
-- Jugadores que son liberos
SELECT * FROM jugadores 
WHERE posicion = 'Libero';

-- Jugadores altos (más de 185cm)
SELECT nombre, altura 
FROM jugadores 
WHERE altura > 185;

-- Jugadores con buena puntuación (más de 200 puntos)
SELECT nombre, posicion, puntos_temporada 
FROM jugadores 
WHERE puntos_temporada > 200;
```

---

## 🔤 LIKE: Buscar Patrones de Texto

### Wildcards (Comodines)
- **%**: Representa cualquier cantidad de caracteres
- **_**: Representa exactamente un carácter

```sql
-- Nombres que empiezan con 'Juan'
SELECT * FROM jugadores 
WHERE nombre LIKE 'Juan%';

-- Nombres que terminan con 'ez'
SELECT * FROM jugadores 
WHERE nombre LIKE '%ez';

-- Nombres que contienen 'ar'
SELECT * FROM jugadores 
WHERE nombre LIKE '%ar%';

-- Nombres de exactamente 4 letras que empiezan con 'J'
SELECT * FROM jugadores 
WHERE nombre LIKE 'J___';
```

---

## 🔗 AND / OR: Combinar Condiciones

### AND - Todas las condiciones deben cumplirse
```sql
-- Jugadores altos Y con muchos puntos
SELECT * FROM jugadores 
WHERE altura > 185 AND puntos_temporada > 200;

-- Liberos con peso menor a 70kg
SELECT * FROM jugadores 
WHERE posicion = 'Libero' AND peso < 70;
```

### OR - Al menos una condición debe cumplirse
```sql
-- Jugadores que son Opuestos O Centrales
SELECT * FROM jugadores 
WHERE posicion = 'Opuesto' OR posicion = 'Central';

-- Jugadores muy altos O con muchos puntos
SELECT * FROM jugadores 
WHERE altura > 200 OR puntos_temporada > 300;
```

### Combinar AND/OR con Paréntesis
```sql
-- Jugadores altos que son Opuestos O Centrales
SELECT * FROM jugadores 
WHERE altura > 185 AND (posicion = 'Opuesto' OR posicion = 'Central');
```

---

## 📊 ORDER BY: Ordenar Resultados

### Orden Ascendente (ASC) - Por defecto
```sql
-- Jugadores ordenados por altura (menor a mayor)
SELECT nombre, altura 
FROM jugadores 
ORDER BY altura;

-- También podés escribir explícitamente:
SELECT nombre, altura 
FROM jugadores 
ORDER BY altura ASC;
```

### Orden Descendente (DESC)
```sql
-- Jugadores ordenados por puntos (mayor a menor)
SELECT nombre, puntos_temporada 
FROM jugadores 
ORDER BY puntos_temporada DESC;
```

### Ordenar por Múltiples Columnas
```sql
-- Primero por posición, luego por puntos
SELECT nombre, posicion, puntos_temporada 
FROM jugadores 
ORDER BY posicion, puntos_temporada DESC;
```

---

## 🎯 LIMIT: Limitar Resultados

```sql
-- Los 3 jugadores con más puntos
SELECT nombre, puntos_temporada 
FROM jugadores 
ORDER BY puntos_temporada DESC 
LIMIT 3;

-- Los 5 jugadores más altos
SELECT nombre, altura 
FROM jugadores 
ORDER BY altura DESC 
LIMIT 5;
```

---

## 🚀 Práctica en SQLSandbox

### Setup: Copiá Este Código
```sql
-- 🏐 BASE DE DATOS DE JUGADORES DE VOLLEY

CREATE TABLE jugadores_volley (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    posicion TEXT,
    altura INTEGER, -- en centímetros
    peso REAL,      -- en kilogramos  
    puntos_temporada INTEGER,
    edad INTEGER,
    años_experiencia INTEGER
);

INSERT INTO jugadores_volley VALUES 
(1, 'Juan Pérez', 'Opuesto', 195, 85.5, 240, 24, 5),
(2, 'María García', 'Libero', 165, 60.0, 180, 22, 3),
(3, 'Carlos López', 'Central', 205, 95.2, 190, 26, 7),
(4, 'Ana Martínez', 'Armador', 170, 62.5, 220, 23, 4),
(5, 'Roberto Silva', 'Punta', 188, 78.0, 210, 25, 6),
(6, 'Laura Rodríguez', 'Opuesto', 182, 68.5, 260, 24, 5),
(7, 'Diego Fernández', 'Central', 202, 92.0, 185, 27, 8),
(8, 'Sofía González', 'Libero', 163, 58.5, 170, 21, 2),
(9, 'Andrés Ruiz', 'Punta', 190, 82.0, 225, 25, 6),
(10, 'Valentina Torres', 'Armador', 168, 61.0, 195, 22, 3);
```

---

## 🏋️ Ejercicios Prácticos

### Nivel 1: Filtros Básicos
```sql
-- 1. Mostrar solo los liberos
SELECT * FROM jugadores_volley WHERE posicion = 'Libero';

-- 2. Jugadores que miden más de 180cm
SELECT nombre, altura FROM jugadores_volley WHERE altura > 180;

-- 3. Jugadores con más de 200 puntos
SELECT nombre, puntos_temporada FROM jugadores_volley WHERE puntos_temporada > 200;
```

### Nivel 2: Búsquedas con LIKE
```sql
-- 4. Jugadores cuyos nombres empiezan con 'A'
SELECT nombre FROM jugadores_volley WHERE nombre LIKE 'A%';

-- 5. Jugadores cuyos nombres terminan con 'ez'
SELECT nombre FROM jugadores_volley WHERE nombre LIKE '%ez';

-- 6. Jugadores cuyos nombres contienen 'ar'
SELECT nombre FROM jugadores_volley WHERE nombre LIKE '%ar%';
```

### Nivel 3: Condiciones Combinadas
```sql
-- 7. Jugadores altos (>185cm) CON muchos puntos (>200)
SELECT nombre, altura, puntos_temporada 
FROM jugadores_volley 
WHERE altura > 185 AND puntos_temporada > 200;

-- 8. Jugadores que son Opuestos O Centrales
SELECT nombre, posicion 
FROM jugadores_volley 
WHERE posicion = 'Opuesto' OR posicion = 'Central';
```

### Nivel 4: Ordenamiento
```sql
-- 9. Todos los jugadores ordenados por altura (menor a mayor)
SELECT nombre, altura 
FROM jugadores_volley 
ORDER BY altura;

-- 10. Jugadores ordenados por puntos (mayor a menor)
SELECT nombre, puntos_temporada 
FROM jugadores_volley 
ORDER BY puntos_temporada DESC;
```

### Nivel 5: Top Rankings
```sql
-- 11. Los 3 jugadores más altos
SELECT nombre, altura 
FROM jugadores_volley 
ORDER BY altura DESC 
LIMIT 3;

-- 12. Los 5 jugadores con más puntos
SELECT nombre, puntos_temporada 
FROM jugadores_volley 
ORDER BY puntos_temporada DESC 
LIMIT 5;
```

---

## 🔥 Desafíos Avanzados

### Desafío 1: Ranking por Posición
```sql
-- Mostrar el jugador con más puntos de cada posición
-- Pista: Vas a necesitar ORDER BY y LIMIT por cada posición
```

### Desafío 2: Consulta Compleja
```sql
-- Jugadores jóvenes (<=24 años) que son altos (>180cm) 
-- o tienen muchos puntos (>210), ordenados por experiencia
SELECT nombre, edad, altura, puntos_temporada, años_experiencia
FROM jugadores_volley 
WHERE edad <= 24 AND (altura > 180 OR puntos_temporada > 210)
ORDER BY años_experiencia DESC;
```

---

## 🎯 Patrones SQL Comunes

### Patrón 1: "Top N" 
```sql
SELECT columnas 
FROM tabla 
ORDER BY columna_criterio DESC 
LIMIT n;
```

### Patrón 2: "Buscar Similar"
```sql
SELECT columnas 
FROM tabla 
WHERE columna LIKE '%texto%';
```

### Patrón 3: "Entre Rangos"
```sql
SELECT columnas 
FROM tabla 
WHERE columna >= valor_min AND columna <= valor_max;
```

### Patrón 4: "Múltiples Opciones"
```sql
SELECT columnas 
FROM tabla 
WHERE columna = 'opcion1' OR columna = 'opcion2';
```

---

## 🤔 Comparación con MongoDB

| **SQL** | **MongoDB** | **Propósito** |
|---------|-------------|---------------|
| `WHERE altura > 180` | `{ altura: { $gt: 180 } }` | Filtrar por condición |
| `ORDER BY puntos DESC` | `.sort({ puntos: -1 })` | Ordenar resultados |  
| `LIMIT 5` | `.limit(5)` | Limitar cantidad |
| `WHERE nombre LIKE '%ez'` | `{ nombre: /ez$/ }` | Buscar patrones |

---

## ✅ Verificaciones de la Clase

**Antes de terminar, asegurate de poder:**
- [ ] Filtrar jugadores por posición usando WHERE
- [ ] Buscar nombres que contengan cierto texto con LIKE  
- [ ] Ordenar jugadores por altura o puntos
- [ ] Mostrar solo los top 3 en alguna categoría
- [ ] Combinar condiciones con AND/OR

---

## 🏠 Tarea Para Casa

1. **Practicar con los ejercicios**: Completar todos los ejercicios de la clase
2. **Crear consultas propias**: Inventar 3 consultas útiles para un equipo de volley
3. **Pensar en aplicaciones**: ¿Qué filtros y ordenamientos necesitarías en tu app de la concesionaria?

### Ejercicios Extra
```sql
-- 1. Jugadores entre 20 y 25 años
-- 2. Jugadores cuyo nombre tiene exactamente 4 letras
-- 3. Los 3 jugadores más pesados que no sean Centrales
-- 4. Jugadores con más experiencia que puntos/10
```

---

## 🎯 Próxima Clase: Creación de Tablas

En la **Clase 3** vamos a aprender:
- Crear tablas desde cero con CREATE TABLE
- Tipos de datos (INTEGER, TEXT, REAL, BOOLEAN)
- Constraints (NOT NULL, UNIQUE, PRIMARY KEY)
- Modificar tablas existentes

**¡Excelente progreso! Ya podés hacer consultas SQL útiles y poderosas.**