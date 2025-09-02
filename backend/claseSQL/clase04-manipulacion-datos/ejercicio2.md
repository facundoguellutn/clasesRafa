# Ejercicio 2: Manipulación de Datos en Lote

## 🎯 Objetivo

Practicar la actualización y eliminación de múltiples registros a la vez de forma segura y controlada, aplicando lógicas de negocio a un conjunto de datos.

---

## 🚀 Setup

Usá el script de `sqlsandbox-setup.sql` de esta clase para tener la tabla `productos` con datos iniciales en [sqlsandbox.com](https://sqlsandbox.com).

---

## 🏋️‍♀️ Ejercicios

### Parte 1: Actualizaciones en Lote (`UPDATE`)

1.  **Promoción de Verano**: El gerente de marketing decide aplicar un 15% de descuento a todos los productos de la categoría 'Electrónica' y 'Computación'.
    *   Escribí una sola sentencia `UPDATE` para aplicar este cambio.
    *   Asegurate de actualizar también la columna `fecha_actualizacion` a la fecha actual.

    ```sql
    -- Primero, verificá qué productos serán afectados
    SELECT nombre, categoria, precio FROM productos WHERE categoria IN ('Electrónica', 'Computación');

    -- Ahora, escribí tu sentencia UPDATE

    ```

2.  **Ajuste de Stock**: Llegó un nuevo lote de accesorios. Aumentá el stock de todos los productos de la categoría 'Accesorios' en 10 unidades.

    ```sql
    -- Verificá el stock actual de accesorios
    SELECT nombre, stock FROM productos WHERE categoria = 'Accesorios';

    -- Escribí tu sentencia UPDATE para incrementar el stock

    ```

3.  **Etiquetado de Productos Antiguos**: Para productos que no se han actualizado (suponiendo que `fecha_actualizacion` es `NULL`), queremos agregar una nota en su descripción.
    *   Añadí el texto " - REVISAR PRECIO" al final de la `descripcion` de todos los productos donde `fecha_actualizacion` sea `NULL`.
    *   (Nota: Como el setup no tiene `descripcion`, primero agregala: `ALTER TABLE productos ADD COLUMN descripcion TEXT;`)

    ```sql
    -- Tu código UPDATE aquí

    ```

### Parte 2: Eliminaciones Estratégicas (`DELETE` y Soft Delete)

4.  **Limpieza de Inventario**: Se decide descontinuar todos los productos de la categoría 'Gaming' (si la agregaste en ejercicios anteriores) o, si no, de la categoría 'Accesorios' cuyo precio sea menor a 5000.
    *   **Primero**, escribí el `SELECT` para ver exactamente qué productos se borrarían.
    *   **Segundo**, escribí la sentencia `DELETE`.

    ```sql
    -- Tu SELECT de verificación

    -- Tu sentencia DELETE

    ```

5.  **Archivado de Productos sin Stock**: En lugar de borrar, vamos a "archivar" (soft delete) todos los productos cuyo stock sea 0.
    *   Escribí una sentencia `UPDATE` para cambiar el estado `activo` a `FALSE` para todos los productos con `stock = 0`.

    ```sql
    -- Tu código UPDATE para el soft delete

    ```

6.  **Desafío de Eliminación**: Eliminá todos los clientes (de la tabla `clientes` del setup) que no tengan un email que termine en `.com`.
    *   ¡Cuidado! Verificá primero con `SELECT`.

    ```sql
    -- Tu SELECT de verificación

    -- Tu sentencia DELETE

    ```

---

## 💡 Solución Propuesta

<details>
<summary>Click para ver la solución</summary>

```sql
-- --- EJERCICIO 1: Promoción de Verano ---
UPDATE productos
SET 
    precio = precio * 0.85,
    fecha_actualizacion = CURRENT_DATE
WHERE categoria IN ('Electrónica', 'Computación');


-- --- EJERCICIO 2: Ajuste de Stock ---
UPDATE productos
SET stock = stock + 10
WHERE categoria = 'Accesorios';


-- --- EJERCICIO 3: Etiquetado de Productos Antiguos ---
-- (Primero, agregar la columna si no existe)
-- ALTER TABLE productos ADD COLUMN descripcion TEXT;
UPDATE productos
SET descripcion = IFNULL(descripcion, '') || ' - REVISAR PRECIO'
WHERE fecha_actualizacion IS NULL;
-- Usamos IFNULL para evitar problemas si la descripción era NULL.


-- --- EJERCICIO 4: Limpieza de Inventario ---
-- Verificación
SELECT * FROM productos WHERE categoria = 'Accesorios' AND precio < 5000;
-- Eliminación
DELETE FROM productos WHERE categoria = 'Accesorios' AND precio < 5000;


-- --- EJERCICIO 5: Archivado de Productos sin Stock ---
UPDATE productos
SET activo = FALSE
WHERE stock = 0;


-- --- EJERCICIO 6: Desafío de Eliminación ---
-- Verificación
SELECT * FROM clientes WHERE email NOT LIKE '%.com';
-- Eliminación
DELETE FROM clientes WHERE email NOT LIKE '%.com';

```

</details>
