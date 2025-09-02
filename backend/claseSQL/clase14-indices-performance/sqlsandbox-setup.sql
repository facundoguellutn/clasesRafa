-- ⚡ ÍNDICES Y OPTIMIZACIÓN DE PERFORMANCE - CLASE 14
-- Copiá y pegá este código completo en sqlsandbox.com
-- Sistema para practicar optimización de consultas SQL

-- 1. CREAR ESTRUCTURA DE DATOS PARA TESTING DE PERFORMANCE

-- Tabla de categorías (jerarquía simple)
CREATE TABLE categorias (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    descripcion TEXT,
    activa BOOLEAN DEFAULT TRUE
);

-- Tabla de proveedores
CREATE TABLE proveedores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    pais TEXT,
    calificacion REAL DEFAULT 0.0
);

-- Tabla de productos (sin índices inicialmente)
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
    descripcion TEXT,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)
);

-- Tabla de clientes (sin índices inicialmente)
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    telefono TEXT,
    fecha_nacimiento DATE,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    ciudad TEXT,
    pais TEXT DEFAULT 'Argentina',
    activo BOOLEAN DEFAULT TRUE,
    segmento TEXT DEFAULT 'Regular' CHECK (segmento IN ('VIP', 'Premium', 'Regular', 'Nuevo'))
);

-- Tabla de pedidos (diseñada para testing de performance)
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    numero_pedido TEXT UNIQUE NOT NULL,
    cliente_id INTEGER NOT NULL,
    fecha_pedido DATE DEFAULT CURRENT_DATE,
    fecha_entrega DATE,
    subtotal REAL NOT NULL CHECK (subtotal >= 0),
    descuento REAL DEFAULT 0.0 CHECK (descuento >= 0),
    impuestos REAL NOT NULL CHECK (impuestos >= 0),
    total REAL NOT NULL CHECK (total >= 0),
    estado TEXT DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'procesando', 'enviado', 'entregado', 'cancelado')),
    canal TEXT DEFAULT 'Online' CHECK (canal IN ('Online', 'Tienda', 'Teléfono', 'App')),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Tabla de items de pedidos (muchos registros para testing)
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

-- 2. INSERTAR DATOS DE EJEMPLO PARA TESTING

-- Categorías
INSERT INTO categorias (nombre, descripcion) VALUES 
('Electrónicos', 'Dispositivos electrónicos'),
('Computación', 'Laptops, PCs y accesorios'),
('Telefonía', 'Smartphones y accesorios'),
('Audio', 'Auriculares y parlantes'),
('Gaming', 'Consolas y videojuegos'),
('Hogar', 'Electrodomésticos'),
('Deportes', 'Artículos deportivos'),
('Libros', 'Literatura y técnicos'),
('Ropa', 'Vestimenta y calzado'),
('Belleza', 'Cosméticos y cuidado personal');

-- Proveedores
INSERT INTO proveedores (nombre, pais, calificacion) VALUES 
('TechCorp SA', 'Argentina', 4.5),
('GlobalSupplies Inc', 'Estados Unidos', 4.8),
('EuroTech GmbH', 'Alemania', 4.6),
('AsiaElectronics Ltd', 'China', 4.2),
('LocalDistributor', 'Argentina', 4.0),
('SouthAmerica Trading', 'Brasil', 4.3),
('TechInnovation', 'España', 4.7),
('QualityGoods Co', 'Japón', 4.9);

-- Productos (variedad para testing de índices)
INSERT INTO productos (nombre, categoria_id, proveedor_id, precio_venta, precio_costo, stock, descripcion) VALUES 
-- Electrónicos (Categoría 1)
('Smartphone Galaxy X1', 1, 1, 89000.00, 62300.00, 45, 'Smartphone de última generación'),
('Tablet Pro 11', 1, 2, 125000.00, 87500.00, 25, 'Tablet profesional para trabajo'),
('Smartwatch Fitness', 1, 3, 35000.00, 24500.00, 60, 'Reloj inteligente deportivo'),
('Cámara Digital 4K', 1, 4, 156000.00, 109200.00, 15, 'Cámara profesional 4K'),

