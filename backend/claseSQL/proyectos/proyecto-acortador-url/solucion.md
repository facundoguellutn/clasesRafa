# Solución: Acortador de URL

Guía paso a paso para construir el proyecto desde cero.

---

### Paso 1: Configuración del Proyecto

```bash
# 1. Crear carpeta y navegar a ella
mkdir acortador-url
cd acortador-url

# 2. Inicializar proyecto de Node.js
npm init -y

# 3. Instalar dependencias
npm install express @prisma/client @libsql/client nanoid

# 4. Instalar dependencia de desarrollo
npm install prisma --save-dev

# 5. Inicializar Prisma
npx prisma init
```

---

### Paso 2: Configuración de Prisma y Base de Datos

1.  **`prisma/schema.prisma`**: Reemplaza el contenido con el siguiente modelo.

    ```prisma
    generator client {
      provider = "prisma-client-js"
    }

    datasource db {
      provider = "sqlite"
      url      = env("DATABASE_URL")
    }

    model Url {
      id          Int      @id @default(autoincrement())
      originalUrl String
      shortCode   String   @unique
      visitCount  Int      @default(0)
      createdAt   DateTime @default(now())
    }
    ```

2.  **`.env`**: Configura la URL de tu base de datos de Turso.

    ```env
    DATABASE_URL="libsql://tu-db.turso.io?authToken=TU_TOKEN"
    ```

3.  **Ejecutar Migración**: Crea la tabla en tu base de datos.

    ```bash
    npx prisma migrate dev --name init-url-schema
    ```

---

### Paso 3: Código de la Aplicación

Crea un archivo `index.js` con el siguiente contenido:

```javascript
const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { nanoid } = require('nanoid');

const prisma = new PrismaClient();
const app = express();

app.use(express.json());

const BASE_URL = 'http://localhost:3000';

// Endpoint para acortar una URL
app.post('/shorten', async (req, res) => {
  const { url } = req.body;
  if (!url) {
    return res.status(400).json({ error: 'URL es requerida' });
  }

  try {
    const shortCode = nanoid(7); // Genera un código corto de 7 caracteres

    const newUrl = await prisma.url.create({
      data: {
        originalUrl: url,
        shortCode: shortCode,
      },
    });

    res.json({ shortUrl: `${BASE_URL}/${shortCode}` });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al crear la URL corta' });
  }
});

// Endpoint para redirigir a la URL original
app.get('/:shortCode', async (req, res) => {
  const { shortCode } = req.params;

  try {
    const urlRecord = await prisma.url.findUnique({
      where: { shortCode },
    });

    if (urlRecord) {
      // Incrementar el contador de visitas (sin esperar a que termine)
      await prisma.url.update({
        where: { id: urlRecord.id },
        data: { visitCount: { increment: 1 } },
      });
      // Redirigir al usuario
      return res.redirect(urlRecord.originalUrl);
    } else {
      return res.status(404).json({ error: 'URL no encontrada' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error en el servidor' });
  }
});

// Endpoint para ver estadísticas
app.get('/stats/:shortCode', async (req, res) => {
    const { shortCode } = req.params;

    try {
        const urlRecord = await prisma.url.findUnique({
            where: { shortCode },
        });

        if (urlRecord) {
            res.json({
                originalUrl: urlRecord.originalUrl,
                visitCount: urlRecord.visitCount,
                createdAt: urlRecord.createdAt,
            });
        } else {
            res.status(404).json({ error: 'URL no encontrada' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Error en el servidor' });
    }
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en ${BASE_URL}`);
});
```

---

### Paso 4: Probar la API

1.  **Inicia el servidor:**
    ```bash
    node index.js
    ```

2.  **Acorta una URL:**
    ```bash
    curl -X POST -H "Content-Type: application/json" -d '''{"url":"https://www.google.com"}''' http://localhost:3000/shorten
    # Respuesta esperada: {"shortUrl":"http://localhost:3000/xxxxxxx"}
    ```

3.  **Prueba la redirección:**
    Abre en tu navegador la URL corta que recibiste. Deberías ser redirigido a Google.

4.  **Consulta las estadísticas:**
    Si tu código corto fue `abcdefg`:
    ```bash
    curl http://localhost:3000/stats/abcdefg
    # Respuesta esperada: {"originalUrl":"https://www.google.com","visitCount":1, ...}
    ```
