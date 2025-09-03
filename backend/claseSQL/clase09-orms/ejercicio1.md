# Ejercicio 1: Configuración del Proyecto

**Objetivo:** Crear un nuevo proyecto desde cero, instalar todas las dependencias necesarias y conectar Prisma a una base de datos de Turso.

Este ejercicio es fundamental para asegurar que tienes el entorno de desarrollo correctamente configurado.

## Pasos a seguir:

1.  **Crear el Directorio del Proyecto:**
    *   En tu terminal, crea una nueva carpeta para este ejercicio llamada `ejercicio-orm-basico`.
    *   Navega dentro de esa carpeta.

2.  **Inicializar el Proyecto de Node.js:**
    *   Ejecuta el comando `npm init -y` para crear un archivo `package.json` por defecto.

3.  **Instalar Dependencias:**
    *   Instala `express`, `@prisma/client` y `@libsql/client` como dependencias de producción.
    *   Instala `prisma` como una dependencia de desarrollo. Revisa el `tutorial.md` si no recuerdas cómo hacerlo.

4.  **Inicializar Prisma:**
    *   Utiliza el comando de `npx` para inicializar Prisma en tu proyecto. Esto debería crear la carpeta `prisma` y el archivo `.env`.

5.  **Configurar el `schema.prisma`:**
    *   Abre el archivo `prisma/schema.prisma`.
    *   Asegúrate de que el `provider` en el `datasource` sea `sqlite`.
    *   Crea un nuevo modelo llamado `Student`. Debe tener los siguientes campos:
        *   `id`: Un `Int`, que sea la clave primaria (`@id`) y autoincremental (`@default(autoincrement())`).
        *   `name`: Un `String`.
        *   `email`: Un `String` que sea único (`@unique`).

6.  **Configurar la Conexión a Turso:**
    *   Ve a tu cuenta de Turso y crea una nueva base de datos (o usa una existente).
    *   Copia la URL de conexión y tu token de autenticación.
    *   Abre el archivo `.env` en la raíz de tu proyecto.
    *   Establece la variable `DATABASE_URL` con el formato `libsql://...` que incluye tu token.

7.  **Ejecutar la Primera Migración:**
    *   Corre el comando `npx prisma migrate dev`.
    *   Cuando te pida un nombre para la migración, puedes escribir `initial-setup`.
    *   Si el comando se ejecuta correctamente, Prisma habrá creado la tabla `Student` en tu base de datos de Turso.

## Verificación:

*   Al final de este ejercicio, deberías tener una estructura de carpetas que incluye `node_modules`, `prisma`, `.env`, `package.json` y `package-lock.json`.
*   El comando `npx prisma migrate dev` debería haber terminado sin errores.
*   Si entras a la consola de tu base de datos en Turso y ejecutas `.tables`, deberías ver la tabla `Student` (y también una tabla `_prisma_migrations`).

¡Si has llegado hasta aquí, tu proyecto está listo para empezar a interactuar con la base de datos!