-- Computación (Categoría 2) 
('Laptop Business Pro', 2, 1, 245000.00, 171500.00, 20, 'Laptop para profesionales'),
('Desktop Gaming Xtreme', 2, 2, 189000.00, 132300.00, 12, 'PC para gaming profesional'),
('Monitor 27" 4K', 2, 3, 85000.00, 59500.00, 35, 'Monitor profesional 4K'),
('Teclado Mecánico RGB', 2, 5, 15000.00, 10500.00, 80, 'Teclado gaming RGB'),
('Mouse Gaming Pro', 2, 5, 8500.00, 5950.00, 120, 'Mouse profesional gaming'),

-- Telefonía (Categoría 3)
('iPhone Pro Max', 3, 2, 325000.00, 227500.00, 18, 'iPhone de alta gama'),
('Samsung Galaxy Note', 3, 1, 198000.00, 138600.00, 28, 'Smartphone empresarial'),
('Xiaomi Flagship', 3, 4, 95000.00, 66500.00, 50, 'Smartphone con buena relación precio-calidad'),
('Cargador Inalámbrico', 3, 5, 5500.00, 3850.00, 200, 'Cargador wireless rápido'),

-- Audio (Categoría 4)
('Auriculares Noise Cancel', 4, 2, 45000.00, 31500.00, 40, 'Auriculares con cancelación de ruido'),
('Parlante Bluetooth Premium', 4, 3, 25000.00, 17500.00, 65, 'Parlante portable de alta calidad'),
('Micrófono Podcasting', 4, 6, 18000.00, 12600.00, 30, 'Micrófono profesional para streaming'),

-- Gaming (Categoría 5)
('PlayStation 5 Pro', 5, 2, 189000.00, 132300.00, 8, 'Consola de nueva generación'),
('Xbox Series X', 5, 2, 175000.00, 122500.00, 12, 'Consola Microsoft premium'),
('Nintendo Switch OLED', 5, 7, 95000.00, 66500.00, 25, 'Consola híbrida OLED'),
('Silla Gaming Ergonómica', 5, 5, 85000.00, 59500.00, 15, 'Silla profesional para gaming'),

-- Más productos para testing de performance...
('Licuadora Smart', 6, 4, 28000.00, 19600.00, 45, 'Licuadora inteligente'),
('Aspiradora Robot', 6, 3, 65000.00, 45500.00, 22, 'Robot aspirador automático'),
('Bicicleta Eléctrica', 7, 6, 185000.00, 129500.00, 8, 'Bicicleta con motor eléctrico'),
('Cinta de Correr Plegable', 7, 5, 125000.00, 87500.00, 12, 'Cinta de correr para hogar'),
('Libro SQL Avanzado', 8, 8, 8500.00, 5950.00, 150, 'Libro técnico sobre bases de datos'),
('Novela Bestseller', 8, 8, 3200.00, 2240.00, 300, 'Novela más vendida del año'),
('Zapatillas Running', 9, 6, 15000.00, 10500.00, 85, 'Zapatillas profesionales para correr'),
('Perfume Premium', 10, 7, 12000.00, 8400.00, 75, 'Fragancia de lujo');

-- Clientes (diversidad para testing)
INSERT INTO clientes (nombre, email, fecha_nacimiento, ciudad, fecha_registro, segmento) VALUES 
-- Clientes VIP (compradores frecuentes)
('Juan Carlos Pérez', 'juan.perez@email.com', '1985-03-15', 'Buenos Aires', '2022-06-15', 'VIP'),
('María Elena García', 'maria.garcia@email.com', '1990-07-22', 'Buenos Aires', '2022-08-20', 'VIP'),
('Carlos Alberto Mendoza', 'carlos.mendoza@email.com', '1982-11-08', 'Córdoba', '2022-09-10', 'VIP'),
('Ana Sofía Rodríguez', 'ana.rodriguez@email.com', '1988-05-12', 'Buenos Aires', '2022-10-05', 'VIP'),

