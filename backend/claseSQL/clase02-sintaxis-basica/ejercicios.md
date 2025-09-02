# Ejercicios Clase 2 - Sintaxis Básica SQL

## 🚀 Setup Inicial
1. Abrir [sqlsandbox.com](https://sqlsandbox.com)
2. Copiar y pegar el contenido de `sqlsandbox-setup.sql`
3. Hacer click en "Run" para crear la base de datos con 15 jugadores

---

## 🏋️ Ejercicios Nivel Básico

### Ejercicio 1: Filtros Simples con WHERE
```sql
-- 1.1 Mostrar solo los liberos
SELECT * FROM jugadores_volley WHERE posicion = 'Libero';

-- 1.2 Jugadores que miden más de 180cm
SELECT nombre, altura FROM jugadores_volley WHERE altura > 180;

-- 1.3 Jugadores con más de 200 puntos en la temporada
SELECT nombre, puntos_temporada FROM jugadores_volley WHERE puntos_temporada > 200;

-- 1.4 Jugadores menores de 25 años
SELECT nombre, edad FROM jugadores_volley WHERE edad < 25;
```

### Ejercicio 2: Búsquedas con LIKE
```sql
-- 2.1 Jugadores cuyos nombres empiezan con 'M'
SELECT nombre FROM jugadores_volley WHERE nombre LIKE 'M%';

-- 2.2 Jugadores cuyos nombres terminan con 'ez'
SELECT nombre FROM jugadores_volley WHERE nombre LIKE '%ez';

-- 2.3 Jugadores cuyos nombres contienen 'ar'
SELECT nombre FROM jugadores_volley WHERE nombre LIKE '%ar%';

-- 2.4 Jugadores con nombres de exactamente 4 letras empezando con 'J'
SELECT nombre FROM jugadores_volley WHERE nombre LIKE 'J___';
```

---

## 🏋️ Ejercicios Nivel Intermedio

### Ejercicio 3: Condiciones Combinadas con AND/OR
```sql
-- 3.1 Jugadores altos (>185cm) Y con muchos puntos (>200)
SELECT nombre, altura, puntos_temporada 
FROM jugadores_volley 
WHERE altura > 185 AND puntos_temporada > 200;

-- 3.2 Jugadores que son Opuestos O Centrales
SELECT nombre, posicion 
FROM jugadores_volley 
WHERE posicion = 'Opuesto' OR posicion = 'Central';

-- 3.3 Jugadores jóvenes (<=24) O con poca experiencia (<=3 años)
SELECT nombre, edad, años_experiencia 
FROM jugadores_volley 
WHERE edad <= 24 OR años_experiencia <= 3;

-- 3.4 Jugadores que NO son Liberos
SELECT nombre, posicion 
FROM jugadores_volley 
WHERE posicion != 'Libero';
```

### Ejercicio 4: Ordenamiento con ORDER BY
```sql
-- 4.1 Todos los jugadores ordenados por altura (menor a mayor)
SELECT nombre, altura FROM jugadores_volley ORDER BY altura;

-- 4.2 Jugadores ordenados por puntos (mayor a menor)  
SELECT nombre, puntos_temporada FROM jugadores_volley ORDER BY puntos_temporada DESC;

-- 4.3 Ordenar por posición, luego por altura
SELECT nombre, posicion, altura FROM jugadores_volley ORDER BY posicion, altura DESC;

-- 4.4 Ordenar por experiencia (más experiencia primero), luego por edad
SELECT nombre, años_experiencia, edad FROM jugadores_volley ORDER BY años_experiencia DESC, edad;
```

---

## 🏋️ Ejercicios Nivel Avanzado

### Ejercicio 5: Rankings con LIMIT
```sql
-- 5.1 Los 3 jugadores más altos
SELECT nombre, altura FROM jugadores_volley ORDER BY altura DESC LIMIT 3;

-- 5.2 Los 5 jugadores con más puntos
SELECT nombre, puntos_temporada FROM jugadores_volley ORDER BY puntos_temporada DESC LIMIT 5;

-- 5.3 Los 3 jugadores más jóvenes
SELECT nombre, edad FROM jugadores_volley ORDER BY edad LIMIT 3;

-- 5.4 El jugador más pesado
SELECT nombre, peso FROM jugadores_volley ORDER BY peso DESC LIMIT 1;
```

### Ejercicio 6: Consultas Complejas
```sql
-- 6.1 Jugadores entre 22 y 25 años que midan más de 170cm
SELECT nombre, edad, altura 
FROM jugadores_volley 
WHERE edad >= 22 AND edad <= 25 AND altura > 170;

-- 6.2 Top 3 jugadores más efectivos (más puntos por año de experiencia)
-- Pista: necesitás calcular puntos_temporada / años_experiencia
SELECT nombre, puntos_temporada, años_experiencia,
       (puntos_temporada * 1.0 / años_experiencia) as efectividad
FROM jugadores_volley 
WHERE años_experiencia > 0
ORDER BY efectividad DESC 
LIMIT 3;

-- 6.3 Jugadores altos que son atacantes (Opuesto, Central, Punta)
SELECT nombre, posicion, altura 
FROM jugadores_volley 
WHERE altura > 180 AND (posicion = 'Opuesto' OR posicion = 'Central' OR posicion = 'Punta');
```

---

## 🔥 Desafíos Extra

### Desafío 1: Análisis por Posiciones
```sql
-- Mostrar cuántos jugadores hay de cada posición
-- Pista: Vas a necesitar GROUP BY (lo vemos en clase futura, pero podés intentar)
SELECT posicion, COUNT(*) as cantidad
FROM jugadores_volley 
GROUP BY posicion;
```

### Desafío 2: Búsquedas Creativas
```sql
-- D2.1 Jugadores cuyo nombre tiene exactamente 2 palabras
SELECT nombre FROM jugadores_volley WHERE nombre LIKE '% %' AND nombre NOT LIKE '% % %';

-- D2.2 Jugadores cuyo peso está entre 60 y 80 kg
SELECT nombre, peso FROM jugadores_volley WHERE peso >= 60 AND peso <= 80;

-- D2.3 Jugadores que tienen más puntos que su altura
SELECT nombre, puntos_temporada, altura 
FROM jugadores_volley 
WHERE puntos_temporada > altura;
```

---

## 🎯 Ejercicios Para Casa

### Aplicación Práctica: Concesionaria
Imaginate que tenés estos datos de una concesionaria. Escribí las consultas SQL:

```sql
-- Setup hipotético (no lo corras, solo pensá la consulta)
CREATE TABLE vehiculos (
    id INTEGER PRIMARY KEY,
    marca TEXT,
    modelo TEXT,
    año INTEGER,
    precio INTEGER,
    kilometraje INTEGER,
    combustible TEXT,
    vendido BOOLEAN
);
```

**Escribí consultas para:**
1. Autos Toyota no vendidos
2. Los 5 autos más baratos
3. Autos del 2020 o más nuevos ordenados por precio
4. Autos con menos de 50,000 km que usen nafta
5. Autos cuyo modelo contenga "Corolla"

---

## ✅ Verificaciones

### ¿Completaste correctamente?
Estas consultas deberían darte estos resultados:

```sql
-- Debería mostrar 4 liberos
SELECT COUNT(*) FROM jugadores_volley WHERE posicion = 'Libero';

-- Debería mostrar "Fernando Castro" como el de más puntos
SELECT nombre FROM jugadores_volley ORDER BY puntos_temporada DESC LIMIT 1;

-- Debería mostrar 6 jugadores
SELECT COUNT(*) FROM jugadores_volley WHERE altura > 185;
```

### Auto-evaluación
- [ ] Puedo filtrar datos con WHERE usando =, >, <, !=
- [ ] Sé usar LIKE con % y _ para buscar patrones
- [ ] Puedo combinar condiciones con AND/OR
- [ ] Sé ordenar datos con ORDER BY ASC/DESC  
- [ ] Puedo limitar resultados con LIMIT
- [ ] Entiendo cómo combinar WHERE, ORDER BY y LIMIT

---

## 🤔 Reflexiones

1. **¿Qué consulta te resultó más útil?** ¿Por qué?

2. **Compará con MongoDB**: ¿Cuál te parece más claro para filtrar y ordenar datos?

3. **Aplicación real**: Si fueras a hacer una app para tu equipo de volley, ¿qué consultas harías más seguido?

---

## 🎯 Próxima Clase: Creación de Tablas

En la **Clase 3** vamos a aprender:
- Crear nuestras propias tablas con CREATE TABLE
- Tipos de datos (INTEGER, TEXT, REAL, DATE, BOOLEAN)
- Constraints (NOT NULL, UNIQUE, PRIMARY KEY, CHECK)
- Modificar tablas existentes con ALTER TABLE

**¡Excelente trabajo! Ya dominás lo básico de consultas SQL.**