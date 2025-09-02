-- 🏐 BASE DE DATOS DE JUGADORES DE VOLLEY - CLASE 2
-- Copiá y pegá este código completo en sqlsandbox.com

-- Crear la tabla de jugadores de volley
CREATE TABLE jugadores_volley (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    posicion TEXT,
    altura INTEGER, -- en centímetros
    peso REAL,      -- en kilogramos  
    puntos_temporada INTEGER,
    edad INTEGER,
    años_experiencia INTEGER
);

-- Insertar datos de ejemplo para practicar filtros y ordenamiento
INSERT INTO jugadores_volley VALUES 
(1, 'Juan Pérez', 'Opuesto', 195, 85.5, 240, 24, 5),
(2, 'María García', 'Libero', 165, 60.0, 180, 22, 3),
(3, 'Carlos López', 'Central', 205, 95.2, 190, 26, 7),
(4, 'Ana Martínez', 'Armador', 170, 62.5, 220, 23, 4),
(5, 'Roberto Silva', 'Punta', 188, 78.0, 210, 25, 6),
(6, 'Laura Rodríguez', 'Opuesto', 182, 68.5, 260, 24, 5),
(7, 'Diego Fernández', 'Central', 202, 92.0, 185, 27, 8),
(8, 'Sofía González', 'Libero', 163, 58.5, 170, 21, 2),
(9, 'Andrés Ruiz', 'Punta', 190, 82.0, 225, 25, 6),
(10, 'Valentina Torres', 'Armador', 168, 61.0, 195, 22, 3),
(11, 'Martín Jiménez', 'Central', 198, 89.0, 175, 28, 9),
(12, 'Camila Vargas', 'Punta', 175, 65.0, 205, 23, 4),
(13, 'Fernando Castro', 'Opuesto', 192, 83.5, 285, 26, 7),
(14, 'Lucía Morales', 'Libero', 160, 57.0, 165, 20, 1),
(15, 'Pablo Herrera', 'Armador', 174, 70.5, 200, 24, 5);

-- Consulta básica para verificar que funciona
SELECT * FROM jugadores_volley;