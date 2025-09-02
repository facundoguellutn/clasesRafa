# 🚀 EXPRESS.JS + SQL: INTEGRACIÓN BACKEND - CLASE 15

> **Objetivo**: Crear APIs REST con Express.js que se conecten a bases de datos SQL, implementando operaciones CRUD completas y validaciones robustas.

## 🎯 ¿Qué aprenderemos?

Después de dominar SQL puro, es hora de integrarlo con **Express.js** para crear backends reales:

1. **Conexión a bases de datos SQL** desde Express
2. **APIs RESTful** con operaciones CRUD  
3. **Validación de datos** con middlewares
4. **Manejo de errores** profesional
5. **Organización de código** con MVC
6. **Testing de APIs** con datos reales

## 🛠️ Setup del Proyecto

### 📦 Dependencias necesarias

```json
{
  "name": "biblioteca-api",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "nodemon server.js",
    "start": "node server.js",
    "test": "jest"
  },
  "dependencies": {
    "express": "^4.18.2",
    "sqlite3": "^5.1.6",
    "cors": "^2.8.5",
    "helmet": "^7.1.0",
    "express-rate-limit": "^7.1.5",
    "joi": "^17.11.0",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    "nodemon": "^3.0.2",
    "jest": "^29.7.0",
    "supertest": "^6.3.3"
  }
}
```

### 🗂️ Estructura del proyecto

```
biblioteca-api/
├── src/
│   ├── controllers/
│   │   ├── librosController.js
│   │   ├── usuariosController.js
│   │   └── prestamosController.js
│   ├── models/
│   │   ├── database.js
│   │   ├── Libro.js
│   │   ├── Usuario.js
│   │   └── Prestamo.js
│   ├── routes/
│   │   ├── libros.js
│   │   ├── usuarios.js
│   │   └── prestamos.js
│   ├── middleware/
│   │   ├── validation.js
│   │   ├── errorHandler.js
│   │   └── auth.js
│   └── utils/
│       ├── logger.js
│       └── responses.js
├── database/
│   ├── schema.sql
│   └── seed.sql
├── tests/
│   ├── libros.test.js
│   └── usuarios.test.js
├── .env.example
├── server.js
└── README.md
```

## 🗄️ Configuración de Base de Datos

### 📁 database/schema.sql

```sql
-- Base de datos normalizada para biblioteca
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS autores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    nacionalidad TEXT,
    fecha_nacimiento DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS generos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT UNIQUE NOT NULL,
    descripcion TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS libros (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT NOT NULL,
    isbn TEXT UNIQUE,
    autor_id INTEGER NOT NULL,
    genero_id INTEGER,
    fecha_publicacion DATE,
    paginas INTEGER,
    disponible BOOLEAN DEFAULT TRUE,
    precio_reposicion REAL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (autor_id) REFERENCES autores(id),
    FOREIGN KEY (genero_id) REFERENCES generos(id)
);

CREATE TABLE IF NOT EXISTS usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    telefono TEXT,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    activo BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS prestamos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    libro_id INTEGER NOT NULL,
    usuario_id INTEGER NOT NULL,
    fecha_prestamo DATE DEFAULT CURRENT_DATE,
    fecha_devolucion_esperada DATE NOT NULL,
    fecha_devolucion_real DATE,
    multa REAL DEFAULT 0.0,
    estado TEXT DEFAULT 'activo' CHECK (estado IN ('activo', 'devuelto', 'vencido')),
    observaciones TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (libro_id) REFERENCES libros(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_libros_autor ON libros(autor_id);
CREATE INDEX IF NOT EXISTS idx_libros_disponible ON libros(disponible);
CREATE INDEX IF NOT EXISTS idx_prestamos_usuario ON prestamos(usuario_id);
CREATE INDEX IF NOT EXISTS idx_prestamos_estado ON prestamos(estado);
CREATE INDEX IF NOT EXISTS idx_usuarios_email ON usuarios(email);
```

### 🔌 src/models/database.js

