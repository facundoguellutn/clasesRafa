# Ejercicio 3: Escenarios del Mundo Real y Manipulación de Datos

## 🎯 Objetivo

Traducir requerimientos del "mundo real" a consultas SQL completas y aprender a modificar datos existentes con la sentencia `UPDATE`.

---

## 🚀 Setup

Asegurate de tener la tabla `jugadores_volley` creada en [sqlsandbox.com](https://sqlsandbox.com) usando el script de `sqlsandbox-setup.sql`.

---

## 🏋️‍♀️ Ejercicios

### Parte 1: Eres el Analista del Equipo

El entrenador te pide los siguientes informes. Escribí una sola consulta SQL para cada petición.

1.  **Petición**: "Necesito una lista de posibles líberos para probar. Dame los 3 jugadores más ligeros (menor peso) que no sean Centrales ni Opuestos. Mostrame su nombre, posición y peso."
    ```sql
    -- Tu código aquí
    ```

2.  **Petición**: "Quiero ver a nuestros jugadores más experimentados. Dame la lista de jugadores con 5 o más años de experiencia, ordenados del más al menos experimentado. Si tienen la misma experiencia, que el más alto aparezca primero."
    ```sql
    -- Tu código aquí
    ```

3.  **Petición**: "Buscamos un atacante potente y joven. Filtra los jugadores que sean Punta u Opuesto, que tengan 25 años o menos, y muéstrame los 2 con más puntos de esa selección. Necesito ver su nombre, posición, edad y puntos."
    ```sql
    -- Tu código aquí
    ```

### Parte 2: Actualizando Datos con `UPDATE`

Ha pasado un tiempo y los datos de los jugadores han cambiado. La sentencia `UPDATE` nos permite modificar registros existentes.

**Sintaxis básica de `UPDATE`:**
```sql
UPDATE nombre_tabla
SET columna1 = valor1, columna2 = valor2
WHERE condicion; -- ¡MUY IMPORTANTE! Si no pones WHERE, actualizas TODA la tabla.
```

**Ahora, aplicá las siguientes actualizaciones:**

4.  **Actualización de Puntos**: Juan Pérez (id=1) tuvo un gran partido y sumó 30 puntos más. Su total era 240. Actualizá sus `puntos_temporada` a 270.
    ```sql
    -- Tu código aquí
    ```
    *Después de correr el `UPDATE`, verificá con un `SELECT` que el cambio se hizo.* 
    `SELECT nombre, puntos_temporada FROM jugadores_volley WHERE id = 1;`

5.  **Cambio de Posición**: Roberto Silva (id=5) ha demostrado ser un gran Opuesto. Cambiá su `posicion` de 'Punta' a 'Opuesto'.
    ```sql
    -- Tu código aquí
    ```
    *Verificá el cambio con un `SELECT`.*

6.  **Actualización General**: El entrenador decide dar un bonus de 5 puntos a todos los Armadores por su buen desempeño. Actualizá los `puntos_temporada` de todos los jugadores cuya posición es 'Armador', sumándoles 5 puntos a su valor actual.
    ```sql
    -- Pista: podés hacer `SET puntos_temporada = puntos_temporada + 5`
    -- Tu código aquí
    ```
    *Verificá el cambio con un `SELECT` que muestre todos los armadores.*

### Parte 3: Desafío Final

7.  **El Jugador Más Valioso (MVP)**: Después de todas las actualizaciones que hiciste, ¿quién es ahora el jugador con más puntos en toda la temporada? Escribí una sola consulta para encontrarlo.
    ```sql
    -- Tu código aquí
    ```

---
## 💡 Soluciones

<details>
<summary>Click para ver las soluciones</summary>

1.  **Posibles Líberos**:
    ```sql
    SELECT nombre, posicion, peso
    FROM jugadores_volley
    WHERE posicion != 'Central' AND posicion != 'Opuesto'
    ORDER BY peso ASC
    LIMIT 3;
    ```

2.  **Jugadores Experimentados**:
    ```sql
    SELECT nombre, años_experiencia, altura
    FROM jugadores_volley
    WHERE años_experiencia >= 5
    ORDER BY años_experiencia DESC, altura DESC;
    ```

3.  **Atacante Potente y Joven**:
    ```sql
    SELECT nombre, posicion, edad, puntos_temporada
    FROM jugadores_volley
    WHERE (posicion = 'Punta' OR posicion = 'Opuesto') AND edad <= 25
    ORDER BY puntos_temporada DESC
    LIMIT 2;
    ```

4.  **Actualizar Puntos de Juan Pérez**:
    ```sql
    UPDATE jugadores_volley
    SET puntos_temporada = 270
    WHERE id = 1;
    ```

5.  **Cambiar Posición de Roberto Silva**:
    ```sql
    UPDATE jugadores_volley
    SET posicion = 'Opuesto'
    WHERE id = 5;
    ```

6.  **Bonus para Armadores**:
    ```sql
    UPDATE jugadores_volley
    SET puntos_temporada = puntos_temporada + 5
    WHERE posicion = 'Armador';
    ```

7.  **MVP Post-Actualización**:
    ```sql
    SELECT nombre, puntos_temporada
    FROM jugadores_volley
    ORDER BY puntos_temporada DESC
    LIMIT 1;
    ```
    *(La respuesta debería ser Juan Pérez con 270 puntos)*.

</details>
