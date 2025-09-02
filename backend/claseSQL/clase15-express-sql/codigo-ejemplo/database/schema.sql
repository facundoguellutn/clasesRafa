-- 📚 ESQUEMA DE BASE DE DATOS PARA BIBLIOTECA
-- Base de datos normalizada con SQLite

PRAGMA foreign_keys = ON;

-- Tabla de autores
CREATE TABLE IF NOT EXISTS autores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    nacionalidad TEXT,
    fecha_nacimiento DATE,
    biografia TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de géneros literarios
CREATE TABLE IF NOT EXISTS generos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT UNIQUE NOT NULL,
    descripcion TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de editoriales
CREATE TABLE IF NOT EXISTS editoriales (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    pais TEXT,
    fundacion INTEGER,
    sitio_web TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de libros
CREATE TABLE IF NOT EXISTS libros (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT NOT NULL,
    isbn TEXT UNIQUE,
    autor_id INTEGER NOT NULL,
    genero_id INTEGER,
    editorial_id INTEGER,
    fecha_publicacion DATE,
    paginas INTEGER CHECK (paginas > 0),
    disponible BOOLEAN DEFAULT TRUE,
    precio_reposicion REAL CHECK (precio_reposicion >= 0),
    resumen TEXT,
    imagen_url TEXT,
    stock INTEGER DEFAULT 1 CHECK (stock >= 0),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (autor_id) REFERENCES autores(id) ON DELETE RESTRICT,
    FOREIGN KEY (genero_id) REFERENCES generos(id) ON DELETE SET NULL,
    FOREIGN KEY (editorial_id) REFERENCES editoriales(id) ON DELETE SET NULL
);

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    telefono TEXT,
    direccion TEXT,
    fecha_nacimiento DATE,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    activo BOOLEAN DEFAULT TRUE,
    multa_acumulada REAL DEFAULT 0.0 CHECK (multa_acumulada >= 0),
    maximo_prestamos INTEGER DEFAULT 3 CHECK (maximo_prestamos > 0),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de préstamos
CREATE TABLE IF NOT EXISTS prestamos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    libro_id INTEGER NOT NULL,
    usuario_id INTEGER NOT NULL,
    fecha_prestamo DATE DEFAULT CURRENT_DATE,
    fecha_devolucion_esperada DATE NOT NULL,
    fecha_devolucion_real DATE,
    multa REAL DEFAULT 0.0 CHECK (multa >= 0),
    estado TEXT DEFAULT 'activo' CHECK (estado IN ('activo', 'devuelto', 'vencido', 'perdido')),
    observaciones TEXT,
    renovaciones INTEGER DEFAULT 0 CHECK (renovaciones >= 0),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (libro_id) REFERENCES libros(id) ON DELETE RESTRICT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE RESTRICT,
    
    -- Constraints adicionales
    CHECK (fecha_devolucion_esperada > fecha_prestamo),
    CHECK (fecha_devolucion_real IS NULL OR fecha_devolucion_real >= fecha_prestamo)
);

