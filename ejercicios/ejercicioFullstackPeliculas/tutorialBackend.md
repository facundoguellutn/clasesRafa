# 🎥 MovieBase: Plataforma fullstack de películas con Express, MongoDB y React

## 📖 Introducción
Este ejercicio consiste en construir una aplicación completa usando Express.js en el backend, MongoDB como base de datos y React en el frontend. La aplicación se llama **MovieBase** y permite a los usuarios registrar su propio catálogo de películas. Este proyecto fue diseñado para practicar:

- Autenticación con JWT
- CRUD completo
- Uso de Mongoose y relaciones entre modelos
- Validación de sesión
- Filtros y búsquedas
- Conexión cliente-servidor

---

## 🪐 Lógica de resolución
Si tuviera que resolverlo desde cero, seguiría esta estrategia:

### 1. **Definir el alcance funcional**
- Qué puede hacer un usuario:
  - Registrarse, iniciar sesión, cerrar sesión
  - Crear, leer, editar, borrar películas
  - Buscar por género o puntuación

### 2. **Modelar los datos**
- Modelo `User`: username, email, password (hasheada)
- Modelo `Movie`: title, genre, rating (1-5), review, userId (ref a User)

### 3. **Planear el backend con Express**
- Crear servidor Express
- Conectar con MongoDB usando Mongoose
- Crear controladores, rutas, modelos
- Implementar login, registro, JWT y protección de rutas
- Crear rutas REST para películas

### 4. **Planear el frontend con React**
- Crear formulario de login/registro
- Crear interfaz para ver y filtrar películas
- Crear formularios para añadir y editar
- Usar fetch/Axios para consumir el backend

---

## 📂 Estructura del proyecto

```
moviebase/
├── backend/
│   ├── controllers/
│   ├── middlewares/
│   ├── models/
│   ├── routes/
│   ├── server.js
│   ├── .env
│   └── package.json
└── frontend/
    └── (App React)
```

---

## 🚀 Backend paso a paso

### 1. Inicialización del proyecto
```bash
mkdir moviebase && cd moviebase
mkdir backend && cd backend
npm init -y
npm install express mongoose bcrypt jsonwebtoken dotenv cors cookie-parser
```

### 2. Estructura base y configuración
```js
// backend/server.js
const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const cors = require('cors');
const cookieParser = require('cookie-parser');

const authRoutes = require('./routes/auth');
const movieRoutes = require('./routes/movies');
const { isAuthenticated } = require('./middlewares/authMiddleware');

dotenv.config();
const app = express();

app.use(cors({ origin: 'http://localhost:5173', credentials: true }));
app.use(express.json());
app.use(cookieParser());

mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB conectado'))
  .catch(err => console.log(err));

app.use('/api/auth', authRoutes);
app.use('/api/movies', isAuthenticated, movieRoutes);

app.listen(3000, () => console.log('Servidor en http://localhost:3000'));
```

### 3. Modelos Mongoose

```js
// backend/models/User.js
const mongoose = require('mongoose');
const UserSchema = new mongoose.Schema({
  username: String,
  email: String,
  password: String,
});
module.exports = mongoose.model('User', UserSchema);

// backend/models/Movie.js
const mongoose = require('mongoose');
const MovieSchema = new mongoose.Schema({
  title: String,
  genre: String,
  rating: Number,
  review: String,
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
});
module.exports = mongoose.model('Movie', MovieSchema);
```

### 4. Middleware de autenticación
```js
// backend/middlewares/authMiddleware.js
const jwt = require('jsonwebtoken');

exports.isAuthenticated = (req, res, next) => {
  const token = req.cookies.token;
  if (!token) return res.status(401).json({ message: 'No autorizado' });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.userId;
    next();
  } catch (err) {
    res.status(401).json({ message: 'Token inválido' });
  }
};
```

### 5. Rutas de autenticación
```js
// backend/routes/auth.js
const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const router = express.Router();

router.post('/register', async (req, res) => {
  const { username, email, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);
  const user = new User({ username, email, password: hashedPassword });
  await user.save();
  res.status(201).json({ message: 'Usuario registrado' });
});

router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  const user = await User.findOne({ email });
  if (!user || !(await bcrypt.compare(password, user.password))) {
    return res.status(400).json({ message: 'Credenciales inválidas' });
  }
  const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET);
  res.cookie('token', token, { httpOnly: true }).json({ message: 'Login exitoso' });
});

router.post('/logout', (req, res) => {
  res.clearCookie('token').json({ message: 'Sesíón cerrada' });
});

module.exports = router;
```

### 6. Rutas para películas
```js
// backend/routes/movies.js
const express = require('express');
const Movie = require('../models/Movie');
const router = express.Router();

router.get('/', async (req, res) => {
  const filters = { userId: req.userId };
  if (req.query.genre) filters.genre = req.query.genre;
  if (req.query.minRating) filters.rating = { $gte: Number(req.query.minRating) };
  const movies = await Movie.find(filters);
  res.json(movies);
});

router.post('/', async (req, res) => {
  const movie = new Movie({ ...req.body, userId: req.userId });
  await movie.save();
  res.status(201).json(movie);
});

router.put('/:id', async (req, res) => {
  const movie = await Movie.findOneAndUpdate(
    { _id: req.params.id, userId: req.userId },
    req.body,
    { new: true }
  );
  res.json(movie);
});

router.delete('/:id', async (req, res) => {
  await Movie.findOneAndDelete({ _id: req.params.id, userId: req.userId });
  res.json({ message: 'Película eliminada' });
});

module.exports = router;
```

---

## 💻 Frontend (resumen)

1. Crear app React con Vite o Create React App
2. Usar `react-router-dom` para rutas: login, registro, dashboard
3. Guardar token en cookie o localStorage
4. Componentes principales:
   - `LoginForm`, `RegisterForm`
   - `MovieList`, `MovieForm`
   - `FilterBar`
5. Usar `fetch` con `credentials: 'include'` para mantener la sesión

---

## 🔹 Extras opcionales

- Validaciones con `express-validator`
- Paginado en la lista de películas
- Sistema de favoritos o listas por categoría
- Subida de imagen de portada con Multer

---

Si querés te armo también el frontend completo en otro archivo paso a paso. ¡Decime si querés seguirlo!

