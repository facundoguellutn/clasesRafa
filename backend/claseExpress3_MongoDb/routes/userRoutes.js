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
    console.log("Obteniendo todos los usuarios");
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

// Incrementar edad de todos los usuarios
router.put("/incrementarEdadUsuarios", async (req, res) => {
  try {
    const result = await User.updateMany(
      {}, // Filtro vacío para seleccionar todos los usuarios
      { $inc: { edad: 1 } } // Incrementar la edad en 1
    );
    res.json({ 
      message: `Se incrementó la edad de ${result.modifiedCount} usuarios` 
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;

//sumarle 1 a la edad de todos los usuarios
