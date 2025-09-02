# Ejercicio 3: Finanzas Personales y Modificación de Tablas

## 🎯 Objetivo

Diseñar tablas para un escenario práctico y aprender a modificar una estructura de tabla existente usando `ALTER TABLE` para agregar nuevas funcionalidades.

---

## 📖 Escenario

Queremos crear una base de datos para una aplicación de seguimiento de finanzas personales. Inicialmente, necesitamos dos tablas:

1.  **`ingresos`**:
    *   Debe tener un `id`.
    *   Una `descripcion` obligatoria (ej: "Salario Enero", "Venta de item usado").
    *   Un `monto` obligatorio, que debe ser un número positivo.
    *   Una `fecha` en la que se recibió el ingreso (por defecto, la fecha actual).

2.  **`gastos`**:
    *   Debe tener un `id`.
    *   Una `descripcion` obligatoria (ej: "Supermercado", "Alquiler").
    *   Un `monto` obligatorio y positivo.
    *   Una `fecha` en la que se realizó el gasto (por defecto, la fecha actual).

---

## 🏋️‍♀️ Tu Tarea - Parte 1: Diseño Inicial

Escribí las sentencias `CREATE TABLE` para las tablas `ingresos` y `gastos`.

*   Asegurate de usar los tipos de datos y `constraints` correctos según los requisitos.

```sql
-- Tu código para la tabla 'ingresos' aquí


-- Tu código para la tabla 'gastos' aquí

```

### Inserta Datos de Prueba

Escribí 3 sentencias `INSERT` para la tabla `ingresos` y 5 para la tabla `gastos` para tener datos con los que trabajar.

```sql
-- Tus sentencias INSERT para 'ingresos'


-- Tus sentencias INSERT para 'gastos'

```

---

## 📖 Nuevo Requisito del Cliente

Después de usar la aplicación, el cliente se da cuenta de que sería muy útil poder **categorizar los gastos**. Nos pide agregar esta funcionalidad.

**Nuevo requisito**: La tabla `gastos` debe tener una columna `categoria`.

*   La categoría debe ser un texto.
*   Queremos que las categorías sean consistentes. Solo se permitirán los siguientes valores: 'Comida', 'Vivienda', 'Transporte', 'Ocio', 'Salud', 'Otros'.
*   Si no se especifica una categoría, debería asignarse 'Otros' por defecto.

---

## 🏋️‍♀️ Tu Tarea - Parte 2: Modificando la Tabla

Usá la sentencia `ALTER TABLE` para agregar la nueva columna `categoria` a la tabla `gastos`.

*   La nueva columna debe incluir los `constraints` `CHECK` y `DEFAULT` que se piden en el nuevo requisito.

```sql
-- Tu código ALTER TABLE aquí

```

### Verificación

1.  **Insertá un nuevo gasto** sin especificar la categoría. Luego, hacé un `SELECT` para verificar que se le haya asignado 'Otros' automáticamente.
2.  **Intentá insertar un gasto** con una categoría inválida (ej: 'Vacaciones'). La base de datos debería darte un error.

```sql
-- Código de verificación aquí

```

---

## 💡 Solución Propuesta

<details>
<summary>Click para ver la solución</summary>

```sql
-- --- PARTE 1: DISEÑO INICIAL ---

-- Tabla de Ingresos
CREATE TABLE ingresos (
    id INTEGER PRIMARY KEY,
    descripcion TEXT NOT NULL,
    monto REAL NOT NULL CHECK (monto > 0),
    fecha DATE DEFAULT CURRENT_DATE
);

-- Tabla de Gastos
CREATE TABLE gastos (
    id INTEGER PRIMARY KEY,
    descripcion TEXT NOT NULL,
    monto REAL NOT NULL CHECK (monto > 0),
    fecha DATE DEFAULT CURRENT_DATE
);

-- --- INSERTS DE EJEMPLO ---
INSERT INTO ingresos (descripcion, monto, fecha) VALUES
('Salario Mensual', 2000.00, '2024-08-01'),
('Venta de bicicleta usada', 150.00, '2024-08-10'),
('Regalo de cumpleaños', 50.00, '2024-08-20');

INSERT INTO gastos (descripcion, monto, fecha) VALUES
('Alquiler Agosto', 800.00, '2024-08-05'),
('Supermercado semanal', 120.50, '2024-08-07'),
('Factura de internet', 60.00, '2024-08-15'),
('Salida al cine', 30.00, '2024-08-18'),
('Compra de libro', 25.75, '2024-08-22');


-- --- PARTE 2: MODIFICANDO LA TABLA ---

-- Agregar la columna 'categoria' a la tabla 'gastos'
ALTER TABLE gastos ADD COLUMN categoria TEXT 
    CHECK (categoria IN ('Comida', 'Vivienda', 'Transporte', 'Ocio', 'Salud', 'Otros')) 
    DEFAULT 'Otros';


-- --- VERIFICACIÓN ---

-- 1. Insertar un gasto sin categoría (debería asignarse 'Otros')
INSERT INTO gastos (descripcion, monto) VALUES ('Farmacia', 45.00);
-- SELECT * FROM gastos WHERE descripcion = 'Farmacia'; -- Debería mostrar 'Otros' en categoría.

-- 2. Intentar insertar un gasto con categoría inválida (debería fallar)
-- INSERT INTO gastos (descripcion, monto, categoria) VALUES ('Pasajes de avión', 300.00, 'Vacaciones');
-- Esto debería producir un error: CHECK constraint failed: gastos

```

</details>
