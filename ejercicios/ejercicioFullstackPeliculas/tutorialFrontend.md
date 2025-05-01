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

## 🧠 Lógica de resolución
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

## 🗂️ Estructura del proyecto

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

(... backend igual ...)

---

## 💻 Frontend paso a paso

### 1. Inicializar proyecto
```bash
cd ..
npx create-react-app frontend
cd frontend
npm install react-router-dom
```

### 2. Estructura de carpetas
```
frontend/
├── src/
│   ├── components/
│   │   ├── LoginForm.js
│   │   ├── RegisterForm.js
│   │   ├── MovieList.js
│   │   ├── MovieForm.js
│   │   └── FilterBar.js
│   ├── pages/
│   │   ├── LoginPage.js
│   │   ├── RegisterPage.js
│   │   └── Dashboard.js
│   ├── App.js
│   └── index.js
```

### 3. Configurar router
```jsx
// src/App.js
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import LoginPage from './pages/LoginPage';
import RegisterPage from './pages/RegisterPage';
import Dashboard from './pages/Dashboard';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
```

### 4. Crear formulario de login
```jsx
// src/components/LoginForm.js
import { useState } from 'react';

export default function LoginForm({ onLogin }) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    const res = await fetch('http://localhost:3000/api/auth/login', {
      method: 'POST',
      credentials: 'include',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password }),
    });
    if (res.ok) onLogin();
  };

  return (
    <form onSubmit={handleSubmit}>
      <input value={email} onChange={e => setEmail(e.target.value)} placeholder="Email" />
      <input value={password} type="password" onChange={e => setPassword(e.target.value)} placeholder="Password" />
      <button type="submit">Iniciar sesión</button>
    </form>
  );
}
```

### 5. Dashboard y listado de películas
```jsx
// src/pages/Dashboard.js
import { useEffect, useState } from 'react';

export default function Dashboard() {
  const [movies, setMovies] = useState([]);

  useEffect(() => {
    fetch('http://localhost:3000/api/movies', {
      credentials: 'include',
    })
      .then(res => res.json())
      .then(data => setMovies(data));
  }, []);

  return (
    <div>
      <h1>Mis Películas</h1>
      <ul>
        {movies.map(m => (
          <li key={m._id}>{m.title} ({m.rating}/5)</li>
        ))}
      </ul>
    </div>
  );
}
```

### 6. Agregar/editar película
```jsx
// src/components/MovieForm.js
import { useState } from 'react';

export default function MovieForm({ onCreated }) {
  const [title, setTitle] = useState('');
  const [genre, setGenre] = useState('');
  const [rating, setRating] = useState(1);

  const handleSubmit = async (e) => {
    e.preventDefault();
    await fetch('http://localhost:3000/api/movies', {
      method: 'POST',
      credentials: 'include',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title, genre, rating }),
    });
    onCreated();
  };

  return (
    <form onSubmit={handleSubmit}>
      <input value={title} onChange={e => setTitle(e.target.value)} placeholder="Título" />
      <input value={genre} onChange={e => setGenre(e.target.value)} placeholder="Género" />
      <input type="number" value={rating} onChange={e => setRating(Number(e.target.value))} min="1" max="5" />
      <button type="submit">Agregar</button>
    </form>
  );
}
```

---

## 🔄 Conexión cliente-servidor

- Siempre usar `credentials: 'include'` en fetch para enviar cookies JWT.
- Controlar estado de login (ej: redirect al login si no hay sesión).
- Almacenar y eliminar token desde cookies manejadas por el backend.

---

¿Querés que agregue estilos con Tailwind y mejor estructura visual también?

