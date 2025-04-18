# Tutorial completo: Servidor Express con MongoDB y Mongoose

Este tutorial explica paso a paso cómo crear un servidor utilizando **Express** (un framework para Node.js) que se conecta a una base de datos **MongoDB** utilizando **Mongoose**.

---

## ✨ Objetivo
Aprender a construir un servidor con Express que permita:
- Recibir peticiones HTTP (como GET, POST, etc.)
- Conectarse a una base de datos MongoDB usando Mongoose
- Realizar operaciones CRUD (Crear, Leer, Actualizar, Eliminar)

---

## ⚙️ Tecnologías utilizadas

- **Node.js**: entorno para ejecutar JavaScript fuera del navegador.
- **Express**: framework minimalista para construir servidores web con Node.js.
- **MongoDB**: base de datos NoSQL orientada a documentos.
- **Mongoose**: biblioteca de modelado de objetos para MongoDB en Node.js.

---

## 🌐 ¿Qué es MongoDB?

MongoDB es una base de datos **NoSQL** (no relacional) basada en **documentos** (similar a objetos JSON), flexible y escalable. En lugar de usar tablas y filas (como en una base de datos SQL), usa **colecciones** y **documentos**.

Ejemplo de documento Mongo:
```json
{
  "name": "Juan",
  "age": 30,
  "email": "juan@example.com"
}
```

---

## 💡 ¿Qué es Mongoose?

**Mongoose** es una librería para Node.js que facilita trabajar con MongoDB:
- Permite definir esquemas de datos.
- Provee validaciones.
- Facilita operaciones CRUD.

---

## 📅 Paso 1: Crear el proyecto y configuraciones iniciales

### 1.1 Inicializar proyecto

```bash
mkdir servidor-express-mongo
cd servidor-express-mongo
npm init -y
```

Esto crea un archivo `package.json` que manejará tus dependencias.

### 1.2 Instalar dependencias

```bash
npm install express mongoose dotenv
```

- `express`: para crear el servidor.
- `mongoose`: para manejar la conexión y modelos de MongoDB.
- `dotenv`: para gestionar variables de entorno (como la URL de la base de datos).

---

## 📂 Estructura del proyecto

```
servidor-express-mongo/
├── models/
│   └── User.js        # Modelo de Mongoose
├── routes/
│   └── userRoutes.js  # Rutas para el modelo
├── .env               # Variables de entorno (como la URL de MongoDB)
├── index.js           # Archivo principal del servidor
└── package.json       # Configuraciones del proyecto
```

---

## 🚀 Paso 2: Crear el servidor con Express

### index.js
```js
require("dotenv").config(); // Carga variables de entorno
const express = require("express");
const mongoose = require("mongoose");
const userRoutes = require("./routes/userRoutes");

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware para parsear JSON
app.use(express.json());

// Conectar a MongoDB
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log("Conectado a MongoDB"))
.catch((err) => console.error("Error de conexión", err));

// Rutas
app.use("/api/users", userRoutes);

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
```

---

## 📖 Paso 3: Definir el modelo con Mongoose

### models/User.js
```js
const mongoose = require("mongoose");

// Definimos el esquema del usuario
const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  age: Number,
});

// Creamos el modelo
module.exports = mongoose.model("User", userSchema);
```

---

## 📧 Paso 4: Crear las rutas (API REST)

### routes/userRoutes.js
```js
const express = require("express");
const User = require("../models/User");
const router = express.Router();

// Crear nuevo usuario
router.post("/", async (req, res) => {
  try {
    const user = await User.create(req.body);
    res.status(201).json(user);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Obtener todos los usuarios
router.get("/", async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Obtener usuario por ID
router.get("/:id", async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) return res.status(404).json({ message: "No encontrado" });
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Actualizar usuario por ID
router.put("/:id", async (req, res) => {
  try {
    const user = await User.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(user);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Eliminar usuario
router.delete("/:id", async (req, res) => {
  try {
    await User.findByIdAndDelete(req.params.id);
    res.json({ message: "Usuario eliminado" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
```

---

## 🌍 Archivo .env (NO lo subas a GitHub)

### .env
```
PORT=3000
MONGO_URI=mongodb://localhost:27017/miapp
```

---

## 🎯 Probar las APIs

Puedes usar herramientas como **Postman** o **Thunder Client** para probar las rutas:

- `GET http://localhost:3000/api/users` → Lista todos los usuarios
- `POST http://localhost:3000/api/users` con body JSON → Crea usuario
- `GET http://localhost:3000/api/users/:id` → Trae un usuario
- `PUT http://localhost:3000/api/users/:id` → Actualiza
- `DELETE http://localhost:3000/api/users/:id` → Elimina

---

## 🔍 Conclusión

Con este proyecto aprendiste a:
- Crear un servidor básico con Express.
- Conectarte a MongoDB usando Mongoose.
- Definir esquemas y modelos.
- Crear rutas API RESTful para manejar operaciones CRUD.

Este es el primer paso para construir aplicaciones backend sólidas con Node.js y Mongo.

---

## 🔗 Recursos recomendados

- https://mongoosejs.com/docs/
- https://expressjs.com/es/
- https://www.mongodb.com/docs/manual/

---

¿Listo para llevar esto a producción? Próximamente podemos ver cómo hacer deploy con servicios como **Render**, **Railway** o **Vercel + Serverless Functions** ✨

