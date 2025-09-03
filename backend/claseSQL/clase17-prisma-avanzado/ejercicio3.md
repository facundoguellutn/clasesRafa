# Ejercicio 3: Tarea Transaccional

**Objetivo:** Utilizar las transacciones de Prisma para garantizar la atomicidad de las operaciones. Crearás un endpoint que registre a un usuario y su primer post en una sola operación indivisible.

---

## El Escenario

Imagina que en tu blog, al registrarse, un usuario debe escribir obligatoriamente un post de presentación. Quieres asegurarte de que ambas cosas ocurran: se crea el usuario y se crea su post. No quieres terminar con un usuario en la base de datos que no tenga su post de presentación.

Esta es una situación perfecta para una transacción.

## Tareas:

### 1. Diseñar el Endpoint

- **Endpoint:** `POST /register-and-post`
- **Body de la Petición:** Deberá aceptar todos los datos necesarios para crear un usuario y su primer post.
  ```json
  {
    "userData": {
      "email": "nuevo.usuario@test.com",
      "name": "Nuevo Usuario"
    },
    "postData": {
      "title": "¡Hola a todos!",
      "content": "Este es mi primer post en este increíble blog."
    }
  }
  ```

### 2. Implementar la Lógica con `prisma.$transaction`

Dentro de la ruta de Express, usarás `prisma.$transaction` para envolver la lógica.

- **Pasos dentro de la transacción:**
    1.  Usa `tx.user.create()` para crear el nuevo usuario con los datos de `userData`. (`tx` es el cliente de Prisma para la transacción).
    2.  **Simula un error (opcional pero recomendado para probar):** Después de crear el usuario, puedes lanzar un error intencionadamente para verificar que la transacción hace un rollback (es decir, que el usuario no se guarda en la base de datos).
        ```javascript
        // throw new Error("Algo salió mal a propósito");
        ```
    3.  Usa `tx.post.create()` para crear el nuevo post. En el campo `authorId`, debes usar el `id` del usuario que acabas de crear en el paso 1.
    4.  La transacción debe devolver tanto el usuario como el post creados.

- **Manejo de Errores:** Envuelve toda la llamada a `prisma.$transaction` en un bloque `try...catch`. Si la transacción falla por cualquier motivo (ej. el email del usuario ya existe, o el error que simulaste), el `catch` se activará y podrás devolver un mensaje de error apropiado al cliente.

---

## Código de Ayuda

```javascript
app.post('/register-and-post', async (req, res) => {
  const { userData, postData } = req.body;

  if (!userData || !postData) {
    return res.status(400).json({ error: "Se requieren userData y postData." });
  }

  try {
    const result = await prisma.$transaction(async (tx) => {
      // 1. Crear el usuario
      const newUser = await tx.user.create({
        data: userData,
      });

      // Descomenta la siguiente línea para probar el rollback de la transacción
      // if (true) { throw new Error("Fallo simulado después de crear el usuario"); }

      // 2. Crear el post, conectándolo con el usuario recién creado
      const newPost = await tx.post.create({
        data: {
          ...postData,
          authorId: newUser.id, // Usar el ID del usuario creado en esta misma transacción
        },
      });

      return { newUser, newPost };
    });

    // Si la transacción tiene éxito, devuelve el resultado
    res.status(201).json(result);

  } catch (error) {
    console.error("Error en la transacción:", error);
    // Si la transacción falla, Prisma se encarga del rollback automáticamente
    res.status(500).json({ 
        message: "No se pudo completar el registro. La operación fue revertida.",
        error: error.message 
    });
  }
});
```

## Pruebas

1.  **Prueba de Éxito:**
    - Envía una petición válida a `POST /register-and-post`.
    - Verifica que la respuesta contiene tanto el nuevo usuario como el nuevo post.
    - Usa Prisma Studio o tus endpoints `GET` para confirmar que ambos registros existen en la base de datos.

2.  **Prueba de Fallo (Rollback):**
    - Descomenta la línea `throw new Error(...)` en tu código.
    - Envía la misma petición válida de nuevo.
    - Verifica que la respuesta es un error 500.
    - **Lo más importante:** Revisa tu base de datos. El usuario **NO** debería haber sido creado. Esto confirma que la transacción funcionó y revirtió la creación del usuario cuando el proceso falló.
    - Vuelve a comentar la línea del error para que el endpoint funcione normalmente.
