# Ejercicio 1: Normalizando un Sistema de Citas Médicas

## 🎯 Objetivo

Tomar una tabla de datos completamente desnormalizada y aplicar los principios de la Primera, Segunda y Tercera Forma Normal para crear un esquema de base de datos relacional, limpio y eficiente.

---

## 📖 Escenario: La Hoja de Cálculo del Caos

Una clínica médica ha estado gestionando sus citas en una única hoja de cálculo. Al importarla a una base de datos, obtenemos una sola tabla `citas_raw` con un diseño problemático.

**Tabla `citas_raw` (No Normalizada):**

| cita_id | fecha_cita | paciente_dni | paciente_nombre | paciente_telefono | doctor_id | doctor_nombre | doctor_especialidad | consultorio_numero | notas_cita |
|---|---|---|---|---|---|---|---|---|---|
| 101 | 2024-09-10 | 12345678A | Ana Gómez | 11-555-1234 | D05 | Dr. Carlos Ruiz | Cardiología | 301 | "Paciente refiere dolor de pecho" |
| 102 | 2024-09-10 | 87654321B | Luis Torres | 11-555-8765 | D07 | Dra. Laura Paus | Dermatología | 402 | "Revisión de lunar" |
| 103 | 2024-09-11 | 12345678A | Ana Gómez | 11-555-1234 | D05 | Dr. Carlos Ruiz | Cardiología | 301 | "Seguimiento de tratamiento" |
| 104 | 2024-09-12 | 99988777C | Pedro Luna | 11-555-9988 | D05 | Dr. Carlos Ruiz | Cardiología | 301 | "Electrocardiograma" |

---

## 🏋️‍♀️ Tu Tarea

### Parte 1: Análisis del Problema

1.  **Identificá la Redundancia**: ¿Qué datos se repiten innecesariamente en la tabla `citas_raw`?
2.  **Identificá las Dependencias**: 
    *   ¿Qué columnas dependen del paciente (`paciente_dni`)?
    *   ¿Qué columnas dependen del doctor (`doctor_id`)?
    *   ¿Qué columnas dependen realmente de la cita (`cita_id`)?
3.  **Identificá las Violaciones a las Formas Normales**:
    *   **3NF**: ¿Hay dependencias transitivas? (Pista: ¿El `consultorio_numero` depende del `doctor_nombre` o del `doctor_id`?).

### Parte 2: Diseño del Nuevo Esquema

Diseñá un esquema de base de datos normalizado (en 3NF). Deberías tener al menos tres tablas principales.

*   **Tabla 1**: Para almacenar la información de los **Doctores**.
*   **Tabla 2**: Para almacenar la información de los **Pacientes**.
*   **Tabla 3**: Para almacenar la información de las **Citas**, que conectará a un doctor con un paciente en una fecha específica.

### Parte 3: Creación de las Tablas

Escribí las sentencias `CREATE TABLE` para tu nuevo esquema. Asegurate de:

*   Usar el tipo de dato más apropiado para cada columna.
*   Definir una `PRIMARY KEY` para cada tabla.
*   Usar `UNIQUE` donde sea necesario (ej: DNI del paciente, email del doctor).
*   Usar `FOREIGN KEY` en la tabla de citas para referenciar a las tablas de doctores y pacientes.
*   Añadir `NOT NULL` a los campos que consideres obligatorios.

```sql
-- Tu CREATE TABLE para Doctores


-- Tu CREATE TABLE para Pacientes


-- Tu CREATE TABLE para Citas

```

---

## 💡 Solución Propuesta

<details>
<summary>Click para ver la solución</summary>

### Análisis del Problema (Solución)

1.  **Redundancia**: Se repiten los datos completos de "Ana Gómez" y del "Dr. Carlos Ruiz" en múltiples filas.
2.  **Dependencias**:
    *   `paciente_nombre` y `paciente_telefono` dependen de `paciente_dni`.
    *   `doctor_nombre`, `doctor_especialidad` y `consultorio_numero` dependen de `doctor_id`.
    *   Solo `fecha_cita`, `paciente_dni`, `doctor_id` y `notas_cita` dependen directamente de `cita_id`.
3.  **Violaciones**: Hay claras dependencias transitivas. `doctor_nombre` depende de `doctor_id`, que a su vez está en la fila de la cita. Esto viola la 3NF.

### Creación de Tablas (Solución)

```sql
-- Tabla para Doctores
CREATE TABLE doctores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    doctor_codigo TEXT UNIQUE NOT NULL, -- Mantenemos el D05, D07 como código único
    nombre TEXT NOT NULL,
    especialidad TEXT NOT NULL,
    consultorio_numero INTEGER
);

-- Tabla para Pacientes
CREATE TABLE pacientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dni TEXT UNIQUE NOT NULL,
    nombre TEXT NOT NULL,
    telefono TEXT
);

-- Tabla para Citas (la tabla transaccional)
CREATE TABLE citas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fecha_cita DATETIME NOT NULL,
    paciente_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    notas TEXT,
    estado TEXT DEFAULT 'programada' CHECK(estado IN ('programada', 'completada', 'cancelada')),
    
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    FOREIGN KEY (doctor_id) REFERENCES doctores(id)
);

```

</details>
