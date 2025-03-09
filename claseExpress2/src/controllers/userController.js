import { client } from '../config/db.js';

// Obtener todos los usuarios
export const getUsuarios = async (req, res) => {
  try {
    const result = await client.execute('SELECT * FROM usuarios');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Obtener un usuario por ID
export const getUsuarioById = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await client.execute({
      sql: 'SELECT * FROM usuarios WHERE id = ?',
      args: [id]
    });
    
    if (result.rows.length === 0) {
      return res.status(404).json({ mensaje: 'Usuario no encontrado' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar usuarios por nombre
export const buscarUsuariosPorNombre = async (req, res) => {
  try {
    const { nombre } = req.params;
    const result = await client.execute({
      sql: 'SELECT * FROM usuarios WHERE nombre LIKE ?',
      args: [`%${nombre}%`]
    });
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Crear un nuevo usuario
export const crearUsuario = async (req, res) => {
  try {
    const { nombre, email, edad } = req.body;
    console.log(nombre, email, edad);
    const result = await client.execute({
      sql: 'INSERT INTO usuarios (nombre, email, edad) VALUES (?, ?, ?)',
      args: [nombre, email, edad]
    });
    
    res.status(201).json({
      mensaje: 'Usuario creado exitosamente',
      id: result.lastInsertRowid
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Actualizar un usuario
export const actualizarUsuario = async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, email, edad } = req.body;
    
    const result = await client.execute({
      sql: 'UPDATE usuarios SET nombre = ?, email = ?, edad = ? WHERE id = ?',
      args: [nombre, email, edad, id]
    });
    
    if (result.rowsAffected === 0) {
      return res.status(404).json({ mensaje: 'Usuario no encontrado' });
    }
    
    res.json({ mensaje: 'Usuario actualizado exitosamente' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Eliminar un usuario
export const eliminarUsuario = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await client.execute({
      sql: 'DELETE FROM usuarios WHERE id = ?',
      args: [id]
    });
    
    if (result.rowsAffected === 0) {
      return res.status(404).json({ mensaje: 'Usuario no encontrado' });
    }
    
    res.json({ mensaje: 'Usuario eliminado exitosamente' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}; 