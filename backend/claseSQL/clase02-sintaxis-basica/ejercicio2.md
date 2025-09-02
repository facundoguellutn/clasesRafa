# Ejercicio 2: Combinando Cláusulas

## 🎯 Objetivo

Practicar la combinación de las cláusulas `WHERE`, `ORDER BY` y `LIMIT` para resolver problemas más complejos y realistas.

---

## 🚀 Setup

Asegurate de tener la tabla `jugadores_volley` creada en [sqlsandbox.com](https://sqlsandbox.com) usando el script de `sqlsandbox-setup.sql`.

---

## 🏋️‍♀️ Ejercicios

En estos ejercicios, necesitarás combinar varias cláusulas para obtener el resultado exacto.

### Parte 1: Filtrar y Ordenar

1.  **Atacantes por Altura**: Mostrame el `nombre` y la `altura` de todos los jugadores que son `Punta` u `Opuesto`, ordenados por altura de mayor a menor.
    ```sql
    -- Tu código aquí
    ```

2.  **Jugadores Experimentados y Ligeros**: Mostrame el `nombre`, `años_experiencia` y `peso` de los jugadores con más de 5 años de experiencia y que pesan menos de 85kg. Ordenalos por años de experiencia (los más veteranos primero).
    ```sql
    -- Tu código aquí
    ```

3.  **Jóvenes Promesas**: Mostrame el `nombre`, `edad` y `puntos_temporada` de los jugadores de 23 años o menos. Ordenalos por los puntos que han hecho, de mayor a menor.
    ```sql
    -- Tu código aquí
    ```

### Parte 2: El Top de un Subconjunto

Ahora vamos a encontrar el "Top N" pero no de toda la tabla, sino de un grupo filtrado.

4.  **El Central Más Alto**: De todos los jugadores que son `Central`, encontrá al más alto. Mostrá solo su `nombre` y `altura`.
    ```sql
    -- Tu código aquí
    ```

5.  **Los 2 Armadores con Más Puntos**: De los jugadores que son `Armador`, encontrá los 2 que tienen más puntos. Mostrá su `nombre` y `puntos_temporada`.
    ```sql
    -- Tu código aquí
    ```

6.  **El Libero Más Joven**: Encontrá al `Libero` de menor edad. Mostrá su `nombre` y `edad`.
    ```sql
    -- Tu código aquí
    ```

### Parte 3: Desafíos de Combinación Total

7.  **El Talento Oculto**: Encontrá a los 3 jugadores con más puntos entre aquellos que tienen 4 años de experiencia o menos. Mostrá `nombre`, `puntos_temporada` y `años_experiencia`, ordenados por puntos.
    ```sql
    -- Tu código aquí
    ```

8.  **Búsqueda Específica**: Encontrá jugadores cuyo nombre contenga la letra 'o', que sean mayores de 24 años, y ordenalos por edad de forma ascendente.
    ```sql
    -- Tu código aquí
    ```

---
## 💡 Soluciones

<details>
<summary>Click para ver las soluciones</summary>

1.  **Atacantes por Altura**:
    ```sql
    SELECT nombre, altura
    FROM jugadores_volley
    WHERE posicion = 'Punta' OR posicion = 'Opuesto'
    ORDER BY altura DESC;
    ```

2.  **Jugadores Experimentados y Ligeros**:
    ```sql
    SELECT nombre, años_experiencia, peso
    FROM jugadores_volley
    WHERE años_experiencia > 5 AND peso < 85
    ORDER BY años_experiencia DESC;
    ```

3.  **Jóvenes Promesas**:
    ```sql
    SELECT nombre, edad, puntos_temporada
    FROM jugadores_volley
    WHERE edad <= 23
    ORDER BY puntos_temporada DESC;
    ```

4.  **El Central Más Alto**:
    ```sql
    SELECT nombre, altura
    FROM jugadores_volley
    WHERE posicion = 'Central'
    ORDER BY altura DESC
    LIMIT 1;
    ```

5.  **Los 2 Armadores con Más Puntos**:
    ```sql
    SELECT nombre, puntos_temporada
    FROM jugadores_volley
    WHERE posicion = 'Armador'
    ORDER BY puntos_temporada DESC
    LIMIT 2;
    ```

6.  **El Libero Más Joven**:
    ```sql
    SELECT nombre, edad
    FROM jugadores_volley
    WHERE posicion = 'Libero'
    ORDER BY edad ASC
    LIMIT 1;
    ```

7.  **El Talento Oculto**:
    ```sql
    SELECT nombre, puntos_temporada, años_experiencia
    FROM jugadores_volley
    WHERE años_experiencia <= 4
    ORDER BY puntos_temporada DESC
    LIMIT 3;
    ```

8.  **Búsqueda Específica**:
    ```sql
    SELECT nombre, edad
    FROM jugadores_volley
    WHERE nombre LIKE '%o%' AND edad > 24
    ORDER BY edad ASC;
    ```

</details>
