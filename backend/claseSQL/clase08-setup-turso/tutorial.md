# Clase 8: Setup de Entorno Real con Turso

## 🎯 Objetivos de la Clase

Al finalizar esta clase, Rafa será capaz de:
- Configurar una cuenta en Turso paso a paso
- Migrar proyectos desde SQLSandbox a Turso
- Conectar Turso con herramientas locales
- Usar la CLI de Turso para gestión de bases de datos
- Preparar el entorno para integración con Express.js y Next.js

---

## 🌐 ¿Por Qué Turso?

### Transición Natural desde SQLSandbox
Hasta ahora usamos **SQLSandbox** para aprender, pero necesitás un entorno **real** para proyectos serios.

**Turso** es perfecto porque:
- ✅ **Mismo SQL**: Todo lo que aprendiste funciona igual
- ✅ **Setup súper simple**: 5 minutos y estás listo
- ✅ **Gratis para aprender**: Plan generoso sin costo
- ✅ **Escalable**: Crece con tus proyectos
- ✅ **Moderno**: Edge computing, réplicas automáticas

### SQLSandbox → Turso → Express/Next.js
```
SQLSandbox (aprendizaje) → Turso (desarrollo) → Producción
```

---

## 🚀 Paso 1: Crear Cuenta en Turso