-- Tabla de historial de multas
CREATE TABLE IF NOT EXISTS multas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    prestamo_id INTEGER NOT NULL,
    usuario_id INTEGER NOT NULL,
    monto REAL NOT NULL CHECK (monto > 0),
    concepto TEXT NOT NULL,
    fecha_multa DATE DEFAULT CURRENT_DATE,
    fecha_pago DATE,
    pagado BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (prestamo_id) REFERENCES prestamos(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Tabla de reservas (para libros no disponibles)
CREATE TABLE IF NOT EXISTS reservas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    libro_id INTEGER NOT NULL,
    usuario_id INTEGER NOT NULL,
    fecha_reserva DATE DEFAULT CURRENT_DATE,
    fecha_expiracion DATE NOT NULL,
    estado TEXT DEFAULT 'activa' CHECK (estado IN ('activa', 'cumplida', 'cancelada', 'expirada')),
    notificado BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (libro_id) REFERENCES libros(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    
    -- Un usuario no puede tener múltiples reservas del mismo libro
    UNIQUE(libro_id, usuario_id)
);

-- Índices para optimización de consultas
CREATE INDEX IF NOT EXISTS idx_libros_autor ON libros(autor_id);
CREATE INDEX IF NOT EXISTS idx_libros_genero ON libros(genero_id);
CREATE INDEX IF NOT EXISTS idx_libros_disponible ON libros(disponible);
CREATE INDEX IF NOT EXISTS idx_libros_isbn ON libros(isbn);
CREATE INDEX IF NOT EXISTS idx_libros_titulo ON libros(titulo);

CREATE INDEX IF NOT EXISTS idx_usuarios_email ON usuarios(email);
CREATE INDEX IF NOT EXISTS idx_usuarios_activo ON usuarios(activo);

CREATE INDEX IF NOT EXISTS idx_prestamos_usuario ON prestamos(usuario_id);
CREATE INDEX IF NOT EXISTS idx_prestamos_libro ON prestamos(libro_id);
CREATE INDEX IF NOT EXISTS idx_prestamos_estado ON prestamos(estado);
CREATE INDEX IF NOT EXISTS idx_prestamos_fecha_prestamo ON prestamos(fecha_prestamo);
CREATE INDEX IF NOT EXISTS idx_prestamos_fecha_devolucion ON prestamos(fecha_devolucion_esperada);

CREATE INDEX IF NOT EXISTS idx_reservas_libro ON reservas(libro_id);
CREATE INDEX IF NOT EXISTS idx_reservas_usuario ON reservas(usuario_id);
CREATE INDEX IF NOT EXISTS idx_reservas_estado ON reservas(estado);

CREATE INDEX IF NOT EXISTS idx_multas_usuario ON multas(usuario_id);
CREATE INDEX IF NOT EXISTS idx_multas_prestamo ON multas(prestamo_id);
CREATE INDEX IF NOT EXISTS idx_multas_pagado ON multas(pagado);

-- Triggers para mantener integridad y automatizar procesos

-- Trigger: Actualizar timestamp de updated_at
CREATE TRIGGER IF NOT EXISTS update_libros_timestamp 
AFTER UPDATE ON libros
BEGIN
    UPDATE libros SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_usuarios_timestamp 
AFTER UPDATE ON usuarios
BEGIN
    UPDATE usuarios SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_prestamos_timestamp 
AFTER UPDATE ON prestamos
BEGIN
    UPDATE prestamos SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Trigger: Actualizar disponibilidad del libro al crear préstamo
CREATE TRIGGER IF NOT EXISTS update_libro_disponibilidad_prestamo
AFTER INSERT ON prestamos
WHEN NEW.estado = 'activo'
BEGIN
    UPDATE libros 
    SET stock = stock - 1,
        disponible = CASE WHEN stock - 1 > 0 THEN TRUE ELSE FALSE END
    WHERE id = NEW.libro_id;
END;

-- Trigger: Restaurar disponibilidad del libro al devolver
CREATE TRIGGER IF NOT EXISTS update_libro_disponibilidad_devolucion
AFTER UPDATE ON prestamos
WHEN OLD.estado = 'activo' AND NEW.estado = 'devuelto'
BEGIN
    UPDATE libros 
    SET stock = stock + 1,
        disponible = TRUE
    WHERE id = NEW.libro_id;
END;

-- Vistas útiles para consultas frecuentes

-- Vista: Información completa de libros
CREATE VIEW IF NOT EXISTS vista_libros_completa AS
SELECT 
    l.id,
    l.titulo,
    l.isbn,
    a.nombre as autor_nombre,
    a.nacionalidad as autor_nacionalidad,
    g.nombre as genero_nombre,
    e.nombre as editorial_nombre,
    l.fecha_publicacion,
    l.paginas,
    l.disponible,
    l.stock,
    l.precio_reposicion,
    l.created_at,
    l.updated_at,
    COUNT(p.id) as total_prestamos,
    COUNT(CASE WHEN p.estado = 'activo' THEN 1 END) as prestamos_activos
FROM libros l
LEFT JOIN autores a ON l.autor_id = a.id
LEFT JOIN generos g ON l.genero_id = g.id
LEFT JOIN editoriales e ON l.editorial_id = e.id
LEFT JOIN prestamos p ON l.id = p.libro_id
GROUP BY l.id;

-- Vista: Préstamos con información completa
CREATE VIEW IF NOT EXISTS vista_prestamos_completa AS
SELECT 
    p.id,
    l.titulo as libro_titulo,
    l.isbn as libro_isbn,
    a.nombre as autor_nombre,
    u.nombre as usuario_nombre,
    u.email as usuario_email,
    p.fecha_prestamo,
    p.fecha_devolucion_esperada,
    p.fecha_devolucion_real,
    p.estado,
    p.multa,
    p.observaciones,
    CASE 
        WHEN p.fecha_devolucion_real IS NULL AND p.fecha_devolucion_esperada < date('now')
        THEN julianday('now') - julianday(p.fecha_devolucion_esperada)
        ELSE 0
    END as dias_vencido,
    CASE 
        WHEN p.fecha_devolucion_real IS NULL AND p.fecha_devolucion_esperada < date('now')
        THEN 'VENCIDO'
        WHEN p.fecha_devolucion_real IS NULL
        THEN 'ACTIVO'
        ELSE 'DEVUELTO'
    END as estado_calculado
FROM prestamos p
JOIN libros l ON p.libro_id = l.id
JOIN autores a ON l.autor_id = a.id
JOIN usuarios u ON p.usuario_id = u.id;

-- Vista: Usuarios con estadísticas
CREATE VIEW IF NOT EXISTS vista_usuarios_estadisticas AS
SELECT 
    u.id,
    u.nombre,
    u.email,
    u.activo,
    u.multa_acumulada,
    COUNT(p.id) as total_prestamos,
    COUNT(CASE WHEN p.estado = 'activo' THEN 1 END) as prestamos_activos,
    COUNT(CASE WHEN p.estado = 'vencido' THEN 1 END) as prestamos_vencidos,
    MAX(p.fecha_prestamo) as ultimo_prestamo,
    u.created_at,
    u.updated_at
FROM usuarios u
LEFT JOIN prestamos p ON u.id = p.usuario_id
GROUP BY u.id;