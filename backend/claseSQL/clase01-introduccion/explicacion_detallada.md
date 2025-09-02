# Explicación Detallada: Fundamentos de SQL y el Modelo Relacional

## 🎯 Objetivo de este Documento

Este documento amplía los conceptos introducidos en el tutorial de la Clase 1. El objetivo es solidificar tu comprensión sobre **por qué** SQL funciona como lo hace y las ideas fundamentales que lo sustentan.

---

## 🏛️ El Modelo Relacional: El "Plano" de los Datos

SQL se basa en el **modelo relacional**, una idea matemática propuesta por Edgar F. Codd en 1970. No te preocupes por la matemática, la idea central es simple y elegante:

> **Organizar los datos en tablas (o "relaciones") donde cada pieza de información está claramente definida y relacionada con otras.**

Imaginá que estás construyendo un edificio. No apilás ladrillos al azar. Usás un plano que define qué es una pared, una ventana, una puerta y cómo se conectan entre sí. El modelo relacional es ese plano para tus datos.

### ¿Por qué es tan importante?

1.  **Consistencia (Integridad de los Datos)**: El "plano" asegura que los datos tengan sentido. Por ejemplo, no podés tener una venta sin un cliente asociado. El sistema mismo te protege de datos basura.
2.  **Eficiencia**: Al tener una estructura predecible, la base de datos puede optimizar las búsquedas para que sean increíblemente rápidas, incluso con millones de registros.
3.  **Flexibilidad en las Consultas**: La estructura rígida de almacenamiento permite una flexibilidad asombrosa a la hora de hacer preguntas (consultas). Podés combinar datos de formas que ni siquiera habías previsto al diseñar las tablas.
4.  **Reducción de la Redundancia**: El modelo busca eliminar la duplicación de datos. En lugar de escribir "Toyota Corolla" en 50 tablas diferentes, lo escribís una vez en la tabla `vehiculos` y lo referenciás por su ID en las demás. Esto ahorra espacio y evita errores.

---

## 🧱 Anatomía de una Tabla: Profundizando

Veamos la tabla `peliculas` con más detalle:

```sql
CREATE TABLE peliculas (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    año INTEGER,
    genero TEXT,
    calificacion REAL,
    director TEXT
);
```

### 1. **Tipos de Datos (Data Types)**

Cada columna tiene un **tipo de dato** específico. Esto es crucial y una gran diferencia con MongoDB, donde un campo puede ser un string en un documento y un número en otro.

*   `INTEGER`: Números enteros (ej: `id`, `año`). No pueden tener decimales.
*   `TEXT`: Cadenas de texto de longitud variable (ej: `titulo`, `genero`, `director`).
*   `REAL`: Números de punto flotante, es decir, con decimales (ej: `calificacion`).
*   `NOT NULL`: Es una **restricción (constraint)**. Significa que la columna `titulo` **debe** tener un valor. No podés insertar una película sin título. Esto garantiza la calidad de tus datos.

Existen muchos otros tipos de datos (`DATE`, `BOOLEAN`, `VARCHAR`, etc.) que veremos más adelante, pero estos son los básicos.

### 2. **La Clave Primaria (Primary Key): El DNI de tus Datos**

La línea `id INTEGER PRIMARY KEY` es una de las más importantes.

*   `PRIMARY KEY`: Designa a la columna `id` como la **clave primaria**.
*   **¿Qué significa esto?**
    *   **Única**: No puede haber dos películas con el mismo `id`. La base de datos lo impedirá automáticamente.
    *   **No Nula**: El `id` nunca puede estar vacío.
    *   **Identificador Universal**: Es la forma oficial de referirse a un registro. Si querés borrar, actualizar o conectar "Pulp Fiction" con otra tabla, usarás su `id` (que es `2`), no su título.

> **Analogía para Rafa**: Pensá en el CUIT de una empresa o el DNI de una persona. Aunque dos personas se llamen "Juan Pérez", tienen DNI distintos. La clave primaria es ese identificador único e irrepetible.

---

## 💬 El Lenguaje SQL: Más que solo Consultas

SQL es el acrónimo de **Structured Query Language** (Lenguaje de Consulta Estructurado). Aunque la parte de "Query" (consulta) es la que más usarás, el lenguaje se divide en varias partes:

1.  **DQL (Data Query Language)**: Para hacer consultas. Es el que empezamos a usar.
    *   `SELECT`

2.  **DDL (Data Definition Language)**: Para definir la estructura de la base de datos.
    *   `CREATE TABLE` (¡ya la usaste!)
    *   `ALTER TABLE` (para modificar una tabla)
    *   `DROP TABLE` (para borrar una tabla)

3.  **DML (Data Manipulation Language)**: Para manipular los datos dentro de las tablas.
    *   `INSERT` (¡también la usaste!)
    *   `UPDATE` (para actualizar registros)
    *   `DELETE` (para borrar registros)

4.  **DCL (Data Control Language)**: Para gestionar permisos y acceso.
    *   `GRANT` (dar permisos)
    *   `REVOKE` (quitar permisos)

No necesitás memorizar esto ahora, pero es útil entender que SQL es una herramienta completa para gestionar todos los aspectos de una base de datos relacional, desde su creación hasta su uso diario.

---

## ✅ Resumen de Conceptos Ampliados

*   **Modelo Relacional**: Es el "plano" que organiza los datos en tablas con reglas claras, garantizando consistencia y eficiencia.
*   **Tipos de Datos**: SQL exige que definas qué tipo de información va en cada columna (`INTEGER`, `TEXT`, etc.). Esto previene errores y optimiza el almacenamiento.
*   **Clave Primaria (Primary Key)**: Es el identificador único e irrepetible de cada registro en una tabla. Es el concepto más importante para relacionar datos.
*   **SQL como Lenguaje Completo**: No solo sirve para consultar (`SELECT`), sino también para definir (`CREATE`), manipular (`INSERT`) y controlar (`GRANT`) los datos.

Estos conceptos son la base sobre la que construiremos todo lo demás. Entenderlos bien te hará mucho más fácil aprender las consultas complejas que veremos en las próximas clases.
