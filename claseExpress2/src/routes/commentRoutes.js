import express from 'express';
import {
  getComentariosUsuario,
  crearComentario,
  actualizarComentario,
  eliminarComentario
} from '../controllers/commentController.js';

const router = express.Router({ mergeParams: true });

// Rutas de comentarios
router.get('/', getComentariosUsuario);
router.post('/', crearComentario);
router.put('/:comentarioId', actualizarComentario);
router.delete('/:comentarioId', eliminarComentario);

export default router; 