```javascript
import sqlite3 from 'sqlite3';
import { readFileSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));

class Database {
    constructor() {
        this.db = null;
        this.connect();
    }

    connect() {
        const dbPath = process.env.NODE_ENV === 'test' 
            ? ':memory:' 
            : join(__dirname, '../../database/biblioteca.sqlite');

        this.db = new sqlite3.Database(dbPath, (err) => {
            if (err) {
                console.error('Error conectando a la base de datos:', err);
                process.exit(1);
            }
            
            console.log('✅ Conectado a SQLite');
            this.initialize();
        });

        // Habilitar foreign keys
        this.db.run("PRAGMA foreign_keys = ON");
    }

    async initialize() {
        try {
            const schema = readFileSync(
                join(__dirname, '../../database/schema.sql'), 
                'utf8'
            );
            
            await this.run(schema);
            console.log('✅ Base de datos inicializada');
            
        } catch (error) {
            console.error('Error inicializando base de datos:', error);
        }
    }

    // Promisify para async/await
    run(sql, params = []) {
        return new Promise((resolve, reject) => {
            this.db.run(sql, params, function(err) {
                if (err) reject(err);
                else resolve({ id: this.lastID, changes: this.changes });
            });
        });
    }

    get(sql, params = []) {
        return new Promise((resolve, reject) => {
            this.db.get(sql, params, (err, row) => {
                if (err) reject(err);
                else resolve(row);
            });
        });
    }

    all(sql, params = []) {
        return new Promise((resolve, reject) => {
            this.db.all(sql, params, (err, rows) => {
                if (err) reject(err);
                else resolve(rows);
            });
        });
    }

    close() {
        return new Promise((resolve) => {
            this.db.close(() => {
                console.log('🔒 Base de datos cerrada');
                resolve();
            });
        });
    }
}

// Singleton pattern
export const database = new Database();
```

## 📚 Modelo de Datos: Libros

### 📖 src/models/Libro.js

