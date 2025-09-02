-- 📚 SISTEMA DE BIBLIOTECA PERSONAL - CLASE 5
-- Copiá y pegá este código completo en sqlsandbox.com
-- Este es un proyecto de consolidación que integra todos los conceptos aprendidos

-- 1. CREAR TABLAS DEL SISTEMA

-- Tabla de géneros literarios
CREATE TABLE generos (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    descripcion TEXT
);

-- Tabla de autores
CREATE TABLE autores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    nacionalidad TEXT,
    fecha_nacimiento DATE,
    biografia TEXT,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion DATE DEFAULT CURRENT_DATE
);

-- Tabla principal de libros
CREATE TABLE libros (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    isbn TEXT UNIQUE,
    año_publicacion INTEGER CHECK (año_publicacion >= 1000 AND año_publicacion <= 2030),
    paginas INTEGER CHECK (paginas > 0),
    idioma TEXT DEFAULT 'Español',
    genero_id INTEGER,
    precio REAL CHECK (precio >= 0),
    fecha_adquisicion DATE DEFAULT CURRENT_DATE,
    
    -- Estado de lectura
    leido BOOLEAN DEFAULT FALSE,
    fecha_lectura DATE,
    calificacion INTEGER CHECK (calificacion >= 1 AND calificacion <= 10),
    notas TEXT,
    
    -- Metadatos
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (genero_id) REFERENCES generos(id)
);

-- Tabla de relación muchos a muchos (libros ↔ autores)
CREATE TABLE libros_autores (
    id INTEGER PRIMARY KEY,
    libro_id INTEGER NOT NULL,
    autor_id INTEGER NOT NULL,
    rol TEXT DEFAULT 'Autor',
    FOREIGN KEY (libro_id) REFERENCES libros(id),
    FOREIGN KEY (autor_id) REFERENCES autores(id),
    UNIQUE(libro_id, autor_id, rol)
);

-- 2. INSERTAR DATOS MAESTROS

-- Géneros literarios básicos
INSERT INTO generos (nombre, descripcion) VALUES 
('Ficción', 'Narrativa de historias imaginarias'),
('No Ficción', 'Textos basados en hechos reales'),
('Ciencia Ficción', 'Literatura especulativa y futurista'),
('Fantasía', 'Mundos imaginarios con elementos mágicos'),
('Misterio', 'Novelas de suspenso e investigación'),
('Romance', 'Historias centradas en relaciones amorosas'),
('Biografía', 'Relatos de vidas reales'),
('Historia', 'Textos sobre eventos históricos'),
('Tecnología', 'Libros sobre informática y programación'),
('Autoayuda', 'Libros de desarrollo personal');

-- Autores reconocidos
INSERT INTO autores (nombre, apellido, nacionalidad, fecha_nacimiento, biografia) VALUES 
('Gabriel', 'García Márquez', 'Colombiana', '1927-03-06', 'Premio Nobel de Literatura, maestro del realismo mágico'),
('Isabel', 'Allende', 'Chilena', '1942-08-02', 'Una de las escritoras más leídas del mundo en español'),
('Jorge Luis', 'Borges', 'Argentina', '1899-08-24', 'Escritor y poeta, maestro de la literatura fantástica'),
('George', 'Orwell', 'Británica', '1903-06-25', 'Autor de 1984 y Rebelión en la granja'),
('J.K.', 'Rowling', 'Británica', '1965-07-31', 'Creadora de la saga Harry Potter'),
('Stephen', 'King', 'Estadounidense', '1947-09-21', 'Maestro del horror y suspenso contemporáneo'),
('Agatha', 'Christie', 'Británica', '1890-09-15', 'La reina del misterio, creadora de Hercule Poirot'),
('Dan', 'Brown', 'Estadounidense', '1964-06-22', 'Autor de El Código Da Vinci y thrillers históricos'),
('Paulo', 'Coelho', 'Brasileña', '1947-08-24', 'Autor de El Alquimista y literatura espiritual'),
('Yuval Noah', 'Harari', 'Israelí', '1976-02-24', 'Historiador, autor de Sapiens y Homo Deus'),
('Robert', 'Martin', 'Estadounidense', '1952-12-05', 'Ingeniero de software, autor de Clean Code'),
('Octavio', 'Paz', 'Mexicana', '1914-03-31', 'Poeta y ensayista, Premio Nobel de Literatura');

