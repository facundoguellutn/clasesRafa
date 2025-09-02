# Ejercicio 3: Corrección de Datos y Operaciones Secuenciales

## 🎯 Objetivo

Enfrentar un escenario realista de "datos sucios" y corregirlos mediante una secuencia lógica de operaciones `UPDATE`. Además, simular un proceso de negocio que requiere múltiples pasos.

---

## 📖 Escenario: Datos Desordenados

Después de una migración de datos fallida, la tabla `productos` ha quedado con algunas inconsistencias. Tu tarea es limpiarla.

**Datos Iniciales (Imaginarios, para el ejercicio):**
*   Hay productos llamados 'Iphone 13' y 'samsung galaxy s22' (en minúsculas).
*   Algunos productos de 'Computación' tienen un precio de `0` o negativo.
*   La categoría 'Accesorios' a veces está mal escrita como 'accesorios' (en minúscula).
*   Hay un producto duplicado: dos entradas para 'Logitech Mouse'.

---

## 🏋️‍♀️ Tu Tarea - Parte 1: Limpieza de Datos

Escribí una secuencia de sentencias `UPDATE` para corregir los siguientes problemas. Hacé una sentencia por cada punto.

1.  **Estandarizar Nombres**: Poné en mayúscula la primera letra de los nombres de todos los productos. SQLite tiene la función `INITCAP()`.
    ```sql
    -- Pista: UPDATE productos SET nombre = INITCAP(nombre);
    ```

2.  **Corregir Categorías**: Unificá la categoría 'accesorios' a 'Accesorios'.
    ```sql
    -- Tu código aquí
    ```

3.  **Solucionar Precios Inválidos**: Para cualquier producto de la categoría 'Computación' con un precio menor o igual a 0, establecé un precio por defecto de `10000.00` y añadí la nota "PRECIO A CONFIRMAR" en la descripción.
    ```sql
    -- (Primero, asegurate de que la columna descripcion exista: ALTER TABLE productos ADD COLUMN descripcion TEXT;)
    -- Tu código aquí
    ```

4.  **Manejar Duplicados (Conceptual)**: No podemos borrar duplicados fácilmente sin riesgo, pero vamos a identificarlos y "desactivar" el más antiguo.
    *   Identificá el `id` más bajo del 'Logitech Mouse'.
    *   Usá `UPDATE` para hacer un soft delete (poner `activo = FALSE`) de ese `id`.

    ```sql
    -- Ver los duplicados y sus IDs
    SELECT id, nombre FROM productos WHERE nombre = 'Logitech Mouse';

    -- Escribí el UPDATE para desactivar el de ID más bajo

    ```

---

## 🏋️‍♀️ Tu Tarea - Parte 2: Simulación de Proceso de Negocio

El departamento de compras te informa de una nueva llegada de 'MacBook Air'.

**Realizá las siguientes operaciones en orden:**

1.  **Aumentar Stock**: Llegaron 5 unidades nuevas. Incrementá el stock del 'MacBook Air' en 5.

2.  **Ajuste de Precio**: El nuevo lote es un 10% más caro. Actualizá el precio del 'MacBook Air' para que refleje este aumento.

3.  **Actualizar Descripción**: Añadí la nota "Modelo M2 - Nuevo Ingreso" al final de la descripción del producto.

4.  **Registrar Actualización**: Asegurate de que la `fecha_actualizacion` refleje el día de hoy.

**Desafío**: ¿Podés hacer todo esto en una sola sentencia `UPDATE`?

```sql
-- Tu código aquí (puede ser una o varias sentencias)

```

### Verificación

Escribí una consulta `SELECT` para mostrar el estado final del 'MacBook Air' y asegurarte de que todos los cambios se aplicaron correctamente.

```sql
-- Tu SELECT de verificación aquí

```

---

## 💡 Solución Propuesta

<details>
<summary>Click para ver la solución</summary>

```sql
-- --- PARTE 1: LIMPIEZA DE DATOS ---

-- 1. Estandarizar Nombres
UPDATE productos SET nombre = INITCAP(nombre);

-- 2. Corregir Categorías
UPDATE productos SET categoria = 'Accesorios' WHERE categoria = 'accesorios';

-- 3. Solucionar Precios Inválidos
-- (Asegurarse de que la columna exista)
-- ALTER TABLE productos ADD COLUMN descripcion TEXT;
UPDATE productos 
SET 
    precio = 10000.00,
    descripcion = IFNULL(descripcion, '') || ' PRECIO A CONFIRMAR'
WHERE categoria = 'Computación' AND precio <= 0;

-- 4. Manejar Duplicados
-- (Supongamos que los IDs para 'Logitech Mouse' son 8 y 14)
UPDATE productos
SET activo = FALSE
WHERE id = 8; -- O el ID más bajo que hayas encontrado


-- --- PARTE 2: PROCESO DE NEGOCIO ---

-- Solución en una sola sentencia UPDATE
UPDATE productos
SET
    stock = stock + 5,
    precio = precio * 1.10,
    descripcion = IFNULL(descripcion, '') || ' Modelo M2 - Nuevo Ingreso',
    fecha_actualizacion = CURRENT_DATE
WHERE nombre = 'MacBook Air';


-- --- VERIFICACIÓN ---
SELECT nombre, stock, precio, descripcion, fecha_actualizacion
FROM productos
WHERE nombre = 'MacBook Air';

```

</details>
