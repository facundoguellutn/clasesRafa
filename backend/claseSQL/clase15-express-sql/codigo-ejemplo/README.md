# 📚 Biblioteca API - Express.js + SQLite

API REST completa para un sistema de biblioteca desarrollada con Express.js y SQLite. Este proyecto implementa todas las mejores prácticas para el desarrollo de APIs modernas.

## 🚀 Características

- ✅ **API RESTful** con Express.js
- ✅ **Base de datos SQLite** con esquema normalizado
- ✅ **Validaciones robustas** con Joi
- ✅ **Manejo de errores** centralizado
- ✅ **Seguridad** con Helmet y rate limiting
- ✅ **Testing** automatizado con Jest
- ✅ **Documentación** completa de endpoints
- ✅ **CORS** configurado para desarrollo

## 📁 Estructura del Proyecto

```
biblioteca-api/
├── src/
│   ├── controllers/     # Lógica de negocio
│   ├── models/         # Modelos de datos
│   ├── routes/         # Definición de rutas
│   ├── middleware/     # Middlewares personalizados
│   └── utils/         # Utilidades y helpers
├── database/          # Esquemas y datos de ejemplo
├── tests/            # Pruebas automatizadas
├── scripts/          # Scripts de setup y utilidades
└── docs/            # Documentación adicional
```

## 🛠️ Instalación

### Requisitos previos

- Node.js >= 18.0.0
- npm >= 8.0.0

### Pasos de instalación

1. **Clonar e instalar dependencias:**

```bash
# Clonar el proyecto
git clone <url-del-proyecto>
cd biblioteca-api

# Instalar dependencias
npm install
```

2. **Configurar variables de entorno:**

```bash
# Copiar archivo de ejemplo
cp .env.example .env

# Editar variables según tu entorno
nano .env
```

3. **Configurar base de datos:**

```bash
# Ejecutar script de setup (crea DB y tablas)
npm run setup

# Poblar con datos de ejemplo (opcional)
npm run seed
```

4. **Iniciar servidor:**

```bash
# Modo desarrollo (con nodemon)
npm run dev

# Modo producción
npm start
```

## 🔧 Scripts Disponibles

| Script | Descripción |
|--------|-------------|
| `npm run dev` | Inicia servidor en modo desarrollo |
| `npm start` | Inicia servidor en modo producción |
| `npm test` | Ejecuta todas las pruebas |
| `npm run test:watch` | Ejecuta pruebas en modo watch |
| `npm run setup` | Configura base de datos inicial |
| `npm run seed` | Pobla la DB con datos de ejemplo |

## 📡 Endpoints de la API

### Health Check

```bash
GET /api/health
```

**Respuesta:**
```json
{
  "success": true,
  "status": "OK",
  "timestamp": "2024-03-15T10:30:00.000Z",
  "uptime": 1234.567
}
```

### Libros

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| `GET` | `/api/libros` | Listar todos los libros |
| `GET` | `/api/libros/:id` | Obtener libro por ID |
| `POST` | `/api/libros` | Crear nuevo libro |
| `PUT` | `/api/libros/:id` | Actualizar libro |
| `DELETE` | `/api/libros/:id` | Eliminar libro |
| `GET` | `/api/libros/stats` | Estadísticas de libros |

#### Filtros disponibles para GET /api/libros

```bash
# Buscar por texto (título o autor)
GET /api/libros?q=garcia

# Filtrar por disponibilidad
GET /api/libros?disponible=true

# Filtrar por género
GET /api/libros?genero_id=1

# Filtrar por autor
GET /api/libros?autor_id=2

# Paginación
GET /api/libros?limit=10&offset=20

# Combinar filtros
GET /api/libros?q=soledad&disponible=true&limit=5
```

#### Crear libro (POST /api/libros)

```bash
curl -X POST http://localhost:3000/api/libros \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Cien años de soledad",
    "isbn": "978-8437604947",
    "autor_id": 1,
    "genero_id": 1,
    "paginas": 471,
    "precio_reposicion": 8500.00
  }'
```

### Usuarios

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| `GET` | `/api/usuarios` | Listar usuarios |
| `GET` | `/api/usuarios/:id` | Obtener usuario por ID |
| `POST` | `/api/usuarios` | Crear nuevo usuario |
| `PUT` | `/api/usuarios/:id` | Actualizar usuario |
| `DELETE` | `/api/usuarios/:id` | Eliminar usuario |

