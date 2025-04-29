# Extensión: Mejorar Autenticación con JWT y Refresh Tokens en Express.js

## Introducción

El método de guardar `userId` en cookies funciona, pero **no es el más seguro ni escalable**.

Para profesionalizar el sistema de autenticación, vamos a usar **JWT (JSON Web Tokens)** junto con **Refresh Tokens**.

### 📅 ¿Por qué usar JWT?

- No requiere almacenar sesión en el servidor (es stateless).
- Puede incluir información del usuario.
- Firma que garantiza integridad.

### 📒 ¿Qué es un Refresh Token?

- Un token de larga vida que permite solicitar nuevos JWTs sin necesidad de re-loguearse.
- Se guarda de forma **segura** (normalmente en cookies `HttpOnly`).

---

## Nuevos Paquetes a Instalar

```bash
npm install jsonwebtoken
```

---

## Actualizar lógica de Login

### 1. Generar Tokens

Creamos dos tipos de tokens:
- **Access Token**: corto plazo (ej: 15 min).
- **Refresh Token**: largo plazo (ej: 7 días).

**controllers/authController.js** (modificado)

```javascript
const jwt = require('jsonwebtoken');

// Funciones auxiliares
const createAccessToken = (userId) => {
    return jwt.sign({ userId }, process.env.JWT_SECRET, { expiresIn: '15m' });
};

const createRefreshToken = (userId) => {
    return jwt.sign({ userId }, process.env.JWT_SECRET, { expiresIn: '7d' });
};

exports.login = async (req, res) => {
    const { username, password } = req.body;

    try {
        const user = await User.findOne({ username });
        if (!user) return res.status(400).json({ message: 'Credenciales incorrectas' });

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) return res.status(400).json({ message: 'Credenciales incorrectas' });

        const accessToken = createAccessToken(user._id);
        const refreshToken = createRefreshToken(user._id);

        // Guardar refresh token en cookie segura
        res.cookie('refreshToken', refreshToken, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'strict',
            path: '/api/auth/refresh'
        });

        res.json({ accessToken });

    } catch (error) {
        res.status(500).json({ message: 'Error en el servidor' });
    }
};
```

### 2. Ruta para Refresh Token

**routes/authRoutes.js**

```javascript
router.post('/refresh', (req, res) => {
    const token = req.cookies.refreshToken;
    if (!token) return res.status(401).json({ message: 'No autenticado' });

    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) return res.status(403).json({ message: 'Token inválido' });

        const accessToken = jwt.sign({ userId: decoded.userId }, process.env.JWT_SECRET, { expiresIn: '15m' });
        res.json({ accessToken });
    });
});
```

### 3. Middleware para Proteger Rutas con Access Token

**middleware/authMiddleware.js**

```javascript
exports.isAuthenticated = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) return res.status(401).json({ message: 'No token, acceso denegado' });

    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) return res.status(403).json({ message: 'Token inválido' });
        req.userId = decoded.userId;
        next();
    });
};
```

---

## Agregar Rutas de Prueba

### 1. Ruta Pública (no requiere autenticación)

```javascript
router.get('/public', (req, res) => {
    res.json({ message: 'Esta es una ruta pública, no necesitas estar logueado.' });
});
```

### 2. Ruta Protegida (requiere autenticación)

```javascript
const { isAuthenticated } = require('../middleware/authMiddleware');

router.get('/protected', isAuthenticated, (req, res) => {
    res.json({ message: `Acceso autorizado. Usuario ID: ${req.userId}` });
});
```

Así podrás probar ambos tipos de rutas fácilmente.

---

## Flujo Completo

1. El usuario hace **login**:
   - Recibe un `accessToken` (guardado en frontend, ej: localStorage).
   - Se guarda `refreshToken` como cookie segura.

2. Cada vez que hace un request protegido:
   - Envia `Authorization: Bearer <accessToken>` en headers.

3. Si el `accessToken` expira:
   - Usa el `refreshToken` para pedir uno nuevo sin loguearse.

4. Si el `refreshToken` también expira:
   - Debe loguearse nuevamente.

---

## Buenas Prácticas Adicionales

- **Revocar** refresh tokens manualmente (opcional: guardar refreshTokens válidos en DB).
- Rotación de Refresh Tokens: emitir uno nuevo cada vez que se use.
- Usar cabeceras **secure** para cookies en producción.
- No guardar tokens en `localStorage` si quieres la máxima seguridad, usar solo cookies `HttpOnly`.
- Configurar tiempos de expiración racionales.

---

# 🎉 Con esto ya tienes un sistema de login de calidad profesional, seguro y escalable.

