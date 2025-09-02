-- 🏗️ NORMALIZACIÓN Y DISEÑO DE SCHEMAS - CLASE 11
-- Copiá y pegá este código completo en sqlsandbox.com
-- Sistema de biblioteca para practicar normalización

-- 1. EJEMPLO INICIAL: TABLA SIN NORMALIZAR (PROBLEMAS)

-- Tabla con problemas de diseño (solo para demostrar problemas)
CREATE TABLE prestamos_sin_normalizar (
    id INTEGER PRIMARY KEY,
    libro_titulo TEXT,
    libro_isbn TEXT,
    autor_nombre TEXT,
    autor_nacionalidad TEXT,
    autor_nacimiento DATE,
    genero_nombre TEXT,
    usuario_nombre TEXT,
    usuario_email TEXT,
    usuario_telefono TEXT,
    usuario_ciudad TEXT,
    fecha_prestamo DATE,
    fecha_devolucion_esperada DATE,
    fecha_devolucion_real DATE,
    multa REAL DEFAULT 0.0
);

-- Datos problemáticos (redundancia evidente)
INSERT INTO prestamos_sin_normalizar VALUES 
(1, 'Cien años de soledad', '978-84-376-0494-7', 'Gabriel García Márquez', 'Colombiana', '1927-03-06', 'Novela', 'Ana García', 'ana.garcia@email.com', '11-1234-5678', 'Buenos Aires', '2024-01-15', '2024-01-29', '2024-01-28', 0.0),
(2, 'El Quijote', '978-84-376-0495-4', 'Miguel de Cervantes', 'Española', '1547-09-29', 'Novela', 'Ana García', 'ana.garcia@email.com', '11-1234-5678', 'Buenos Aires', '2024-02-01', '2024-02-15', NULL, 0.0),
(3, 'Cien años de soledad', '978-84-376-0494-7', 'Gabriel García Márquez', 'Colombiana', '1927-03-06', 'Novela', 'Carlos López', 'carlos.lopez@email.com', '351-987-6543', 'Córdoba', '2024-02-10', '2024-02-24', NULL, 0.0),
(4, 'El amor en los tiempos del cólera', '978-84-376-0496-1', 'Gabriel García Márquez', 'Colombiana', '1927-03-06', 'Novela', 'Ana García', 'ana.garcia@email.com', '11-1234-5678', 'Buenos Aires', '2024-02-15', '2024-03-01', NULL, 0.0);

-- Consulta para ver los problemas
SELECT 'PROBLEMAS EN TABLA SIN NORMALIZAR:' as observacion;
SELECT 
    'Redundancia de datos' as problema,
    COUNT(*) as veces_repetido,
    'Gabriel García Márquez aparece ' || COUNT(*) || ' veces con toda su info' as ejemplo
FROM prestamos_sin_normalizar 
WHERE autor_nombre = 'Gabriel García Márquez';

-- 2. DISEÑO NORMALIZADO (SOLUCIÓN)

-- Países y ciudades (para evitar inconsistencias)
CREATE TABLE paises (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    codigo TEXT UNIQUE NOT NULL
);

CREATE TABLE ciudades (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    pais_id INTEGER,
    FOREIGN KEY (pais_id) REFERENCES paises(id)
);

-- Autores (información única por autor)
CREATE TABLE autores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    nacionalidad TEXT,
    fecha_nacimiento DATE,
    biografia TEXT,
    activo BOOLEAN DEFAULT TRUE
);

-- Géneros literarios
CREATE TABLE generos (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    descripcion TEXT
);

-- Editorial (para información adicional de libros)
CREATE TABLE editoriales (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    pais_id INTEGER,
    fundacion INTEGER,
    FOREIGN KEY (pais_id) REFERENCES paises(id)
);

-- Libros (información única por libro)
CREATE TABLE libros (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    isbn TEXT UNIQUE,
    autor_id INTEGER NOT NULL,
    genero_id INTEGER,
    editorial_id INTEGER,
    fecha_publicacion DATE,
    paginas INTEGER,
    disponible BOOLEAN DEFAULT TRUE,
    precio_reposicion REAL,
    FOREIGN KEY (autor_id) REFERENCES autores(id),
    FOREIGN KEY (genero_id) REFERENCES generos(id),
    FOREIGN KEY (editorial_id) REFERENCES editoriales(id)
);