```javascript
import { database } from './database.js';

export class Libro {
    
    // Crear nuevo libro
    static async create(libroData) {
        const {
            titulo,
            isbn,
            autor_id,
            genero_id,
            fecha_publicacion,
            paginas,
            precio_reposicion
        } = libroData;

        const sql = `
            INSERT INTO libros (
                titulo, isbn, autor_id, genero_id, 
                fecha_publicacion, paginas, precio_reposicion
            ) VALUES (?, ?, ?, ?, ?, ?, ?)
        `;

        const result = await database.run(sql, [
            titulo, isbn, autor_id, genero_id,
            fecha_publicacion, paginas, precio_reposicion
        ]);

        return this.findById(result.id);
    }

    // Buscar por ID con información del autor y género
    static async findById(id) {
        const sql = `
            SELECT 
                l.*,
                a.nombre as autor_nombre,
                a.nacionalidad as autor_nacionalidad,
                g.nombre as genero_nombre
            FROM libros l
            LEFT JOIN autores a ON l.autor_id = a.id
            LEFT JOIN generos g ON l.genero_id = g.id
            WHERE l.id = ?
        `;

        return await database.get(sql, [id]);
    }

    // Listar todos con filtros opcionales
    static async findAll(filtros = {}) {
        let sql = `
            SELECT 
                l.*,
                a.nombre as autor_nombre,
                g.nombre as genero_nombre
            FROM libros l
            LEFT JOIN autores a ON l.autor_id = a.id
            LEFT JOIN generos g ON l.genero_id = g.id
            WHERE 1=1
        `;
        
        const params = [];

        // Filtros dinámicos
        if (filtros.disponible !== undefined) {
            sql += ' AND l.disponible = ?';
            params.push(filtros.disponible);
        }

        if (filtros.genero_id) {
            sql += ' AND l.genero_id = ?';
            params.push(filtros.genero_id);
        }

        if (filtros.autor_id) {
            sql += ' AND l.autor_id = ?';
            params.push(filtros.autor_id);
        }

        if (filtros.busqueda) {
            sql += ' AND (l.titulo LIKE ? OR a.nombre LIKE ?)';
            params.push(`%${filtros.busqueda}%`, `%${filtros.busqueda}%`);
        }

        // Ordenamiento
        sql += ' ORDER BY l.titulo ASC';

        // Paginación
        if (filtros.limit) {
            sql += ' LIMIT ?';
            params.push(parseInt(filtros.limit));
            
            if (filtros.offset) {
                sql += ' OFFSET ?';
                params.push(parseInt(filtros.offset));
            }
        }

        return await database.all(sql, params);
    }

    // Actualizar libro
    static async update(id, updates) {
        const camposPermitidos = [
            'titulo', 'isbn', 'autor_id', 'genero_id',
            'fecha_publicacion', 'paginas', 'disponible', 'precio_reposicion'
        ];

        const campos = [];
        const valores = [];

        // Construir query dinámicamente
        Object.keys(updates).forEach(campo => {
            if (camposPermitidos.includes(campo)) {
                campos.push(`${campo} = ?`);
                valores.push(updates[campo]);
            }
        });

        if (campos.length === 0) {
            throw new Error('No hay campos válidos para actualizar');
        }

        // Agregar timestamp y ID
        campos.push('updated_at = CURRENT_TIMESTAMP');
        valores.push(id);

        const sql = `
            UPDATE libros 
            SET ${campos.join(', ')}
            WHERE id = ?
        `;

        const result = await database.run(sql, valores);
        
        if (result.changes === 0) {
            throw new Error('Libro no encontrado');
        }

        return this.findById(id);
    }

    // Eliminar libro (soft delete)
    static async delete(id) {
        // Verificar que no tenga préstamos activos
        const prestamosActivos = await database.get(
            'SELECT COUNT(*) as count FROM prestamos WHERE libro_id = ? AND estado = "activo"',
            [id]
        );

        if (prestamosActivos.count > 0) {
            throw new Error('No se puede eliminar un libro con préstamos activos');
        }

        const result = await database.run(
            'UPDATE libros SET disponible = FALSE, updated_at = CURRENT_TIMESTAMP WHERE id = ?',
            [id]
        );

        if (result.changes === 0) {
            throw new Error('Libro no encontrado');
        }

        return { mensaje: 'Libro eliminado correctamente' };
    }

    // Buscar libros disponibles para préstamo
    static async findDisponibles() {
        return this.findAll({ disponible: true });
    }

    // Estadísticas de libros
    static async getEstadisticas() {
        const stats = await database.all(`
            SELECT 
                COUNT(*) as total_libros,
                COUNT(CASE WHEN disponible = 1 THEN 1 END) as disponibles,
                COUNT(CASE WHEN disponible = 0 THEN 1 END) as no_disponibles,
                AVG(paginas) as promedio_paginas,
                COUNT(DISTINCT autor_id) as total_autores,
                COUNT(DISTINCT genero_id) as total_generos
            FROM libros
        `);

        return stats[0];
    }
}
```

## 🎮 Controller: Lógica de Negocio

### 🎯 src/controllers/librosController.js

