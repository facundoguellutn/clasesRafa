# Tutorial Completo: Implementar Login Seguro con Express.js y MongoDB

## Introducción

Cuando creamos aplicaciones web, necesitamos **identificar a los usuarios** para ofrecerles funcionalidades personalizadas. Esto involucra dos procesos importantes:

- **Autenticación**: Verificar la identidad del usuario (ej: login).
- **Autorización**: Determinar qué acciones puede realizar el usuario (ej: acceso a contenido privado).

En este tutorial aprenderás a implementar un sistema de **registro y login** seguro utilizando **Express.js** y **MongoDB**.

---

## Conceptos Clave

### 1. Autenticación vs Autorización
- **Autenticación**: "¿Quién eres?". Proceso de validar identidad (usuario y contraseña).
- **Autorización**: "¿Qué estás permitido a hacer?". Proceso de dar acceso a recursos según su rol.

### 2. Cookies y Sesiones
- **Cookies**: Pequeños archivos que el servidor pide al navegador que almacene.
- **Sesiones**: Información guardada en el servidor para seguir identificando al usuario entre peticiones.

Generalmente guardamos **tokens** o **identificadores de sesión** en cookies.

### 3. Seguridad de contraseñas
- **Nunca guardes contraseñas en texto plano**.
- **Usa hashing** (con funciones como `bcrypt`) para guardar solo versiones encriptadas.
- Hashing es **unidireccional**: no se puede recuperar la contraseña original desde el hash.

---

## Tecnologías Usadas

- **Express.js**: Framework para construir APIs en Node.js.
- **MongoDB + Mongoose**: Base de datos NoSQL y librería para modelado de datos.
- **bcryptjs**: Para hashear contraseñas.
- **cookie-parser**: Middleware para manejar cookies.
- **dotenv**: Manejo de variables de entorno.

---

## Paso a Paso

### 1. Inicializar el proyecto

```bash
mkdir auth-tutorial
cd auth-tutorial
npm init -y
npm install express mongoose bcryptjs cookie-parser dotenv cors
```

### 2. Estructura de Carpetas

```bash
auth-tutorial/
|-- models/
|   |-- User.js
|-- routes/
|   |-- authRoutes.js
|-- controllers/
|   |-- authController.js
|-- middleware/
|   |-- authMiddleware.js
|-- .env
|-- server.js
```

### 3. Configurar la conexión a MongoDB

**server.js**

```javascript
require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cookieParser = require('cookie-parser');
const cors = require('cors');
const authRoutes = require('./routes/authRoutes');

const app = express();

// Middlewares
app.use(cors({ origin: true, credentials: true }));
app.use(express.json());
app.use(cookieParser());

// Rutas
app.use('/api/auth', authRoutes);

// Conexión a la base de datos
mongoose.connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true
})
.then(() => app.listen(5000, () => console.log('Servidor corriendo en puerto 5000')))
.catch(err => console.error(err));
```

**.env**

```
MONGO_URI=mongodb://localhost:27017/authdb
JWT_SECRET=supersecreto
```

### 4. Crear el modelo de Usuario

**models/User.js**

```javascript
const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true
    }
});

module.exports = mongoose.model('User', UserSchema);
```

### 5. Crear el controlador de autenticación

**controllers/authController.js**

```javascript
const User = require('../models/User');
const bcrypt = require('bcryptjs');

// Registrar nuevo usuario
exports.register = async (req, res) => {
    const { username, password } = req.body;

    try {
        // Validar datos
        if (!username || !password) {
            return res.status(400).json({ message: 'Completa todos los campos' });
        }

        // Verificar si el usuario ya existe
        const existingUser = await User.findOne({ username });
        if (existingUser) {
            return res.status(400).json({ message: 'El usuario ya existe' });
        }

        // Hashear la contraseña
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        // Crear el usuario
        const user = new User({ username, password: hashedPassword });
        await user.save();

        res.status(201).json({ message: 'Usuario registrado correctamente' });
    } catch (error) {
        res.status(500).json({ message: 'Error en el servidor' });
    }
};

// Login de usuario
exports.login = async (req, res) => {
    const { username, password } = req.body;

    try {
        // Buscar usuario
        const user = await User.findOne({ username });
        if (!user) {
            return res.status(400).json({ message: 'Credenciales incorrectas' });
        }

        // Comparar contraseñas
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ message: 'Credenciales incorrectas' });
        }

        // Crear cookie (muy simplificada, normalmente se usa JWT)
        res.cookie('userId', user._id.toString(), {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production'
        });

        res.json({ message: 'Login exitoso' });
    } catch (error) {
        res.status(500).json({ message: 'Error en el servidor' });
    }
};

// Logout de usuario
exports.logout = (req, res) => {
    res.clearCookie('userId');
    res.json({ message: 'Logout exitoso' });
};
```

### 6. Crear las rutas

**routes/authRoutes.js**

```javascript
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.post('/register', authController.register);
router.post('/login', authController.login);
router.post('/logout', authController.logout);

module.exports = router;
```

### 7. Middleware para proteger rutas (opcional)

**middleware/authMiddleware.js**

```javascript
exports.isAuthenticated = (req, res, next) => {
    if (!req.cookies.userId) {
        return res.status(401).json({ message: 'No autenticado' });
    }
    next();
};
```

Se puede usar así en cualquier ruta:

```javascript
const { isAuthenticated } = require('../middleware/authMiddleware');

router.get('/protected', isAuthenticated, (req, res) => {
    res.json({ message: 'Ruta protegida!' });
});
```

---

## Buenas Prácticas Adicionales

- Usar **Tokens JWT** en lugar de guardar directamente un userId en la cookie.
- Configurar `SameSite`, `Secure` y `HttpOnly` para las cookies.
- Implementar **refresh tokens** para sesiones más seguras.
- Limitar los intentos de login para evitar **fuerza bruta**.
- Validar inputs para prevenir **inyecciones**.
- Usar HTTPS en producción para cifrar las cookies.

---

## Resumen Final

Con este tutorial:
- Aprendiste qué es autenticación y autorización.
- Entendiste cómo funcionan cookies y sesiones.
- Implementaste un sistema de registro, login y logout en Express.js y MongoDB.
- Aplicaste buenas prácticas de seguridad básicas.

---

## Ejemplo de pruebas con Postman

- POST `http://localhost:5000/api/auth/register`
  - Body: `{ "username": "juan", "password": "123456" }`
- POST `http://localhost:5000/api/auth/login`
  - Body: `{ "username": "juan", "password": "123456" }`
- POST `http://localhost:5000/api/auth/logout`

---

# ✨ Listo para seguir avanzando hacia JWTs y OAuth2 en el futuro ✨