-- Clientes Premium
('Luis Fernando Torres', 'luis.torres@email.com', '1983-09-30', 'Rosario', '2023-01-15', 'Premium'),
('Sofía Isabel Morales', 'sofia.morales@email.com', '1991-01-18', 'Córdoba', '2023-02-20', 'Premium'),
('Roberto Daniel Silva', 'roberto.silva@email.com', '1987-12-05', 'Buenos Aires', '2023-03-10', 'Premium'),
('Valentina Castro López', 'valentina.castro@email.com', '1993-04-25', 'Mendoza', '2023-04-15', 'Premium'),

-- Clientes Regulares  
('Diego Alejandro Vega', 'diego.vega@email.com', '1986-08-14', 'La Plata', '2023-05-20', 'Regular'),
('Carmen Beatriz Ruiz', 'carmen.ruiz@email.com', '1989-06-03', 'Mar del Plata', '2023-06-25', 'Regular'),
('Patricia Mónica Díaz', 'patricia.diaz@email.com', '1992-02-28', 'Tucumán', '2023-07-30', 'Regular'),
('Fernando José Castro', 'fernando.castro@email.com', '1984-10-17', 'Salta', '2023-08-15', 'Regular'),
('Gabriela Andrea Herrera', 'gabriela.herrera@email.com', '1990-12-09', 'Neuquén', '2023-09-20', 'Regular'),
('Andrés Martín Vargas', 'andres.vargas@email.com', '1985-07-21', 'Bahía Blanca', '2023-10-25', 'Regular'),

-- Clientes Nuevos
('Lucía Esperanza González', 'lucia.gonzalez@email.com', '1994-03-12', 'Buenos Aires', '2024-01-10', 'Nuevo'),
('Mateo Ignacio Fernández', 'mateo.fernandez@email.com', '1989-08-07', 'Córdoba', '2024-01-20', 'Nuevo'),
('Camila Victoria Romero', 'camila.romero@email.com', '1991-11-15', 'Rosario', '2024-02-05', 'Nuevo'),
('Sebastián Pablo Jiménez', 'sebastian.jimenez@email.com', '1986-05-28', 'Buenos Aires', '2024-02-15', 'Nuevo');

-- Pedidos (distribuidos en el tiempo para análisis)
INSERT INTO pedidos (numero_pedido, cliente_id, fecha_pedido, fecha_entrega, subtotal, descuento, impuestos, total, estado, canal) VALUES 
-- 2023 - Pedidos históricos
('PED-2023-001', 1, '2023-01-15', '2023-01-18', 245000.00, 12250.00, 46020.75, 278770.75, 'entregado', 'Online'),
('PED-2023-002', 2, '2023-01-20', '2023-01-23', 85000.00, 0.00, 17850.00, 102850.00, 'entregado', 'Tienda'),
('PED-2023-003', 3, '2023-02-01', '2023-02-05', 189000.00, 9450.00, 37695.75, 217245.75, 'entregado', 'App'),
('PED-2023-004', 1, '2023-02-10', '2023-02-13', 45000.00, 2250.00, 8977.50, 51727.50, 'entregado', 'Online'),
('PED-2023-005', 4, '2023-02-15', '2023-02-20', 325000.00, 16250.00, 64877.50, 373627.50, 'entregado', 'Tienda'),
('PED-2023-006', 5, '2023-03-01', '2023-03-05', 95000.00, 4750.00, 18952.50, 109202.50, 'entregado', 'Online'),
('PED-2023-007', 6, '2023-03-10', '2023-03-15', 125000.00, 6250.00, 24937.50, 143687.50, 'entregado', 'App'),
('PED-2023-008', 2, '2023-03-20', '2023-03-25', 28000.00, 0.00, 5880.00, 33880.00, 'entregado', 'Online'),
('PED-2023-009', 7, '2023-04-01', '2023-04-05', 156000.00, 7800.00, 31122.00, 179322.00, 'entregado', 'Tienda'),
('PED-2023-010', 8, '2023-04-15', '2023-04-20', 35000.00, 1750.00, 6997.50, 40247.50, 'entregado', 'Online'),

