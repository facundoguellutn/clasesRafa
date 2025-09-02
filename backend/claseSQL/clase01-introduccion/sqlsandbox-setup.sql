-- 🎬 BASE DE DATOS DE PELÍCULAS - CLASE 1
-- Copiá y pegá este código completo en sqlsandbox.com

-- Crear la tabla de películas
CREATE TABLE peliculas (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    año INTEGER,
    genero TEXT,
    calificacion REAL,
    director TEXT
);

-- Insertar datos de ejemplo para practicar
INSERT INTO peliculas (id, titulo, año, genero, calificacion, director) VALUES 
(1, 'El Padrino', 1972, 'Drama', 9.2, 'Francis Ford Coppola'),
(2, 'Pulp Fiction', 1994, 'Crime', 8.9, 'Quentin Tarantino'),
(3, 'Forrest Gump', 1994, 'Drama', 8.8, 'Robert Zemeckis'),
(4, 'El Señor de los Anillos', 2001, 'Fantasy', 8.8, 'Peter Jackson'),
(5, 'Matrix', 1999, 'Sci-Fi', 8.7, 'Lana Wachowski'),
(6, 'Goodfellas', 1990, 'Crime', 8.7, 'Martin Scorsese'),
(7, 'Titanic', 1997, 'Romance', 7.8, 'James Cameron'),
(8, 'Avatar', 2009, 'Sci-Fi', 7.8, 'James Cameron'),
(9, 'Inception', 2010, 'Sci-Fi', 8.8, 'Christopher Nolan'),
(10, 'Interstellar', 2014, 'Sci-Fi', 8.6, 'Christopher Nolan');

-- Consulta básica para verificar que funciona
SELECT * FROM peliculas;