```javascript
import { Libro } from '../models/Libro.js';
import { validarLibro, validarActualizacionLibro } from '../middleware/validation.js';
import { ApiResponse } from '../utils/responses.js';

export const librosController = {
    
    // GET /api/libros
    async listarLibros(req, res, next) {
        try {
            const filtros = {
                disponible: req.query.disponible === 'true' ? true : 
                           req.query.disponible === 'false' ? false : undefined,
                genero_id: req.query.genero_id,
                autor_id: req.query.autor_id,
                busqueda: req.query.q,
                limit: req.query.limit || 20,
                offset: req.query.offset || 0
            };

            const libros = await Libro.findAll(filtros);
            
            ApiResponse.success(res, {
                data: libros,
                pagination: {
                    limit: parseInt(filtros.limit),
                    offset: parseInt(filtros.offset),
                    total: libros.length
                }
            });
            
        } catch (error) {
            next(error);
        }
    },

    // GET /api/libros/:id
    async obtenerLibro(req, res, next) {
        try {
            const { id } = req.params;
            const libro = await Libro.findById(id);
            
            if (!libro) {
                return ApiResponse.notFound(res, 'Libro no encontrado');
            }

            ApiResponse.success(res, { data: libro });
            
        } catch (error) {
            next(error);
        }
    },

    // POST /api/libros
    async crearLibro(req, res, next) {
        try {
            // Validación ya aplicada por middleware
            const nuevoLibro = await Libro.create(req.body);
            
            ApiResponse.created(res, {
                data: nuevoLibro,
                message: 'Libro creado exitosamente'
            });
            
        } catch (error) {
            if (error.code === 'SQLITE_CONSTRAINT_UNIQUE') {
                return ApiResponse.badRequest(res, 'El ISBN ya existe');
            }
            next(error);
        }
    },

    // PUT /api/libros/:id
    async actualizarLibro(req, res, next) {
        try {
            const { id } = req.params;
            const libroActualizado = await Libro.update(id, req.body);
            
            ApiResponse.success(res, {
                data: libroActualizado,
                message: 'Libro actualizado exitosamente'
            });
            
        } catch (error) {
            if (error.message === 'Libro no encontrado') {
                return ApiResponse.notFound(res, error.message);
            }
            if (error.code === 'SQLITE_CONSTRAINT_UNIQUE') {
                return ApiResponse.badRequest(res, 'El ISBN ya existe');
            }
            next(error);
        }
    },

    // DELETE /api/libros/:id
    async eliminarLibro(req, res, next) {
        try {
            const { id } = req.params;
            await Libro.delete(id);
            
            ApiResponse.success(res, {
                message: 'Libro eliminado exitosamente'
            });
            
        } catch (error) {
            if (error.message.includes('no encontrado')) {
                return ApiResponse.notFound(res, error.message);
            }
            if (error.message.includes('préstamos activos')) {
                return ApiResponse.badRequest(res, error.message);
            }
            next(error);
        }
    },

    // GET /api/libros/stats
    async obtenerEstadisticas(req, res, next) {
        try {
            const estadisticas = await Libro.getEstadisticas();
            
            ApiResponse.success(res, {
                data: estadisticas
            });
            
        } catch (error) {
            next(error);
        }
    }
};
```

## ✅ Validaciones con Joi

### 🛡️ src/middleware/validation.js

```javascript
import Joi from 'joi';
import { ApiResponse } from '../utils/responses.js';

// Esquemas de validación
const libroSchema = Joi.object({
    titulo: Joi.string()
        .min(1)
        .max(200)
        .required()
        .messages({
            'string.empty': 'El título no puede estar vacío',
            'string.max': 'El título no puede tener más de 200 caracteres',
            'any.required': 'El título es obligatorio'
        }),
        
    isbn: Joi.string()
        .pattern(/^978-\d{10}$/)
        .optional()
        .messages({
            'string.pattern.base': 'El ISBN debe tener el formato 978-XXXXXXXXXX'
        }),
        
    autor_id: Joi.number()
        .integer()
        .positive()
        .required()
        .messages({
            'number.base': 'El autor debe ser un número válido',
            'number.positive': 'El ID del autor debe ser positivo',
            'any.required': 'El autor es obligatorio'
        }),
        
    genero_id: Joi.number()
        .integer()
        .positive()
        .optional(),
        
    fecha_publicacion: Joi.date()
        .max('now')
        .optional()
        .messages({
            'date.max': 'La fecha de publicación no puede ser futura'
        }),
        
    paginas: Joi.number()
        .integer()
        .min(1)
        .max(10000)
        .optional()
        .messages({
            'number.min': 'Un libro debe tener al menos 1 página',
            'number.max': 'Un libro no puede tener más de 10,000 páginas'
        }),
        
    precio_reposicion: Joi.number()
        .positive()
        .precision(2)
        .optional()
        .messages({
            'number.positive': 'El precio debe ser positivo'
        })
});

const actualizacionLibroSchema = libroSchema.fork(
    ['titulo', 'autor_id'], 
    (schema) => schema.optional()
);

// Middleware de validación
export const validarLibro = (req, res, next) => {
    const { error } = libroSchema.validate(req.body, {
        abortEarly: false,
        stripUnknown: true
    });

    if (error) {
        const errores = error.details.map(detail => ({
            campo: detail.path.join('.'),
            mensaje: detail.message
        }));

        return ApiResponse.badRequest(res, 'Errores de validación', { errores });
    }

    next();
};

export const validarActualizacionLibro = (req, res, next) => {
    const { error } = actualizacionLibroSchema.validate(req.body, {
        abortEarly: false,
        stripUnknown: true
    });

    if (error) {
        const errores = error.details.map(detail => ({
            campo: detail.path.join('.'),
            mensaje: detail.message
        }));

        return ApiResponse.badRequest(res, 'Errores de validación', { errores });
    }

    next();
};
```

