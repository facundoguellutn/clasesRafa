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