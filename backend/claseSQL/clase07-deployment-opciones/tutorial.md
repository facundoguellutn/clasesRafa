# Clase 7: Opciones de Deployment - SQLite vs PostgreSQL vs Turso

## 🎯 Objetivos de la Clase

Al finalizar esta clase, Rafa será capaz de:
- Entender las diferencias entre SQLite, PostgreSQL y Turso
- Elegir la base de datos correcta según el proyecto
- Conocer ventajas y desventajas de cada opción
- Prepararse para integrar con Express.js y Next.js
- Entender conceptos de deployment y escalabilidad

---

## 🤔 ¿Por Qué Importa la Elección de Base de Datos?

Hasta ahora usamos **SQLSandbox** para aprender, pero en proyectos reales necesitás elegir:

### Factores Clave a Considerar:
- **Tamaño del proyecto**: ¿Personal o empresarial?
- **Tráfico esperado**: ¿10 usuarios o 10,000?
- **Complejidad**: ¿CRUD simple o análisis complejos?
- **Presupuesto**: ¿Gratis o podés pagar hosting?
- **Mantenimiento**: ¿Querés configurar servidor o algo automático?

---

## 📊 Comparativa General

| Característica | SQLite | PostgreSQL | Turso |
|---------------|---------|------------|-------|
| **Tipo** | Archivo local | Servidor dedicado | SQLite en la nube |
| **Costo** | Gratis | Gratis (self-hosted) / Pago (cloud) | Gratis hasta límite |
| **Setup** | Cero configuración | Configuración compleja | Setup mínimo |
| **Concurrencia** | Limitada | Excelente | Buena |
| **Escalabilidad** | Baja | Alta | Media-Alta |
| **Ideal para** | Prototipos, apps pequeñas | Apps grandes, empresas | Apps modernas, startups |

---

## 🗃️ SQLite: La Base de Datos de Archivo

### ¿Qué es SQLite?
- Base de datos **almacenada en un archivo** (.db, .sqlite)
- **Sin servidor**: La app accede directamente al archivo
- **Embebida**: Incluida en tu aplicación
- **Perfecta para comenzar** y proyectos pequeños

### Ventajas ✅
- **Cero configuración**: Solo un archivo
- **Ultrarrápida** para consultas simples
- **Ideal para desarrollo**: Sin setup de servidor
- **Gratuita y confiable**: Usada en millones de apps
- **Perfecta para aprender**: Sintaxis SQL estándar

### Desventajas ❌
- **Una conexión de escritura a la vez**: Problemas de concurrencia
- **No escalable**: Para proyectos grandes se queda corta  
- **No tiene usuarios/permisos**: Seguridad básica
- **Archivo local**: Si se corrompe, perdés todo

### ¿Cuándo Usar SQLite?
```
✅ PERFECTO PARA:
- Aplicaciones de escritorio
- Prototipos y MVPs
- Apps móviles
- Proyectos personales
- Desarrollo y testing
- Blogs o sites con poco tráfico

❌ NO USAR PARA:
- Apps con muchos usuarios simultáneos
- Sistemas críticos empresariales  
- Apps que necesitan replicación
- Análisis de Big Data
```

### Ejemplo de Uso
```javascript
// En Node.js con SQLite
const Database = require('better-sqlite3');
const db = new Database('mi_app.db');

// Crear tabla
db.exec(`
  CREATE TABLE IF NOT EXISTS usuarios (
    id INTEGER PRIMARY KEY,
    email TEXT UNIQUE,
    nombre TEXT
  )
`);

// Insertar datos
const insert = db.prepare('INSERT INTO usuarios (email, nombre) VALUES (?, ?)');
insert.run('juan@email.com', 'Juan Pérez');
```

---

## 🐘 PostgreSQL: La Base de Datos Empresarial

### ¿Qué es PostgreSQL?
- Base de datos **cliente-servidor** completa
- **Open source** pero con características empresariales
- **Estándar de oro** para aplicaciones serias
- **Extensible**: Soporta JSON, arrays, funciones personalizadas

### Ventajas ✅
- **Concurrencia excelente**: Miles de usuarios simultáneos
- **Muy escalable**: Desde pequeña hasta gigante
- **Características avanzadas**: Triggers, stored procedures, índices complejos
- **ACID completo**: Transacciones robustas
- **Ecosystem maduro**: Herramientas, extensiones, soporte

### Desventajas ❌
- **Setup complejo**: Configuración de servidor
- **Overhead de recursos**: Consume más memoria
- **Curva de aprendizaje**: Muchas opciones y configuraciones
- **Mantenimiento**: Backups, updates, monitoring

