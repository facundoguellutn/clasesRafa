-- 📊 ANÁLISIS DE DATOS CON FUNCIONES AGREGADAS - CLASE 13
-- Copiá y pegá este código completo en sqlsandbox.com
-- Sistema completo para practicar COUNT, SUM, AVG, GROUP BY, HAVING

-- 1. CREAR ESTRUCTURA DE DATOS PARA ANÁLISIS

-- Tabla de regiones (para análisis geográfico)
CREATE TABLE regiones (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    pais TEXT NOT NULL
);

-- Tabla de clientes (expandida para análisis)
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    edad INTEGER CHECK (edad >= 18),
    genero TEXT CHECK (genero IN ('M', 'F', 'Otro')),
    region_id INTEGER,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    plan TEXT CHECK (plan IN ('Basic', 'Premium', 'VIP')) DEFAULT 'Basic',
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (region_id) REFERENCES regiones(id)
);

-- Tabla de categorías (para análisis por segmento)
CREATE TABLE categorias (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    descripcion TEXT,
    margen_promedio REAL DEFAULT 0.30
);

-- Tabla de productos (expandida)
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    categoria_id INTEGER,
    precio_venta REAL NOT NULL,
    precio_costo REAL NOT NULL,
    stock INTEGER DEFAULT 0,
    peso_kg REAL,
    fecha_lanzamiento DATE,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- Tabla de vendedores (para análisis de performance)
CREATE TABLE vendedores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    region_id INTEGER,
    comision_porcentaje REAL DEFAULT 5.0,
    meta_mensual REAL DEFAULT 50000.0,
    fecha_contratacion DATE DEFAULT CURRENT_DATE,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (region_id) REFERENCES regiones(id)
);

-- Tabla de pedidos (con más campos para análisis)
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    numero_pedido TEXT UNIQUE NOT NULL,
    cliente_id INTEGER NOT NULL,
    vendedor_id INTEGER,
    fecha_pedido DATE DEFAULT CURRENT_DATE,
    fecha_entrega DATE,
    subtotal REAL NOT NULL,
    descuento REAL DEFAULT 0.0,
    impuestos REAL NOT NULL,
    total REAL NOT NULL,
    estado TEXT DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'procesando', 'enviado', 'entregado', 'cancelado')),
    canal TEXT CHECK (canal IN ('Online', 'Tienda', 'Teléfono', 'Email')) DEFAULT 'Online',
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (vendedor_id) REFERENCES vendedores(id)
);

