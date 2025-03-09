import { createClient } from "@libsql/client";
import dotenv from 'dotenv';

// Cargar variables de entorno
dotenv.config();

const client = createClient({
  url: process.env.DB_URL,
  syncUrl: process.env.DB_SYNC_URL,
  authToken: process.env.DB_AUTH_TOKEN,
});

// Crear las tablas si no existen
const initDB = async () => {
  try {
    // Crear tabla de usuarios
    await client.execute(`
      CREATE TABLE IF NOT EXISTS usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        edad INTEGER
      );
    `);

    // Crear tabla de comentarios
    await client.execute(`
      CREATE TABLE IF NOT EXISTS comentarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contenido TEXT NOT NULL,
        fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
        usuario_id INTEGER,
        FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
      );
    `);
    
    console.log('Base de datos inicializada correctamente');
  } catch (error) {
    console.error('Error al inicializar la base de datos:', error);
  }
};

export { client, initDB }; 