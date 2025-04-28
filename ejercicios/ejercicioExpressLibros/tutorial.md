# Ejercicio Express.js + MongoDB

## Proyecto: Gestión de Libros y Autores

---

## Consigna

Crear una aplicación backend usando **Express.js** y **MongoDB (Mongoose)** que permita:

- Registrar autores.
- Registrar libros asociados a autores.
- Consultar libros con la información del autor.
- Consultar autores con la lista de sus libros.
- Editar información de un libro o un autor.
- Eliminar un libro o un autor (y gestionar correctamente las relaciones).

### Requisitos:

- Utilizar controladores separados para manejar la lógica.
- Definir dos modelos relacionados: `Author` y `Book`.
- Aplicar buenas prácticas de estructura de carpetas.
- Implementar operaciones CRUD básicas.
- Realizar el populate de Mongoose para combinar datos de modelos relacionados.
- Bonus: Que al eliminar un autor, se eliminen automáticamente sus libros (cascade delete).

---

## Resolución paso a paso

---

### 1. Inicializar el proyecto

```bash
mkdir books-authors-api
cd books-authors-api
npm init -y
npm install express mongoose dotenv
npm install nodemon --save-dev
```

Agregar en `package.json` para usar nodemon:

```json
"scripts": {
  "start": "nodemon server.js"
}
```

---

### 2. Estructura de carpetas

```
books-authors-api/
|
|├── controllers/
|   ├── authorController.js
|   └── bookController.js
|
|├── models/
|   ├── Author.js
|   └── Book.js
|
|├── routes/
|   ├── authorRoutes.js
|   └── bookRoutes.js
|
|├── server.js
|├── .env
└── config/
    └── db.js
```

---

### 3. Configurar la base de datos (`config/db.js`)

```javascript
const mongoose = require('mongoose');
require('dotenv').config();

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('MongoDB connected');
  } catch (error) {
    console.error('Mongo connection error:', error.message);
    process.exit(1);
  }
};

module.exports = connectDB;
```

**Crear `.env`:**

```plaintext
MONGO_URI=mongodb://localhost:27017/booksAuthorsDB
```

---

### 4. Definir los modelos

**`models/Author.js`**

```javascript
const mongoose = require('mongoose');

const authorSchema = new mongoose.Schema({
  name: { type: String, required: true },
  biography: { type: String },
  birthDate: { type: Date },
});

module.exports = mongoose.model('Author', authorSchema);
```

---

**`models/Book.js`**

```javascript
const mongoose = require('mongoose');

const bookSchema = new mongoose.Schema({
  title: { type: String, required: true },
  summary: { type: String },
  publishDate: { type: Date },
  author: { type: mongoose.Schema.Types.ObjectId, ref: 'Author', required: true },
});

module.exports = mongoose.model('Book', bookSchema);
```

---

### 5. Crear los controladores

**`controllers/authorController.js`**

```javascript
const Author = require('../models/Author');
const Book = require('../models/Book');

exports.createAuthor = async (req, res) => {
  try {
    const author = await Author.create(req.body);
    res.status(201).json(author);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.getAuthors = async (req, res) => {
  try {
    const authors = await Author.find();
    res.json(authors);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getAuthorWithBooks = async (req, res) => {
  try {
    const author = await Author.findById(req.params.id);
    if (!author) return res.status(404).json({ message: 'Author not found' });

    const books = await Book.find({ author: author._id });
    res.json({ author, books });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.deleteAuthor = async (req, res) => {
  try {
    const author = await Author.findByIdAndDelete(req.params.id);
    if (!author) return res.status(404).json({ message: 'Author not found' });

    await Book.deleteMany({ author: author._id });
    res.json({ message: 'Author and their books deleted' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
```

---

**`controllers/bookController.js`**

```javascript
const Book = require('../models/Book');

exports.createBook = async (req, res) => {
  try {
    const book = await Book.create(req.body);
    res.status(201).json(book);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.getBooks = async (req, res) => {
  try {
    const books = await Book.find().populate('author');
    res.json(books);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.updateBook = async (req, res) => {
  try {
    const book = await Book.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!book) return res.status(404).json({ message: 'Book not found' });
    res.json(book);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.deleteBook = async (req, res) => {
  try {
    const book = await Book.findByIdAndDelete(req.params.id);
    if (!book) return res.status(404).json({ message: 'Book not found' });
    res.json({ message: 'Book deleted' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
```

---

### 6. Definir las rutas

**`routes/authorRoutes.js`**

```javascript
const express = require('express');
const router = express.Router();
const authorController = require('../controllers/authorController');

router.post('/', authorController.createAuthor);
router.get('/', authorController.getAuthors);
router.get('/:id', authorController.getAuthorWithBooks);
router.delete('/:id', authorController.deleteAuthor);

module.exports = router;
```

---

**`routes/bookRoutes.js`**

```javascript
const express = require('express');
const router = express.Router();
const bookController = require('../controllers/bookController');

router.post('/', bookController.createBook);
router.get('/', bookController.getBooks);
router.put('/:id', bookController.updateBook);
router.delete('/:id', bookController.deleteBook);

module.exports = router;
```

---

### 7. Configurar el servidor principal

**`server.js`**

```javascript
const express = require('express');
const connectDB = require('./config/db');
const authorRoutes = require('./routes/authorRoutes');
const bookRoutes = require('./routes/bookRoutes');
require('dotenv').config();

const app = express();

// Middlewares
app.use(express.json());

// Conectar base de datos
connectDB();

// Rutas
app.use('/api/authors', authorRoutes);
app.use('/api/books', bookRoutes);

// Iniciar servidor
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
```

---

## Pruebas sugeridas

Usar **Postman** o similar para probar:

- `POST /api/authors` → Crear un autor.
- `POST /api/books` → Crear un libro (pasar el `author` como ID en el body).
- `GET /api/books` → Obtener libros con info del autor (populate).
- `GET /api/authors/:id` → Obtener autor + sus libros.
- `PUT /api/books/:id` → Actualizar un libro.
- `DELETE /api/books/:id` → Eliminar un libro.
- `DELETE /api/authors/:id` → Eliminar autor y sus libros.

---

# Fin del ejercicio 👉🏻 Listo para subir a GitHub 🚀

