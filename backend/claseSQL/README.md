# SQL y Bases de Datos Relacionales - Plan Semestral para Rafa

## 🎯 Objetivo General

Transicionar de MongoDB (NoSQL) a SQL (relacional), desarrollando competencias sólidas en bases de datos relacionales, su integración con backends (Express.js) y aplicaciones fullstack (Next.js).

---

## 📚 Estructura del Plan (18 Clases)

### BLOQUE 1: Fundamentos SQL 🌱
**Objetivo**: Dominar conceptos básicos y sintaxis esencial

| Clase | Tema | Herramienta | Estado |
|-------|------|-------------|---------|
| **1** | [¿Qué es SQL? Introducción y conceptos clave](clase01-introduccion/tutorial.md) | SQLSandbox | ✅ |
| **2** | [Sintaxis básica - SELECT, WHERE, ORDER BY, LIMIT](clase02-sintaxis-basica/tutorial.md) | SQLSandbox | ✅ |
| **3** | [Creación de tablas - CREATE TABLE, tipos de datos, constraints](clase03-creacion-tablas/tutorial.md) | SQLSandbox | ✅ |
| **4** | [Manipulación de datos - INSERT, UPDATE, DELETE](clase04-manipulacion-datos/tutorial.md) | SQLSandbox | ✅ |
| **5** | [Práctica consolidación - Proyecto "Mi Biblioteca Personal"](clase05-proyecto-biblioteca/tutorial.md) | SQLSandbox | ✅ |

### BLOQUE 2: Estructura y Deployment 🏗️
**Objetivo**: Entender opciones de infraestructura y preparar entorno de desarrollo

| Clase | Tema | Herramienta | Estado |
|-------|------|-------------|---------|
| **6** | Índices, claves primarias y foráneas - Performance y integridad | SQLite Browser | 🔄 |
| **7** | [Opciones de deployment - SQLite vs PostgreSQL vs Turso vs PlanetScale](clase07-deployment-opciones/tutorial.md) | Comparativa | ✅ |
| **8** | Setup de entorno - Local, cloud y preparación para proyectos | Turso + Local | 🔄 |

### BLOQUE 3: Relaciones y Diseño 🔗
**Objetivo**: Dominar el diseño relacional y normalización

| Clase | Tema | Herramienta | Estado |
|-------|------|-------------|---------|
| **9** | Relaciones entre tablas - 1:1, 1:N, N:M con ejemplos | SQLite + Diagrams | 🔄 |
| **10** | JOINS - INNER, LEFT, RIGHT, FULL con casos prácticos | SQLSandbox | 🔄 |
| **11** | Normalización - 1NF, 2NF, 3NF paso a paso | Teoría + Práctica | 🔄 |
| **12** | Diseño de schema - Proyecto "Sistema de Turnos Médicos" | DB Designer | 🔄 |

### BLOQUE 4: SQL Avanzado 🚀
**Objetivo**: Queries complejas y análisis de datos

| Clase | Tema | Herramienta | Estado |
|-------|------|-------------|---------|
| **13** | Funciones agregadas - COUNT, SUM, AVG, GROUP BY, HAVING | SQLSandbox | 🔄 |
| **14** | Subconsultas y queries complejas - EXISTS, IN, correlated queries | SQLSandbox | 🔄 |

### BLOQUE 5: Integración Backend 💻
**Objetivo**: Conectar SQL con aplicaciones Node.js

| Clase | Tema | Herramienta | Estado |
|-------|------|-------------|---------|
| **15** | SQL con Express.js - Conexión a Turso y queries básicas | Express + Turso | 🔄 |
| **16** | API REST completa con SQL - CRUD operations | Express + Turso | 🔄 |
| **17** | ORMs - Introducción a Prisma con Turso | Prisma ORM | 🔄 |

### BLOQUE 6: Fullstack Integration 🌐
**Objetivo**: Aplicar SQL en proyectos Next.js completos

| Clase | Tema | Herramienta | Estado |
|-------|------|-------------|---------|
| **18** | SQL con Next.js - Server Actions con Turso y proyecto final | Next.js 14 + Turso | 🔄 |

---

## 🛠️ Herramientas Progresivas