### ¿Cuándo Usar PostgreSQL?
```
✅ PERFECTO PARA:
- Aplicaciones empresariales
- E-commerce con muchas transacciones
- Apps con múltiples usuarios
- Sistemas que requieren alta disponibilidad
- Análisis de datos complejos
- Apps que manejan dinero (banking, fintech)

❌ CONSIDERAR OTRAS OPCIONES:
- Prototipos rápidos
- Apps simples con poco tráfico
- Proyectos donde el costo es crítico
- Equipos sin experiencia en DevOps
```

### Ejemplo de Conexión
```javascript
// En Node.js con PostgreSQL
const { Pool } = require('pg');

const pool = new Pool({
  user: 'tu_usuario',
  host: 'localhost',
  database: 'mi_app',
  password: 'tu_password',
  port: 5432,
});

// Consulta
const result = await pool.query('SELECT * FROM usuarios WHERE activo = $1', [true]);
console.log(result.rows);
```

### Hosting PostgreSQL
- **Self-hosted**: Tu propio servidor (más barato, más trabajo)
- **Managed services**: 
  - Heroku Postgres (fácil, caro para escalar)
  - AWS RDS (potente, complejo)
  - Digital Ocean (balance precio/facilidad)
  - Supabase (PostgreSQL + API automática)

---

## ⚡ Turso: SQLite para la Era Moderna

### ¿Qué es Turso?
- **SQLite distribuido**: La simplicidad de SQLite con la escalabilidad de la nube
- **Edge database**: Réplicas cerca de tus usuarios
- **Compatible con SQLite**: Mismo SQL, mejor infraestructura
- **Creado por el equipo de libSQL**: Fork moderno de SQLite

### Ventajas ✅
- **Setup mínimo**: Registro y listo
- **Escalabilidad automática**: Desde 0 a millones de requests
- **Latencia ultra baja**: Réplicas globales
- **Plan gratuito generoso**: Perfecto para aprender y prototipos
- **Compatible**: Migrás fácil desde SQLite
- **Moderno**: Diseñado para apps web actuales

### Desventajas ❌
- **Relativamente nuevo**: Menos tiempo en producción
- **Vendor lock-in**: Dependés de Turso como servicio
- **Limitaciones de SQLite**: Hereda algunas restricciones
- **Menos features**: Comparado con PostgreSQL

### ¿Cuándo Usar Turso?
```
✅ PERFECTO PARA:
- Aplicaciones modernas (Next.js, React)
- Startups que necesitan escalar rápido
- Apps globales (usuarios worldwide)
- Proyectos que empiezan con SQLite
- Developers que quieren simplicidad + poder
- APIs y backends modernos

✅ ESPECIALMENTE BUENO PARA:
- Proyectos con Express.js / Next.js
- Apps que necesitan respuestas súper rápidas
- Equipos pequeños sin DevOps dedicado
```

### Configuración Básica
```javascript
// En Node.js con Turso
import { createClient } from '@libsql/client';

const client = createClient({
  url: process.env.TURSO_DATABASE_URL,
  authToken: process.env.TURSO_AUTH_TOKEN,
});

// Usar como SQLite normal
const result = await client.execute('SELECT * FROM usuarios WHERE activo = ?', [true]);
console.log(result.rows);
```

---

## 🛣️ Ruta de Migración Recomendada

### Para Rafa (Aprendizaje)
```
1. SQLSandbox (Clases 1-5) ✅
   ↓
2. SQLite Local (Clase 6)
   ↓  
3. Turso (Clases 8-18)
   ↓
4. PostgreSQL (Futuro, proyectos grandes)
```

### ¿Por Qué Esta Progresión?
- **SQLite primero**: Entendés el SQL puro sin complejidades
- **Turso después**: Mantenés la simplicidad pero agregás escalabilidad
- **PostgreSQL al final**: Cuando necesites características avanzadas

---

## 🏗️ Preparación para Integración

### Setup para Express.js

#### Con SQLite (Desarrollo)
```bash
npm install better-sqlite3
```

#### Con Turso (Producción moderna)
```bash
npm install @libsql/client dotenv
```

#### Con PostgreSQL (Empresarial)
```bash
npm install pg
npm install -D @types/pg  # Si usás TypeScript
```

### Setup para Next.js 14

#### Variables de Entorno (.env.local)
```env
# SQLite local
DATABASE_PATH=./database.db

# Turso
TURSO_DATABASE_URL=libsql://tu-db.turso.io
TURSO_AUTH_TOKEN=tu-token-aqui

# PostgreSQL
DATABASE_URL=postgresql://user:pass@localhost:5432/mydb
```