## 🛣️ Rutas: Definiendo Endpoints

### 📍 src/routes/libros.js

```javascript
import { Router } from 'express';
import { librosController } from '../controllers/librosController.js';
import { validarLibro, validarActualizacionLibro } from '../middleware/validation.js';

const router = Router();

// GET /api/libros - Listar libros con filtros
router.get('/', librosController.listarLibros);

// GET /api/libros/stats - Estadísticas (antes que /:id)
router.get('/stats', librosController.obtenerEstadisticas);

// GET /api/libros/:id - Obtener libro por ID
router.get('/:id', librosController.obtenerLibro);

// POST /api/libros - Crear nuevo libro
router.post('/', validarLibro, librosController.crearLibro);

// PUT /api/libros/:id - Actualizar libro
router.put('/:id', validarActualizacionLibro, librosController.actualizarLibro);

// DELETE /api/libros/:id - Eliminar libro
router.delete('/:id', librosController.eliminarLibro);

export default router;
```

## 🚀 Servidor Principal

### ⚡ server.js

```javascript
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';

// Importar rutas
import librosRoutes from './src/routes/libros.js';

// Importar middlewares
import { errorHandler } from './src/middleware/errorHandler.js';
import { ApiResponse } from './src/utils/responses.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares de seguridad
app.use(helmet());
app.use(cors({
    origin: process.env.FRONTEND_URL || 'http://localhost:3000',
    credentials: true
}));

// Rate limiting
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutos
    max: 100, // máximo 100 requests por ventana
    message: {
        error: 'Demasiadas solicitudes desde esta IP',
        retryAfter: '15 minutos'
    }
});

app.use('/api/', limiter);

// Middlewares de parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Middleware de logging
app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
    next();
});

// Rutas principales
app.use('/api/libros', librosRoutes);

// Ruta de health check
app.get('/api/health', (req, res) => {
    ApiResponse.success(res, {
        status: 'OK',
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});

// Ruta 404
app.use('*', (req, res) => {
    ApiResponse.notFound(res, `Ruta ${req.originalUrl} no encontrada`);
});

// Middleware de manejo de errores (debe ir al final)
app.use(errorHandler);

// Iniciar servidor
if (process.env.NODE_ENV !== 'test') {
    app.listen(PORT, () => {
        console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
        console.log(`📚 API docs: http://localhost:${PORT}/api/health`);
    });
}

export default app;
```

## 🧪 Testing de la API

### 🔬 tests/libros.test.js

```javascript
import request from 'supertest';
import app from '../server.js';
import { database } from '../src/models/database.js';