### Fase 1: Aprendizaje (Clases 1-8)
- **[SQLSandbox.com](https://sqlsandbox.com)** - Práctica online sin setup
- **DB Browser for SQLite** - Visualización local
- **SQLite** - Base de datos local simple

### Fase 2: Desarrollo (Clases 9-18)  
- **[Turso](https://turso.tech)** - SQLite distribuido para producción
- **Express.js** - Backend integration
- **Next.js 14** - Fullstack con Server Actions
- **Prisma ORM** - Abstracción moderna

---

## 📋 Metodología de Enseñanza

### Para Clases con SQLSandbox (1-5, 9-14)
1. **Contexto real** (5 min): ¿Para qué sirve en el mundo real?
2. **Demo en SQLSandbox** (10 min): Comandos paso a paso
3. **Código inicial** (5 min): Script para crear tablas con datos
4. **Ejercicio guiado** (15 min): Rafa practica junto conmigo
5. **Ejercicio individual** (15 min): Rafa resuelve solo
6. **Tarea para casa**: Queries adicionales para reforzar

### Para Proyectos Integrados (6-8, 15-18)
1. **Repaso del concepto** (5 min)
2. **Setup del entorno** (10 min): Turso, conexiones, instalaciones
3. **Implementación paso a paso** (20 min): Código explicado línea por línea
4. **Testing y verificación** (10 min): ¿Funciona correctamente?
5. **Tarea individual**: Expandir funcionalidad

---

## 🎯 Proyectos Principales

### Proyecto 1: Mi Biblioteca Personal (Clase 5)
**Tecnología**: SQLSandbox
**Objetivo**: Consolidar CRUD básico y relaciones simples
**Características**:
- Tabla de libros y autores
- Queries de búsqueda y filtrado
- Estadísticas básicas

### Proyecto 2: Sistema de Turnos Médicos (Clase 12)
**Tecnología**: SQLite local + DB Browser
**Objetivo**: Diseño relacional completo y normalización
**Características**:
- Doctores, pacientes, turnos, especialidades
- Relaciones 1:N y N:M
- Diseño normalizado

### Proyecto 3: API REST con SQL (Clases 15-16)
**Tecnología**: Express.js + Turso
**Objetivo**: Integración backend real
**Características**:
- CRUD completo via API
- Validaciones y manejo de errores
- Testing con Postman

### Proyecto 4: App Fullstack Final (Clase 18)
**Tecnología**: Next.js 14 + Turso + Prisma
**Objetivo**: Aplicación completa SQL-powered
**Características**:
- Server Actions con SQL
- Forms y validaciones
- Dashboard con estadísticas

---

## 🏋️ Sistema de Ejercicios

### Ejercicios por Clase
Cada clase incluye:
- **Código inicial**: Setup completo para SQLSandbox
- **Ejercicios guiados**: Paso a paso en clase
- **Ejercicios individuales**: Para resolver solo
- **Desafíos extra**: Para estudiantes avanzados
- **Tarea para casa**: Refuerzo de conceptos

### Niveles de Dificultad
- 🟢 **Básico**: Sintaxis fundamental
- 🟡 **Intermedio**: Combinación de conceptos
- 🔴 **Avanzado**: Queries complejas y casos reales

---

## 🎮 Adaptación al Estilo de Rafa

### Conectar con Sus Intereses
- **Estadísticas de volley**: Tablas de jugadores, partidos, rankings
- **Concesionaria**: Inventario de vehículos, clientes, ventas
- **Apps conocidas**: Migrar proyectos existentes de MongoDB a SQL

### Metodología Probada
- **Código inicial siempre**: Nunca empezar desde cero
- **Verificación constante**: "¿Se ve bien el resultado?"
- **Comparación con MongoDB**: "En Mongoose hacíamos X, en SQL hacemos Y"
- **Proyectos aplicables**: Cada concepto conectado a casos reales

### Progresión de Herramientas
1. **SQLSandbox** → Sin setup, práctica inmediata
2. **SQLite local** → Entender persistencia en archivos  
3. **Turso** → Producción moderna sin complejidad
4. **Prisma** → Abstracción familiar (como Mongoose)

---

## 📊 Seguimiento del Progreso

### Checkpoints por Bloque
- **Bloque 1**: ¿Puede hacer queries básicas de forma autónoma?
- **Bloque 2**: ¿Entiende las opciones de deployment y setup?
- **Bloque 3**: ¿Puede diseñar un schema relacional normalizado?
- **Bloque 4**: ¿Maneja queries complejas y análisis de datos?
- **Bloque 5**: ¿Integra SQL con backends de forma competente?
- **Bloque 6**: ¿Construye apps fullstack con SQL efectivamente?

### Evaluación Continua
- Ejercicios completados por clase
- Participación en resolución de problemas
- Autonomía progresiva en la resolución
- Capacidad de conectar conceptos

---

## 🔗 Recursos Adicionales

### Documentación
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [Turso Documentation](https://docs.turso.tech/)
- [Prisma Documentation](https://www.prisma.io/docs)

### Herramientas Online
- [SQLSandbox](https://sqlsandbox.com) - Práctica interactiva
- [DB Diagram](https://dbdiagram.io/) - Diseño visual de schemas
- [SQL Formatter](https://sqlformat.org/) - Formatear queries

### Referencias Rápidas
- [SQL Cheat Sheet](https://www.w3schools.com/sql/)
- [SQLite vs PostgreSQL](https://tableplus.com/blog/2018/08/sqlite-vs-postgresql-which-database-to-use-and-why.html)

---

**¡Comenzamos el viaje hacia el dominio de SQL y bases de datos relacionales! 🚀**