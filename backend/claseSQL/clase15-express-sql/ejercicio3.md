# Ejercicio 3: Creando Recursos con `POST` y Validación

## 🎯 Objetivo

Implementar un endpoint `POST` para crear nuevos registros en la base de datos. Este ejercicio integra la lógica del modelo y controlador con un middleware de validación para asegurar la integridad de los datos antes de que lleguen a la base de datos.

---

## 📖 Escenario

Queremos poder agregar nuevos autores a nuestra biblioteca a través de la API. Para ello, implementaremos el endpoint `POST /api/autores`, que recibirá los datos del nuevo autor en el cuerpo de la petición (request body).

**Endpoint a Implementar**: `POST /api/autores`

---

## 🏋️‍♀️ Tu Tarea

Continuarás trabajando sobre los archivos del recurso `autores` que creaste en el Ejercicio 1.

### Parte 1: El Modelo (`Autor.js`)

1.  Abrí el archivo `src/models/Autor.js`.
2.  Añadí un nuevo método estático y asíncrono `create(autorData)`.
3.  El método debe recibir un objeto `autorData` con las propiedades `nombre` y `nacionalidad`.
4.  Debe ejecutar una sentencia `INSERT INTO autores (nombre, nacionalidad) VALUES (?, ?)`.
5.  Usá `database.run()` para la inserción.
6.  Después de la inserción, usá el `result.id` devuelto por `database.run()` para llamar a `this.findById(result.id)` y devolver el autor recién creado con todos sus datos.

### Parte 2: El Middleware de Validación (`validation.js`)

1.  Abrí el archivo `src/middleware/validation.js`.
2.  Creá un nuevo esquema de Joi llamado `autorSchema`.
3.  Definí las reglas de validación: `nombre` debe ser un string, con un mínimo de 2 caracteres y es obligatorio. `nacionalidad` es un string opcional.
4.  Creá y exportá una nueva función de middleware llamada `validarAutor` que use `autorSchema` para validar `req.body`.

### Parte 3: El Controlador (`autoresController.js`)

1.  Abrí `src/controllers/autoresController.js`.
2.  Añadí un nuevo método asíncrono `crearAutor(req, res, next)`.
3.  Dentro de un bloque `try...catch`, llamá a `Autor.create(req.body)`.
4.  Usá `ApiResponse.created(res, { data: nuevoAutor })` para enviar la respuesta 201.
5.  En el bloque `catch`, verificá si el error tiene un código `SQLITE_CONSTRAINT_UNIQUE` (si hubieras puesto un `UNIQUE` en el nombre) y devolvé un error 400 apropiado. Si no, pasá el error a `next()`.

### Parte 4: La Ruta (`autores.js`)

1.  Abrí `src/routes/autores.js`.
2.  Importá tu nuevo middleware `validarAutor`.
3.  Definí la ruta `POST /`, asegurándote de colocar el middleware `validarAutor` **antes** del método del controlador: `router.post('/', validarAutor, autoresController.crearAutor);`

---

## 💡 Soluciones Propuestas

<details>
<summary>Click para ver la solución</summary>

**`src/models/Autor.js` (métodos a agregar)**
```javascript
// ... dentro de la clase Autor

static async create(autorData) {
    const { nombre, nacionalidad } = autorData;
    const sql = `INSERT INTO autores (nombre, nacionalidad) VALUES (?, ?)`;
    const result = await database.run(sql, [nombre, nacionalidad]);
    return this.findById(result.id);
}

// findById es necesario para devolver el objeto creado
static async findById(id) {
    const sql = `SELECT * FROM autores WHERE id = ?`;
    return await database.get(sql, [id]);
}
```

**`src/middleware/validation.js` (código a agregar)**
```javascript
// ... otros esquemas

const autorSchema = Joi.object({
    nombre: Joi.string().min(2).max(100).required(),
    nacionalidad: Joi.string().max(100).optional(),
    fecha_nacimiento: Joi.date().optional()
});

export const validarAutor = (req, res, next) => {
    const { error } = autorSchema.validate(req.body);
    if (error) {
        return ApiResponse.badRequest(res, 'Datos de autor inválidos', {
            errores: error.details.map(d => d.message)
        });
    }
    next();
};
```

**`src/controllers/autoresController.js` (método a agregar)**
```javascript
// ... dentro del objeto autoresController

async crearAutor(req, res, next) {
    try {
        const nuevoAutor = await Autor.create(req.body);
        ApiResponse.created(res, { data: nuevoAutor });
    } catch (error) {
        // Manejar errores de constraints únicos si los hubiera
        next(error);
    }
}
```

**`src/routes/autores.js` (código a agregar)**
```javascript
// ... otras importaciones
import { validarAutor } from '../middleware/validation.js';

// ...
router.post('/', validarAutor, autoresController.crearAutor);

// ...
```

</details>