-- 2024 - Pedidos recientes
('PED-2024-001', 1, '2024-01-05', '2024-01-10', 189000.00, 9450.00, 37695.75, 217245.75, 'entregado', 'Online'),
('PED-2024-002', 15, '2024-01-10', '2024-01-15', 15000.00, 0.00, 3150.00, 18150.00, 'entregado', 'App'),
('PED-2024-003', 9, '2024-01-20', '2024-01-25', 65000.00, 3250.00, 12997.50, 74747.50, 'entregado', 'Online'),
('PED-2024-004', 16, '2024-01-25', '2024-01-30', 25000.00, 1250.00, 4987.50, 28737.50, 'entregado', 'Tienda'),
('PED-2024-005', 3, '2024-02-01', '2024-02-05', 175000.00, 8750.00, 34912.50, 201162.50, 'entregado', 'Online'),
('PED-2024-006', 10, '2024-02-05', '2024-02-10', 85000.00, 4250.00, 16997.50, 97747.50, 'entregado', 'App'),
('PED-2024-007', 17, '2024-02-10', NULL, 45000.00, 2250.00, 8977.50, 51727.50, 'procesando', 'Online'),
('PED-2024-008', 11, '2024-02-15', NULL, 18000.00, 0.00, 3780.00, 21780.00, 'enviado', 'Tienda'),
('PED-2024-009', 18, '2024-02-20', NULL, 12000.00, 600.00, 2394.00, 13794.00, 'pendiente', 'Online'),
('PED-2024-010', 4, '2024-02-25', NULL, 95000.00, 4750.00, 18952.50, 109202.50, 'procesando', 'App');

-- Items de pedidos (datos para testing de JOINs)
INSERT INTO pedido_items (pedido_id, producto_id, cantidad, precio_unitario, descuento_item) VALUES 
-- PED-2023-001: Juan - Laptop Business Pro
(1, 5, 1, 245000.00, 12250.00),
-- PED-2023-002: María - Monitor 4K  
(2, 7, 1, 85000.00, 0.00),
-- PED-2023-003: Carlos - Desktop Gaming
(3, 6, 1, 189000.00, 9450.00),
-- PED-2023-004: Juan - Auriculares (segunda compra)
(4, 15, 1, 45000.00, 2250.00),
-- PED-2023-005: Ana - iPhone Pro Max
(5, 10, 1, 325000.00, 16250.00),
-- PED-2023-006: Luis - Nintendo Switch
(6, 18, 1, 95000.00, 4750.00),
-- PED-2023-007: Sofia - Tablet Pro
(7, 2, 1, 125000.00, 6250.00),
-- PED-2023-008: María - Licuadora (segunda compra)
(8, 20, 1, 28000.00, 0.00),
-- PED-2023-009: Roberto - Cámara 4K
(9, 4, 1, 156000.00, 7800.00),
-- PED-2023-010: Valentina - Smartwatch
(10, 3, 1, 35000.00, 1750.00),
-- PED-2024-001: Juan - Desktop Gaming (tercera compra - cliente fiel)
(11, 6, 1, 189000.00, 9450.00),
-- PED-2024-002: Lucía - Zapatillas Running
(12, 25, 1, 15000.00, 0.00),
-- PED-2024-003: Diego - Aspiradora Robot
(13, 21, 1, 65000.00, 3250.00),
-- PED-2024-004: Mateo - Parlante Bluetooth
(14, 16, 1, 25000.00, 1250.00),
-- PED-2024-005: Carlos - Xbox Series X
(15, 17, 1, 175000.00, 8750.00);

-- 3. CONSULTAS DE ANÁLISIS DE PERFORMANCE (SIN ÍNDICES)

SELECT 'SISTEMA CREADO - AHORA ANALICEMOS PERFORMANCE SIN ÍNDICES' as mensaje;

-- CONSULTA 1: Buscar productos por categoría (LENTA sin índice)
SELECT 'CONSULTA 1: Productos por categoría - ANALIZAR CON EXPLAIN QUERY PLAN' as ejemplo;

EXPLAIN QUERY PLAN
SELECT p.nombre, p.precio_venta, c.nombre as categoria
FROM productos p
JOIN categorias c ON p.categoria_id = c.id
WHERE p.categoria_id = 2 AND p.activo = TRUE;

-- CONSULTA 2: Pedidos de un cliente específico (LENTA sin índice)
SELECT 'CONSULTA 2: Pedidos por cliente - ANALIZAR PERFORMANCE' as ejemplo;