### Préstamos

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| `GET` | `/api/prestamos` | Listar préstamos |
| `GET` | `/api/prestamos/:id` | Obtener préstamo por ID |
| `POST` | `/api/prestamos` | Crear nuevo préstamo |
| `PUT` | `/api/prestamos/:id/devolver` | Devolver libro |
| `GET` | `/api/prestamos/vencidos` | Préstamos vencidos |

## 🧪 Testing

El proyecto incluye pruebas automatizadas completas:

```bash
# Ejecutar todas las pruebas
npm test

# Ejecutar con coverage
npm test -- --coverage

# Ejecutar pruebas específicas
npm test -- --testNamePattern="libros"

# Modo watch para desarrollo
npm run test:watch
```

### Estructura de tests

```
tests/
├── libros.test.js      # Tests de la API de libros
├── usuarios.test.js    # Tests de la API de usuarios
├── prestamos.test.js   # Tests de la API de préstamos
└── helpers/           # Utilidades para testing
```

## 🔒 Seguridad

La API implementa múltiples capas de seguridad:

- **Helmet**: Headers de seguridad HTTP
- **CORS**: Control de acceso entre dominios
- **Rate Limiting**: Límite de requests por IP
- **Validación**: Validación estricta de datos de entrada
- **Sanitización**: Limpieza de datos para prevenir inyecciones

## 📊 Base de Datos

### Esquema

La base de datos está completamente normalizada con las siguientes tablas:

- **autores**: Información de autores
- **generos**: Géneros literarios
- **editoriales**: Casas editoriales
- **libros**: Catálogo de libros
- **usuarios**: Usuarios del sistema
- **prestamos**: Transacciones de préstamos
- **multas**: Historial de multas
- **reservas**: Sistema de reservas

### Relaciones

```
autores (1) -> (N) libros
generos (1) -> (N) libros
usuarios (1) -> (N) prestamos
libros (1) -> (N) prestamos
usuarios (1) -> (N) multas
```

### Vistas predefinidas

- `vista_libros_completa`: Libros con información de autor, género y estadísticas
- `vista_prestamos_completa`: Préstamos con información completa
- `vista_usuarios_estadisticas`: Usuarios con métricas de préstamos

## 🔧 Configuración

### Variables de entorno

```bash
# Servidor
PORT=3000
NODE_ENV=development

# Base de datos
DATABASE_PATH=./database/biblioteca.sqlite

# Seguridad
JWT_SECRET=tu-secret-key
RATE_LIMIT_MAX_REQUESTS=100

# CORS
FRONTEND_URL=http://localhost:3001
```

### Personalización

El proyecto está diseñado para ser fácilmente extensible:

1. **Nuevos endpoints**: Agregar rutas en `/src/routes/`
2. **Validaciones**: Extender esquemas en `/src/middleware/validation.js`
3. **Modelos**: Crear nuevos modelos en `/src/models/`
4. **Middlewares**: Agregar lógica personalizada en `/src/middleware/`

## 📈 Monitoreo

### Logs

Los logs se generan automáticamente para:

- Requests HTTP (método, URL, IP, timestamp)
- Errores de la aplicación
- Queries a la base de datos (en modo desarrollo)

### Métricas

Endpoints de estadísticas disponibles:

- `/api/libros/stats` - Estadísticas de libros
- `/api/usuarios/stats` - Métricas de usuarios
- `/api/prestamos/stats` - Análisis de préstamos

## 🚀 Despliegue

### Desarrollo

```bash
npm run dev
```

### Producción

```bash
# Instalar dependencias de producción solamente
npm ci --only=production

# Configurar variables de entorno de producción
export NODE_ENV=production
export PORT=8080

# Iniciar servidor
npm start
```

### Docker

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear un Pull Request

### Estándares de código

- **ESLint**: Configurado con estándar de JavaScript
- **Prettier**: Formateo automático de código
- **Commits**: Seguir convención de commits convencionales

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 📞 Soporte

Si tienes preguntas o encuentras problemas:

1. Revisa la documentación
2. Verifica los issues existentes
3. Crea un nuevo issue con detalles del problema

---

**¡Desarrollado con ❤️ por Rafa!** 

¿Preguntas? ¡Contactame!