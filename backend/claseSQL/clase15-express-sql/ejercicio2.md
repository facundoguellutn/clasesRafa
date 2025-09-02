# Ejercicio 2: Obteniendo un Recurso por ID (GET /:id)

## 🎯 Objetivo

Implementar un endpoint que recupere un único recurso de la base de datos utilizando un parámetro de ruta (ej: `/api/generos/3`). Esto implica manejar parámetros, escribir consultas SQL con `WHERE` y gestionar el caso en que el recurso no se encuentra (error 404).

---

## 📖 Escenario

Necesitamos poder ver los detalles de un género literario específico. Para ello, vamos a crear un nuevo conjunto de archivos (modelo, controlador, ruta) para el recurso `generos` y implementaremos el endpoint para obtener un género por su ID.

**Endpoint a Implementar**: `GET /api/generos/:id`

---

## 🏋️‍♀️ Tu Tarea

Siguiendo la arquitectura del proyecto, crearás los archivos necesarios para el recurso `generos`.

### Parte 1: El Modelo (`Genero.js`)

1.  Creá un nuevo archivo en `src/models/Genero.js`.
2.  Dentro, creá una clase `Genero`.
3.  Implementá un método estático y asíncrono `findById(id)`.
4.  Este método debe ejecutar la consulta `SELECT * FROM generos WHERE id = ?`.
5.  Utilizá `database.get()` ya que esperas un único resultado.
6.  Pasá el `id` como un parámetro en el array para prevenir inyección SQL.

### Parte 2: El Controlador (`generosController.js`)

1.  Creá un nuevo archivo en `src/controllers/generosController.js`.
2.  Importá el modelo `Genero` y la clase `ApiResponse`.
3.  Creá un objeto `generosController` con un método asíncrono `obtenerGenero(req, res, next)`.
4.  Extraé el `id` de los parámetros de la ruta: `const { id } = req.params;`.
5.  Llamá a `Genero.findById(id)`.
6.  **Manejo de Errores**: Si el método del modelo devuelve `undefined` (o `null`), significa que el género no fue encontrado. En ese caso, usá `ApiResponse.notFound(res, 'Género no encontrado')` para enviar una respuesta 404.
7.  Si se encuentra el género, envialo como una respuesta exitosa.

### Parte 3: La Ruta (`generos.js`)

1.  Creá un nuevo archivo en `src/routes/generos.js`.
2.  Definí la ruta `GET /:id` para que apunte al método `generosController.obtenerGenero`.

### Parte 4: Conexión Final (`server.js`)

1.  En `server.js`, importá y registrá tu nuevo `generosRoutes` bajo la ruta `/api/generos`.

---

## 💡 Soluciones Propuestas

<details>
<summary>Click para ver la solución</summary>

**`src/models/Genero.js`**
```javascript
import { database } from './database.js';

export class Genero {
    static async findById(id) {
        const sql = `SELECT * FROM generos WHERE id = ?`;
        return await database.get(sql, [id]);
    }
}
```

**`src/controllers/generosController.js`**
```javascript
import { Genero } from '../models/Genero.js';
import { ApiResponse } from '../utils/responses.js';

export const generosController = {
    async obtenerGenero(req, res, next) {
        try {
            const { id } = req.params;
            const genero = await Genero.findById(id);

            if (!genero) {
                return ApiResponse.notFound(res, 'Género no encontrado');
            }

            ApiResponse.success(res, { data: genero });
        } catch (error) {
            next(error);
        }
    }
};
```

**`src/routes/generos.js`**
```javascript
import { Router } from 'express';
import { generosController } from '../controllers/generosController.js';

const router = Router();

router.get('/:id', generosController.obtenerGenero);

export default router;
```

**`server.js` (líneas a agregar)**
```javascript
// ... otras importaciones
import generosRoutes from './src/routes/generos.js';

// ... otros app.use()
app.use('/api/generos', generosRoutes);

// ... resto del archivo
```

</details>
