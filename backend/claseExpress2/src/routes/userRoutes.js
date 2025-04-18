import express from 'express';
import {
  getUsuarios,
  getUsuarioById,
  buscarUsuariosPorNombre,
  crearUsuario,
  actualizarUsuario,
  eliminarUsuario
} from '../controllers/userController.js';
import commentRoutes from './commentRoutes.js';

const router = express.Router();

// Middleware para comentarios
router.use('/:id/comentarios', commentRoutes);

// Rutas de usuarios
router.get('/', getUsuarios);
router.get('/buscar/:nombre', buscarUsuariosPorNombre);
router.get('/:id', getUsuarioById);
router.post('/', crearUsuario);
router.put('/:id', actualizarUsuario);
router.delete('/:id', eliminarUsuario);

export default router; 