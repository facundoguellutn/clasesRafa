-- 🏫 SISTEMA DE E-LEARNING COMPLETO - CLASE 6
-- Copiá y pegá este código completo en sqlsandbox.com
-- Sistema para practicar claves primarias, foráneas e índices

-- 1. CREAR TABLAS CON RELACIONES

-- Tabla principal de usuarios
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    rol TEXT CHECK (rol IN ('estudiante', 'instructor', 'admin')) DEFAULT 'estudiante',
    activo BOOLEAN DEFAULT TRUE,
    fecha_registro DATE DEFAULT CURRENT_DATE
);

-- Tabla de cursos (1:N con usuarios - instructor)
CREATE TABLE cursos (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    descripcion TEXT,
    instructor_id INTEGER NOT NULL,
    precio REAL CHECK (precio >= 0),
    duracion_horas INTEGER,
    nivel TEXT CHECK (nivel IN ('Principiante', 'Intermedio', 'Avanzado')) DEFAULT 'Principiante',
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (instructor_id) REFERENCES usuarios(id)
);

-- Tabla de lecciones (1:N con cursos)
CREATE TABLE lecciones (
    id INTEGER PRIMARY KEY,
    curso_id INTEGER NOT NULL,
    titulo TEXT NOT NULL,
    contenido TEXT,
    video_url TEXT,
    orden INTEGER NOT NULL,
    duracion_minutos INTEGER,
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);

-- Tabla de inscripciones (N:M entre usuarios y cursos)
CREATE TABLE inscripciones (
    id INTEGER PRIMARY KEY,
    estudiante_id INTEGER NOT NULL,
    curso_id INTEGER NOT NULL,
    fecha_inscripcion DATE DEFAULT CURRENT_DATE,
    fecha_completado DATE,
    progreso INTEGER DEFAULT 0 CHECK (progreso >= 0 AND progreso <= 100),
    calificacion INTEGER CHECK (calificacion >= 1 AND calificacion <= 10),
    FOREIGN KEY (estudiante_id) REFERENCES usuarios(id),
    FOREIGN KEY (curso_id) REFERENCES cursos(id),
    UNIQUE(estudiante_id, curso_id)
);

-- 2. CREAR ÍNDICES ESTRATÉGICOS

CREATE INDEX idx_cursos_instructor ON cursos(instructor_id);
CREATE INDEX idx_cursos_activo ON cursos(activo);
CREATE INDEX idx_cursos_nivel ON cursos(nivel);
CREATE INDEX idx_lecciones_curso ON lecciones(curso_id);
CREATE INDEX idx_lecciones_orden ON lecciones(curso_id, orden);
CREATE INDEX idx_inscripciones_estudiante ON inscripciones(estudiante_id);
CREATE INDEX idx_inscripciones_curso ON inscripciones(curso_id);
CREATE INDEX idx_inscripciones_progreso ON inscripciones(progreso);

-- 3. INSERTAR DATOS DE EJEMPLO

-- Usuarios (instructores y estudiantes)
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES 
-- Instructores
('juan.dev@email.com', 'Juan', 'Martínez', 'instructor'),
('maria.frontend@email.com', 'María', 'García', 'instructor'),
('carlos.backend@email.com', 'Carlos', 'López', 'instructor'),
('ana.fullstack@email.com', 'Ana', 'Rodríguez', 'instructor'),

-- Estudiantes
('estudiante1@email.com', 'Pedro', 'González', 'estudiante'),
('estudiante2@email.com', 'Laura', 'Silva', 'estudiante'),
('estudiante3@email.com', 'Diego', 'Torres', 'estudiante'),
('estudiante4@email.com', 'Sofia', 'Morales', 'estudiante'),
('estudiante5@email.com', 'Roberto', 'Vega', 'estudiante'),
('estudiante6@email.com', 'Valentina', 'Castro', 'estudiante'),

-- Admin
('admin@plataforma.com', 'Admin', 'Sistema', 'admin');

-- Cursos con diferentes instructores
INSERT INTO cursos (titulo, descripcion, instructor_id, precio, duracion_horas, nivel) VALUES 
('JavaScript Moderno', 'Aprende JavaScript desde cero hasta conceptos avanzados', 1, 4500.00, 40, 'Principiante'),
('React.js Completo', 'Desarrollo de aplicaciones web con React y hooks', 2, 6000.00, 50, 'Intermedio'),
('Node.js y Express', 'Backend development con JavaScript', 3, 5500.00, 45, 'Intermedio'),
('Full Stack Development', 'Desarrollo completo frontend y backend', 4, 8500.00, 80, 'Avanzado'),
('CSS y Tailwind', 'Estilos modernos para web', 2, 3500.00, 25, 'Principiante'),
('MongoDB y Base de Datos', 'Bases de datos NoSQL para desarrolladores', 3, 4000.00, 30, 'Intermedio'),
('Next.js Avanzado', 'Framework moderno de React para producción', 1, 7000.00, 60, 'Avanzado'),
('TypeScript para Developers', 'JavaScript tipado para proyectos escalables', 4, 5000.00, 35, 'Intermedio');

