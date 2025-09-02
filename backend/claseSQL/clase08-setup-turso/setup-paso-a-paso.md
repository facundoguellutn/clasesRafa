# Guía Paso a Paso: Setup Completo de Turso

## 🎯 Checklist de Configuración

### Fase 1: Preparación
- [ ] Cuenta de GitHub activa
- [ ] Node.js instalado (v16 o superior)
- [ ] Terminal/PowerShell funcionando
- [ ] Editor de código listo (VS Code recomendado)

### Fase 2: Registro y Autenticación
- [ ] Cuenta creada en turso.tech
- [ ] CLI de Turso instalado
- [ ] Autenticación completada
- [ ] Verificación de login exitosa

### Fase 3: Primera Base de Datos
- [ ] Base de datos creada
- [ ] Token de acceso generado
- [ ] URL de conexión obtenida
- [ ] Conexión desde CLI probada

### Fase 4: Integración Node.js
- [ ] Proyecto de prueba creado
- [ ] Dependencias instaladas
- [ ] Variables de entorno configuradas
- [ ] Primera conexión exitosa

### Fase 5: Migración de Proyecto
- [ ] Estructura de tablas migrada
- [ ] Datos de ejemplo insertados
- [ ] Operaciones CRUD funcionando
- [ ] Helper de conexión implementado

---

## 🔧 Comandos de Instalación Rápida

### Windows (PowerShell como Administrador)
```powershell
# Instalar Turso CLI
npm install -g @turso/cli

# Verificar instalación
turso --version

# Si npm no funciona, usar winget:
# winget install turso-cli
```

### macOS
```bash
# Método 1: npm (recomendado)
npm install -g @turso/cli

# Método 2: Homebrew
brew install turso

# Método 3: curl
curl -sSfL https://get.tur.so/install.sh | bash
```

### Linux
```bash
# npm (universal)
npm install -g @turso/cli

# curl (alternativa)
curl -sSfL https://get.tur.so/install.sh | bash

# Agregar al PATH si usas curl
echo 'export PATH="$HOME/.turso:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## 🚀 Script de Setup Automático

### Para Windows (PowerShell)
```powershell
# setup-turso.ps1
Write-Host "🚀 Configurando Turso paso a paso..." -ForegroundColor Green

# 1. Verificar Node.js
if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "✅ Node.js encontrado: $(node --version)"
} else {
    Write-Host "❌ Node.js no encontrado. Instalar desde nodejs.org" -ForegroundColor Red
    exit 1
}

# 2. Instalar Turso CLI
Write-Host "📦 Instalando Turso CLI..."
npm install -g @turso/cli

# 3. Verificar instalación
if (Get-Command turso -ErrorAction SilentlyContinue) {
    Write-Host "✅ Turso CLI instalado: $(turso --version)"
} else {
    Write-Host "❌ Error instalando Turso CLI" -ForegroundColor Red
    exit 1
}

# 4. Guía de siguiente paso
Write-Host "🔐 Ejecutá: turso auth login" -ForegroundColor Yellow
Write-Host "📊 Después: turso db create tu-primera-db" -ForegroundColor Yellow
```

### Para macOS/Linux (Bash)
```bash
#!/bin/bash
# setup-turso.sh

echo "🚀 Configurando Turso paso a paso..."

# 1. Verificar Node.js
if command -v node >/dev/null 2>&1; then
    echo "✅ Node.js encontrado: $(node --version)"
else
    echo "❌ Node.js no encontrado. Instalar desde nodejs.org"
    exit 1
fi

# 2. Instalar Turso CLI
echo "📦 Instalando Turso CLI..."
npm install -g @turso/cli

# 3. Verificar instalación
if command -v turso >/dev/null 2>&1; then
    echo "✅ Turso CLI instalado: $(turso --version)"
else
    echo "❌ Error instalando Turso CLI"
    exit 1
fi

# 4. Guía de siguiente paso
echo "🔐 Ejecutá: turso auth login"
echo "📊 Después: turso db create tu-primera-db"
```

---

## 🗄️ Template de Proyecto Base

### Estructura de Carpetas
```
mi-proyecto-turso/
├── .env                    # Variables de entorno
├── .gitignore             # Excluir .env y node_modules
├── package.json           # Dependencias
├── lib/
│   └── db.js             # Helper de conexión
├── scripts/
│   ├── create-tables.js   # Crear estructura
│   ├── seed-data.js      # Datos de ejemplo
│   └── test-connection.js # Probar conexión
└── examples/
    ├── crud-operations.js # Ejemplos CRUD
    └── advanced-queries.js # Consultas complejas
