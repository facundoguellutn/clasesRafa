// Importamos Express
const express = require('express');

// Creamos una instancia de Express
const app = express();

// Middleware para procesar JSON
app.use(express.json());

// Array de usuarios (simulando una base de datos)
let usuarios = [
    { id: 1, nombre: "Juan", email: "juan@email.com", edad: 25 },
    { id: 2, nombre: "María", email: "maria@email.com", edad: 30 },
    { id: 3, nombre: "Pedro", email: "pedro@email.com", edad: 28 },
    { id: 4, nombre: "Pedro", email: "pedro@email.com", edad: 28 }

];

// GET - Buscar usuarios por nombre
app.get('/api/usuarios/buscar', (req, res) => {
    const nombre = req.query.nombre;
    
    if (!nombre) {
        return res.status(400).json({ mensaje: "El parámetro 'nombre' es requerido" });
    }
    
    const usuariosEncontrados = usuarios.filter(u => 
        u.nombre.toLowerCase().includes(nombre.toLowerCase())
    );
    
    res.json(usuariosEncontrados);
});

// GET - Obtener todos los usuarios
app.get('/api/usuarios', (req, res) => {
    res.json(usuarios);
});

// GET - Obtener un usuario por ID
app.get('/api/usuarios/:id', (req, res) => {
    const id = parseInt(req.params.id);
    const usuario = usuarios.find(u => u.id === id);
    
    if (!usuario) {
        return res.status(404).json({ mensaje: "Usuario no encontrado" });
    }
    
    res.json(usuario);
});

// POST - Crear un nuevo usuario
app.post('/api/usuarios', (req, res) => {
    const { nombre, email, edad } = req.body;
    
    if (!nombre || !email || !edad) {
        return res.status(400).json({ mensaje: "Todos los campos son requeridos" });
    }
    
    const nuevoUsuario = {
        id: usuarios.length + 1,
        nombre,
        email,
        edad
    };
    
    usuarios.push(nuevoUsuario);
    res.status(201).json(nuevoUsuario);
});

// PUT - Actualizar un usuario
app.put('/api/usuarios/:id', (req, res) => {
    const id = parseInt(req.params.id);
    const { nombre, email, edad } = req.body;
    
    const usuarioIndex = usuarios.findIndex(u => u.id === id);
    
    if (usuarioIndex === -1) {
        return res.status(404).json({ mensaje: "Usuario no encontrado" });
    }
    
    usuarios[usuarioIndex] = {
        ...usuarios[usuarioIndex],
        nombre: nombre || usuarios[usuarioIndex].nombre,
        email: email || usuarios[usuarioIndex].email,
        edad: edad || usuarios[usuarioIndex].edad
    };
    
    res.json(usuarios[usuarioIndex]);
});

// DELETE - Eliminar un usuario
app.delete('/api/usuarios/:id', (req, res) => {
    const id = parseInt(req.params.id);
    const usuarioIndex = usuarios.findIndex(u => u.id === id);
    
    if (usuarioIndex === -1) {
        return res.status(404).json({ mensaje: "Usuario no encontrado" });
    }
    
    const usuarioEliminado = usuarios[usuarioIndex];
    usuarios = usuarios.filter(u => u.id !== id);
    
    res.json(usuarioEliminado);
});

// Iniciamos el servidor
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
}); 