---

## 💡 Casos de Uso Reales

### Proyecto 1: Blog Personal
```
Base de datos recomendada: SQLite o Turso
Razón: Pocos usuarios, contenido estático, setup simple
```

### Proyecto 2: E-commerce Pequeño
```
Base de datos recomendada: Turso
Razón: Necesita escalar, transacciones, pero equipo pequeño
```

### Proyecto 3: Sistema Bancario
```
Base de datos recomendada: PostgreSQL
Razón: Transacciones críticas, compliance, características avanzadas
```

### Proyecto 4: App de Estadísticas de Volley (Para Rafa)
```
Base de datos recomendada: Turso
Razón: 
- Empezás simple con SQLite
- Podés escalar si se hace popular
- Fácil de deployar
- Perfecto para Next.js
```

---

## 🚀 Plan de Implementación

### Próximas Clases: Roadmap Técnico

**Clase 8**: Setup de Turso + Primera Integración
- Crear cuenta en Turso
- Configurar proyecto local
- Migrar biblioteca desde SQLSandbox

**Clases 15-16**: Express.js + Turso
- API REST completa
- CRUD operations
- Manejo de errores

**Clase 18**: Next.js + Turso + Server Actions
- Integración full-stack moderna
- Formularios y validaciones
- Deploy en Vercel

---

## 📊 Matriz de Decisión

### ¿Qué Base de Datos Elegir?

Respondé estas preguntas:

1. **¿Es tu primer proyecto con SQL?** → SQLite
2. **¿Necesitás deployar algo simple rápido?** → Turso  
3. **¿Más de 1000 usuarios simultáneos?** → PostgreSQL
4. **¿Presupuesto = $0?** → SQLite o Turso (free tier)
5. **¿Equipo con experiencia DevOps?** → PostgreSQL
6. **¿App global con usuarios worldwide?** → Turso
7. **¿Características avanzadas (ej: full-text search)?** → PostgreSQL
8. **¿Prototipo/MVP rápido?** → SQLite o Turso

### Recomendación para Rafa
**Para los próximos proyectos: Turso**

¿Por qué?
- ✅ Compatible con todo lo que ya aprendiste
- ✅ Setup súper simple
- ✅ Escala automáticamente  
- ✅ Perfecto para Next.js
- ✅ Plan gratuito para aprender
- ✅ Migración fácil desde SQLite

---

## 🎯 Ejercicio Práctico: Análisis de Casos

### Caso A: App de Recetas de Cocina
**Características**: 
- Usuario sube/busca recetas
- Fotos de platos
- Sistema de favoritos
- 500-2000 usuarios estimados

**Tu recomendación:** ________________
**Justificación:** ________________

### Caso B: Sistema de Inventario para Concesionaria
**Características**:
- CRUD de vehículos
- Reportes de ventas
- 5-10 usuarios simultáneos máximo
- Datos críticos de negocio

**Tu recomendación:** ________________  
**Justificación:** ________________

### Caso C: Red Social de Nicho (Volley)
**Características**:
- Perfiles de jugadores
- Estadísticas de partidos
- Chat en tiempo real
- Potencial de crecimiento viral

**Tu recomendación:** ________________
**Justificación:** ________________

### Respuestas Sugeridas:
- **Caso A**: Turso (escalable, global, fácil setup)
- **Caso B**: SQLite/Turso (pocos usuarios, pero datos críticos favorecen backup automático de Turso)
- **Caso C**: Turso inicial, migrar a PostgreSQL si explota (estrategia de crecimiento)

---

## 🏠 Tarea Para Casa

### Investigación Personal
1. **Crear cuenta gratuita en Turso**: [turso.tech](https://turso.tech)
2. **Explorar Supabase**: Alternativa PostgreSQL managed
3. **Investigar precios**: Comparar costos cuando escalás

### Decisión de Proyecto
Para tu próximo proyecto personal (app de volley, concesionaria, etc.):
1. **Definir requisitos**: Usuarios, features, presupuesto
2. **Elegir base de datos** usando los criterios de la clase
3. **Justificar elección** por escrito
4. **Preparar setup** para la próxima clase

---

## 🎯 Próxima Clase: Setup de Entorno Real

En la **Clase 8** vamos a:
- Configurar Turso paso a paso
- Migrar proyecto biblioteca desde SQLSandbox
- Conectar con herramientas locales
- Preparar para integración con Express

**¡Excelente! Ya sabés qué base de datos elegir para cada proyecto. Ahora vamos a la implementación real.**