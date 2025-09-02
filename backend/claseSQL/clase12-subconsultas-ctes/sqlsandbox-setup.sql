-- 🔍 SUBCONSULTAS Y CTEs - CLASE 12
-- Copiá y pegá este código completo en sqlsandbox.com
-- Sistema avanzado de e-commerce para practicar consultas complejas

-- 1. CREAR ESTRUCTURA COMPLETA PARA ANÁLISIS AVANZADO

-- Tabla de países y ciudades (para análisis geográfico)
CREATE TABLE paises (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    codigo TEXT UNIQUE NOT NULL
);

CREATE TABLE ciudades (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    pais_id INTEGER NOT NULL,
    FOREIGN KEY (pais_id) REFERENCES paises(id)
);

-- Categorías jerárquicas (padre-hijo)
CREATE TABLE categorias (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    categoria_padre_id INTEGER,
    margen_promedio REAL DEFAULT 0.30,
    activa BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (categoria_padre_id) REFERENCES categorias(id)
);

-- Proveedores
CREATE TABLE proveedores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    pais_id INTEGER,
    calificacion REAL DEFAULT 0.0,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (pais_id) REFERENCES paises(id)
);

-- Productos expandido
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    categoria_id INTEGER NOT NULL,
    proveedor_id INTEGER,
    precio_venta REAL NOT NULL CHECK (precio_venta > 0),
    precio_costo REAL NOT NULL CHECK (precio_costo > 0),
    stock INTEGER DEFAULT 0 CHECK (stock >= 0),
    stock_minimo INTEGER DEFAULT 10,
    fecha_lanzamiento DATE DEFAULT CURRENT_DATE,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)
);

-- Clientes con segmentación
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    telefono TEXT,
    fecha_nacimiento DATE,
    ciudad_id INTEGER,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    segmento TEXT DEFAULT 'Regular' CHECK (segmento IN ('VIP', 'Premium', 'Regular', 'Nuevo')),
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (ciudad_id) REFERENCES ciudades(id)
);

-- Vendedores con jerarquía
CREATE TABLE vendedores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    jefe_id INTEGER,
    ciudad_id INTEGER,
    comision_porcentaje REAL DEFAULT 5.0,
    meta_mensual REAL DEFAULT 50000.0,
    fecha_contratacion DATE DEFAULT CURRENT_DATE,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (jefe_id) REFERENCES vendedores(id),
    FOREIGN KEY (ciudad_id) REFERENCES ciudades(id)
);

-- Pedidos con más información
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    numero_pedido TEXT UNIQUE NOT NULL,
    cliente_id INTEGER NOT NULL,
    vendedor_id INTEGER,
    fecha_pedido DATE DEFAULT CURRENT_DATE,
    fecha_entrega_estimada DATE,
    fecha_entrega_real DATE,
    subtotal REAL NOT NULL CHECK (subtotal >= 0),
    descuento REAL DEFAULT 0.0 CHECK (descuento >= 0),
    impuestos REAL NOT NULL CHECK (impuestos >= 0),
    total REAL NOT NULL CHECK (total >= 0),
    estado TEXT DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'procesando', 'enviado', 'entregado', 'cancelado')),
    canal TEXT DEFAULT 'Online' CHECK (canal IN ('Online', 'Tienda', 'Teléfono', 'Email', 'WhatsApp')),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (vendedor_id) REFERENCES vendedores(id)
);

