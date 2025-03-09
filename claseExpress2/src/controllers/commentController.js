import { client } from '../config/db.js';

// Obtener comentarios de un usuario
export const getComentariosUsuario = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await client.execute({
      sql: `
        SELECT c.*, u.nombre as nombre_usuario 
        FROM comentarios c
        JOIN usuarios u ON c.usuario_id = u.id
        WHERE c.usuario_id = ?
        ORDER BY c.fecha DESC
      `,
      args: [id]
    });
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Crear un nuevo comentario
export const crearComentario = async (req, res) => {
  try {
    const { id } = req.params;
    const { contenido } = req.body;

    // Verificar que el usuario existe
    const usuario = await client.execute({
      sql: 'SELECT id FROM usuarios WHERE id = ?',
      args: [id]
    });

    if (usuario.rows.length === 0) {
      return res.status(404).json({ mensaje: 'Usuario no encontrado' });
    }

    const result = await client.execute({
      sql: 'INSERT INTO comentarios (contenido, usuario_id) VALUES (?, ?)',
      args: [contenido, id]
    });

    res.status(201).json({
      mensaje: 'Comentario creado exitosamente',
      id: result.lastInsertRowid
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Actualizar un comentario
export const actualizarComentario = async (req, res) => {
  try {
    const { id, comentarioId } = req.params;
    const { contenido } = req.body;

    const result = await client.execute({
      sql: `
        UPDATE comentarios 
        SET contenido = ? 
        WHERE id = ? AND usuario_id = ?
      `,
      args: [contenido, comentarioId, id]
    });

    if (result.rowsAffected === 0) {
      return res.status(404).json({ mensaje: 'Comentario no encontrado' });
    }

    res.json({ mensaje: 'Comentario actualizado exitosamente' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Eliminar un comentario
export const eliminarComentario = async (req, res) => {
  try {
    const { id, comentarioId } = req.params;

    const result = await client.execute({
      sql: 'DELETE FROM comentarios WHERE id = ? AND usuario_id = ?',
      args: [comentarioId, id]
    });

    if (result.rowsAffected === 0) {
      return res.status(404).json({ mensaje: 'Comentario no encontrado' });
    }

    res.json({ mensaje: 'Comentario eliminado exitosamente' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}; 