# Ejercicio 2: Migración de un Segundo Proyecto y Gestión de Réplicas

## 🎯 Objetivo

Reforzar el proceso de creación y migración de bases de datos en Turso con un nuevo proyecto. Además, practicar la gestión de réplicas para entender cómo funciona la distribución global.

---

## 📖 Escenario

Has tenido éxito con el proyecto de la Biblioteca y ahora querés migrar el proyecto de la **Plataforma de E-Learning** de la Clase 6 a Turso. Quieres mantener los proyectos en bases de datos separadas y asegurarte de que la plataforma de e-learning tenga buen rendimiento en Europa, donde esperas tener muchos usuarios.

---

## 🏋️‍♀️ Tu Tarea

### Parte 1: Creación y Migración de la Nueva Base de Datos

1.  **Creá una nueva base de datos** en Turso específicamente para este proyecto. Un buen nombre sería `elearning-plataforma`.

    ```bash
    # Tu comando aquí
    ```

2.  **Generá un nuevo token de autenticación** que no expire para esta nueva base de datos. Guarda el token en un lugar seguro.

    ```bash
    # Tu comando aquí
    ```

3.  **Creá un archivo SQL local** llamado `elearning-schema.sql`. Copiá y pegá dentro de este archivo todas las sentencias `CREATE TABLE` del proyecto de E-Learning de la Clase 6 (las tablas `usuarios`, `cursos`, `lecciones`, `inscripciones`).

4.  **Ejecutá el script `elearning-schema.sql`** contra tu nueva base de datos `elearning-plataforma` usando la CLI de Turso. Utilizá una tubería (`|`) para dirigir el contenido del archivo a la shell de Turso.

    ```bash
    # Pista: cat elearning-schema.sql | turso db shell ...
    # Tu comando aquí
    ```

5.  **Verificá que las tablas se crearon correctamente**. Conectate a la shell de la nueva base de datos y ejecutá un comando para listar todas las tablas.

    ```bash
    # Tu comando para entrar a la shell y luego el comando SQL
    ```

### Parte 2: Gestión de Réplicas

6.  **Listá las ubicaciones de réplicas disponibles** en Turso para ver los códigos de las regiones.

    ```bash
    # Tu comando aquí
    ```

7.  **Creá una réplica** de tu base de datos `elearning-plataforma` en una ubicación de Europa. Un buen ejemplo es Frankfurt (`fra`).

    ```bash
    # Tu comando aquí
    ```

8.  **Verificá el estado de tus réplicas**. Ejecutá un comando que te muestre la lista de réplicas para tu base de datos. Deberías ver la primaria y la nueva que creaste en Europa.

    ```bash
    # Tu comando aquí
    ```

### Parte 3: Conexión al Nuevo Proyecto (Conceptual)

9.  **Creá un nuevo archivo `.env.elearning`**. Dentro, poné las variables de entorno `TURSO_DATABASE_URL` y `TURSO_AUTH_TOKEN` para la base de datos `elearning-plataforma`.

10. **Escribí un pequeño script de Node.js** (en un archivo markdown, no es necesario ejecutarlo) que muestre cómo te conectarías a esta nueva base de datos y harías una consulta para contar el número de cursos. Esto demuestra que entiendes cómo manejar las credenciales para múltiples proyectos.

---

## 💡 Solución Propuesta

<details>
<summary>Click para ver la solución</summary>

```bash
# --- PARTE 1: CREACIÓN Y MIGRACIÓN ---

# 1. Crear nueva DB
turso db create elearning-plataforma

# 2. Generar token
turso db tokens create elearning-plataforma --expiration none

# 3. Crear archivo elearning-schema.sql (contenido de la Clase 6)

# 4. Ejecutar script contra la DB
cat elearning-schema.sql | turso db shell elearning-plataforma

# 5. Verificar tablas
turso db shell elearning-plataforma
# Dentro de la shell:
# .tables
# .exit


# --- PARTE 2: GESTIÓN DE RÉPLICAS ---

# 6. Listar ubicaciones
turso db locations

# 7. Crear réplica en Frankfurt
turso db replica create elearning-plataforma --location fra

# 8. Verificar estado de réplicas
turso db replica list elearning-plataforma

```

**Contenido de `.env.elearning`:**
```env
TURSO_DATABASE_URL=libsql://elearning-plataforma-tu-usuario.turso.io
TURSO_AUTH_TOKEN=el-token-que-generaste-para-elearning
```

**Script conceptual de Node.js (`test-elearning.js`):**
```javascript
// Cargar variables desde un archivo específico
require('dotenv').config({ path: '.env.elearning' });

const { createClient } = require('@libsql/client');

async function testElearningConnection() {
  const client = createClient({
    url: process.env.TURSO_DATABASE_URL,
    authToken: process.env.TURSO_AUTH_TOKEN,
  });

  try {
    const result = await client.execute('SELECT COUNT(*) as total_cursos FROM cursos');
    console.log('Conexión exitosa a la plataforma de e-learning.');
    console.log('Total de cursos en la base de datos:', result.rows[0].total_cursos);
  } catch (error) {
    console.error('Error conectando a la DB de e-learning:', error.message);
  }
}

testElearningConnection();
```

</details>
