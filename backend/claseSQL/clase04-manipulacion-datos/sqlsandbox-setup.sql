-- 🏪 SISTEMA DE INVENTARIO SIMPLE - CLASE 4
-- Copiá y pegá este código completo en sqlsandbox.com

-- Crear tabla de productos para practicar INSERT, UPDATE, DELETE
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    categoria TEXT,
    precio REAL CHECK (precio > 0),
    stock INTEGER DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion DATE DEFAULT CURRENT_DATE,
    fecha_actualizacion DATE,
    descripcion TEXT
);

-- Insertar productos iniciales para practicar
INSERT INTO productos (nombre, categoria, precio, stock, descripcion) VALUES 
('iPhone 13', 'Electrónica', 120000.00, 5, 'Smartphone Apple última generación'),
('Samsung Galaxy S22', 'Electrónica', 95000.00, 3, 'Android flagship con excelente cámara'),
('MacBook Air', 'Computación', 180000.00, 2, 'Laptop ultradelgada con chip M1'),
('iPad Pro', 'Electrónica', 85000.00, 4, 'Tablet profesional con Apple Pencil'),
('AirPods Pro', 'Accesorios', 25000.00, 10, 'Auriculares inalámbricos con cancelación de ruido'),
('Dell XPS 13', 'Computación', 150000.00, 1, 'Laptop premium con pantalla InfinityEdge'),
('Logitech Mouse MX', 'Accesorios', 3500.00, 25, 'Mouse ergonómico para productividad'),
('Monitor 24" LG', 'Accesorios', 35000.00, 8, 'Monitor IPS Full HD para trabajo'),
('Teclado Mecánico', 'Accesorios', 8500.00, 15, 'Teclado gaming con switches azules'),
('Webcam HD', 'Accesorios', 4500.00, 12, 'Cámara 1080p para videollamadas');

-- Crear tabla de clientes para ejercicios avanzados
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE,
    telefono TEXT,
    activo BOOLEAN DEFAULT TRUE,
    fecha_registro DATE DEFAULT CURRENT_DATE
);

-- Insertar algunos clientes
INSERT INTO clientes (nombre, email, telefono) VALUES 
('Juan Pérez', 'juan@email.com', '11-1234-5678'),
('María García', 'maria@email.com', '11-8765-4321'),
('Carlos López', 'carlos@email.com', '11-5555-5555'),
('Ana Martínez', 'ana@email.com', '11-9999-9999');

-- Consulta básica para verificar el setup
SELECT 'Productos creados:', COUNT(*) as cantidad FROM productos
UNION ALL
SELECT 'Clientes creados:', COUNT(*) as cantidad FROM clientes;