# Ejercicio 2: Creando un CRUD Completo

**Objetivo:** Construir una API REST completa con operaciones CRUD (Crear, Leer, Actualizar, Eliminar) para el modelo `Student` que creaste en el ejercicio anterior.

## Pasos a seguir:

1.  **Continuar desde el Ejercicio 1:**
    *   Abre el proyecto `ejercicio-orm-basico` que configuraste previamente.

2.  **Crear el Archivo del Servidor:**
    *   Crea un archivo `server.js` en la raíz de tu proyecto.

3.  **Configurar el Servidor Express y Prisma Client:**
    *   Dentro de `server.js`, importa `express` y `PrismaClient`.
    *   Crea una instancia de la aplicación Express y del cliente de Prisma.
    *   Asegúrate de que tu servidor pueda parsear JSON (`app.use(express.json())`).

4.  **Implementar los Endpoints CRUD:**

    *   **CREATE:** `POST /students`
        *   Este endpoint debe recibir `name` y `email` en el cuerpo de la petición.
        *   Debe usar `prisma.student.create()` para guardar un nuevo estudiante en la base de datos.
        *   Devuelve el estudiante recién creado con un código de estado `201`.
        *   Añade manejo de errores (por ejemplo, si el email ya existe, Prisma lanzará un error que puedes capturar en un bloque `try...catch`).

    *   **READ (Todos):** `GET /students`
        *   Este endpoint debe usar `prisma.student.findMany()` para obtener todos los estudiantes.
        *   Devuelve la lista de estudiantes como un JSON.

    *   **READ (Uno):** `GET /students/:id`
        *   Este endpoint debe obtener el `id` de los parámetros de la URL.
        *   Usa `prisma.student.findUnique()` para encontrar un estudiante por su `id`.
        *   **Importante:** El `id` de la URL será un string, pero en la base de datos es un número. ¡No olvides convertirlo con `parseInt()`!
        *   Si el estudiante no se encuentra, devuelve un error `404`.

    *   **UPDATE:** `PUT /students/:id`
        *   Este endpoint debe recibir el `id` del estudiante a actualizar desde la URL.
        *   Puede recibir `name` y/o `email` en el cuerpo de la petición para actualizar.
        *   Usa `prisma.student.update()` para modificar los datos.
        *   Devuelve el estudiante actualizado.

    *   **DELETE:** `DELETE /students/:id`
        *   Este endpoint debe recibir el `id` del estudiante a eliminar desde la URL.
        *   Usa `prisma.student.delete()` para eliminarlo.
        *   Devuelve un mensaje de éxito o el estudiante eliminado.

5.  **Iniciar el Servidor:**
    *   Añade el código para que el servidor escuche en un puerto (ej. 3000).
    *   Ejecuta `node server.js` en tu terminal.

## Pruebas:

Usa una herramienta como Insomnia, Postman o `curl` para probar cada uno de los endpoints:

1.  Crea 2-3 estudiantes usando el endpoint `POST`.
2.  Verifica que se han creado pidiendo la lista completa con `GET /students`.
3.  Pide uno de los estudiantes por su `id` usando `GET /students/:id`.
4.  Actualiza el nombre de uno de los estudiantes con `PUT /students/:id`.
5.  Verifica la actualización pidiendo de nuevo ese estudiante.
6.  Elimina uno de los estudiantes con `DELETE /students/:id`.
7.  Verifica la eliminación pidiendo la lista completa de nuevo.

## Código de Ayuda (Fragmento):

```javascript
// server.js

// ... (importaciones y configuración inicial)

// READ (Uno)
app.get('/students/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const student = await prisma.student.findUnique({
      where: {
        id: parseInt(id), // ¡No olvides el parseInt!
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

// ... (resto de los endpoints)

// ... (app.listen)
```
