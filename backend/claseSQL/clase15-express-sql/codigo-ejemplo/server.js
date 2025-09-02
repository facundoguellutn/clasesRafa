import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';

// Importar rutas
import librosRoutes from './src/routes/libros.js';
import usuariosRoutes from './src/routes/usuarios.js';
import prestamosRoutes from './src/routes/prestamos.js';

// Importar middlewares
import { errorHandler } from './src/middleware/errorHandler.js';
import { ApiResponse } from './src/utils/responses.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares de seguridad
app.use(helmet());
app.use(cors({
    origin: process.env.FRONTEND_URL || ['http://localhost:3000', 'http://localhost:3001'],
    credentials: true
}));

// Rate limiting
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutos
    max: process.env.NODE_ENV === 'development' ? 1000 : 100, // más permisivo en desarrollo
    message: {
        success: false,
        message: 'Demasiadas solicitudes desde esta IP',
        retryAfter: '15 minutos'
    },
    standardHeaders: true,
    legacyHeaders: false
});

app.use('/api/', limiter);

// Middlewares de parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Middleware de logging
app.use((req, res, next) => {
    const timestamp = new Date().toISOString();
    console.log(`${timestamp} - ${req.method} ${req.path} - IP: ${req.ip}`);
    next();
});

// Rutas principales
app.use('/api/libros', librosRoutes);
app.use('/api/usuarios', usuariosRoutes);
app.use('/api/prestamos', prestamosRoutes);

// Ruta de health check
app.get('/api/health', (req, res) => {
    ApiResponse.success(res, {
        status: 'OK',
        timestamp: new Date().toISOString(),
        uptime: process.uptime(),
        version: process.env.npm_package_version || '1.0.0',
        environment: process.env.NODE_ENV || 'development'
    });
});

// Documentación básica de la API
app.get('/api', (req, res) => {
    ApiResponse.success(res, {
        message: 'API de Biblioteca - Sistema de gestión',
        endpoints: {
            libros: '/api/libros',
            usuarios: '/api/usuarios',
            prestamos: '/api/prestamos',
            health: '/api/health'
        },
        version: '1.0.0'
    });
});

// Ruta 404
app.use('*', (req, res) => {
    ApiResponse.notFound(res, {
        message: `Ruta ${req.originalUrl} no encontrada`,
        availableRoutes: ['/api', '/api/health', '/api/libros', '/api/usuarios', '/api/prestamos']
    });
});

// Middleware de manejo de errores (debe ir al final)
app.use(errorHandler);

// Manejo de cierre graceful
process.on('SIGTERM', () => {
    console.log('SIGTERM señal recibida: cerrando servidor HTTP...');
    process.exit(0);
});

process.on('SIGINT', () => {
    console.log('SIGINT señal recibida: cerrando servidor HTTP...');
    process.exit(0);
});

// Iniciar servidor
if (process.env.NODE_ENV !== 'test') {
    app.listen(PORT, () => {
        console.log('🚀 Servidor iniciado');
        console.log(`📍 URL: http://localhost:${PORT}`);
        console.log(`📚 API docs: http://localhost:${PORT}/api`);
        console.log(`💚 Health check: http://localhost:${PORT}/api/health`);
        console.log(`🌍 Ambiente: ${process.env.NODE_ENV || 'development'}`);
        console.log('─'.repeat(50));
    });
}

export default app;