-- Usuarios (información única por usuario)
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    telefono TEXT,
    ciudad_id INTEGER,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (ciudad_id) REFERENCES ciudades(id)
);

-- Préstamos (transacciones)
CREATE TABLE prestamos (
    id INTEGER PRIMARY KEY,
    libro_id INTEGER NOT NULL,
    usuario_id INTEGER NOT NULL,
    fecha_prestamo DATE DEFAULT CURRENT_DATE,
    fecha_devolucion_esperada DATE NOT NULL,
    fecha_devolucion_real DATE,
    multa REAL DEFAULT 0.0,
    estado TEXT DEFAULT 'activo' CHECK (estado IN ('activo', 'devuelto', 'vencido', 'perdido')),
    observaciones TEXT,
    FOREIGN KEY (libro_id) REFERENCES libros(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- 3. ÍNDICES PARA OPTIMIZACIÓN

CREATE INDEX idx_libros_autor ON libros(autor_id);
CREATE INDEX idx_libros_genero ON libros(genero_id);
CREATE INDEX idx_libros_disponible ON libros(disponible);
CREATE INDEX idx_prestamos_usuario ON prestamos(usuario_id);
CREATE INDEX idx_prestamos_libro ON prestamos(libro_id);
CREATE INDEX idx_prestamos_estado ON prestamos(estado);
CREATE INDEX idx_prestamos_fecha ON prestamos(fecha_prestamo);
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_usuarios_activo ON usuarios(activo);

-- 4. INSERTAR DATOS NORMALIZADOS

-- Países
INSERT INTO paises (nombre, codigo) VALUES 
('Argentina', 'AR'),
('Colombia', 'CO'),
('España', 'ES'),
('México', 'MX'),
('Chile', 'CL'),
('Brasil', 'BR');

-- Ciudades
INSERT INTO ciudades (nombre, pais_id) VALUES 
-- Argentina
('Buenos Aires', 1),
('Córdoba', 1),
('Rosario', 1),
('Mendoza', 1),
-- Colombia  
('Bogotá', 2),
('Medellín', 2),
('Cartagena', 2),
-- España
('Madrid', 3),
('Barcelona', 3),
('Valencia', 3);

-- Géneros
INSERT INTO generos (nombre, descripcion) VALUES 
('Novela', 'Narrativa de ficción extensa'),
('Ensayo', 'Texto reflexivo sobre diversos temas'),
('Poesía', 'Expresión artística en verso'),
('Teatro', 'Obras para representación escénica'),
('Ciencia Ficción', 'Narrativa basada en avances científicos'),
('Biografía', 'Relato de la vida de una persona'),
('Historia', 'Narrativa de hechos históricos'),
('Filosofía', 'Textos sobre pensamiento filosófico');

-- Editoriales
INSERT INTO editoriales (nombre, pais_id, fundacion) VALUES 
('Sudamericana', 1, 1939),
('Planeta', 3, 1949),
('Alfaguara', 3, 1964),
('Anagrama', 3, 1969),
('Tusquets', 3, 1969),
('Fondo de Cultura Económica', 4, 1934);

-- Autores
INSERT INTO autores (nombre, nacionalidad, fecha_nacimiento) VALUES 
('Gabriel García Márquez', 'Colombiana', '1927-03-06'),
('Miguel de Cervantes', 'Española', '1547-09-29'),
('Jorge Luis Borges', 'Argentina', '1899-08-24'),
('Julio Cortázar', 'Argentina', '1914-08-26'),
('Isabel Allende', 'Chilena', '1942-08-02'),
('Mario Vargas Llosa', 'Peruana', '1936-03-28'),
('Octavio Paz', 'Mexicana', '1914-03-31'),
('Roberto Bolaño', 'Chilena', '1953-04-28');

-- Libros
INSERT INTO libros (titulo, isbn, autor_id, genero_id, editorial_id, fecha_publicacion, paginas, precio_reposicion) VALUES 
-- Gabriel García Márquez
('Cien años de soledad', '978-84-376-0494-7', 1, 1, 3, '1967-06-05', 471, 8500.00),
('El amor en los tiempos del cólera', '978-84-376-0496-1', 1, 1, 3, '1985-12-05', 348, 7200.00),
('Crónica de una muerte anunciada', '978-84-376-0497-8', 1, 1, 3, '1981-04-07', 122, 5800.00),

-- Miguel de Cervantes
('Don Quijote de la Mancha', '978-84-376-0495-4', 2, 1, 2, '1605-01-16', 863, 12000.00),
('Las novelas ejemplares', '978-84-376-0498-5', 2, 1, 2, '1613-01-01', 425, 9500.00),

-- Jorge Luis Borges
('Ficciones', '978-84-376-0499-2', 3, 1, 1, '1944-01-01', 174, 6800.00),
('El Aleph', '978-84-376-0500-5', 3, 1, 1, '1949-01-01', 152, 6500.00),
('Laberintos', '978-84-376-0501-2', 3, 1, 4, '1962-01-01', 268, 7800.00),

-- Julio Cortázar
('Rayuela', '978-84-376-0502-9', 4, 1, 1, '1963-06-28', 635, 9800.00),
('Historias de cronopios y de famas', '978-84-376-0503-6', 4, 1, 4, '1962-01-01', 136, 5200.00),

-- Isabel Allende
('La casa de los espíritus', '978-84-376-0504-3', 5, 1, 2, '1982-01-01', 433, 8900.00),
('De amor y de sombra', '978-84-376-0505-0', 5, 1, 2, '1984-01-01', 276, 7600.00),

-- Mario Vargas Llosa
('La ciudad y los perros', '978-84-376-0506-7', 6, 1, 6, '1963-01-01', 423, 8700.00),
('Conversación en la catedral', '978-84-376-0507-4', 6, 1, 6, '1969-01-01', 731, 11200.00),

-- Roberto Bolaño
('Los detectives salvajes', '978-84-376-0508-1', 8, 1, 4, '1998-01-01', 609, 10500.00);

-- Usuarios
INSERT INTO usuarios (nombre, email, telefono, ciudad_id) VALUES 
('Ana García', 'ana.garcia@email.com', '11-1234-5678', 1),
('Carlos López', 'carlos.lopez@email.com', '351-987-6543', 2),
('María Rodríguez', 'maria.rodriguez@email.com', '341-555-1234', 3),
('Juan Pérez', 'juan.perez@email.com', '11-9876-5432', 1),
('Laura Silva', 'laura.silva@email.com', '261-444-7788', 4),
('Roberto Torres', 'roberto.torres@email.com', '11-3333-9999', 1),
('Sofía Morales', 'sofia.morales@email.com', '351-111-2222', 2),
('Diego Vega', 'diego.vega@email.com', '11-666-3333', 1),
('Valentina Castro', 'valentina.castro@email.com', '341-777-4444', 3),
('Paulo Santos', 'paulo.santos@email.com', '11-888-5555', 1);

-- Préstamos (replicando los datos originales pero normalizados)
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado) VALUES 
-- Ana García
(1, 1, '2024-01-15', '2024-01-29', '2024-01-28', 'devuelto'),     -- Cien años de soledad
(4, 1, '2024-02-01', '2024-02-15', NULL, 'activo'),              -- Don Quijote
(2, 1, '2024-02-15', '2024-03-01', NULL, 'activo'),              -- El amor en los tiempos del cólera

-- Carlos López  
(1, 2, '2024-02-10', '2024-02-24', NULL, 'vencido'),             -- Cien años de soledad
(6, 2, '2024-01-20', '2024-02-03', '2024-02-01', 'devuelto'),    -- Ficciones
(9, 2, '2024-02-05', '2024-02-19', NULL, 'activo'),              -- Rayuela

-- María Rodríguez
(11, 3, '2024-01-10', '2024-01-24', '2024-01-23', 'devuelto'),   -- La casa de los espíritus
(13, 3, '2024-02-01', '2024-02-15', NULL, 'activo'),             -- La ciudad y los perros

-- Juan Pérez
(7, 4, '2024-01-25', '2024-02-08', '2024-02-07', 'devuelto'),    -- El Aleph
(15, 4, '2024-02-12', '2024-02-26', NULL, 'activo'),             -- Los detectives salvajes

-- Laura Silva
(10, 5, '2024-01-18', '2024-02-01', NULL, 'vencido'),            -- Historias de cronopios
(12, 5, '2024-02-08', '2024-02-22', NULL, 'activo'),             -- De amor y de sombra

-- Préstamos adicionales para análisis
(3, 6, '2024-01-30', '2024-02-13', '2024-02-12', 'devuelto'),    -- Crónica de una muerte anunciada
(8, 7, '2024-02-03', '2024-02-17', NULL, 'activo'),              -- Laberintos
(14, 8, '2024-02-06', '2024-02-20', NULL, 'activo'),             -- Conversación en la catedral
(5, 9, '2024-01-28', '2024-02-11', '2024-02-10', 'devuelto'),    -- Las novelas ejemplares
(4, 10, '2024-02-14', '2024-02-28', NULL, 'activo');             -- Don Quijote

-- 5. VISTA DESNORMALIZADA PARA CONSULTAS FRECUENTES

CREATE VIEW vista_prestamos_completa AS
SELECT 
    p.id as prestamo_id,
    l.titulo,
    l.isbn,
    a.nombre as autor,
    g.nombre as genero,
    u.nombre as usuario,
    u.email as usuario_email,
    c.nombre as ciudad_usuario,
    pa.nombre as pais_usuario,
    p.fecha_prestamo,
    p.fecha_devolucion_esperada,
    p.fecha_devolucion_real,
    p.estado,
    p.multa,
    CASE 
        WHEN p.fecha_devolucion_real IS NULL AND p.fecha_devolucion_esperada < date('now')
        THEN 'VENCIDO'
        WHEN p.fecha_devolucion_real IS NULL
        THEN 'ACTIVO'
        ELSE 'DEVUELTO'
    END as estado_calculado,
    CASE 
        WHEN p.fecha_devolucion_real IS NULL AND p.fecha_devolucion_esperada < date('now')
        THEN julianday('now') - julianday(p.fecha_devolucion_esperada)
        ELSE 0
    END as dias_vencido
FROM prestamos p
JOIN libros l ON p.libro_id = l.id
JOIN autores a ON l.autor_id = a.id
LEFT JOIN generos g ON l.genero_id = g.id
JOIN usuarios u ON p.usuario_id = u.id
JOIN ciudades c ON u.ciudad_id = c.id
JOIN paises pa ON c.pais_id = pa.id;

-- 6. CONSULTAS DE VERIFICACIÓN Y ANÁLISIS

SELECT 'SISTEMA NORMALIZADO CREADO EXITOSAMENTE' as resultado;

-- Comparar con sistema sin normalizar
SELECT 
    'COMPARACIÓN DE REDUNDANCIA:' as analisis,
    '' as separador;

-- Datos únicos en sistema normalizado
SELECT 
    'Autores únicos' as tipo,
    COUNT(*) as cantidad
FROM autores
UNION ALL
SELECT 
    'Libros únicos' as tipo,
    COUNT(*) as cantidad
FROM libros  
UNION ALL
SELECT 
    'Usuarios únicos' as tipo,
    COUNT(*) as cantidad
FROM usuarios
UNION ALL
SELECT 
    'Préstamos totales' as tipo,
    COUNT(*) as cantidad
FROM prestamos;

-- Vista simplificada para consultas
SELECT 'CONSULTA SIMPLIFICADA CON VISTA:' as ejemplo;
SELECT 
    usuario,
    titulo,
    autor,
    fecha_prestamo,
    estado_calculado,
    dias_vencido
FROM vista_prestamos_completa
WHERE estado_calculado IN ('ACTIVO', 'VENCIDO')
ORDER BY dias_vencido DESC, fecha_prestamo;

-- Análisis por autor más prestado
SELECT 'ANÁLISIS: AUTORES MÁS PRESTADOS' as reporte;
SELECT 
    a.nombre as autor,
    COUNT(p.id) as total_prestamos,
    COUNT(CASE WHEN p.estado = 'devuelto' THEN 1 END) as devueltos,
    COUNT(CASE WHEN p.estado = 'activo' THEN 1 END) as activos,
    COUNT(CASE WHEN p.estado = 'vencido' THEN 1 END) as vencidos
FROM autores a
JOIN libros l ON a.id = l.autor_id
JOIN prestamos p ON l.id = p.libro_id
GROUP BY a.id, a.nombre
ORDER BY total_prestamos DESC;