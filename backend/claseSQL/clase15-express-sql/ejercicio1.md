# Ejercicio 1: Creando el Recurso `autores` (GET)

## 🎯 Objetivo

Practicar el flujo completo de creación de un nuevo recurso en la API, siguiendo la arquitectura MVC del proyecto. Crearás el modelo, el controlador y la ruta para obtener una lista de todos los autores.

---

## 📖 Escenario

La API de la biblioteca ya puede gestionar libros, pero ahora necesitamos endpoints para gestionar a los autores. El primer paso es crear un endpoint que devuelva una lista de todos los autores en la base de datos.

**Endpoint a Implementar**: `GET /api/autores`

---

## 🏋️‍♀️ Tu Tarea

Necesitarás crear tres nuevos archivos y modificar uno existente.

### Parte 1: El Modelo (`Autor.js`)

1.  Creá un nuevo archivo en `src/models/Autor.js`.
2.  Dentro, creá una clase `Autor`.
3.  Implementá un método estático y asíncrono `findAll()` que ejecute la consulta `SELECT * FROM autores` y devuelva todos los resultados.

### Parte 2: El Controlador (`autoresController.js`)

1.  Creá un nuevo archivo en `src/controllers/autoresController.js`.
2.  Importá el modelo `Autor` y la clase `ApiResponse`.
3.  Creá un objeto `autoresController` con un método asíncrono `listarAutores(req, res, next)`.
4.  Dentro de `listarAutores`, llamá a `Autor.findAll()`, y si tiene éxito, usá `ApiResponse.success(res, { data: autores })` para enviar la respuesta.
5.  No te olvides del bloque `try...catch` para pasar cualquier error a `next(error)`.

### Parte 3: La Ruta (`autores.js`)

1.  Creá un nuevo archivo en `src/routes/autores.js`.
2.  Importá `Router` de Express y tu `autoresController`.
3.  Creá una nueva instancia del router.
4.  Definí la ruta `GET /` para que llame a `autoresController.listarAutores`.
5.  Exportá el router.

### Parte 4: Conectando Todo (`server.js`)

1.  Abrí el archivo principal `server.js`.
2.  Importá tu nuevo router de autores: `import autoresRoutes from './src/routes/autores.js';`
3.  Registrá el nuevo router con la aplicación de Express: `app.use('/api/autores', autoresRoutes);`

---

## 💡 Soluciones Propuestas

<details>
<summary>Click para ver la solución</summary>

**`src/models/Autor.js`**
```javascript
import { database } from './database.js';

export class Autor {
    static async findAll() {
        const sql = `SELECT * FROM autores ORDER BY apellido, nombre`;
        return await database.all(sql);
    }
}
```

**`src/controllers/autoresController.js`**
```javascript
import { Autor } from '../models/Autor.js';
import { ApiResponse } from '../utils/responses.js';

export const autoresController = {
    async listarAutores(req, res, next) {
        try {
            const autores = await Autor.findAll();
            ApiResponse.success(res, { data: autores });
        } catch (error) {
            next(error);
        }
    }
};
```

**`src/routes/autores.js`**
```javascript
import { Router } from 'express';
import { autoresController } from '../controllers/autoresController.js';

const router = Router();

router.get('/', autoresController.listarAutores);

export default router;
```

**`server.js` (líneas a agregar)**
```javascript
// ... otras importaciones
import autoresRoutes from './src/routes/autores.js';

// ... otros app.use()
app.use('/api/autores', autoresRoutes);

// ... resto del archivo
```

</details>
