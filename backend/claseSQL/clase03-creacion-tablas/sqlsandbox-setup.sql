-- 🚗 SISTEMA DE CONCESIONARIA - CLASE 3
-- Copiá y pegá este código completo en sqlsandbox.com

-- Crear tabla de vehículos con todos los tipos de datos y constraints
CREATE TABLE vehiculos (
    id INTEGER PRIMARY KEY,
    marca TEXT NOT NULL,
    modelo TEXT NOT NULL,
    año INTEGER CHECK (año >= 1990 AND año <= 2025),
    precio REAL CHECK (precio > 0),
    kilometraje INTEGER CHECK (kilometraje >= 0) DEFAULT 0,
    combustible TEXT CHECK (combustible IN ('Nafta', 'Diesel', 'GNC', 'Eléctrico')),
    color TEXT,
    transmision TEXT DEFAULT 'Manual',
    vendido BOOLEAN DEFAULT FALSE,
    fecha_ingreso DATE DEFAULT CURRENT_DATE,
    descripcion TEXT
);

-- Insertar datos de ejemplo para practicar
INSERT INTO vehiculos (marca, modelo, año, precio, kilometraje, combustible, color, transmision) VALUES 
('Toyota', 'Corolla', 2020, 18000.00, 45000, 'Nafta', 'Blanco', 'Automática'),
('Ford', 'Focus', 2019, 16500.50, 32000, 'Nafta', 'Azul', 'Manual'),
('Honda', 'Civic', 2021, 22000.00, 15000, 'Nafta', 'Gris', 'Automática'),
('Volkswagen', 'Golf', 2018, 14500.00, 68000, 'Nafta', 'Rojo', 'Manual'),
('Chevrolet', 'Cruze', 2019, 17800.00, 41000, 'Nafta', 'Negro', 'Automática'),
('Peugeot', '208', 2020, 15200.00, 28000, 'Nafta', 'Blanco', 'Manual'),
('Fiat', 'Cronos', 2021, 16800.00, 12000, 'Nafta', 'Plata', 'Manual'),
('Renault', 'Logan', 2018, 12500.00, 55000, 'GNC', 'Azul', 'Manual'),
('Tesla', 'Model 3', 2023, 45000.00, 8000, 'Eléctrico', 'Negro', 'Automática'),
('Nissan', 'Versa', 2020, 14800.00, 35000, 'Nafta', 'Gris', 'Automática');

-- Crear tabla de clientes
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    dni TEXT UNIQUE NOT NULL,
    telefono TEXT NOT NULL,
    email TEXT UNIQUE,
    direccion TEXT,
    fecha_nacimiento DATE,
    activo BOOLEAN DEFAULT TRUE
);

-- Insertar clientes de ejemplo
INSERT INTO clientes (nombre, apellido, dni, telefono, email, direccion, fecha_nacimiento) VALUES 
('Juan', 'Pérez', '12345678', '11-1234-5678', 'juan@email.com', 'Av. Libertador 1234', '1985-05-15'),
('María', 'García', '87654321', '11-8765-4321', 'maria@email.com', 'San Martín 567', '1990-03-22'),
('Carlos', 'López', '11111111', '11-1111-1111', 'carlos@email.com', 'Belgrano 890', '1988-12-10'),
('Ana', 'Martínez', '22222222', '11-2222-2222', 'ana@email.com', 'Rivadavia 456', '1992-07-18'),
('Roberto', 'Silva', '33333333', '11-3333-3333', 'roberto@email.com', 'Mitre 789', '1987-09-25');

-- Consulta básica para verificar que funciona
SELECT * FROM vehiculos LIMIT 5;