-- Tabla de detalles de pedidos (para análisis granular)
CREATE TABLE pedido_items (
    id INTEGER PRIMARY KEY,
    pedido_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario REAL NOT NULL,
    descuento_item REAL DEFAULT 0.0,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- 2. CREAR ÍNDICES PARA OPTIMIZACIÓN DE AGREGACIONES

CREATE INDEX idx_clientes_region_plan ON clientes(region_id, plan);
CREATE INDEX idx_productos_categoria_activo ON productos(categoria_id, activo);
CREATE INDEX idx_pedidos_cliente_fecha ON pedidos(cliente_id, fecha_pedido);
CREATE INDEX idx_pedidos_vendedor_estado ON pedidos(vendedor_id, estado);
CREATE INDEX idx_pedidos_fecha_canal ON pedidos(fecha_pedido, canal);
CREATE INDEX idx_pedido_items_producto ON pedido_items(producto_id);

-- 3. INSERTAR DATOS PARA ANÁLISIS REALISTA

-- Regiones
INSERT INTO regiones (nombre, pais) VALUES 
('Buenos Aires', 'Argentina'),
('Córdoba', 'Argentina'),
('Santa Fe', 'Argentina'),
('Mendoza', 'Argentina'),
('São Paulo', 'Brasil'),
('Rio de Janeiro', 'Brasil'),
('Santiago', 'Chile'),
('Lima', 'Perú');

-- Categorías con márgenes diferentes
INSERT INTO categorias (nombre, descripcion, margen_promedio) VALUES 
('Electrónicos', 'Dispositivos electrónicos de consumo', 0.25),
('Computación', 'Hardware y software informático', 0.30),
('Telefonía', 'Smartphones y accesorios móviles', 0.35),
('Audio & Video', 'Equipos de sonido e imagen', 0.40),
('Gaming', 'Consolas, juegos y accesorios gaming', 0.20),
('Hogar', 'Electrodomésticos y artículos del hogar', 0.45),
('Deportes', 'Artículos deportivos y fitness', 0.50),
('Libros', 'Libros físicos y digitales', 0.60);

-- Productos con datos realistas
INSERT INTO productos (nombre, categoria_id, precio_venta, precio_costo, stock, peso_kg, fecha_lanzamiento) VALUES 
-- Electrónicos
('iPhone 14 Pro', 1, 180000.00, 135000.00, 25, 0.2, '2023-09-15'),
('Samsung Galaxy S23', 1, 160000.00, 120000.00, 30, 0.18, '2023-02-01'),
('iPad Pro 12.9', 1, 220000.00, 165000.00, 15, 0.68, '2023-10-20'),

-- Computación
('MacBook Pro M3', 2, 450000.00, 315000.00, 8, 1.6, '2023-11-01'),
('Dell XPS 15', 2, 320000.00, 224000.00, 12, 1.8, '2023-05-15'),
('Lenovo ThinkPad', 2, 280000.00, 196000.00, 20, 1.5, '2023-03-10'),
('Monitor 4K 27"', 2, 85000.00, 59500.00, 35, 8.5, '2023-01-20'),

-- Audio & Video
('AirPods Pro 2', 4, 65000.00, 39000.00, 50, 0.05, '2023-09-10'),
('Sony WH-1000XM5', 4, 85000.00, 51000.00, 25, 0.25, '2023-06-15'),
('Bose SoundLink', 4, 45000.00, 27000.00, 40, 0.68, '2023-04-01'),

-- Gaming
('PlayStation 5', 5, 135000.00, 108000.00, 5, 4.5, '2023-01-01'),
('Xbox Series X', 5, 130000.00, 104000.00, 8, 4.4, '2023-01-01'),
('Nintendo Switch OLED', 5, 95000.00, 76000.00, 15, 0.42, '2023-02-15'),

-- Hogar
('Microondas Samsung', 6, 45000.00, 24750.00, 20, 12.0, '2023-08-01'),
('Cafetera Nespresso', 6, 35000.00, 19250.00, 30, 4.2, '2023-07-10'),
('Aspiradora Robot', 6, 75000.00, 41250.00, 12, 3.8, '2023-09-20'),

-- Deportes  
('Bicicleta MTB Trek', 7, 120000.00, 60000.00, 8, 12.5, '2023-03-01'),
('Cinta de Correr', 7, 180000.00, 90000.00, 3, 85.0, '2023-05-01'),

-- Libros
('Clean Code', 8, 8500.00, 3400.00, 50, 0.6, '2023-01-15'),
('Design Patterns', 8, 9200.00, 3680.00, 30, 0.8, '2023-02-20');

-- Clientes con diversidad demográfica
INSERT INTO clientes (nombre, email, edad, genero, region_id, plan, fecha_registro) VALUES 
-- Buenos Aires
('Ana García', 'ana.garcia@email.com', 28, 'F', 1, 'Premium', '2023-01-15'),
('Carlos Mendez', 'carlos.mendez@email.com', 34, 'M', 1, 'VIP', '2023-01-20'),
('Laura Silva', 'laura.silva@email.com', 25, 'F', 1, 'Basic', '2023-02-01'),
('Roberto Torres', 'roberto.torres@email.com', 42, 'M', 1, 'Premium', '2023-02-15'),

-- Córdoba  
('María López', 'maria.lopez@email.com', 31, 'F', 2, 'Basic', '2023-01-25'),
('Juan Pérez', 'juan.perez@email.com', 29, 'M', 2, 'Premium', '2023-02-10'),
('Sofía Morales', 'sofia.morales@email.com', 26, 'F', 2, 'Basic', '2023-03-01'),

-- Santa Fe
('Diego Vega', 'diego.vega@email.com', 35, 'M', 3, 'VIP', '2023-01-30'),
('Valentina Castro', 'valentina.castro@email.com', 27, 'F', 3, 'Premium', '2023-02-20'),

-- Internacional
('Paulo Santos', 'paulo.santos@email.com', 33, 'M', 5, 'Premium', '2023-02-05'),
('Carla Rivera', 'carla.rivera@email.com', 30, 'F', 7, 'Basic', '2023-02-25'),
('Luis Martinez', 'luis.martinez@email.com', 38, 'M', 8, 'VIP', '2023-03-10');

-- Vendedores por región
INSERT INTO vendedores (nombre, email, region_id, comision_porcentaje, meta_mensual, fecha_contratacion) VALUES 
('Pedro Rodriguez', 'pedro.r@empresa.com', 1, 6.0, 80000.00, '2022-06-01'),
('Carmen Ruiz', 'carmen.r@empresa.com', 1, 5.5, 70000.00, '2022-08-15'),
('Fernando Castro', 'fernando.c@empresa.com', 2, 7.0, 60000.00, '2022-07-10'),
('Valeria Díaz', 'valeria.d@empresa.com', 3, 5.0, 50000.00, '2023-01-15'),
('Ricardo Silva', 'ricardo.s@empresa.com', 5, 6.5, 75000.00, '2022-09-01');

-- Pedidos distribuidos en el tiempo con variedad de datos
INSERT INTO pedidos (numero_pedido, cliente_id, vendedor_id, fecha_pedido, fecha_entrega, subtotal, descuento, impuestos, total, estado, canal) VALUES 
-- Enero 2024
('P-2024-001', 1, 1, '2024-01-05', '2024-01-08', 180000.00, 9000.00, 32130.00, 203130.00, 'entregado', 'Online'),
('P-2024-002', 2, 1, '2024-01-08', '2024-01-12', 450000.00, 22500.00, 80325.00, 507825.00, 'entregado', 'Tienda'),
('P-2024-003', 3, 2, '2024-01-10', '2024-01-15', 85000.00, 0.00, 15525.00, 100525.00, 'entregado', 'Online'),
('P-2024-004', 4, 2, '2024-01-15', '2024-01-20', 320000.00, 16000.00, 56880.00, 360880.00, 'entregado', 'Teléfono'),
('P-2024-005', 5, 3, '2024-01-18', '2024-01-23', 95000.00, 4750.00, 16954.50, 107204.50, 'entregado', 'Online'),

-- Febrero 2024
('P-2024-006', 6, 3, '2024-02-02', '2024-02-07', 135000.00, 6750.00, 24094.50, 152344.50, 'entregado', 'Online'),
('P-2024-007', 7, 4, '2024-02-05', '2024-02-10', 65000.00, 0.00, 11700.00, 76700.00, 'entregado', 'Tienda'),
('P-2024-008', 8, 4, '2024-02-08', '2024-02-13', 220000.00, 11000.00, 39780.00, 248780.00, 'entregado', 'Online'),
('P-2024-009', 1, 1, '2024-02-12', '2024-02-17', 160000.00, 8000.00, 28800.00, 180800.00, 'entregado', 'Online'),
('P-2024-010', 9, 5, '2024-02-15', '2024-02-20', 75000.00, 3750.00, 13725.00, 84975.00, 'entregado', 'Email'),

-- Marzo 2024 (incluye pedidos pendientes y cancelados)
('P-2024-011', 10, 5, '2024-03-01', '2024-03-06', 85000.00, 0.00, 15300.00, 100300.00, 'entregado', 'Online'),
('P-2024-012', 11, 1, '2024-03-05', NULL, 180000.00, 9000.00, 32130.00, 203130.00, 'procesando', 'Tienda'),
('P-2024-013', 2, 2, '2024-03-08', NULL, 130000.00, 6500.00, 23490.00, 146990.00, 'pendiente', 'Online'),
('P-2024-014', 12, 3, '2024-03-10', NULL, 45000.00, 2250.00, 8092.50, 50842.50, 'cancelado', 'Teléfono'),
('P-2024-015', 4, 1, '2024-03-12', NULL, 280000.00, 14000.00, 50400.00, 316400.00, 'enviado', 'Online');

-- Detalles de algunos pedidos para análisis granular
INSERT INTO pedido_items (pedido_id, producto_id, cantidad, precio_unitario, descuento_item) VALUES 
-- Pedido 1: Ana - iPhone
(1, 1, 1, 180000.00, 9000.00),

-- Pedido 2: Carlos - MacBook  
(2, 4, 1, 450000.00, 22500.00),

-- Pedido 3: Laura - Monitor
(3, 7, 1, 85000.00, 0.00),

-- Pedido 4: Roberto - Dell XPS
(4, 5, 1, 320000.00, 16000.00),

-- Pedido 5: María - Nintendo
(5, 12, 1, 95000.00, 4750.00),

-- Pedido 6: Juan - PlayStation  
(6, 11, 1, 135000.00, 6750.00),

-- Pedido 7: Sofía - AirPods
(7, 8, 1, 65000.00, 0.00),

-- Pedido 8: Diego - iPad
(8, 3, 1, 220000.00, 11000.00),

-- Pedido 9: Valentina - Samsung
(9, 2, 1, 160000.00, 8000.00),

-- Pedido 10: Paulo - Aspiradora
(10, 15, 1, 75000.00, 3750.00);

-- 4. CONSULTA INICIAL DE VERIFICACIÓN

SELECT 
    'SISTEMA DE ANÁLISIS CREADO EXITOSAMENTE' as resultado,
    (SELECT COUNT(*) FROM clientes) as total_clientes,
    (SELECT COUNT(*) FROM productos) as total_productos,
    (SELECT COUNT(*) FROM pedidos) as total_pedidos,
    (SELECT COUNT(*) FROM vendedores) as total_vendedores,
    (SELECT SUM(total) FROM pedidos WHERE estado = 'entregado') as ingresos_entregados;