-- Detalles de pedidos
CREATE TABLE pedido_items (
    id INTEGER PRIMARY KEY,
    pedido_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario REAL NOT NULL CHECK (precio_unitario > 0),
    descuento_item REAL DEFAULT 0.0 CHECK (descuento_item >= 0),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Tabla para análisis de cohortes
CREATE TABLE eventos_cliente (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    tipo_evento TEXT NOT NULL CHECK (tipo_evento IN ('registro', 'primera_compra', 'compra', 'visita_web')),
    fecha_evento DATE DEFAULT CURRENT_DATE,
    valor REAL DEFAULT 0.0,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- 2. INSERTAR DATOS PARA ANÁLISIS COMPLEJO

-- Países
INSERT INTO paises (nombre, codigo) VALUES 
('Argentina', 'AR'),
('Brasil', 'BR'),
('Chile', 'CL'),
('Colombia', 'CO'),
('México', 'MX'),
('España', 'ES'),
('Estados Unidos', 'US');

-- Ciudades
INSERT INTO ciudades (nombre, pais_id) VALUES 
-- Argentina
('Buenos Aires', 1),
('Córdoba', 1), 
('Rosario', 1),
('Mendoza', 1),
-- Brasil
('São Paulo', 2),
('Rio de Janeiro', 2),
-- Chile
('Santiago', 3),
('Valparaíso', 3),
-- Colombia
('Bogotá', 4),
('Medellín', 4);

-- Categorías jerárquicas
INSERT INTO categorias (id, nombre, categoria_padre_id, margen_promedio) VALUES 
-- Categorías padre
(1, 'Tecnología', NULL, 0.25),
(2, 'Hogar', NULL, 0.40),
(3, 'Deportes', NULL, 0.45),
(4, 'Libros', NULL, 0.50),
-- Subcategorías de Tecnología
(5, 'Computación', 1, 0.30),
(6, 'Telefonía', 1, 0.20),
(7, 'Audio', 1, 0.35),
-- Subcategorías de Hogar
(8, 'Cocina', 2, 0.45),
(9, 'Limpieza', 2, 0.50),
-- Subcategorías de Deportes
(10, 'Fitness', 3, 0.40),
(11, 'Outdoor', 3, 0.50);

-- Proveedores
INSERT INTO proveedores (nombre, pais_id, calificacion) VALUES 
('TechSupplier SA', 1, 4.5),
('GlobalTech Corp', 7, 4.8),
('SouthAmerican Electronics', 2, 4.2),
('LocalHome Supplies', 1, 4.0),
('SportEquip International', 3, 4.6),
('BookDistributor', 1, 4.3);

-- Productos con variedad para análisis
INSERT INTO productos (nombre, categoria_id, proveedor_id, precio_venta, precio_costo, stock, fecha_lanzamiento) VALUES 
-- Computación
('Laptop Gaming Pro', 5, 1, 250000.00, 175000.00, 15, '2023-06-01'),
('MacBook Air M2', 5, 2, 320000.00, 240000.00, 8, '2023-07-15'),
('PC Gamer Ultimate', 5, 1, 180000.00, 126000.00, 12, '2023-05-20'),
('Monitor 4K 32"', 5, 2, 95000.00, 66500.00, 25, '2023-04-10'),

-- Telefonía
('iPhone 15 Pro', 6, 2, 220000.00, 176000.00, 20, '2023-09-15'),
('Samsung Galaxy S24', 6, 3, 180000.00, 144000.00, 30, '2023-08-01'),
('Xiaomi Mi 13', 6, 3, 120000.00, 96000.00, 40, '2023-07-01'),

-- Audio
('AirPods Pro 2', 7, 2, 75000.00, 52500.00, 50, '2023-09-10'),
('Sony WH-1000XM5', 7, 2, 95000.00, 66500.00, 25, '2023-06-20'),
('JBL Flip 6', 7, 3, 35000.00, 24500.00, 60, '2023-05-15'),

-- Cocina
('Air Fryer Philips', 8, 4, 45000.00, 27000.00, 30, '2023-03-01'),
('Cafetera Nespresso', 8, 4, 55000.00, 33000.00, 25, '2023-04-15'),
('Microondas Samsung', 8, 3, 38000.00, 22800.00, 20, '2023-02-20'),

-- Fitness
('Cinta de Correr Pro', 10, 5, 180000.00, 108000.00, 5, '2023-01-15'),
('Bicicleta Spinning', 10, 5, 85000.00, 51000.00, 12, '2023-02-01'),
('Set Pesas 20kg', 10, 5, 25000.00, 15000.00, 40, '2023-01-10'),

-- Libros
('Cien Años de Soledad', 4, 6, 8500.00, 4250.00, 100, '2023-01-01'),
('Clean Code', 4, 6, 12000.00, 6000.00, 80, '2023-01-01'),
('Diseño de APIs', 4, 6, 15000.00, 7500.00, 60, '2023-01-01');

-- Vendedores con jerarquía
INSERT INTO vendedores (id, nombre, email, jefe_id, ciudad_id, comision_porcentaje, meta_mensual) VALUES 
-- Gerentes regionales (sin jefe)
(1, 'Carlos Rodriguez', 'carlos.r@empresa.com', NULL, 1, 8.0, 150000.00),
(2, 'Ana Martinez', 'ana.m@empresa.com', NULL, 5, 8.0, 140000.00),
-- Vendedores bajo Carlos
(3, 'Pedro Lopez', 'pedro.l@empresa.com', 1, 1, 6.0, 80000.00),
(4, 'Laura Silva', 'laura.s@empresa.com', 1, 2, 6.0, 75000.00),
-- Vendedores bajo Ana
(5, 'Roberto Santos', 'roberto.s@empresa.com', 2, 5, 6.0, 85000.00),
(6, 'Maria Gonzalez', 'maria.g@empresa.com', 2, 6, 6.0, 70000.00),
-- Vendedor sin equipo
(7, 'Diego Fernandez', 'diego.f@empresa.com', NULL, 7, 5.0, 60000.00);

-- Clientes con diversidad demográfica
INSERT INTO clientes (nombre, email, fecha_nacimiento, ciudad_id, fecha_registro, segmento) VALUES 
-- VIPs (compradores frecuentes)
('Juan Pérez', 'juan.perez@email.com', '1985-03-15', 1, '2023-01-15', 'VIP'),
('María García', 'maria.garcia@email.com', '1990-07-22', 1, '2023-01-20', 'VIP'),
('Carlos Mendoza', 'carlos.mendoza@email.com', '1982-11-08', 2, '2023-02-01', 'VIP'),

-- Premium 
('Ana Rodriguez', 'ana.rodriguez@email.com', '1988-05-12', 1, '2023-02-15', 'Premium'),
('Luis Torres', 'luis.torres@email.com', '1983-09-30', 3, '2023-02-20', 'Premium'),
('Sofia Morales', 'sofia.morales@email.com', '1991-01-18', 2, '2023-03-01', 'Premium'),

-- Regulares
('Roberto Silva', 'roberto.silva@email.com', '1987-12-05', 1, '2023-03-15', 'Regular'),
('Valentina Castro', 'valentina.castro@email.com', '1993-04-25', 4, '2023-03-20', 'Regular'),
('Diego Vega', 'diego.vega@email.com', '1986-08-14', 5, '2023-04-01', 'Regular'),
('Carmen Ruiz', 'carmen.ruiz@email.com', '1989-06-03', 6, '2023-04-10', 'Regular'),

-- Nuevos (registros recientes)
('Patricia Díaz', 'patricia.diaz@email.com', '1992-02-28', 7, '2023-11-01', 'Nuevo'),
('Fernando Castro', 'fernando.castro@email.com', '1984-10-17', 8, '2023-11-15', 'Nuevo'),
('Gabriela Herrera', 'gabriela.herrera@email.com', '1990-12-09', 9, '2023-12-01', 'Nuevo'),
('Andrés Vargas', 'andres.vargas@email.com', '1985-07-21', 10, '2023-12-15', 'Nuevo');

-- Pedidos distribuidos en el tiempo (2023-2024)
INSERT INTO pedidos (numero_pedido, cliente_id, vendedor_id, fecha_pedido, subtotal, descuento, impuestos, total, estado, canal) VALUES 
-- Enero 2023
('P-2023-001', 1, 3, '2023-01-20', 250000.00, 12500.00, 44625.00, 282125.00, 'entregado', 'Online'),
('P-2023-002', 2, 3, '2023-01-25', 95000.00, 0.00, 17325.00, 112325.00, 'entregado', 'Tienda'),
('P-2023-003', 4, 4, '2023-01-30', 320000.00, 16000.00, 56880.00, 360880.00, 'entregado', 'Online'),

-- Febrero 2023
('P-2023-004', 1, 3, '2023-02-05', 75000.00, 3750.00, 13725.00, 84975.00, 'entregado', 'Online'),
('P-2023-005', 3, 4, '2023-02-08', 180000.00, 9000.00, 32580.00, 203580.00, 'entregado', 'Teléfono'),
('P-2023-006', 5, 5, '2023-02-12', 220000.00, 11000.00, 39780.00, 248780.00, 'entregado', 'Online'),
('P-2023-007', 6, 6, '2023-02-15', 55000.00, 0.00, 10450.00, 65450.00, 'entregado', 'WhatsApp'),

-- Marzo 2023
('P-2023-008', 2, 3, '2023-03-01', 120000.00, 6000.00, 21420.00, 135420.00, 'entregado', 'Online'),
('P-2023-009', 7, 4, '2023-03-05', 85000.00, 4250.00, 15142.50, 95892.50, 'entregado', 'Tienda'),
('P-2023-010', 8, 7, '2023-03-10', 45000.00, 0.00, 8550.00, 53550.00, 'entregado', 'Email'),

-- Datos recientes 2024
('P-2024-001', 1, 3, '2024-01-10', 180000.00, 9000.00, 32130.00, 203130.00, 'entregado', 'Online'),
('P-2024-002', 2, 3, '2024-01-15', 95000.00, 4750.00, 16954.50, 107204.50, 'entregado', 'Online'),
('P-2024-003', 9, 5, '2024-01-20', 25000.00, 0.00, 4750.00, 29750.00, 'entregado', 'Tienda'),
('P-2024-004', 10, 6, '2024-02-01', 38000.00, 1900.00, 6859.00, 42959.00, 'entregado', 'WhatsApp'),
('P-2024-005', 3, 4, '2024-02-05', 250000.00, 12500.00, 44625.00, 282125.00, 'entregado', 'Online'),

-- Pedidos pendientes/en proceso
('P-2024-006', 11, 7, '2024-02-15', 12000.00, 0.00, 2280.00, 14280.00, 'procesando', 'Online'),
('P-2024-007', 12, 5, '2024-02-18', 85000.00, 4250.00, 15142.50, 95892.50, 'enviado', 'Teléfono'),
('P-2024-008', 4, 4, '2024-02-20', 35000.00, 1750.00, 6232.50, 39482.50, 'pendiente', 'Online');

-- Items de pedidos (selección representativa)
INSERT INTO pedido_items (pedido_id, producto_id, cantidad, precio_unitario, descuento_item) VALUES 
-- P-2023-001: Juan - Laptop Gaming
(1, 1, 1, 250000.00, 12500.00),
-- P-2023-002: María - Monitor
(2, 4, 1, 95000.00, 0.00),
-- P-2023-003: Ana - MacBook
(3, 2, 1, 320000.00, 16000.00),
-- P-2023-004: Juan - AirPods
(4, 8, 1, 75000.00, 3750.00),
-- P-2023-005: Carlos - Samsung Galaxy
(5, 6, 1, 180000.00, 9000.00),
-- P-2023-006: Luis - iPhone 15
(6, 5, 1, 220000.00, 11000.00),
-- P-2023-007: Sofia - Cafetera
(7, 12, 1, 55000.00, 0.00),
-- P-2023-008: María - Xiaomi
(8, 7, 1, 120000.00, 6000.00),
-- P-2023-009: Roberto - Bicicleta
(9, 15, 1, 85000.00, 4250.00),
-- P-2023-010: Valentina - Air Fryer
(10, 11, 1, 45000.00, 0.00),
-- P-2024-001: Juan - PC Gamer (cliente recurrente)
(11, 3, 1, 180000.00, 9000.00),
-- P-2024-002: María - Sony Headphones
(12, 9, 1, 95000.00, 4750.00),
-- P-2024-003: Diego - Set Pesas
(13, 16, 1, 25000.00, 0.00),
-- P-2024-004: Carmen - Microondas
(14, 13, 1, 38000.00, 1900.00),
-- P-2024-005: Carlos - Laptop Gaming (upgrade)
(15, 1, 1, 250000.00, 12500.00);

-- Eventos de cliente para análisis de cohortes
INSERT INTO eventos_cliente (cliente_id, tipo_evento, fecha_evento, valor) VALUES 
-- Juan (cliente VIP con historial largo)
(1, 'registro', '2023-01-15', 0),
(1, 'primera_compra', '2023-01-20', 282125.00),
(1, 'compra', '2023-02-05', 84975.00),
(1, 'compra', '2024-01-10', 203130.00),
-- María (cliente VIP activo)
(2, 'registro', '2023-01-20', 0),
(2, 'primera_compra', '2023-01-25', 112325.00),
(2, 'compra', '2023-03-01', 135420.00),
(2, 'compra', '2024-01-15', 107204.50),
-- Clientes nuevos con menos actividad
(11, 'registro', '2023-11-01', 0),
(12, 'registro', '2023-11-15', 0),
(12, 'primera_compra', '2024-02-18', 95892.50);

-- 3. CONSULTAS DE EJEMPLO PARA PRACTICAR

SELECT 'SISTEMA LISTO PARA SUBCONSULTAS Y CTEs' as mensaje;

-- Ejemplo 1: Subconsulta escalar
SELECT 'EJEMPLO 1: PRODUCTOS MÁS CAROS QUE EL PROMEDIO' as ejemplo;
SELECT 
    nombre,
    precio_venta,
    (SELECT AVG(precio_venta) FROM productos) as precio_promedio,
    precio_venta - (SELECT AVG(precio_venta) FROM productos) as diferencia_promedio
FROM productos
WHERE precio_venta > (SELECT AVG(precio_venta) FROM productos)
ORDER BY precio_venta DESC;

-- Ejemplo 2: CTE básico
SELECT 'EJEMPLO 2: ANÁLISIS DE VENTAS CON CTE' as ejemplo;
WITH ventas_por_cliente AS (
    SELECT 
        c.nombre,
        c.segmento,
        COUNT(p.id) as total_pedidos,
        SUM(p.total) as total_gastado,
        AVG(p.total) as ticket_promedio
    FROM clientes c
    LEFT JOIN pedidos p ON c.id = p.cliente_id AND p.estado = 'entregado'
    GROUP BY c.id, c.nombre, c.segmento
),
promedios_generales AS (
    SELECT 
        AVG(total_gastado) as promedio_general,
        AVG(ticket_promedio) as ticket_promedio_general
    FROM ventas_por_cliente
    WHERE total_pedidos > 0
)
SELECT 
    v.nombre,
    v.segmento,
    v.total_pedidos,
    v.total_gastado,
    v.ticket_promedio,
    p.promedio_general,
    CASE 
        WHEN v.total_gastado > p.promedio_general THEN 'Arriba del promedio'
        ELSE 'Abajo del promedio'
    END as performance_relativa
FROM ventas_por_cliente v
CROSS JOIN promedios_generales p
WHERE v.total_pedidos > 0
ORDER BY v.total_gastado DESC;

-- Ejemplo 3: Window Functions
SELECT 'EJEMPLO 3: RANKING DE PRODUCTOS CON WINDOW FUNCTIONS' as ejemplo;
SELECT 
    nombre,
    categoria_id,
    precio_venta,
    ROW_NUMBER() OVER (PARTITION BY categoria_id ORDER BY precio_venta DESC) as ranking_categoria,
    RANK() OVER (ORDER BY precio_venta DESC) as ranking_general,
    ROUND(
        100.0 * (precio_venta - MIN(precio_venta) OVER (PARTITION BY categoria_id)) / 
        (MAX(precio_venta) OVER (PARTITION BY categoria_id) - MIN(precio_venta) OVER (PARTITION BY categoria_id)), 
        2
    ) as percentil_categoria
FROM productos
WHERE activo = TRUE
ORDER BY categoria_id, ranking_categoria;

-- Ejemplo 4: CTE Recursivo - Jerarquía de vendedores
SELECT 'EJEMPLO 4: JERARQUÍA DE VENDEDORES (CTE RECURSIVO)' as ejemplo;
WITH RECURSIVE jerarquia_vendedores AS (
    -- Gerentes (sin jefe)
    SELECT 
        id,
        nombre,
        email,
        jefe_id,
        0 as nivel,
        nombre as ruta_jerarquia
    FROM vendedores
    WHERE jefe_id IS NULL AND activo = TRUE
    
    UNION ALL
    
    -- Subordinados
    SELECT 
        v.id,
        v.nombre,
        v.email,
        v.jefe_id,
        j.nivel + 1,
        j.ruta_jerarquia || ' > ' || v.nombre
    FROM vendedores v
    JOIN jerarquia_vendedores j ON v.jefe_id = j.id
    WHERE v.activo = TRUE
)
SELECT 
    nombre,
    nivel,
    ruta_jerarquia,
    (SELECT COUNT(*) FROM pedidos WHERE vendedor_id = jerarquia_vendedores.id) as pedidos_vendidos
FROM jerarquia_vendedores
ORDER BY nivel, nombre;