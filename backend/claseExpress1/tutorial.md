# Tutorial de Express.js

## ¿Qué es Express.js?
Express.js es un framework web minimalista y flexible para Node.js que proporciona un conjunto robusto de características para desarrollar aplicaciones web y APIs. Es uno de los frameworks más populares de Node.js y se ha convertido en un estándar de facto para crear aplicaciones web del lado del servidor.

## ¿Para qué se usa?
- Crear aplicaciones web
- Desarrollar APIs RESTful
- Servir archivos estáticos
- Integrar con bases de datos
- Manejar rutas y middleware
- Procesar formularios y datos JSON

## Conceptos Básicos

### API REST
Una API REST es un estilo de arquitectura de software que define un conjunto de restricciones y propiedades basadas en HTTP. Los principales métodos HTTP utilizados son:

- GET: Obtener datos
- POST: Crear nuevos recursos
- PUT: Actualizar recursos existentes
- DELETE: Eliminar recursos

### Request y Response
- **Request (req)**: Objeto que contiene la información de la petición del cliente
  - req.params: Parámetros de la URL (ejemplo: /usuarios/:id)
  - req.body: Datos enviados en el cuerpo de la petición
  - req.query: Parámetros de consulta en la URL (ejemplo: ?nombre=juan)

- **Response (res)**: Objeto que nos permite enviar respuestas al cliente
  - res.json(): Enviar respuesta en formato JSON
  - res.status(): Establecer el código de estado HTTP
  - res.send(): Enviar respuesta genérica

### Query Params en Express
Los query params son parámetros que se envían en la URL después del signo de interrogación (?). Por ejemplo:
```
http://localhost:3000/api/usuarios/buscar?nombre=juan
```

Características principales:
- Se acceden a través de `req.query`
- Múltiples parámetros se separan con &
- Son opcionales por defecto
- Útiles para filtros y búsquedas
- No son sensibles a mayúsculas/minúsculas en la clave

Ejemplo de uso:
```javascript
app.get('/api/usuarios/buscar', (req, res) => {
    const nombre = req.query.nombre;
    // Acceder al valor del parámetro 'nombre'
});
```

### Require vs Import
Node.js soporta dos sistemas diferentes para importar módulos:

1. **CommonJS (require)**:
   ```javascript
   const express = require('express');
   ```
   - Es el sistema tradicional de Node.js
   - No necesita configuración especial
   - Funciona de manera síncrona

2. **ES Modules (import)**:
   ```javascript
   import express from 'express';
   ```
   - Sistema más moderno
   - Requiere configuración:
     - Agregar `"type": "module"` en package.json, o
     - Usar extensión `.mjs` en los archivos
   - Soporta importación asíncrona

### JSON en Express
JSON (JavaScript Object Notation) es fundamental en Express:

1. **Procesamiento de JSON entrante**:
   ```javascript
   app.use(express.json()); // Middleware para parsear JSON
   ```

2. **Envío de respuestas JSON**:
   ```javascript
   app.get('/api/usuarios', (req, res) => {
       res.json({ mensaje: "Datos en formato JSON" });
   });
   ```

### Códigos de Estado HTTP
Los códigos de estado más comunes en Express:

- **2xx - Éxito**
  - `200`: OK - Petición exitosa
  - `201`: Created - Recurso creado exitosamente
  
- **4xx - Errores del cliente**
  - `400`: Bad Request - Error en la petición
  - `401`: Unauthorized - No autorizado
  - `403`: Forbidden - Prohibido
  - `404`: Not Found - Recurso no encontrado
  
- **5xx - Errores del servidor**
  - `500`: Internal Server Error - Error interno

Ejemplo de uso:
```javascript
app.post('/api/usuarios', (req, res) => {
    // Al crear un nuevo usuario
    res.status(201).json({ mensaje: "Usuario creado" });
});
```

### Método app.use()
El método `use()` es fundamental para el middleware en Express:

1. **Middleware Global**:
   ```javascript
   app.use(express.json()); // Se aplica a todas las rutas
   ```

2. **Middleware para Rutas Específicas**:
   ```javascript
   app.use('/api', (req, res, next) => {
       console.log('Petición a /api');
       next();
   });
   ```

3. **Archivos Estáticos**:
   ```javascript
   app.use(express.static('public'));
   ```

### Método app.listen()
Este método inicia el servidor HTTP:

1. **Configuración Básica**:
   ```javascript
   const port = 3000;
   app.listen(port, () => {
       console.log(`Servidor corriendo en http://localhost:${port}`);
   });
   ```

2. **Configuración Avanzada**:
   ```javascript
   app.listen(3000, '0.0.0.0', () => {
       console.log('Servidor escuchando en todas las interfaces');
   });
   ```

## Pasos para crear este ejemplo

1. **Inicializar el proyecto**
   ```bash
   npm init -y
   ```

2. **Instalar dependencias**
   ```bash
   npm install express
   npm install nodemon --save-dev
   ```

3. **Estructura del proyecto**
   ```
   express-tutorial/
   ├── package.json
   ├── index.js
   └── tutorial.md
   ```

4. **Configuración del package.json**
   - Se agregaron scripts para iniciar el servidor
   - Se especificaron las dependencias necesarias

5. **Creación del servidor (index.js)**
   - Importación de Express
   - Configuración del middleware
   - Definición de rutas
   - Implementación de operaciones CRUD

## Explicación del código

### Middleware
```javascript
app.use(express.json());
```
Este middleware permite procesar datos JSON en las peticiones.

### Rutas implementadas

1. **GET /api/usuarios/buscar**
   - Busca usuarios por nombre
   - Requiere parámetro de consulta 'nombre'
   - Retorna array de usuarios que coinciden
   - Ejemplo: `/api/usuarios/buscar?nombre=juan`

2. **GET /api/usuarios**
   - Obtiene todos los usuarios
   - No requiere parámetros
   - Retorna array de usuarios

3. **GET /api/usuarios/:id**
   - Obtiene un usuario específico
   - Requiere ID en la URL
   - Retorna usuario o error 404

4. **POST /api/usuarios**
   - Crea un nuevo usuario
   - Requiere nombre, email y edad en el body
   - Retorna el usuario creado

5. **PUT /api/usuarios/:id**
   - Actualiza un usuario existente
   - Requiere ID en la URL y datos a actualizar en el body
   - Retorna usuario actualizado

6. **DELETE /api/usuarios/:id**
   - Elimina un usuario
   - Requiere ID en la URL
   - Retorna usuario eliminado

## Pruebas de la API

Para probar la API puedes usar herramientas como Postman o cURL:

### Ejemplos de cURL

1. Buscar usuarios por nombre:
```bash
curl "http://localhost:3000/api/usuarios/buscar?nombre=juan"
```

2. Obtener todos los usuarios:
```bash
curl http://localhost:3000/api/usuarios
```

3. Crear un usuario:
```bash
curl -X POST http://localhost:3000/api/usuarios \
  -H "Content-Type: application/json" \
  -d '{"nombre":"Ana","email":"ana@email.com","edad":27}'
```

4. Actualizar un usuario:
```bash
curl -X PUT http://localhost:3000/api/usuarios/1 \
  -H "Content-Type: application/json" \
  -d '{"nombre":"Juan Actualizado"}'
```

5. Eliminar un usuario:
```bash
curl -X DELETE http://localhost:3000/api/usuarios/1
```