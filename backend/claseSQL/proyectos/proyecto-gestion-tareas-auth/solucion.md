# Solución: API de Gestión de Tareas con Autenticación

Guía completa para construir el proyecto.

---

### Paso 1: Configuración del Proyecto

```bash
# 1. Crear carpeta y navegar a ella
mkdir tareas-auth-api
cd tareas-auth-api

# 2. Inicializar proyecto de Node.js
npm init -y

# 3. Instalar dependencias
npm install express @prisma/client @libsql/client jsonwebtoken bcryptjs

# 4. Instalar dependencia de desarrollo
npm install prisma --save-dev

# 5. Inicializar Prisma
npx prisma init
```

---

### Paso 2: Configuración de Prisma y Base de Datos

1.  **`prisma/schema.prisma`**: Reemplaza el contenido con el schema.

    ```prisma
    generator client {
      provider = "prisma-client-js"
    }

    datasource db {
      provider = "sqlite"
      url      = env("DATABASE_URL")
    }

    model User {
      id       Int    @id @default(autoincrement())
      email    String @unique
      password String
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

2.  **`.env`**: Configura tu URL de Turso y añade un secreto para JWT.

    ```env
    DATABASE_URL="libsql://tu-db.turso.io?authToken=TU_TOKEN"
    JWT_SECRET="ESTO_ES_UN_SECRETO_MUY_SEGURO_CAMBIAME"
    ```

3.  **Ejecutar Migración**:

    ```bash
    npx prisma migrate dev --name init-tasks-auth-schema
    ```

---

### Paso 3: Código de la Aplicación

Crea un archivo `index.js` con el siguiente contenido:

```javascript
const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();
const app = express();
app.use(express.json());

const JWT_SECRET = process.env.JWT_SECRET;

// --- Rutas de Autenticación ---

app.post('/auth/register', async (req, res) => {
  const { email, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);
  try {
    const user = await prisma.user.create({
      data: { email, password: hashedPassword },
    });
    res.status(201).json({ message: 'Usuario creado', userId: user.id });
  } catch (error) {
    res.status(400).json({ error: 'El email ya existe' });
  }
});

app.post('/auth/login', async (req, res) => {
  const { email, password } = req.body;
  const user = await prisma.user.findUnique({ where: { email } });

  if (!user || !await bcrypt.compare(password, user.password)) {
    return res.status(401).json({ error: 'Credenciales inválidas' });
  }

  const token = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '1h' });
  res.json({ token });
});

// --- Middleware de Autenticación ---

const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) return res.sendStatus(401);

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.userId = user.userId;
    next();
  });
};

// --- Rutas de Tareas (Protegidas) ---

app.post('/tasks', authenticateToken, async (req, res) => {
  const { title } = req.body;
  const task = await prisma.task.create({
    data: { title, ownerId: req.userId },
  });
  res.status(201).json(task);
});

app.get('/tasks', authenticateToken, async (req, res) => {
  const tasks = await prisma.task.findMany({ where: { ownerId: req.userId } });
  res.json(tasks);
});

app.put('/tasks/:id', authenticateToken, async (req, res) => {
  const { id } = req.params;
  const { title, completed } = req.body;
  try {
    const task = await prisma.task.updateMany({
      where: { id: parseInt(id), ownerId: req.userId },
      data: { title, completed },
    });
    if (task.count === 0) {
        return res.status(404).json({ error: 'Tarea no encontrada o no te pertenece' });
    }
    res.json({ message: 'Tarea actualizada' });
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar la tarea' });
  }
});

app.delete('/tasks/:id', authenticateToken, async (req, res) => {
    const { id } = req.params;
    const task = await prisma.task.deleteMany({
        where: { id: parseInt(id), ownerId: req.userId }
    });
    if (task.count === 0) {
        return res.status(404).json({ error: 'Tarea no encontrada o no te pertenece' });
    }
    res.status(204).send();
});

const PORT = 3000;
app.listen(PORT, () => console.log(`Servidor corriendo en http://localhost:${PORT}`));
```

---

### Paso 4: Probar la API

1.  **Inicia el servidor:** `node index.js`

2.  **Registra un usuario:**
    ```bash
    curl -X POST -H "Content-Type: application/json" -d '''{"email":"test@test.com", "password":"123456"}''' http://localhost:3000/auth/register
    ```

3.  **Inicia sesión para obtener un token:**
    ```bash
    curl -X POST -H "Content-Type: application/json" -d '''{"email":"test@test.com", "password":"123456"}''' http://localhost:3000/auth/login
    # Copia el token que te devuelve. Ej: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
    ```

4.  **Crea una tarea (usando el token):**
    Reemplaza `TU_TOKEN_AQUI` con el token que copiaste.
    ```bash
    export TOKEN=TU_TOKEN_AQUI
    curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d '''{"title":"Aprender JWT"}''' http://localhost:3000/tasks
    ```

5.  **Obtén tus tareas:**
    ```bash
    curl -H "Authorization: Bearer $TOKEN" http://localhost:3000/tasks
    ```

6.  **Intenta obtener tareas sin token (debería fallar):**
    ```bash
    curl http://localhost:3000/tasks
    # Debería devolver un error 401 Unauthorized
    ```
