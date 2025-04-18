# 🧠 Tutorial completo de Mongoose con ejemplo de Usuarios y Comentarios

Este tutorial te explica cómo usar **Mongoose** paso a paso, con un ejemplo basado en una aplicación donde un **usuario** puede dejar múltiples **comentarios**.

---

## 📦 Instalación

```bash
npm install mongoose
```

---

## 🔌 Conexión a MongoDB

```js
// db.js
const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    await mongoose.connect('mongodb://localhost:27017/tutorialMongoose', {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log('MongoDB conectado');
  } catch (error) {
    console.error('Error al conectar:', error.message);
    process.exit(1);
  }
};

module.exports = connectDB;
```

En tu archivo principal (por ejemplo `index.js`):

```js
const connectDB = require('./db');
connectDB();
```

---

## 🧩 Definición de modelos

### 👤 Modelo de Usuario

```js
// models/User.js
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('User', userSchema);
```

### 💬 Modelo de Comentario

```js
// models/Comment.js
const mongoose = require('mongoose');

const commentSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  content: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Comment', commentSchema);
```

---

## ✅ Crear documentos

### Crear un usuario

```js
const User = require('./models/User');

const createUser = async () => {
  const user = new User({ name: 'Facu', email: 'facu@mail.com' });
  await user.save();
  console.log('Usuario creado:', user);
};
```

### Crear un comentario

```js
const Comment = require('./models/Comment');

const createComment = async (userId) => {
  const comment = new Comment({
    userId,
    content: 'Este es un comentario de prueba',
  });
  await comment.save();
  console.log('Comentario creado:', comment);
};
```

---

## 🔍 Leer / Buscar

### Buscar todos los comentarios con información del usuario

```js
const comments = await Comment.find().populate('userId');
console.log(comments);
```

> `.populate('userId')` rellena el campo `userId` con la información del usuario relacionado, en vez de solo el ObjectId.

### Buscar usuarios por nombre

```js
const users = await User.find({ name: 'Facu' });
```

### Buscar por ID

```js
const user = await User.findById('id_del_usuario');
```

---

## 📝 Actualizar documentos

### Reemplazar campos completos

```js
await User.findByIdAndUpdate('id_del_usuario', {
  name: 'Nuevo nombre',
  email: 'nuevo@email.com'
}, { new: true });
```

### Usar operadores `$set`, `$inc`, etc.

```js
await User.updateOne(
  { _id: 'id_del_usuario' },
  { 
    $set: { name: 'Facundo Actualizado' }, // reemplaza valor
    $inc: { loginCount: 1 },              // incrementa loginCount
  }
);
```

> `$set`: actualiza uno o más campos al valor que le indiques.
> 
> `$inc`: incrementa (o decrementa si es negativo) valores numéricos.

Ejemplo práctico:

```js
await Comment.updateOne(
  { _id: 'id_del_comentario' },
  { $set: { content: 'Comentario editado' } }
);
```

---

## 🗑️ Eliminar

```js
await User.findByIdAndDelete('id_usuario');
await Comment.findOneAndDelete({ userId: 'id_usuario' });
```

---

## 🧭 Filtros de búsqueda

```js
// Comentarios de los últimos 7 días
const comments = await Comment.find({
  createdAt: { $gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000) },
});

// Usuarios por nombre o email
const users = await User.find({
  $or: [{ name: 'Facu' }, { email: 'otro@mail.com' }]
});
```

---

## 🔗 Relaciones entre modelos

Ya al definir el schema de Comment con:

```js
userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
```

Podés usar `.populate('userId')` para acceder a todos los datos del usuario desde un comentario.

Para obtener los comentarios de un usuario:

```js
const user = await User.findById(userId);
const comments = await Comment.find({ userId: user._id });
```

---

## 🧪 Validaciones útiles

```js
email: {
  type: String,
  required: true,
  unique: true,
  match: [/^\S+@\S+\.\S+$/, 'Formato de email inválido']
}
```

---

## 🗂️ Estructura recomendada del proyecto

```
📁 models
 ┣ 📄User.js
 ┗ 📄Comment.js
📁 controllers
 ┗ 📄controller.js
📄 db.js
📄 index.js
```

---

## ✅ Buenas prácticas

- Usar validaciones desde los schemas
- Manejar errores con try/catch
- Separar controladores, rutas y modelos
- Usar populate para relaciones entre modelos
- Aplicar filtros eficientes y crear índices donde sea necesario

---

¡Y eso es todo! Ahora tenés una base sólida para trabajar con Mongoose y relaciones entre colecciones 🚀