### Registro
1. Ir a [turso.tech](https://turso.tech)
2. Click en **"Sign up"**
3. Elegir **"Continue with GitHub"** (recomendado)
4. Autorizar la aplicación

### Plan Gratuito
El plan gratuito incluye:
- ✅ **3 bases de datos**
- ✅ **1GB de storage total**
- ✅ **1 billón de consultas/mes**
- ✅ **Réplicas en múltiples regiones**

> **Más que suficiente para aprender y desarrollar proyectos personales.**

---

## ⚙️ Paso 2: Instalar Turso CLI

### En Windows (Recomendado)
```powershell
# Instalar usando npm (más fácil)
npm install -g @turso/cli

# Verificar instalación
turso --version
```

### En macOS/Linux
```bash
# Método 1: npm (universal)
npm install -g @turso/cli

# Método 2: curl (solo macOS/Linux)
curl -sSfL https://get.tur.so/install.sh | bash
```

### Verificar Instalación
```bash
turso --version
# Debería mostrar algo como: turso version v0.84.2
```

---

## 🔐 Paso 3: Autenticación

### Login con GitHub
```bash
# Autenticarse con la cuenta creada
turso auth login
```

Esto abrirá el navegador para confirmar la autenticación.

### Verificar Login
```bash
# Ver información de tu cuenta
turso auth whoami
```

---

## 📊 Paso 4: Crear Tu Primera Base de Datos

### Crear DB para el Proyecto Biblioteca
```bash
# Crear base de datos
turso db create biblioteca-personal

# Verificar que se creó
turso db list
```

### Obtener URL de Conexión
```bash
# Obtener URL de la base de datos
turso db show biblioteca-personal
```

**Guarda esta información:**
- Database URL: `libsql://biblioteca-personal-[tu-usuario].turso.io`
- Auth token: Se genera después

### Crear Token de Acceso
```bash
# Generar token para conectar desde aplicaciones
turso db tokens create biblioteca-personal
```

**Guarda este token** - lo vas a usar en tus aplicaciones.

---

## 🗄️ Paso 5: Migrar Proyecto Biblioteca

### Conectar a la DB con la CLI
```bash
# Conectar a tu base de datos
turso db shell biblioteca-personal
```

### Recrear Estructura
Copiá y pegá este script en la shell de Turso:

```sql
-- 📚 MIGRACIÓN DE BIBLIOTECA PERSONAL A TURSO

-- 1. Tabla de géneros
CREATE TABLE generos (
    id INTEGER PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    descripcion TEXT
);

-- 2. Tabla de autores  
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

-- 3. Tabla principal de libros
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

-- 4. Tabla de relación muchos a muchos
CREATE TABLE libros_autores (
    id INTEGER PRIMARY KEY,
    libro_id INTEGER NOT NULL,
    autor_id INTEGER NOT NULL,
    rol TEXT DEFAULT 'Autor',
    FOREIGN KEY (libro_id) REFERENCES libros(id),
    FOREIGN KEY (autor_id) REFERENCES autores(id),
    UNIQUE(libro_id, autor_id, rol)
);

-- Insertar géneros básicos
INSERT INTO generos (nombre, descripcion) VALUES 
('Ficción', 'Narrativa de historias imaginarias'),
('No Ficción', 'Textos basados en hechos reales'),
('Ciencia Ficción', 'Literatura especulativa y futurista'),
('Fantasía', 'Mundos imaginarios con elementos mágicos'),
('Misterio', 'Novelas de suspenso e investigación'),
('Tecnología', 'Libros sobre informática y programación');

-- Insertar algunos autores
INSERT INTO autores (nombre, apellido, nacionalidad, biografia) VALUES 
('Gabriel', 'García Márquez', 'Colombiana', 'Premio Nobel de Literatura'),
('George', 'Orwell', 'Británica', 'Autor de 1984'),
('J.K.', 'Rowling', 'Británica', 'Creadora de Harry Potter');

-- Verificar que funcionó
SELECT 'Tablas creadas exitosamente' as resultado;
SELECT COUNT(*) as generos FROM generos;
SELECT COUNT(*) as autores FROM autores;
```

### Salir de la Shell
```bash
# Para salir de la shell de Turso
.exit
# o presionar Ctrl+D
```

---

## 💻 Paso 6: Conexión desde Node.js

### Crear Proyecto de Prueba
```bash
# Crear directorio del proyecto
mkdir turso-test
cd turso-test

# Inicializar proyecto Node.js
npm init -y

# Instalar cliente de Turso
npm install @libsql/client dotenv
```

### Configurar Variables de Entorno
Crear archivo `.env`:

```env
# .env
TURSO_DATABASE_URL=libsql://biblioteca-personal-[tu-usuario].turso.io
TURSO_AUTH_TOKEN=tu-token-aqui
```

**⚠️ Importante:** Reemplazá con tus datos reales de Turso.

### Primer Script de Conexión
Crear archivo `test-connection.js`:

```javascript
// test-connection.js
require('dotenv').config();
const { createClient } = require('@libsql/client');

async function testConnection() {
  const client = createClient({
    url: process.env.TURSO_DATABASE_URL,
    authToken: process.env.TURSO_AUTH_TOKEN,
  });

  try {
    // Test básico de conexión
    const result = await client.execute('SELECT "Conexión exitosa a Turso!" as mensaje');
    console.log(result.rows[0]);

    // Probar consulta real
    const generos = await client.execute('SELECT * FROM generos');
    console.log('\nGéneros en la base de datos:');
    generos.rows.forEach(genero => {
      console.log(`- ${genero.nombre}: ${genero.descripcion}`);
    });

  } catch (error) {
    console.error('Error:', error.message);
  }
}

testConnection();
```

### Probar la Conexión
```bash
# Ejecutar el script
node test-connection.js
```

**Si funciona, deberías ver:**
```
{ mensaje: 'Conexión exitosa a Turso!' }

Géneros en la base de datos:
- Ficción: Narrativa de historias imaginarias
- No Ficción: Textos basados en hechos reales
- Ciencia Ficción: Literatura especulativa y futurista
...
```

---

## 📱 Paso 7: Herramientas de Desarrollo

### Turso Web Console
1. Ir a [app.turso.tech](https://app.turso.tech)
2. Login con tu cuenta
3. Ver tus bases de datos
4. Click en "biblioteca-personal"
5. Usar el **SQL Editor** para hacer consultas

### CLI de Turso para Consultas Rápidas
```bash
# Hacer consulta directa desde terminal
turso db shell biblioteca-personal --command "SELECT COUNT(*) as total FROM generos"

# Ejecutar archivo SQL
echo "SELECT * FROM autores;" | turso db shell biblioteca-personal
```

### DB Browser para SQLite (Local)
Como Turso es compatible con SQLite, podés usar herramientas locales:

1. Descargar [DB Browser for SQLite](https://sqlitebrowser.org/)
2. Para usar con Turso, necesitás exportar/importar datos según necesites

---

## 🔄 Paso 8: Operaciones CRUD con Turso

### Script Completo de Ejemplo
Crear archivo `crud-example.js`:

```javascript
// crud-example.js
require('dotenv').config();
const { createClient } = require('@libsql/client');

const client = createClient({
  url: process.env.TURSO_DATABASE_URL,
  authToken: process.env.TURSO_AUTH_TOKEN,
});

async function crudOperations() {
  try {
    // 1. CREATE - Agregar nuevo libro
    console.log('1. Agregando nuevo libro...');
    
    const insertResult = await client.execute({
      sql: 'INSERT INTO libros (titulo, año_publicacion, paginas, genero_id, precio) VALUES (?, ?, ?, ?, ?)',
      args: ['El Arte de la Programación', 2023, 500, 6, 4500.00]
    });
    
    console.log(`Libro agregado con ID: ${insertResult.lastInsertRowid}`);

    // 2. READ - Leer libros
    console.log('\n2. Consultando libros...');
    
    const selectResult = await client.execute(
      'SELECT l.titulo, l.año_publicacion, g.nombre as genero FROM libros l LEFT JOIN generos g ON l.genero_id = g.id ORDER BY l.id DESC LIMIT 3'
    );
    
    selectResult.rows.forEach(libro => {
      console.log(`- ${libro.titulo} (${libro.año_publicacion}) - ${libro.genero || 'Sin género'}`);
    });

    // 3. UPDATE - Actualizar libro
    console.log('\n3. Actualizando libro...');
    
    await client.execute({
      sql: 'UPDATE libros SET leido = TRUE, calificacion = ? WHERE titulo = ?',
      args: [9, 'El Arte de la Programación']
    });
    
    console.log('Libro marcado como leído');

    // 4. DELETE - Eliminar libro (soft delete)
    console.log('\n4. Desactivando libro...');
    
    await client.execute({
      sql: 'UPDATE libros SET activo = FALSE WHERE titulo = ?',
      args: ['El Arte de la Programación']
    });
    
    console.log('Libro desactivado (soft delete)');

    // 5. Verificar operaciones
    console.log('\n5. Verificando estado final...');
    
    const finalCheck = await client.execute(
      'SELECT titulo, leido, calificacion, activo FROM libros WHERE titulo = "El Arte de la Programación"'
    );
    
    if (finalCheck.rows.length > 0) {
      const libro = finalCheck.rows[0];
      console.log(`Estado: ${libro.titulo} - Leído: ${libro.leido ? 'Sí' : 'No'} - Calificación: ${libro.calificacion} - Activo: ${libro.activo ? 'Sí' : 'No'}`);
    }

  } catch (error) {
    console.error('Error en operaciones CRUD:', error.message);
  }
}

crudOperations();
```

### Ejecutar CRUD
```bash
node crud-example.js
```

---

## 🛠️ Paso 9: Configuración para Proyectos Futuros

### Template .env para Proyectos
```env
# Database Configuration
TURSO_DATABASE_URL=libsql://tu-database.turso.io
TURSO_AUTH_TOKEN=tu-token-aqui

# Development
NODE_ENV=development
PORT=3000

# Future integrations
NEXTAUTH_SECRET=tu-secret-para-next-auth
NEXTAUTH_URL=http://localhost:3000
```

### Helper de Conexión Reutilizable
Crear archivo `lib/db.js`:

```javascript
// lib/db.js
const { createClient } = require('@libsql/client');

let client = null;

function getClient() {
  if (!client) {
    client = createClient({
      url: process.env.TURSO_DATABASE_URL,
      authToken: process.env.TURSO_AUTH_TOKEN,
    });
  }
  return client;
}

// Helper functions
async function query(sql, params = []) {
  const client = getClient();
  return await client.execute({ sql, args: params });
}

async function queryOne(sql, params = []) {
  const result = await query(sql, params);
  return result.rows[0] || null;
}

async function queryAll(sql, params = []) {
  const result = await query(sql, params);
  return result.rows;
}

module.exports = {
  getClient,
  query,
  queryOne,
  queryAll
};
```

### Usar el Helper
```javascript
// ejemplo-con-helper.js
require('dotenv').config();
const { queryAll, queryOne } = require('./lib/db');

async function ejemploConHelper() {
  try {
    // Obtener todos los géneros
    const generos = await queryAll('SELECT * FROM generos ORDER BY nombre');
    console.log('Géneros:', generos);

    // Obtener un libro específico
    const libro = await queryOne('SELECT * FROM libros WHERE id = ?', [1]);
    console.log('Libro:', libro);

  } catch (error) {
    console.error('Error:', error.message);
  }
}

ejemploConHelper();
```

---

## 🔧 Comandos Útiles de Turso CLI

### Gestión de Bases de Datos
```bash
# Listar todas las bases de datos
turso db list

# Ver información detallada
turso db show biblioteca-personal

# Crear nueva base de datos
turso db create mi-nueva-db

# Eliminar base de datos (¡CUIDADO!)
turso db destroy mi-db-test
```

### Gestión de Tokens
```bash
# Listar tokens existentes
turso db tokens list biblioteca-personal

# Crear nuevo token
turso db tokens create biblioteca-personal

# Revocar token
turso db tokens revoke biblioteca-personal [token-name]
```

### Ubicaciones y Réplicas
```bash
# Ver ubicaciones disponibles
turso db locations

# Crear réplica en otra región
turso db replica create biblioteca-personal --location fra  # Frankfurt
```

---

## 🚨 Troubleshooting Común

### Error: "Database not found"
```bash
# Verificar nombre exacto de la DB
turso db list

# Verificar que estás autenticado
turso auth whoami
```

### Error: "Invalid auth token"
```bash
# Generar nuevo token
turso db tokens create tu-database

# Actualizar .env con el nuevo token
```

### Error de Conexión en Node.js
```javascript
// Verificar variables de entorno
console.log('URL:', process.env.TURSO_DATABASE_URL);
console.log('Token length:', process.env.TURSO_AUTH_TOKEN?.length);

// Asegurate de que .env está en gitignore
```

### Performance Lenta
```bash
# Verificar ubicación más cercana
turso db show tu-database

# Considerar crear réplica local
turso db replica create tu-database --location scl  # Santiago (más cerca de Argentina)
```

---

## ✅ Checklist de Configuración Completa

- [ ] ✅ Cuenta creada en Turso
- [ ] ✅ CLI instalado y funcionando  
- [ ] ✅ Autenticación exitosa
- [ ] ✅ Base de datos creada
- [ ] ✅ Token de acceso generado
- [ ] ✅ Conexión desde Node.js funcionando
- [ ] ✅ CRUD operations working
- [ ] ✅ Helper de conexión configurado
- [ ] ✅ Variables de entorno organizadas

---

## 🏠 Tarea Para Casa

### Proyecto: Migrar Sistema de E-Learning
1. **Crear nueva DB** en Turso llamada "elearning-platform"
2. **Migrar estructura completa** de la Clase 6 (usuarios, cursos, inscripciones, etc.)
3. **Crear helper de conexión** específico para este proyecto
4. **Implementar 5 operaciones CRUD** usando el helper
5. **Documentar el proceso** en un README.md

### Script de Migración Requerido
```javascript
// migration-elearning.js
// Crear script que:
// 1. Conecte a Turso
// 2. Cree todas las tablas de e-learning
// 3. Inserte datos de ejemplo
// 4. Verifique que todo funciona
// 5. Genere reporte de éxito
```

### Consultas de Verificación
Implementar estas consultas en Node.js:
- Cursos por instructor
- Estudiantes más activos  
- Tasa de completado por curso
- Ingresos totales por mes
- Dashboard de KPIs

---

## 🎯 Próxima Clase: Relaciones entre Tablas (JOINs)

En la **Clase 10** vamos a:
- Dominar INNER JOIN, LEFT JOIN, RIGHT JOIN  
- Consultas complejas con múltiples tablas
- Optimización de JOINs con índices
- Casos reales de análisis de datos

**¡Excelente! Ya tenés tu entorno de desarrollo real configurado. Ahora podés trabajar con bases de datos como en producción.**