EXPLAIN QUERY PLAN  
SELECT p.numero_pedido, p.fecha_pedido, p.total, p.estado
FROM pedidos p
WHERE p.cliente_id = 1
ORDER BY p.fecha_pedido DESC;

-- CONSULTA 3: JOIN complejo sin índices (MUY LENTA)
SELECT 'CONSULTA 3: JOIN complejo sin optimizar' as ejemplo;

EXPLAIN QUERY PLAN
SELECT 
    c.nombre as cliente,
    COUNT(p.id) as total_pedidos,
    SUM(p.total) as total_gastado,
    AVG(p.total) as ticket_promedio
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE p.estado = 'entregado' 
  AND p.fecha_pedido >= '2023-06-01'
GROUP BY c.id, c.nombre
HAVING COUNT(p.id) >= 2
ORDER BY total_gastado DESC;

-- 4. CREAR ÍNDICES ESTRATÉGICOS PASO A PASO

-- PASO 1: Índices básicos para consultas frecuentes
SELECT 'CREANDO ÍNDICES BÁSICOS...' as accion;

CREATE INDEX idx_productos_categoria ON productos(categoria_id);
CREATE INDEX idx_productos_activo ON productos(activo);
CREATE INDEX idx_clientes_email ON clientes(email);
CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);

-- PASO 2: Índices compuestos para consultas específicas
SELECT 'CREANDO ÍNDICES COMPUESTOS...' as accion;

CREATE INDEX idx_productos_categoria_activo ON productos(categoria_id, activo);
CREATE INDEX idx_pedidos_cliente_fecha ON pedidos(cliente_id, fecha_pedido DESC);
CREATE INDEX idx_pedidos_estado_fecha ON pedidos(estado, fecha_pedido);

-- PASO 3: Índices para JOINs frecuentes
SELECT 'CREANDO ÍNDICES PARA JOINS...' as accion;

CREATE INDEX idx_pedido_items_pedido ON pedido_items(pedido_id);
CREATE INDEX idx_pedido_items_producto ON pedido_items(producto_id);

-- PASO 4: Índices parciales (solo datos relevantes)
SELECT 'CREANDO ÍNDICES PARCIALES...' as accion;

CREATE INDEX idx_pedidos_entregados ON pedidos(fecha_pedido, total) 
    WHERE estado = 'entregado';

CREATE INDEX idx_productos_en_stock ON productos(categoria_id, precio_venta) 
    WHERE activo = TRUE AND stock > 0;

-- 5. COMPARAR PERFORMANCE DESPUÉS DE ÍNDICES

SELECT 'COMPARANDO PERFORMANCE CON ÍNDICES...' as titulo;

-- La misma consulta 1, ahora optimizada
SELECT 'CONSULTA 1 OPTIMIZADA:' as resultado;
EXPLAIN QUERY PLAN
SELECT p.nombre, p.precio_venta, c.nombre as categoria
FROM productos p
JOIN categorias c ON p.categoria_id = c.id  
WHERE p.categoria_id = 2 AND p.activo = TRUE;

-- La misma consulta 2, ahora optimizada
SELECT 'CONSULTA 2 OPTIMIZADA:' as resultado;
EXPLAIN QUERY PLAN
SELECT p.numero_pedido, p.fecha_pedido, p.total, p.estado
FROM pedidos p
WHERE p.cliente_id = 1
ORDER BY p.fecha_pedido DESC;

-- La misma consulta 3, ahora optimizada  
SELECT 'CONSULTA 3 OPTIMIZADA:' as resultado;
EXPLAIN QUERY PLAN
SELECT 
    c.nombre as cliente,
    COUNT(p.id) as total_pedidos, 
    SUM(p.total) as total_gastado,
    AVG(p.total) as ticket_promedio
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE p.estado = 'entregado'
  AND p.fecha_pedido >= '2023-06-01'
GROUP BY c.id, c.nombre
HAVING COUNT(p.id) >= 2
ORDER BY total_gastado DESC;

-- 6. CONSULTAS ADICIONALES PARA PRACTICAR OPTIMIZACIÓN

-- Dashboard de métricas (optimizado con índices)
SELECT 'DASHBOARD OPTIMIZADO:' as titulo;
SELECT 
    'Total Productos' as metrica,
    COUNT(*) as valor