```

### package.json Base
```json
{
  "name": "mi-proyecto-turso",
  "version": "1.0.0",
  "description": "Proyecto base con Turso",
  "main": "index.js",
  "scripts": {
    "dev": "node examples/crud-operations.js",
    "setup": "node scripts/create-tables.js && node scripts/seed-data.js",
    "test": "node scripts/test-connection.js"
  },
  "dependencies": {
    "@libsql/client": "^0.4.2",
    "dotenv": "^16.3.1"
  },
  "keywords": ["turso", "sqlite", "database"],
  "author": "Tu Nombre",
  "license": "MIT"
}
```

### .env Template
```env
# Turso Database Configuration
TURSO_DATABASE_URL=libsql://tu-database.turso.io
TURSO_AUTH_TOKEN=tu-token-secreto

# Application Configuration
NODE_ENV=development
APP_PORT=3000

# Future Integrations (opcional)
NEXTAUTH_SECRET=tu-secret-key
RESEND_API_KEY=tu-resend-key
```

### .gitignore
```gitignore
# Environment variables
.env
.env.local
.env.production

# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
```

---

## 📡 Helper de Conexión Mejorado

### lib/db.js (Versión Avanzada)
```javascript
const { createClient } = require('@libsql/client');

class TursoClient {
  constructor() {
    this.client = null;
    this.isConnected = false;
  }

  connect() {
    if (!this.client) {
      this.client = createClient({
        url: process.env.TURSO_DATABASE_URL,
        authToken: process.env.TURSO_AUTH_TOKEN,
      });
      this.isConnected = true;
    }
    return this.client;
  }

  async execute(sql, params = []) {
    const client = this.connect();
    try {
      const result = await client.execute({
        sql,
        args: params
      });
      return result;
    } catch (error) {
      console.error('Database error:', error.message);
      throw error;
    }
  }

  async queryOne(sql, params = []) {
    const result = await this.execute(sql, params);
    return result.rows[0] || null;
  }

  async queryAll(sql, params = []) {
    const result = await this.execute(sql, params);
    return result.rows;
  }

  async transaction(queries) {
    const client = this.connect();
    try {
      const results = [];
      for (const { sql, params = [] } of queries) {
        const result = await this.execute(sql, params);
        results.push(result);
      }
      return results;
    } catch (error) {
      console.error('Transaction error:', error.message);
      throw error;
    }
  }

  async healthCheck() {
    try {
      const result = await this.queryOne('SELECT 1 as health');
      return result?.health === 1;
    } catch (error) {
      return false;
    }
  }
}

// Singleton instance
const db = new TursoClient();

module.exports = db;
```

### Uso del Helper Mejorado
```javascript
// ejemplo-helper-avanzado.js
require('dotenv').config();
const db = require('./lib/db');

async function ejemploCompleto() {
  try {
    // 1. Health check
    const isHealthy = await db.healthCheck();
    console.log('Database healthy:', isHealthy);

    // 2. Query simple
    const generos = await db.queryAll('SELECT * FROM generos LIMIT 3');
    console.log('Géneros:', generos);

    // 3. Query con parámetros
    const libro = await db.queryOne(
      'SELECT * FROM libros WHERE titulo LIKE ?', 
      ['%JavaScript%']
    );
    console.log('Libro encontrado:', libro);

    // 4. Transacción (múltiples operaciones)
    await db.transaction([
      {
        sql: 'INSERT INTO autores (nombre, apellido) VALUES (?, ?)',
        params: ['Test', 'Author']
      },
      {
        sql: 'UPDATE autores SET activo = ? WHERE nombre = ?',
        params: [true, 'Test']
      }
    ]);

    console.log('Transacción completada');

  } catch (error) {
    console.error('Error:', error.message);
  }
}

ejemploCompleto();
```

---

## 🔍 Script de Diagnóstico

### scripts/diagnostics.js
```javascript
// scripts/diagnostics.js
require('dotenv').config();
const db = require('../lib/db');

async function runDiagnostics() {
  console.log('🔍 Ejecutando diagnósticos de Turso...\n');

  // 1. Variables de entorno
  console.log('1. Verificando configuración:');
  console.log(`   DATABASE_URL: ${process.env.TURSO_DATABASE_URL ? '✅ Configurada' : '❌ Faltante'}`);
  console.log(`   AUTH_TOKEN: ${process.env.TURSO_AUTH_TOKEN ? '✅ Configurado' : '❌ Faltante'}`);
  
  // 2. Conexión
  console.log('\n2. Probando conexión:');
  const isHealthy = await db.healthCheck();
  console.log(`   Conexión: ${isHealthy ? '✅ Exitosa' : '❌ Falló'}`);

  if (!isHealthy) {
    console.log('❌ No se puede conectar a la base de datos');
    return;
  }

  // 3. Verificar tablas
  console.log('\n3. Verificando estructura:');
  try {
    const tables = await db.queryAll(
      "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
    );
    console.log(`   Tablas encontradas: ${tables.length}`);
    tables.forEach(table => {
      console.log(`   - ${table.name}`);
    });

    // 4. Contar registros
    console.log('\n4. Contando registros:');
    for (const table of tables) {
      if (!table.name.startsWith('sqlite_')) {
        try {
          const count = await db.queryOne(`SELECT COUNT(*) as count FROM ${table.name}`);
          console.log(`   ${table.name}: ${count.count} registros`);
        } catch (error) {
          console.log(`   ${table.name}: Error contando`);
        }
      }
    }

    // 5. Test de performance básico
    console.log('\n5. Test de performance:');
    const start = Date.now();
    await db.queryAll('SELECT 1 FROM sqlite_master LIMIT 100');
    const duration = Date.now() - start;
    console.log(`   Latencia: ${duration}ms`);

  } catch (error) {
    console.error('Error en diagnóstico:', error.message);
  }

  console.log('\n✅ Diagnóstico completado');
}

