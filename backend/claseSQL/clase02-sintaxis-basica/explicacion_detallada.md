# Explicación Detallada: El Flujo Lógico de una Consulta SQL

## 🎯 Objetivo de este Documento

Este documento profundiza en **cómo** SQL procesa tus consultas. Entender el orden lógico de las operaciones te ayudará a construir queries más complejas sin errores y a optimizar tu pensamiento al resolver problemas.

---

## 🧠 El Orden Lógico de Ejecución en SQL

Cuando escribís una consulta, no la leés como SQL la "piensa". Vos escribís en un orden, pero la base de datos sigue un orden lógico diferente para obtener el resultado. Este es el orden real:

1.  **`FROM`**: Primero, la base de datos mira la tabla que especificaste. Carga todos los datos de `jugadores_volley` en memoria (conceptualmente).

2.  **`WHERE`**: Luego, aplica los filtros. Recorre cada fila de la tabla y descarta las que no cumplen la condición. El resultado de este paso es un conjunto de datos más pequeño (un "result set" intermedio).

3.  **`GROUP BY`**: (Lo veremos más adelante) Agrupa las filas filtradas.

4.  **`HAVING`**: (Lo veremos más adelante) Filtra los grupos.

5.  **`SELECT`**: Ahora, la base de datos mira qué columnas pediste. De las filas que sobrevivieron al filtro `WHERE`, selecciona solo las columnas que especificaste.

6.  **`ORDER BY`**: Después de tener el conjunto final de filas y columnas, las ordena según tu criterio (`ASC` o `DESC`).

7.  **`LIMIT`**: Finalmente, si especificaste un límite, descarta todas las filas ordenadas excepto las primeras `N`.

### ¿Por Qué Es Importante Este Orden?

Porque explica comportamientos que de otra manera serían confusos. Por ejemplo, no podés usar un alias de columna definido en `SELECT` dentro de una cláusula `WHERE`, porque `WHERE` se procesa *antes* que `SELECT`.

**Incorrecto:**
```sql
SELECT nombre, (puntos_temporada / años_experiencia) AS efectividad
FROM jugadores_volley
WHERE efectividad > 30; -- ERROR: la columna "efectividad" no existe todavía
```

**Correcto:**
```sql
SELECT nombre, (puntos_temporada / años_experiencia) AS efectividad
FROM jugadores_volley
WHERE (puntos_temporada / años_experiencia) > 30; -- OK: usas las columnas originales
```

---

## 🚦 Precedencia de Operadores en `WHERE`

Cuando combinás `AND` y `OR`, SQL tiene reglas de prioridad, igual que en matemáticas (la multiplicación se hace antes que la suma).

> **La regla es: `AND` se evalúa siempre ANTES que `OR`.**

Considerá esta consulta:
```sql
SELECT * FROM jugadores_volley
WHERE posicion = 'Opuesto' OR posicion = 'Central' AND altura > 200;
```

Uno podría pensar que esto significa "(Opuesto o Central) Y que midan más de 200cm". **Pero es incorrecto.**

SQL lo interpreta así:
`posicion = 'Opuesto' OR (posicion = 'Central' AND altura > 200)`

Esto te devolverá:
*   Todos los Opuestos (sin importar su altura).
*   Y además, los Centrales que midan más de 200cm.

### El Poder de los Paréntesis `()`

Para evitar esta ambigüedad y controlar el orden, **siempre usá paréntesis cuando combines `AND` y `OR`**. Es una buena práctica que te ahorrará muchos errores.

**Consulta correcta y clara:**
```sql
-- Jugadores que son (Opuestos O Centrales) Y que además son altos
SELECT * FROM jugadores_volley
WHERE (posicion = 'Opuesto' OR posicion = 'Central') AND altura > 200;
```

---

## `LIKE`: Un Vistazo Más Profundo

El operador `LIKE` es muy potente para buscar texto, pero es importante saber algunas cosas:

*   **Sensibilidad a Mayúsculas/Minúsculas (Case Sensitivity)**: En muchas bases de datos (como PostgreSQL), `LIKE` es sensible a mayúsculas. `LIKE 'a%'` no encontrará 'Ana'. En otras (como SQLite, la que usa SQLSandbox), no lo es. Es bueno saber que este comportamiento puede variar.
*   **Rendimiento (Performance)**: Las búsquedas con `LIKE` que empiezan con un comodín (`%texto%`) son las más lentas. ¿Por qué? Porque la base de datos no puede usar un índice (lo veremos en clases futuras) y tiene que escanear la tabla completa. Las que empiezan sin comodín (`texto%`) son mucho más rápidas.

---

## `NULL`: La Representación de la Ausencia

En SQL, `NULL` es un valor especial que representa la ausencia de dato. No es lo mismo que `0`, un string vacío `''` o `false`.

Para buscar filas donde un valor es `NULL`, no podés usar `= NULL`. La sintaxis correcta es `IS NULL` o `IS NOT NULL`.

**Ejemplo**: Si algunos jugadores no tuvieran asignada una posición:
```sql
-- Encontrar jugadores sin posición asignada
SELECT nombre FROM jugadores_volley WHERE posicion IS NULL;

-- Encontrar jugadores que SÍ tienen posición asignada
SELECT nombre FROM jugadores_volley WHERE posicion IS NOT NULL;
```

Esto es fundamental para manejar datos incompletos en el mundo real.

---

## ✅ Resumen de Conceptos Avanzados

*   **Orden de Ejecución Lógico**: `FROM` -> `WHERE` -> `SELECT` -> `ORDER BY` -> `LIMIT`. Entender esto es clave para escribir consultas correctas.
*   **Precedencia de `AND` sobre `OR`**: `AND` se evalúa primero. Usá siempre paréntesis `()` para agrupar condiciones con `OR` y evitar resultados inesperados.
*   **`LIKE` y su Rendimiento**: Las búsquedas que empiezan con `%` son más lentas. La sensibilidad a mayúsculas puede variar entre sistemas de bases de datos.
*   **Manejo de `NULL`**: `NULL` representa la ausencia de un valor. Se debe usar `IS NULL` o `IS NOT NULL` para filtrar por él, nunca `= NULL`.
