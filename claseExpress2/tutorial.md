# Tutorial: API REST con Express y Turso DB

## Índice
1. [Configuración del Entorno](#configuración-del-entorno)
2. [Conceptos Básicos](#conceptos-básicos)
3. [Estructura del Proyecto](#estructura-del-proyecto)
4. [SQL y Bases de Datos](#sql-y-bases-de-datos)
5. [Rutas y Controladores](#rutas-y-controladores)
6. [Implementación](#implementación)

## Configuración del Entorno

### Variables de Entorno
El proyecto utiliza variables de entorno para manejar configuraciones sensibles. Estas se almacenan en un archivo `.env` que no se sube a Git por seguridad.

1. Crea un archivo `.env` en la raíz del proyecto con las siguientes variables:
```bash
DB_URL=file:local.db
DB_SYNC_URL=your_turso_sync_url
DB_AUTH_TOKEN=your_turso_auth_token
PORT=3000
```

2. Se proporciona un archivo `.env.example` como plantilla:
```bash
cp .env.example .env
```

3. Actualiza los valores en tu archivo `.env` con tus credenciales de Turso.

### Archivos Ignorados
El proyecto incluye un `.gitignore` que excluye:
- `node_modules/` - Dependencias de Node.js
- `.env` - Variables de entorno
- `*.db` - Archivos de base de datos
- Archivos de sistema y logs

## Conceptos Básicos

### ¿Qué es una API REST?
Una API REST es una interfaz que permite la comunicación entre sistemas utilizando el protocolo HTTP. Los principales métodos HTTP son:
- GET: Obtener datos
- POST: Crear nuevos datos
- PUT: Actualizar datos existentes
- DELETE: Eliminar datos

### Express.js
Express es un framework para Node.js que facilita la creación de servidores web y APIs. Permite:
- Definir rutas
- Manejar peticiones HTTP
- Implementar middleware
- Gestionar errores

## SQL y Bases de Datos

### ¿Qué es SQL?
SQL (Structured Query Language) es un lenguaje estándar para trabajar con bases de datos relacionales. Permite:
- Crear y modificar tablas
- Insertar, actualizar y eliminar datos
- Consultar información
- Establecer relaciones entre tablas

### Conceptos Básicos de SQL

1. **Tablas**: Son estructuras que almacenan datos en filas y columnas
   ```sql
   CREATE TABLE usuarios (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     nombre TEXT NOT NULL,
     email TEXT UNIQUE NOT NULL,
     edad INTEGER
   );
   ```
   - `INTEGER`: tipo de dato numérico
   - `TEXT`: tipo de dato para texto
   - `PRIMARY KEY`: identificador único
   - `AUTOINCREMENT`: se incrementa automáticamente
   - `NOT NULL`: el campo no puede estar vacío
   - `UNIQUE`: el valor debe ser único en la tabla

2. **Relaciones entre Tablas**:
   ```sql
   CREATE TABLE comentarios (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     contenido TEXT NOT NULL,
     fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
     usuario_id INTEGER,
     FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
   );
   ```
   - `FOREIGN KEY`: establece una relación con otra tabla
   - `REFERENCES`: indica la tabla y columna con la que se relaciona

3. **Consultas Básicas**:
   ```sql
   -- Seleccionar todos los registros
   SELECT * FROM usuarios;

   -- Seleccionar con condición
   SELECT * FROM usuarios WHERE edad > 18;

   -- Unir tablas (JOIN)
   SELECT usuarios.nombre, comentarios.contenido 
   FROM usuarios 
   JOIN comentarios ON usuarios.id = comentarios.usuario_id;
   ```

## Rutas y Controladores

### Rutas (Routes)
Las rutas definen los endpoints de tu API y qué debe suceder cuando se accede a ellos.

```javascript
// userRoutes.js
router.get('/', getUsuarios);           // GET /api/usuarios
router.get('/:id', getUsuarioById);     // GET /api/usuarios/1
router.post('/', crearUsuario);         // POST /api/usuarios
```

- Los parámetros de ruta se definen con `:` (ejemplo: `:id`)
- Cada ruta se asocia a una función del controlador
- El orden de las rutas es importante (las más específicas primero)

### Controladores (Controllers)
Los controladores contienen la lógica de negocio para cada ruta.

```javascript
// userController.js
export const getUsuarios = async (req, res) => {
  try {
    const result = await client.execute('SELECT * FROM usuarios');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
```

- `req`: contiene la información de la petición
- `res`: permite enviar la respuesta
- `async/await`: maneja operaciones asíncronas
- Manejo de errores con try/catch

## Implementación de Comentarios

### 1. Crear la Tabla de Comentarios
```sql
CREATE TABLE IF NOT EXISTS comentarios (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  contenido TEXT NOT NULL,
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
  usuario_id INTEGER,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);
```

### 2. Endpoints para Comentarios

- GET /api/usuarios/:id/comentarios - Obtener comentarios de un usuario
- POST /api/usuarios/:id/comentarios - Crear comentario para un usuario
- PUT /api/usuarios/:id/comentarios/:comentarioId - Actualizar comentario
- DELETE /api/usuarios/:id/comentarios/:comentarioId - Eliminar comentario

### 3. Ejemplos de Uso

#### Crear un comentario:
```bash
curl -X POST http://localhost:3000/api/usuarios/1/comentarios \
  -H "Content-Type: application/json" \
  -d '{"contenido": "¡Gran trabajo!"}'
```

#### Obtener comentarios de un usuario:
```bash
curl http://localhost:3000/api/usuarios/1/comentarios
```

## Pruebas y Ejemplos

### 1. Crear un Usuario
```bash
curl -X POST http://localhost:3000/api/usuarios \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Ana García",
    "email": "ana@ejemplo.com",
    "edad": 28
  }'
```

### 2. Agregar un Comentario
```bash
curl -X POST http://localhost:3000/api/usuarios/1/comentarios \
  -H "Content-Type: application/json" \
  -d '{
    "contenido": "¡Excelente aporte!"
  }'
```

### 3. Obtener Usuario con sus Comentarios
```bash
curl http://localhost:3000/api/usuarios/1/comentarios
``` 