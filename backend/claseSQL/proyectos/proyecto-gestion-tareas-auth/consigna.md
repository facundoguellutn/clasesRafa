# Proyecto 3: API de Gestión de Tareas con Autenticación

**Objetivo:** Crear una API de gestión de tareas (To-Do list) donde los usuarios deben registrarse e iniciar sesión para poder gestionar **sus propias tareas**. Este proyecto introduce la autenticación con JWT, el hasheo de contraseñas y las rutas protegidas.

---

### Requisitos Funcionales:

1.  **Autenticación de Usuarios:**
    - `POST /auth/register`: Registrar un nuevo usuario con email y contraseña. La contraseña debe ser almacenada de forma segura (hasheada).
    - `POST /auth/login`: Iniciar sesión con email y contraseña. Si las credenciales son correctas, la API debe devolver un token JWT (JSON Web Token).

2.  **Rutas Protegidas:**
    - Todas las rutas relacionadas con tareas deben estar protegidas. Solo un usuario autenticado (que presente un token JWT válido) puede acceder a ellas.

3.  **Gestión de Tareas (CRUD):**
    - `POST /tasks`: Crear una nueva tarea. La tarea creada debe quedar asociada automáticamente al usuario autenticado.
    - `GET /tasks`: Obtener la lista de tareas **del usuario autenticado únicamente**.
    - `PUT /tasks/:id`: Actualizar una tarea. Un usuario solo puede actualizar sus propias tareas.
    - `DELETE /tasks/:id`: Eliminar una tarea. Un usuario solo puede eliminar sus propias tareas.

---

### Stack Tecnológico:

-   **Backend:** Express.js
-   **Base de Datos:** Turso
-   **ORM:** Prisma
-   **Autenticación:** `jsonwebtoken`, `bcryptjs`

---

### Schema de Prisma:

```prisma
model User {
  id       Int    @id @default(autoincrement())
  email    String @unique
  password String // Almacenará la contraseña hasheada
  tasks    Task[]
}

model Task {
  id        Int      @id @default(autoincrement())
  title     String
  completed Boolean  @default(false)
  createdAt DateTime @default(now())
  owner     User     @relation(fields: [ownerId], references: [id])
  ownerId   Int
}
```

---

### Endpoints de la API:

| Método | Ruta | Protección | Descripción |
| :--- | :--- | :--- | :--- |
| `POST` | `/auth/register` | Pública | Registra un nuevo usuario. |
| `POST` | `/auth/login` | Pública | Inicia sesión y devuelve un token JWT. |
| `POST` | `/tasks` | Privada | Crea una nueva tarea para el usuario logueado. |
| `GET` | `/tasks` | Privada | Lista las tareas del usuario logueado. |
| `PUT` | `/tasks/:id` | Privada | Actualiza una tarea del usuario logueado. |
| `DELETE` | `/tasks/:id` | Privada | Elimina una tarea del usuario logueado. |
