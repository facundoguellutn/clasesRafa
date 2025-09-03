# Clase 17: Taller Práctico de Prisma con Express y Turso

**Objetivo:** Construir una API REST funcional para un blog, manejando relaciones complejas (uno a uno, uno a muchos, muchos a muchos) con Prisma, Express y Turso.

---

## 1. El Proyecto: API para un Blog

Nuestra API permitirá:
- Registrar usuarios.
- Que los usuarios tengan un perfil.
- Que los usuarios escriban posts.
- Clasificar los posts en categorías.

Esto implica las siguientes relaciones:
- **User ↔ Profile**: Uno a Uno (un usuario tiene un perfil).
- **User ↔ Post**: Uno a Muchos (un usuario puede tener muchos posts).
- **Post ↔ Category**: Muchos a Muchos (un post puede tener varias categorías y una categoría puede estar en muchos posts).

## 2. Configuración del Entorno

### Paso 1: Inicializar el proyecto
```bash
mkdir blog-api-prisma
cd blog-api-prisma
npm init -y
```

### Paso 2: Instalar dependencias
```bash
# Dependencias de producción
npm install express @prisma/client @libsql/client

# Dependencia de desarrollo
npm install prisma --save-dev
```

### Paso 3: Inicializar Prisma
Este comando crea la carpeta `prisma` y el archivo `.env`.
```bash
npx prisma init
```

## 3. Definiendo el Schema de la Base de Datos

Abre `prisma/schema.prisma` y reemplaza su contenido con este schema completo que define todas nuestras relaciones:

```prisma
// prisma/schema.prisma

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "sqlite"
  url      = env("DATABASE_URL")
}

model User {
  id      Int      @id @default(autoincrement())
  email   String   @unique
  name    String?
  posts   Post[]   // Relación 1-a-muchos con Post
  profile Profile? // Relación 1-a-1 con Profile
}

model Profile {
  id     Int     @id @default(autoincrement())
  bio    String?
  user   User    @relation(fields: [userId], references: [id])
  userId Int     @unique // La clave foránea es única para la relación 1-a-1
}

model Post {
  id         Int        @id @default(autoincrement())
  title      String
  content    String?
  published  Boolean    @default(false)
  author     User       @relation(fields: [authorId], references: [id])
  authorId   Int
  categories Category[] @relation("PostToCategory") // Relación muchos-a-muchos
}

model Category {
  id    Int    @id @default(autoincrement())
  name  String @unique
  posts Post[] @relation("PostToCategory") // Relación muchos-a-muchos
}
```

### Paso 4: Configurar la Base de Datos de Turso

Abre el archivo `.env` y configura tu URL de Turso.
```env
# .env
DATABASE_URL="libsql://tu-blog-db.turso.io?authToken=TU_AUTH_TOKEN"
```

### Paso 5: Ejecutar la Migración

Este comando leerá tu schema, se conectará a Turso y creará todas las tablas y relaciones.
```bash
npx prisma migrate dev --name "initial-blog-schema"
```
Si todo va bien, tu base de datos está lista.

## 4. Construyendo el Servidor Express

Crea un archivo `index.js` en la raíz del proyecto.

### Estructura del Servidor (`index.js`)

```javascript
const express = require('express');
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();
const app = express();

app.use(express.json());

/*------------------------------------*
 | Rutas para Usuarios y Perfiles     |
 *------------------------------------*/

// Crear un usuario
app.post('/users', async (req, res) => {
  const { email, name } = req.body;
  const user = await prisma.user.create({
    data: { email, name },
  });
  res.json(user);
});

// Crear un perfil para un usuario
app.post('/users/:id/profile', async (req, res) => {
  const { id } = req.params;
  const { bio } = req.body;
  const profile = await prisma.profile.create({
    data: {
      bio,
      user: { connect: { id: parseInt(id) } }, // Conectar con el usuario
    },
  });
  res.json(profile);
});

// Obtener un usuario con su perfil y posts
app.get('/users/:id', async (req, res) => {
  const { id } = req.params;
  const user = await prisma.user.findUnique({
    where: { id: parseInt(id) },
    include: {
      profile: true, // Incluir el perfil relacionado
      posts: true,   // Incluir los posts relacionados
    },
  });
  res.json(user);
});


/*------------------------------------*
 | Rutas para Posts y Categorías      |
 *------------------------------------*/

// Crear un post para un usuario
app.post('/posts', async (req, res) => {
  const { title, content, authorId } = req.body;
  const post = await prisma.post.create({
    data: {
      title,
      content,
      author: { connect: { id: authorId } }, // Conectar con el autor
    },
  });
  res.json(post);
});

// Obtener todos los posts publicados, incluyendo el autor
app.get('/feed', async (req, res) => {
  const posts = await prisma.post.findMany({
    where: { published: true },
    include: { author: true },
  });
  res.json(posts);
});

// Crear una categoría
app.post('/categories', async (req, res) => {
    const { name } = req.body;
    const category = await prisma.category.create({
        data: { name }
    });
    res.json(category);
});

// Asignar una categoría a un post (relación muchos-a-muchos)
app.put('/posts/:postId/categories/:categoryId', async (req, res) => {
    const { postId, categoryId } = req.params;
    const post = await prisma.post.update({
        where: { id: parseInt(postId) },
        data: {
            categories: {
                connect: { id: parseInt(categoryId) } // Conectar con la categoría
            }
        },
        include: { categories: true }
    });
    res.json(post);
});


/*------------------------------------*
 | Iniciar Servidor                   |
 *------------------------------------*/

const PORT = 3000;
app.listen(PORT, () =>
  console.log(`Servidor corriendo en http://localhost:${PORT}`)
);
```

## 5. Probando la API

Inicia el servidor:
```bash
node index.js
```

Ahora, usa `curl` o una herramienta de API para probar los endpoints.

1.  **Crea un usuario:**
    ```bash
    curl -X POST -H "Content-Type: application/json" -d '''{"email":"rafa@test.com", "name":"Rafa"}''' http://localhost:3000/users
    # Guarda el ID que te devuelve, por ejemplo: 1
    ```

2.  **Crea una categoría:**
    ```bash
    curl -X POST -H "Content-Type: application/json" -d '''{"name":"Node.js"}''' http://localhost:3000/categories
    # Guarda el ID, por ejemplo: 1
    ```

3.  **Crea un post para ese usuario:**
    ```bash
    curl -X POST -H "Content-Type: application/json" -d '''{"title":"Mi primer post con Prisma", "content":"Esto es genial", "authorId":1}''' http://localhost:3000/posts
    # Guarda el ID del post, por ejemplo: 1
    ```

4.  **Asigna la categoría "Node.js" al post:**
    ```bash
    curl -X PUT http://localhost:3000/posts/1/categories/1
    ```

5.  **Consulta el usuario para ver todo junto:**
    ```bash
    curl http://localhost:3000/users/1
    ```
    Verás la información del usuario, su perfil (si lo creaste) y un array con sus posts.

¡Felicidades! Has implementado una API con relaciones complejas usando Prisma.
