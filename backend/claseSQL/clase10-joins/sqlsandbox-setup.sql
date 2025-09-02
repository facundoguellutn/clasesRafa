-- 🛒 SISTEMA DE E-COMMERCE COMPLETO - CLASE 10 JOINS
-- Copiá y pegá este código completo en sqlsandbox.com
-- Sistema para practicar todos los tipos de JOINs

-- 1. CREAR TABLAS RELACIONADAS

-- Tabla de clientes
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    ciudad TEXT,
    telefono TEXT,
    fecha_registro DATE DEFAULT CURRENT_DATE
);

-- Tabla de categorías
CREATE TABLE categorias (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    descripcion TEXT
);

-- Tabla de productos
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    categoria_id INTEGER,
    precio REAL NOT NULL,
    costo REAL,
    stock INTEGER DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- Tabla de vendedores
CREATE TABLE vendedores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    comision_porcentaje REAL DEFAULT 5.0,
    activo BOOLEAN DEFAULT TRUE
);

-- Tabla de pedidos
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    vendedor_id INTEGER,
    fecha DATE DEFAULT CURRENT_DATE,
    total REAL NOT NULL,
    estado TEXT DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'completado', 'cancelado')),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (vendedor_id) REFERENCES vendedores(id)
);

-- Tabla de detalles de pedidos (N:M entre pedidos y productos)
CREATE TABLE pedido_items (
    id INTEGER PRIMARY KEY,
    pedido_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario REAL NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- 2. CREAR ÍNDICES PARA OPTIMIZAR JOINS

CREATE INDEX idx_productos_categoria ON productos(categoria_id);
CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX idx_pedidos_vendedor ON pedidos(vendedor_id);
CREATE INDEX idx_pedido_items_pedido ON pedido_items(pedido_id);
CREATE INDEX idx_pedido_items_producto ON pedido_items(producto_id);

-- 3. INSERTAR DATOS DE EJEMPLO

-- Clientes
INSERT INTO clientes (nombre, email, ciudad, telefono) VALUES 
('Ana García', 'ana.garcia@email.com', 'Buenos Aires', '11-1234-5678'),
('Carlos López', 'carlos.lopez@email.com', 'Córdoba', '351-987-6543'),
('María Rodríguez', 'maria.rodriguez@email.com', 'Rosario', '341-555-1234'),
('Juan Pérez', 'juan.perez@email.com', 'Buenos Aires', '11-9876-5432'),
('Laura Silva', 'laura.silva@email.com', 'Mendoza', '261-444-7788'),
('Roberto Torres', 'roberto.torres@email.com', 'Buenos Aires', '11-3333-9999'),
('Sofía Morales', 'sofia.morales@email.com', 'Córdoba', '351-111-2222'),
('Diego Vega', 'diego.vega@email.com', 'La Plata', '221-666-3333');

-- Categorías
INSERT INTO categorias (nombre, descripcion) VALUES 
('Electrónicos', 'Dispositivos electrónicos y gadgets'),
('Computación', 'Laptops, PCs y accesorios informáticos'),
('Telefonía', 'Smartphones y accesorios móviles'),
('Audio', 'Auriculares, parlantes y equipos de sonido'),
('Gaming', 'Consolas y videojuegos'),
('Hogar', 'Electrodomésticos para el hogar'),
('Deportes', 'Artículos deportivos y fitness');

-- Vendedores
INSERT INTO vendedores (nombre, email, comision_porcentaje) VALUES 
('Pedro Martínez', 'pedro.martinez@empresa.com', 6.0),
('Carmen Ruiz', 'carmen.ruiz@empresa.com', 5.5),
('Fernando Castro', 'fernando.castro@empresa.com', 7.0),
('Valeria Díaz', 'valeria.diaz@empresa.com', 5.0);

-- Productos
INSERT INTO productos (nombre, categoria_id, precio, costo, stock) VALUES 
-- Electrónicos
('iPhone 14', 3, 150000.00, 120000.00, 15),
('Samsung Galaxy S23', 3, 140000.00, 112000.00, 12),
('iPad Air', 1, 95000.00, 76000.00, 8),

-- Computación  
('MacBook Air M2', 2, 320000.00, 256000.00, 5),
('Dell XPS 13', 2, 280000.00, 224000.00, 7),
('HP Pavilion', 2, 180000.00, 144000.00, 10),
('Monitor 27" LG', 2, 85000.00, 68000.00, 20),

-- Audio
('AirPods Pro', 4, 55000.00, 44000.00, 25),
('Sony WH-1000XM4', 4, 75000.00, 60000.00, 15),
('Marshall Acton II', 4, 45000.00, 36000.00, 12),

-- Gaming
('PlayStation 5', 5, 120000.00, 96000.00, 3),
('Xbox Series X', 5, 115000.00, 92000.00, 4),
('Nintendo Switch', 5, 80000.00, 64000.00, 8),

-- Hogar
('Microondas Samsung', 6, 35000.00, 28000.00, 15),
('Cafetera Nespresso', 6, 25000.00, 20000.00, 20),

-- Deportes
('Bicicleta MTB', 7, 65000.00, 52000.00, 6),
('Cinta de correr', 7, 120000.00, 96000.00, 2);

-- Pedidos
INSERT INTO pedidos (cliente_id, vendedor_id, fecha, total, estado) VALUES 
(1, 1, '2024-01-15', 205000.00, 'completado'),  -- Ana - iPhone + AirPods
(2, 2, '2024-01-18', 320000.00, 'completado'),  -- Carlos - MacBook
(3, 1, '2024-01-20', 280000.00, 'completado'),  -- María - Dell XPS
(4, 3, '2024-01-22', 235000.00, 'completado'),  -- Juan - Samsung + Marshall
(1, 2, '2024-01-25', 95000.00, 'completado'),   -- Ana - iPad (segunda compra)
(5, 1, '2024-01-28', 120000.00, 'completado'),  -- Laura - PlayStation
(6, 4, '2024-02-01', 180000.00, 'completado'),  -- Roberto - HP Pavilion
(7, 2, '2024-02-05', 75000.00, 'completado'),   -- Sofía - Sony headphones
(2, 3, '2024-02-08', 85000.00, 'completado'),   -- Carlos - Monitor (segunda compra)
(4, 1, '2024-02-10', 115000.00, 'pendiente'),   -- Juan - Xbox (pendiente)
(8, NULL, '2024-02-12', 65000.00, 'completado'), -- Diego - Bicicleta (sin vendedor)
(3, 4, '2024-02-15', 80000.00, 'cancelado');    -- María - Nintendo (cancelado)

-- Detalles de pedidos (items)
INSERT INTO pedido_items (pedido_id, producto_id, cantidad, precio_unitario) VALUES 
-- Pedido 1: Ana - iPhone + AirPods
(1, 1, 1, 150000.00),  -- iPhone
(1, 8, 1, 55000.00),   -- AirPods

-- Pedido 2: Carlos - MacBook
(2, 4, 1, 320000.00),  -- MacBook

-- Pedido 3: María - Dell XPS
(3, 5, 1, 280000.00),  -- Dell XPS

-- Pedido 4: Juan - Samsung + Marshall
(4, 2, 1, 140000.00),  -- Samsung
(4, 10, 1, 45000.00),  -- Marshall (precio con descuento)

-- Pedido 5: Ana - iPad
(5, 3, 1, 95000.00),   -- iPad

-- Pedido 6: Laura - PlayStation
(6, 11, 1, 120000.00), -- PlayStation

-- Pedido 7: Roberto - HP
(7, 6, 1, 180000.00),  -- HP Pavilion

-- Pedido 8: Sofía - Sony
(8, 9, 1, 75000.00),   -- Sony headphones

-- Pedido 9: Carlos - Monitor
(9, 7, 1, 85000.00),   -- Monitor

-- Pedido 10: Juan - Xbox (pendiente)
(10, 12, 1, 115000.00), -- Xbox

-- Pedido 11: Diego - Bicicleta
(11, 16, 1, 65000.00),  -- Bicicleta

-- Pedido 12: María - Nintendo (cancelado)
(12, 13, 1, 80000.00);  -- Nintendo

-- 4. CONSULTA INICIAL DE VERIFICACIÓN

SELECT 
    'E-COMMERCE CREADO EXITOSAMENTE' as resultado,
    (SELECT COUNT(*) FROM clientes) as clientes,
    (SELECT COUNT(*) FROM productos) as productos,
    (SELECT COUNT(*) FROM pedidos) as pedidos,
    (SELECT COUNT(*) FROM pedido_items) as items_vendidos;