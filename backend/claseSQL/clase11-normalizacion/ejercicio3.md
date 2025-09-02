# Ejercicio 3: Diseño Conceptual de una Base de Datos Normalizada

## 🎯 Objetivo

Practicar el proceso de diseño de una base de datos desde cero a partir de un conjunto de requisitos de negocio, enfocándose en la identificación de entidades, la definición de relaciones y la creación de un esquema normalizado en 3NF de forma conceptual.

---

## 📖 Escenario: Sistema de Gestión para un Gimnasio

Te han contratado para diseñar la base de datos de un nuevo gimnasio. El sistema debe ser capaz de gestionar la siguiente información:

*   **Miembros**: Se necesita almacenar el nombre, apellido, email (que debe ser único), fecha de nacimiento y la fecha en que se unieron al gimnasio. Cada miembro tiene un tipo de membresía (ej: "Básica", "Premium", "Anual").
*   **Clases**: El gimnasio ofrece diferentes clases como "Yoga", "Spinning", "Boxeo", etc. De cada clase se necesita saber su nombre y una breve descripción.
*   **Entrenadores**: Se debe guardar la información de los entrenadores, incluyendo su nombre, apellido y su especialidad (ej: "Entrenador de Pesas", "Instructor de Yoga").
*   **Relaciones Complejas**:
    *   Un entrenador puede impartir varias clases (ej: un entrenador puede dar clases de Yoga y de Pilates).
    *   Una clase puede ser impartida por varios entrenadores (ej: puede haber dos instructores de Spinning).
    *   Un miembro puede inscribirse en muchas clases.
    *   Una clase, por supuesto, puede tener muchos miembros inscritos.

---

## 🏋️‍♀️ Tu Tarea

No necesitas escribir código `CREATE TABLE`. Tu tarea es diseñar el esquema de la base de datos de forma conceptual.

### Parte 1: Identificar Entidades y Atributos

Listá las entidades principales que identificaste en los requisitos. Para cada entidad, listá los atributos (columnas) que necesitarías para almacenar su información.

**Ejemplo de formato:**
*   **Entidad:** Miembros
    *   Atributos: id, nombre, apellido, email, ...

### Parte 2: Definir Relaciones

Describí las relaciones que existen entre las entidades que identificaste. Usá los términos **"Uno a Muchos" (1:N)** o **"Muchos a Muchos" (N:M)**.

**Ejemplo de formato:**
*   La relación entre `Membresías` y `Miembros` es de **1:N** (una membresía puede tener muchos miembros).

### Parte 3: Diseñar el Esquema Normalizado

Basado en tu análisis, diseñá el esquema de la base de datos. Listá cada tabla y las columnas que contendría. Usá `_id` para indicar claves foráneas y marcá las claves primarias (PK) y las relaciones de muchos a muchos que requieren una tabla de unión.

**Ejemplo de formato:**
```
Tabla: membresias
- id (PK)
- nombre_membresia
- precio

Tabla: miembros
- id (PK)
- nombre
- membresia_id (FK a membresias.id)
```

### Parte 4: Justificación de la 3NF

Escribí un breve párrafo explicando por qué tu diseño cumple con la Tercera Forma Normal. Mencioná cómo evitaste las dependencias parciales y transitivas.

---

## 💡 Solución Propuesta

<details>
<summary>Click para ver la solución</summary>

### Parte 1: Entidades y Atributos

*   **Entidad: Miembros**
    *   Atributos: id, nombre, apellido, email, fecha_nacimiento, fecha_union, tipo_membresia_id
*   **Entidad: Tipos de Membresía**
    *   Atributos: id, nombre_membresia, precio_mensual
*   **Entidad: Clases**
    *   Atributos: id, nombre_clase, descripcion
*   **Entidad: Entrenadores**
    *   Atributos: id, nombre, apellido, especialidad

### Parte 2: Relaciones

*   La relación entre `Tipos de Membresía` y `Miembros` es de **1:N**.
*   La relación entre `Entrenadores` y `Clases` es de **N:M** (un entrenador puede dar muchas clases, una clase puede tener muchos entrenadores).
*   La relación entre `Miembros` y `Clases` es de **N:M** (un miembro puede tomar muchas clases, una clase puede tener muchos miembros).

### Parte 3: Esquema Normalizado

**Tabla: tipos_membresia**
- `id` (PK)
- `nombre` (UNIQUE)
- `precio_mensual`

**Tabla: miembros**
- `id` (PK)
- `nombre`
- `apellido`
- `email` (UNIQUE)
- `fecha_nacimiento`
- `fecha_union`
- `tipo_membresia_id` (FK a tipos_membresia.id)

**Tabla: entrenadores**
- `id` (PK)
- `nombre`
- `apellido`
- `especialidad`

**Tabla: clases**
- `id` (PK)
- `nombre` (UNIQUE)
- `descripcion`

**Tabla de Unión: clases_entrenadores** (Resuelve N:M entre clases y entrenadores)
- `clase_id` (PK, FK a clases.id)
- `entrenador_id` (PK, FK a entrenadores.id)

**Tabla de Unión: inscripciones_clases** (Resuelve N:M entre miembros y clases)
- `miembro_id` (PK, FK a miembros.id)
- `clase_id` (PK, FK a clases.id)
- `fecha_inscripcion`

### Parte 4: Justificación de la 3NF

Este diseño está en 3NF porque cada tabla se adhiere a los principios de normalización. 
1.  **1NF**: No hay campos multivaluados; las relaciones de muchos a muchos se manejan con tablas de unión.
2.  **2NF**: En las tablas con claves primarias compuestas (`clases_entrenadores` e `inscripciones_clases`), no hay atributos que dependan solo de una parte de la clave. Por ejemplo, `fecha_inscripcion` depende tanto del miembro como de la clase a la que se inscribe.
3.  **3NF**: No hay dependencias transitivas. Por ejemplo, el `precio_mensual` está en la tabla `tipos_membresia` y no en `miembros`. Si estuviera en `miembros`, dependería del tipo de membresía, que a su vez depende del miembro, creando una dependencia transitiva. Al separar las entidades (`Miembros`, `Clases`, `Entrenadores`, `Tipos de Membresía`), nos aseguramos de que cada atributo describa directamente a la entidad de su tabla, identificada por su clave primaria.

</details>
