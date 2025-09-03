# Ejercicio 2: Implementando un Sistema de "Likes"

**Objetivo:** Añadir una funcionalidad de "Me Gusta" a los posts. Esto requiere modificar el schema para añadir una nueva relación muchos-a-muchos y crear los endpoints para manejarla.

---

## Tareas:

### 1. Modificar el Schema de Prisma

Vamos a crear una relación muchos-a-muchos implícita entre `User` y `Post` para representar los "likes". Un usuario puede dar "like" a muchos posts, y un post puede recibir "likes" de muchos usuarios.

Abre `prisma/schema.prisma` y modifica los modelos `User` y `Post`:

```prisma
model User {
  // ... otros campos
  likedPosts Post[] @relation("UserLikes") // Posts que le gustaron al usuario
}

model Post {
  // ... otros campos
  likedBy User[] @relation("UserLikes") // Usuarios a los que les gustó el post
}
```

- La anotación `@relation("UserLikes")` le da un nombre a esta relación para que Prisma no se confunda con otras relaciones que puedan existir entre `User` y `Post`.

### 2. Ejecutar la Migración

Aplica los cambios a tu base de datos. Prisma es lo suficientemente inteligente para entender que esto crea una nueva tabla de unión (join table) para manejar la relación m-m.

```bash
npx prisma migrate dev --name "add-likes-relation"
```

### 3. Crear los Endpoints

Ahora, implementa la lógica en `index.js`.

- **Endpoint para dar "Like" a un Post:** `POST /posts/:postId/like`
    - **Lógica:**
        - Debe recibir el `postId` desde los parámetros de la URL.
        - Debe recibir el `userId` que está dando el "like" desde el cuerpo de la petición (en una app real, esto vendría de la sesión del usuario autenticado).
        - Usa `prisma.post.update()` para `connect` el usuario (`likedBy`) al post.

- **Endpoint para quitar un "Like":** `POST /posts/:postId/unlike`
    - **Lógica:**
        - Similar al anterior, pero en lugar de `connect`, usa `disconnect` para remover la relación entre el usuario y el post.

- **Endpoint para ver a quién le gustó un post:** `GET /posts/:postId/likes`
    - **Lógica:**
        - Obtén el post por su `id`.
        - Usa `include` para traer la lista de usuarios (`likedBy`).
        - Para no exponer datos sensibles, puedes usar `select` dentro de `include` para devolver solo el `id` y `name` de los usuarios.

---

## Código de Ayuda

**Endpoint para dar "Like":**
```javascript
app.post('/posts/:postId/like', async (req, res) => {
  const { postId } = req.params;
  const { userId } = req.body; // Asumimos que el ID del usuario viene en el body

  if (!userId) {
    return res.status(400).json({ error: "userId es requerido." });
  }

  try {
    const updatedPost = await prisma.post.update({
      where: { id: parseInt(postId) },
      data: {
        likedBy: {
          connect: { id: parseInt(userId) },
        },
      },
      include: {
        likedBy: {
          select: { id: true, name: true } // Devolver solo datos seguros
        }
      }
    });
    res.json(updatedPost);
  } catch (error) {
    res.status(500).json({ error: "No se pudo procesar el like." });
  }
});
```

**Endpoint para ver los "Likes":**
```javascript
app.get('/posts/:postId/likes', async (req, res) => {
    const { postId } = req.params;
    const post = await prisma.post.findUnique({
        where: { id: parseInt(postId) },
        include: {
            _count: { // Prisma puede contar relaciones por ti
                select: { likedBy: true }
            },
            likedBy: {
                select: { id: true, name: true }
            }
        }
    });

    if (!post) {
        return res.status(404).json({ error: "Post no encontrado." });
    }

    res.json({
        likesCount: post._count.likedBy,
        users: post.likedBy
    });
});
```
**Pista:** El objeto `_count` es una característica poderosa de Prisma para obtener conteos de relaciones de manera eficiente.

## Pruebas

1.  Crea un par de usuarios y un post.
2.  Haz que el usuario 1 dé "like" al post.
3.  Haz que el usuario 2 dé "like" al mismo post.
4.  Consulta los likes del post y verifica que ambos usuarios aparecen y el conteo es 2.
5.  Haz que el usuario 1 quite su "like".
6.  Consulta de nuevo y verifica que solo el usuario 2 aparece y el conteo es 1.