FROM productos 
WHERE activo = TRUE
UNION ALL
SELECT 
    'Productos en Stock',
    COUNT(*)
FROM productos 
WHERE activo = TRUE AND stock > stock_minimo
UNION ALL
SELECT 
    'Pedidos Este Mes',
    COUNT(*)
FROM pedidos
WHERE fecha_pedido >= date('now', 'start of month')
  AND estado IN ('entregado', 'enviado')
UNION ALL
SELECT 
    'Ingresos Este Mes',
    ROUND(SUM(total), 2)
FROM pedidos
WHERE fecha_pedido >= date('now', 'start of month')
  AND estado = 'entregado';

-- Top 5 productos más vendidos (usa índices eficientemente)
SELECT 'TOP 5 PRODUCTOS MÁS VENDIDOS:' as titulo;
SELECT 
    pr.nombre,
    SUM(pi.cantidad) as cantidad_vendida,
    COUNT(DISTINCT pi.pedido_id) as pedidos_distintos,
    SUM(pi.cantidad * pi.precio_unitario) as ingresos_producto
FROM productos pr
JOIN pedido_items pi ON pr.id = pi.producto_id
JOIN pedidos p ON pi.pedido_id = p.id AND p.estado = 'entregado'
GROUP BY pr.id, pr.nombre
ORDER BY cantidad_vendida DESC
LIMIT 5;

-- Análisis de clientes VIP (optimizado)
SELECT 'ANÁLISIS DE CLIENTES VIP:' as titulo;
SELECT 
    c.nombre,
    c.segmento,
    COUNT(p.id) as total_pedidos,
    ROUND(SUM(p.total), 2) as total_gastado,
    ROUND(AVG(p.total), 2) as ticket_promedio,
    MAX(p.fecha_pedido) as ultima_compra
FROM clientes c
JOIN pedidos p ON c.id = p.cliente_id AND p.estado = 'entregado'
WHERE c.segmento IN ('VIP', 'Premium')
GROUP BY c.id, c.nombre, c.segmento
ORDER BY total_gastado DESC;

-- 7. EJERCICIOS PARA PRACTICAR

SELECT 'EJERCICIOS PARA PRACTICAR:' as titulo;
SELECT '1. Analiza estas consultas con EXPLAIN QUERY PLAN' as ejercicio;
SELECT '2. Identifica qué índices faltan para optimizarlas' as ejercicio;
SELECT '3. Crea los índices necesarios' as ejercicio;
SELECT '4. Compara el plan de ejecución antes y después' as ejercicio;

-- Consulta de ejercicio 1: Buscar por texto en nombre
SELECT 'EJERCICIO 1: ¿Cómo optimizar búsqueda por texto?' as pregunta;
-- SELECT * FROM productos WHERE nombre LIKE '%Gaming%';

-- Consulta de ejercicio 2: Ranking de ventas por categoría
SELECT 'EJERCICIO 2: ¿Cómo optimizar este ranking?' as pregunta;
/* 
SELECT 
    c.nombre as categoria,
    COUNT(pi.producto_id) as productos_vendidos,
    SUM(pi.cantidad * pi.precio_unitario) as ingresos_categoria
FROM categorias c
LEFT JOIN productos pr ON c.id = pr.categoria_id
LEFT JOIN pedido_items pi ON pr.id = pi.producto_id
LEFT JOIN pedidos p ON pi.pedido_id = p.id AND p.estado = 'entregado'
GROUP BY c.id, c.nombre
ORDER BY ingresos_categoria DESC;
*/

-- Estadísticas finales
SELECT 'ESTADÍSTICAS FINALES DEL SISTEMA:' as resumen;
SELECT 
    (SELECT COUNT(*) FROM productos) as total_productos,
    (SELECT COUNT(*) FROM clientes) as total_clientes,
    (SELECT COUNT(*) FROM pedidos) as total_pedidos,
    (SELECT COUNT(*) FROM pedido_items) as total_items,
    (SELECT COUNT(*) FROM sqlite_master WHERE type='index' AND name NOT LIKE 'sqlite_%') as indices_creados;