-- 3. INSERTAR COLECCIÓN DE LIBROS

-- Libros populares y variados
INSERT INTO libros (titulo, isbn, año_publicacion, paginas, genero_id, precio, leido, fecha_lectura, calificacion, notas) VALUES 
('Cien años de soledad', '978-0307474728', 1967, 417, 1, 2500.00, TRUE, '2023-06-15', 10, 'Obra maestra del realismo mágico. Imprescindible.'),
('1984', '978-0451524935', 1949, 328, 3, 2200.00, TRUE, '2023-08-20', 9, 'Profético y aterrador. Muy relevante hoy en día.'),
('Harry Potter y la Piedra Filosofal', '978-0439708180', 1997, 309, 4, 3000.00, TRUE, '2023-12-10', 9, 'Inicio perfecto de una saga memorable.'),
('El Código Da Vinci', '978-0307474278', 2003, 689, 5, 2800.00, TRUE, '2023-09-05', 8, 'Entretenido thriller con historia del arte.'),
('El Alquimista', '978-0061122415', 1988, 163, 1, 1800.00, TRUE, '2023-11-12', 7, 'Inspirador pero algo repetitivo.'),
('Sapiens: De animales a dioses', '978-8499926223', 2011, 496, 8, 4200.00, FALSE, NULL, NULL, NULL),
('La casa de los espíritus', '978-8497592598', 1982, 433, 1, 3200.00, FALSE, NULL, NULL, NULL),
('El laberinto de la soledad', '978-9681607357', 1950, 351, 2, 2100.00, FALSE, NULL, NULL, NULL),
('It (Eso)', '978-1501142970', 1986, 1138, 5, 3500.00, TRUE, '2023-10-31', 8, 'Horror magistral, aunque algo extenso.'),
('Asesinato en el Orient Express', '978-0062693662', 1934, 256, 5, 1900.00, TRUE, '2023-07-22', 9, 'Misterio clásico perfecto.'),
('Clean Code', '978-0132350884', 2008, 464, 9, 4500.00, FALSE, NULL, NULL, NULL),
('Laberinto de los Espíritus', '978-8408207505', 2016, 848, 1, 3800.00, FALSE, NULL, NULL, NULL);

-- 4. RELACIONAR LIBROS CON AUTORES

INSERT INTO libros_autores (libro_id, autor_id, rol) VALUES 
(1, 1, 'Autor'),        -- Cien años de soledad - García Márquez
(2, 4, 'Autor'),        -- 1984 - George Orwell
(3, 5, 'Autor'),        -- Harry Potter - J.K. Rowling
(4, 8, 'Autor'),        -- El Código Da Vinci - Dan Brown
(5, 9, 'Autor'),        -- El Alquimista - Paulo Coelho
(6, 10, 'Autor'),       -- Sapiens - Yuval Noah Harari
(7, 2, 'Autor'),        -- La casa de los espíritus - Isabel Allende
(8, 12, 'Autor'),       -- El laberinto de la soledad - Octavio Paz
(9, 6, 'Autor'),        -- It - Stephen King
(10, 7, 'Autor'),       -- Asesinato en el Orient Express - Agatha Christie
(11, 11, 'Autor'),      -- Clean Code - Robert Martin
(12, 1, 'Autor');       -- Laberinto de los Espíritus - García Márquez (ejemplo)

-- 5. CONSULTA INICIAL PARA VERIFICAR

-- Ver resumen de la biblioteca
SELECT 
    'BIBLIOTECA CREADA EXITOSAMENTE' as resultado,
    COUNT(DISTINCT l.id) as total_libros,
    COUNT(DISTINCT a.id) as total_autores,
    COUNT(DISTINCT g.id) as total_generos
FROM libros l
CROSS JOIN autores a  
CROSS JOIN generos g;