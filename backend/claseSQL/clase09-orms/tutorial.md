# Clase 09: Introducción a los ORMs con Prisma, Express y Turso

## 1. ¿Qué es un ORM?

Un **ORM (Object-Relational Mapper)** es una herramienta que actúa como un "traductor" entre tu aplicación (escrita en un lenguaje como JavaScript) y una base de datos relacional (que habla SQL).

En lugar de escribir consultas SQL manualmente (como `SELECT * FROM users`), usas métodos y objetos en tu lenguaje de programación. El ORM se encarga de generar y ejecutar el SQL por ti.

**Analogía:** Imagina que quieres pedir comida en un país donde no hablas el idioma. El ORM es como un traductor que toma tu pedido en tu idioma ("Quiero una hamburguesa") y lo comunica correctamente al cocinero en su idioma.

### Ventajas de usar un ORM:

*   **Desarrollo Rápido:** Escribes menos código y más legible.
*   **Seguridad:** Ayudan a prevenir ataques de inyección SQL.
*   **Menos Errores:** El autocompletado y el tipado (especialmente con TypeScript) reducen errores.
*   **Abstracción de la Base de Datos:** Es más fácil cambiar de una base de datos (ej. PostgreSQL) a otra (ej. MySQL) en el futuro.

## 2. Introducción a Prisma

**Prisma** es un ORM moderno para Node.js y TypeScript. Se destaca por tres componentes principales:

1.  **Prisma Schema:** Un archivo (`schema.prisma`) donde defines los modelos de tu base de datos de forma declarativa. Es la "única fuente de verdad".
2.  **Prisma Client:** Un cliente de base de datos auto-generado y con tipado seguro que usas en tu aplicación para leer y escribir datos.
3.  **Prisma Migrate:** Una herramienta para evolucionar el esquema de tu base de datos de forma segura y controlada.

Usaremos Prisma porque es muy intuitivo y su integración con TypeScript es excelente.

## 3. Proyecto: API de Tareas con Express, Turso y Prisma

Vamos a construir una API simple para gestionar una lista de tareas.

### Paso 1: Configuración del Proyecto

1.  Crea una nueva carpeta y inicializa un proyecto de Node.js.
    ```bash
    mkdir mi-api-con-prisma
    cd mi-api-con-prisma
    npm init -y
    ```

2.  Instala las dependencias necesarias:
    ```bash
    # Dependencias de producción
    npm install express @prisma/client @libsql/client

    # Dependencia de desarrollo (solo para la herramienta de Prisma)
    npm install prisma --save-dev
    ```

### Paso 2: Inicializar Prisma

1.  Ejecuta el comando de inicialización de Prisma.
    ```bash
    npx prisma init
    ```
    Esto creará una carpeta `prisma` con un archivo `schema.prisma` y un archivo `.env` en la raíz de tu proyecto.

### Paso 3: Configurar el Schema de Prisma para Turso

1.  Abre el archivo `prisma/schema.prisma`.
2.  Modifica el `datasource` para que use `sqlite` (compatible con Turso/libSQL).
3.  Añade un modelo `Task` para representar nuestras tareas.

    ```prisma
    // prisma/schema.prisma

    generator client {
      provider = "prisma-client-js"
    }

    datasource db {
      provider = "sqlite"
      url      = env("DATABASE_URL")
    }

    model Task {
      id        Int      @id @default(autoincrement())
      title     String
      completed Boolean  @default(false)
      createdAt DateTime @default(now())
    }
    ```

### Paso 4: Configurar la Conexión a Turso

1.  Abre el archivo `.env` que Prisma creó.
2.  Añade la URL de tu base de datos de Turso. Recuerda que debe empezar con `libsql://`.

    ```env
    # .env
    DATABASE_URL="libsql://tu-base-de-datos.turso.io?authToken=TU_AUTH_TOKEN"
    ```
    Reemplaza los valores con los de tu base de datos en Turso.

### Paso 5: Ejecutar la Migración

Prisma necesita sincronizar tu `schema.prisma` con la base de datos real. Esto se hace con una migración.

1.  Ejecuta el comando de migración. Te pedirá un nombre para la migración (puedes poner "init").
    ```bash
    npx prisma migrate dev --name init
    ```
    Prisma se conectará a Turso, creará la tabla `Task` y generará el Prisma Client. Si todo sale bien, ¡tu base de datos ya está lista!

### Paso 6: Crear el Servidor de Express

1.  Crea un archivo `index.js` en la raíz del proyecto.
2.  Configura un servidor básico de Express e importa Prisma Client.

    ```javascript
    // index.js
    const express = require('express');
    const { PrismaClient } = require('@prisma/client');

    const app = express();
    const prisma = new PrismaClient();

    app.use(express.json());

    const PORT = process.env.PORT || 3000;

    // Endpoint para obtener todas las tareas
    app.get('/tasks', async (req, res) => {
      try {
        const tasks = await prisma.task.findMany();
        res.json(tasks);
      } catch (error) {
        res.status(500).json({ error: 'Error al obtener las tareas.' });
      }
    });

    // Endpoint para crear una nueva tarea
    app.post('/tasks', async (req, res) => {
      try {
        const { title } = req.body;
        if (!title) {
          return res.status(400).json({ error: 'El título es obligatorio.' });
        }
        const newTask = await prisma.task.create({
          data: {
            title: title,
          },
        });
        res.status(201).json(newTask);
      } catch (error) {
        res.status(500).json({ error: 'Error al crear la tarea.' });
      }
    });

    app.listen(PORT, () => {
      console.log(`Servidor corriendo en http://localhost:${PORT}`);
    });
    ```

### Paso 7: Probar la API

1.  Inicia tu servidor.
    ```bash
    node index.js
    ```

2.  Usa una herramienta como Postman, Insomnia o `curl` para probar los endpoints.

    *   **Crear una tarea:**
        ```bash
        # Petición POST a http://localhost:3000/tasks
        curl -X POST -H "Content-Type: application/json" -d '{"title":"Aprender sobre ORMs"}' http://localhost:3000/tasks
        ```

    *   **Obtener todas las tareas:**
        ```bash
        # Petición GET a http://localhost:3000/tasks
        curl http://localhost:3000/tasks
        ```

¡Felicidades! Has creado una API funcional utilizando Express, Prisma y Turso. Ahora tienes una base sólida para construir aplicaciones más complejas.
