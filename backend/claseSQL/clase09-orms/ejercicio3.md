# Ejercicio 3: Manejo de Relaciones

**Objetivo:** Extender el schema de la base de datos para incluir una relación "uno a muchos" entre estudiantes y sus calificaciones. Implementar endpoints para manejar esta relación.

## Pasos a seguir:

1.  **Modificar el `schema.prisma`:**
    *   Abre el archivo `prisma/schema.prisma` de tu proyecto.
    *   Añade un nuevo modelo llamado `Grade`. Debe tener los siguientes campos:
        *   `id`: `Int`, clave primaria, autoincremental.
        *   `subject`: `String` (ej. "Matemáticas", "Historia").
        *   `score`: `Float` (para permitir calificaciones con decimales, ej. 8.5).
        *   `studentId`: `Int`. Este campo guardará el ID del estudiante al que pertenece la calificación.
    *   Ahora, crea la relación:
        *   En el modelo `Grade`, añade un campo de relación:
            ```prisma
            student   Student @relation(fields: [studentId], references: [id])
            ```
        *   En el modelo `Student`, añade el campo inverso para acceder a todas las calificaciones de un estudiante:
            ```prisma
            grades    Grade[]
            ```

2.  **Ejecutar la Migración:**
    *   Guarda el archivo `schema.prisma`.
    *   Ejecuta una nueva migración para aplicar estos cambios a tu base de datos de Turso.
        ```bash
        npx prisma migrate dev --name add-grades-table
        ```
    *   Prisma detectará los cambios, creará la tabla `Grade` y establecerá la clave foránea (`foreign key`).

3.  **Implementar Nuevos Endpoints en `server.js`:**

    *   **CREATE: Añadir una calificación a un estudiante**
        *   `POST /students/:studentId/grades`
        *   Este endpoint debe recibir el `studentId` desde la URL.
        *   Debe recibir `subject` y `score` en el cuerpo de la petición.
        *   Usa `prisma.grade.create()` para crear la nueva calificación. En el `data`, asegúrate de incluir el `studentId`.
        *   Devuelve la calificación recién creada.

    *   **READ: Obtener un estudiante y todas sus calificaciones**
        *   Modifica el endpoint `GET /students/:id`.
        *   Al usar `prisma.student.findUnique()`, utiliza la opción `include` para traer también las calificaciones asociadas.
        *   El resultado debería ser un objeto de estudiante que contiene un array `grades`.

## Código de Ayuda (Fragmentos):

**`schema.prisma` final:**
```prisma
model Student {
  id     Int     @id @default(autoincrement())
  name   String
  email  String  @unique
  grades Grade[] // Relación: un estudiante tiene muchas calificaciones
}

model Grade {
  id        Int     @id @default(autoincrement())
  subject   String
  score     Float
  studentId Int
  student   Student @relation(fields: [studentId], references: [id]) // Relación
}
```

**`server.js` (nuevos endpoints):**
```javascript
// POST /students/:studentId/grades
app.post('/students/:studentId/grades', async (req, res) => {
  const { studentId } = req.params;
  const { subject, score } = req.body;

  try {
    const newGrade = await prisma.grade.create({
      data: {
        subject,
        score,
        studentId: parseInt(studentId),
      },
    });
    res.status(201).json(newGrade);
  } catch (error) {
    // Un error común aquí es si el studentId no existe.
    res.status(500).json({ error: 'Error al crear la calificación.' });
  }
});

// GET /students/:id (modificado)
app.get('/students/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const student = await prisma.student.findUnique({
      where: { id: parseInt(id) },
      include: {
        grades: true, // ¡Aquí está la magia!
      },
    });

    if (student) {
      res.json(student);
    } else {
      res.status(404).json({ error: 'Estudiante no encontrado.' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener el estudiante.' });
  }
});
```

## Pruebas:

1.  Asegúrate de tener al menos un estudiante creado.
2.  Usa el nuevo endpoint `POST` para añadirle 2 o 3 calificaciones a ese estudiante.
3.  Llama al endpoint `GET /students/:id` (con el ID de ese estudiante) y verifica que la respuesta ahora incluye un array `grades` con las calificaciones que acabas de añadir.