describe('API de Libros', () => {
    beforeAll(async () => {
        // Setup datos de prueba
        await database.run(`
            INSERT INTO autores (nombre, nacionalidad) VALUES 
            ('Gabriel García Márquez', 'Colombiana'),
            ('Jorge Luis Borges', 'Argentina')
        `);
        
        await database.run(`
            INSERT INTO generos (nombre) VALUES 
            ('Novela'),
            ('Cuento')
        `);
    });

    afterAll(async () => {
        await database.close();
    });

    describe('GET /api/libros', () => {
        it('debería retornar lista vacía inicialmente', async () => {
            const response = await request(app)
                .get('/api/libros')
                .expect(200);

            expect(response.body.success).toBe(true);
            expect(response.body.data).toEqual([]);
        });
    });

    describe('POST /api/libros', () => {
        it('debería crear un libro válido', async () => {
            const nuevoLibro = {
                titulo: 'Cien años de soledad',
                isbn: '978-8437604947',
                autor_id: 1,
                genero_id: 1,
                paginas: 471,
                precio_reposicion: 8500.00
            };

            const response = await request(app)
                .post('/api/libros')
                .send(nuevoLibro)
                .expect(201);

            expect(response.body.success).toBe(true);
            expect(response.body.data.titulo).toBe(nuevoLibro.titulo);
            expect(response.body.data.autor_nombre).toBe('Gabriel García Márquez');
        });

        it('debería rechazar libro sin título', async () => {
            const libroInvalido = {
                isbn: '978-8437604948',
                autor_id: 1
            };

            const response = await request(app)
                .post('/api/libros')
                .send(libroInvalido)
                .expect(400);

            expect(response.body.success).toBe(false);
            expect(response.body.message).toBe('Errores de validación');
        });
    });

    describe('GET /api/libros/:id', () => {
        it('debería obtener libro por ID', async () => {
            const response = await request(app)
                .get('/api/libros/1')
                .expect(200);

            expect(response.body.success).toBe(true);
            expect(response.body.data.id).toBe(1);
        });

        it('debería retornar 404 para libro inexistente', async () => {
            const response = await request(app)
                .get('/api/libros/9999')
                .expect(404);

            expect(response.body.success).toBe(false);
        });
    });
});
```

## 📈 Utilidades y Helpers

### 📊 src/utils/responses.js

```javascript
export class ApiResponse {
    
    static success(res, data = {}) {
        return res.status(200).json({
            success: true,
            ...data
        });
    }
    
    static created(res, data = {}) {
        return res.status(201).json({
            success: true,
            ...data
        });
    }
    
    static badRequest(res, message, errors = null) {
        return res.status(400).json({
            success: false,
            message,
            errors
        });
    }
    
    static notFound(res, message = 'Recurso no encontrado') {
        return res.status(404).json({
            success: false,
            message
        });
    }
    
    static serverError(res, message = 'Error interno del servidor') {
        return res.status(500).json({
            success: false,
            message
        });
    }
}
```

### 🚨 src/middleware/errorHandler.js

```javascript
import { ApiResponse } from '../utils/responses.js';

export const errorHandler = (error, req, res, next) => {
    console.error('Error:', error);

    // Errores de SQLite
    if (error.code === 'SQLITE_CONSTRAINT_FOREIGN_KEY') {
        return ApiResponse.badRequest(res, 'Referencia a registro inexistente');
    }

    if (error.code === 'SQLITE_CONSTRAINT_UNIQUE') {
        return ApiResponse.badRequest(res, 'Valor duplicado no permitido');
    }

    // Errores de validación
    if (error.name === 'ValidationError') {
        return ApiResponse.badRequest(res, 'Error de validación', error.details);
    }

    // Error por defecto
    return ApiResponse.serverError(res);
};
```

## 🎯 Probando la API

### 📝 Ejemplos de uso con curl:

```bash
# Listar libros
curl http://localhost:3000/api/libros

# Crear libro
curl -X POST http://localhost:3000/api/libros \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "El Aleph",
    "isbn": "978-8437604954",
    "autor_id": 2,
    "genero_id": 2,
    "paginas": 152
  }'

# Buscar libros
curl "http://localhost:3000/api/libros?q=aleph&disponible=true"

# Obtener estadísticas
curl http://localhost:3000/api/libros/stats
```

## 🎓 Lo que aprendimos

1. **Arquitectura MVC**: Separación clara de responsabilidades
2. **Base de datos**: Conexión y operaciones con SQLite
3. **Validaciones**: Esquemas robustos con Joi
4. **API REST**: Endpoints siguiendo convenciones
5. **Manejo de errores**: Respuestas consistentes
6. **Testing**: Pruebas automatizadas con Jest
7. **Seguridad**: Middlewares de protección

## 🚀 Próximos pasos

En las siguientes clases implementaremos:
- **Usuarios y Autenticación** con JWT
- **Préstamos** con lógica de negocio compleja
- **Paginación avanzada** y búsquedas
- **Upload de archivos** para portadas
- **Integración con Next.js** (full-stack)

---

**¡Ahora tenés una API REST profesional conectada a SQL!** 🎉