-- Lecciones para algunos cursos
INSERT INTO lecciones (curso_id, titulo, contenido, orden, duracion_minutos) VALUES 
-- Lecciones para JavaScript Moderno (curso_id = 1)
(1, 'Introducción a JavaScript', 'Variables, tipos de datos y operadores básicos', 1, 45),
(1, 'Funciones y Scope', 'Declaración de funciones y alcance de variables', 2, 60),
(1, 'Arrays y Objetos', 'Estructuras de datos fundamentales en JavaScript', 3, 50),
(1, 'DOM Manipulation', 'Interacción con elementos HTML desde JavaScript', 4, 55),
(1, 'Eventos y Event Listeners', 'Manejo de eventos del usuario', 5, 40),

-- Lecciones para React.js Completo (curso_id = 2)
(2, 'Introducción a React', 'Componentes y JSX básico', 1, 50),
(2, 'Props y State', 'Pasando datos y manejo de estado', 2, 60),
(2, 'Hooks Fundamentales', 'useState y useEffect', 3, 70),
(2, 'Manejo de Formularios', 'Formularios controlados en React', 4, 45),

-- Lecciones para Node.js y Express (curso_id = 3)
(3, 'Introducción a Node.js', 'Runtime de JavaScript en el servidor', 1, 40),
(3, 'Creando un servidor con Express', 'Primer servidor HTTP', 2, 55),
(3, 'Rutas y Middleware', 'Manejo de rutas y funciones intermedias', 3, 65),
(3, 'Conexión a Base de Datos', 'Integración con MongoDB', 4, 70);

-- Inscripciones de estudiantes a cursos
INSERT INTO inscripciones (estudiante_id, curso_id, progreso, fecha_inscripcion, calificacion, fecha_completado) VALUES 
-- Estudiante 1 (Pedro)
(5, 1, 100, '2023-11-15', 9, '2023-12-20'),  -- JavaScript completado
(5, 2, 75, '2024-01-10', NULL, NULL),        -- React en progreso
(5, 5, 100, '2023-10-05', 8, '2023-11-15'),  -- CSS completado

-- Estudiante 2 (Laura)
(6, 1, 100, '2023-12-01', 10, '2024-01-15'), -- JavaScript completado
(6, 3, 60, '2024-01-20', NULL, NULL),        -- Node.js en progreso
(6, 4, 25, '2024-02-01', NULL, NULL),        -- Full Stack comenzado

-- Estudiante 3 (Diego)
(7, 2, 100, '2023-11-20', 7, '2024-01-10'),  -- React completado
(7, 6, 80, '2024-01-15', NULL, NULL),        -- MongoDB en progreso
(7, 7, 40, '2024-02-10', NULL, NULL),        -- Next.js comenzado

-- Estudiante 4 (Sofia)
(8, 1, 90, '2023-12-10', NULL, NULL),        -- JavaScript casi terminado
(8, 5, 100, '2023-11-01', 9, '2023-12-01'),  -- CSS completado

-- Estudiante 5 (Roberto)
(9, 4, 100, '2023-09-15', 8, '2024-01-30'),  -- Full Stack completado
(9, 8, 70, '2024-02-01', NULL, NULL),        -- TypeScript en progreso

-- Estudiante 6 (Valentina)
(10, 1, 50, '2024-01-25', NULL, NULL),       -- JavaScript en progreso
(10, 5, 100, '2023-12-15', 10, '2024-01-10'), -- CSS completado
(10, 2, 30, '2024-02-15', NULL, NULL);       -- React comenzado

-- 4. CONSULTA INICIAL DE VERIFICACIÓN

SELECT 
    'PLATAFORMA CREADA EXITOSAMENTE' as estado,
    (SELECT COUNT(*) FROM usuarios) as total_usuarios,
    (SELECT COUNT(*) FROM cursos) as total_cursos,
    (SELECT COUNT(*) FROM lecciones) as total_lecciones,
    (SELECT COUNT(*) FROM inscripciones) as total_inscripciones;