runDiagnostics();
```

---

## ⚡ Quick Start Script

### scripts/quick-start.js
```javascript
// scripts/quick-start.js
require('dotenv').config();
const db = require('../lib/db');

async function quickStart() {
  console.log('🚀 Quick Start de Turso\n');

  try {
    // 1. Verificar conexión
    const isHealthy = await db.healthCheck();
    if (!isHealthy) {
      console.log('❌ Error de conexión. Verificar .env');
      return;
    }
    console.log('✅ Conexión exitosa');

    // 2. Crear tabla de prueba
    await db.execute(`
      CREATE TABLE IF NOT EXISTS quick_test (
        id INTEGER PRIMARY KEY,
        mensaje TEXT,
        fecha DATE DEFAULT CURRENT_DATE
      )
    `);
    console.log('✅ Tabla de prueba creada');

    // 3. Insertar dato de prueba
    const result = await db.execute(
      'INSERT INTO quick_test (mensaje) VALUES (?)',
      ['Hola desde Turso! 🎉']
    );
    console.log(`✅ Registro insertado con ID: ${result.lastInsertRowid}`);

    // 4. Leer datos
    const datos = await db.queryAll('SELECT * FROM quick_test');
    console.log('✅ Datos leídos:', datos);

    // 5. Limpiar
    await db.execute('DROP TABLE quick_test');
    console.log('✅ Limpieza completada');

    console.log('\n🎉 Quick Start exitoso! Tu setup de Turso funciona perfecto.');

  } catch (error) {
    console.error('❌ Error en Quick Start:', error.message);
  }
}

quickStart();
```

### Ejecutar Quick Start
```bash
# Después de configurar .env
npm run test
# o directamente:
node scripts/quick-start.js
```

---

## 🛠️ Comandos de Mantenimiento

### Backup Manual
```bash
# Exportar estructura y datos
turso db shell mi-database --command ".dump" > backup.sql

# Restaurar desde backup (en nueva DB)
turso db create mi-database-restored
cat backup.sql | turso db shell mi-database-restored
```

### Monitoreo
```bash
# Ver estadísticas de uso
turso db show mi-database

# Ver logs (si están disponibles)
turso db logs mi-database

# Listar ubicaciones de réplicas
turso db replica list mi-database
```

### Limpieza
```bash
# Revocar tokens viejos
turso db tokens list mi-database
turso db tokens revoke mi-database [token-name]

# Eliminar réplicas no utilizadas
turso db replica destroy mi-database [location]
```

---

## 🎯 Checklist Final de Validación

Ejecutá estos comandos para validar tu setup:

```bash
# 1. CLI funcionando
turso --version

# 2. Autenticado
turso auth whoami

# 3. Bases de datos visibles
turso db list

# 4. Conexión desde Node.js
node scripts/quick-start.js

# 5. Helper personalizado
node examples/crud-operations.js
```

**Si todos estos comandos funcionan, ¡tu setup está perfecto!** 🎉

---

## 🆘 Problemas Comunes y Soluciones

### "turso: command not found"
```bash
# Reinstalar con npm global
npm install -g @turso/cli

# Verificar PATH
echo $PATH  # macOS/Linux
echo $env:PATH  # Windows PowerShell
```

### "Authentication failed"
```bash
# Logout y login nuevamente
turso auth logout
turso auth login
```

### "Database not found" en aplicación
```javascript
// Verificar variables exactas
console.log('URL:', process.env.TURSO_DATABASE_URL);
console.log('Token presente:', !!process.env.TURSO_AUTH_TOKEN);

// Verificar nombre de base de datos
// turso db list
```

### Performance lenta
```bash
# Verificar ubicación de réplicas
turso db show tu-database

# Crear réplica más cerca (ejemplo para Sudamérica)
turso db replica create tu-database --location scl
```