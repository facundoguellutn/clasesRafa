# Explicación Detallada: El Arte de Diseñar Tablas

## 🎯 Objetivo de este Documento

Este documento va más allá de la sintaxis de `CREATE TABLE`. El objetivo es enseñarte a **pensar como un diseñador de bases de datos**. Aprenderás a traducir los requisitos del mundo real en tablas bien estructuradas, eficientes y robustas.

---

## 🎨 De Requisitos a Tablas: El Proceso Mental

Diseñar una tabla no es solo listar columnas. Es un proceso de modelado. Seguí estos pasos:

1.  **Identificar la "Entidad" Principal**: ¿De qué estás guardando información? ¿Usuarios? ¿Productos? ¿Citas médicas? Cada una de estas es una "entidad" y probablemente será una tabla.

2.  **Listar los "Atributos"**: ¿Qué información necesitás saber sobre esa entidad? Para un `Usuario`, necesitás nombre, email, fecha de nacimiento, etc. Estos son tus futuras columnas.

3.  **Elegir el Tipo de Dato Correcto (Semántica)**: No pienses solo en "número" o "texto". Pensá en el **significado**.
    *   ¿Es un identificador único? -> `INTEGER PRIMARY KEY`.
    *   ¿Es dinero? -> `REAL`.
    *   ¿Es una cantidad contable? -> `INTEGER`.
    *   ¿Es un estado binario (sí/no, activo/inactivo)? -> `BOOLEAN`.
    *   ¿Es una fecha? -> `DATE`.

4.  **Aplicar las Reglas (Constraints)**: Aquí es donde traducís las "reglas del negocio" en reglas de la base de datos.
    *   "Todo usuario debe tener un email" -> `email TEXT NOT NULL`.
    *   "El email no se puede repetir" -> `email TEXT UNIQUE NOT NULL`.
    *   "El stock no puede ser negativo" -> `stock INTEGER CHECK (stock >= 0)`.
    *   "Por defecto, los nuevos usuarios están activos" -> `activo BOOLEAN DEFAULT TRUE`.

5.  **Pensar en las Relaciones (Introducción a Foreign Keys)**: ¿Cómo se conecta esta tabla con otras? (Lo veremos en detalle más adelante, pero es crucial empezar a pensarlo ahora).

---

## 🔗 Introducción a las Relaciones: `FOREIGN KEY` (Clave Foránea)

Ya creamos una tabla `ventas` con `vehiculo_id` y `cliente_id`. Estos campos son la base de las relaciones en SQL.

```sql
CREATE TABLE ventas (
    id INTEGER PRIMARY KEY,
    vehiculo_id INTEGER NOT NULL, -- ← Esto apunta al 'id' de la tabla 'vehiculos'
    cliente_id INTEGER NOT NULL,  -- ← Esto apunta al 'id' de la tabla 'clientes'
    fecha_venta DATE
);
```

Una **Clave Foránea (`FOREIGN KEY`)** es un constraint que formaliza esta conexión. Le dice a la base de datos:

> "El valor en `ventas.vehiculo_id` **DEBE** existir en la columna `vehiculos.id`."

**¿Qué ganas con esto?**

1.  **Integridad Referencial**: La base de datos te **impide** crear una venta para un auto que no existe. ¡No más datos huérfanos!
2.  **Consistencia**: No podés borrar un cliente si tiene ventas asociadas (a menos que se lo pidas explícitamente).
3.  **Claridad**: El diseño de la base de datos se auto-documenta, mostrando claramente cómo se conectan las tablas.

La sintaxis completa la veremos en la clase de `JOINs`, pero el concepto es este: **usar el `PRIMARY KEY` de una tabla como un campo (`FOREIGN KEY`) en otra para crear una relación.**

---

## 📉 Normalización: El Principio de No Repetir Datos

La normalización es un proceso formal para organizar las columnas y tablas en tu base de datos para minimizar la redundancia de datos.

**El principio básico es: "Cada pieza de información debe vivir en un solo lugar".**

### Ejemplo Práctico: Evitando la Redundancia

**Diseño Malo (No Normalizado):**
```sql
CREATE TABLE ventas_mal (
    id INTEGER PRIMARY KEY,
    fecha_venta DATE,
    -- Datos del vehículo
    marca_vehiculo TEXT,
    modelo_vehiculo TEXT,
    -- Datos del cliente
    nombre_cliente TEXT,
    email_cliente TEXT UNIQUE
);
```

**Problemas:**
*   Si Juan Pérez compra 3 autos, su nombre y email estarán repetidos 3 veces.
*   Si escribís mal "Toyota" como "Toyotta" en una venta, tenés datos inconsistentes.
*   Si el cliente cambia su email, tenés que actualizarlo en CADA venta que hizo. Un desastre.

**Diseño Bueno (Normalizado):**

Se divide la información en tres tablas, cada una con su propia responsabilidad:

1.  **`vehiculos`**: Contiene solo información de vehículos.
2.  **`clientes`**: Contiene solo información de clientes.
3.  **`ventas`**: Conecta las otras dos usando sus IDs.

```sql
-- Tabla de ventas (solo los IDs y los datos propios de la venta)
CREATE TABLE ventas_bien (
    id INTEGER PRIMARY KEY,
    fecha_venta DATE,
    precio_final REAL,
    vehiculo_id INTEGER, -- Apunta a vehiculos.id
    cliente_id INTEGER   -- Apunta a clientes.id
);
```

**Ventajas:**
*   El nombre de Juan Pérez está guardado UNA SOLA VEZ en la tabla `clientes`.
*   La información del Toyota Corolla está guardada UNA SOLA VEZ en la tabla `vehiculos`.
*   Si el email de un cliente cambia, lo actualizás en un solo lugar: la tabla `clientes`.
*   Ahorrás espacio y garantizás consistencia.

---

## ✅ Resumen de la Filosofía de Diseño

*   **Una tabla, una entidad**: Cada tabla debe representar una sola cosa del mundo real (usuarios, productos, etc.).
*   **Traducí reglas de negocio a `constraints`**: No dejes la validación solo a tu código. La base de datos es tu primera línea de defensa para mantener la calidad de los datos.
*   **Evitá la redundancia (Normalización)**: No repitas la misma información en múltiples lugares. En su lugar, creá una tabla separada y referenciala usando su `ID`.
*   **Pensá en las relaciones desde el principio**: Identificá cómo se conectan tus tablas. Los campos `*_id` son la clave para esto.

Dominar estos principios te diferencia de alguien que solo sabe escribir `CREATE TABLE` y te convierte en alguien que sabe **diseñar sistemas de datos**.
