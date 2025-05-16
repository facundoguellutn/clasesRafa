# 📘 Parcial 3: Endpoints con route.ts y API en Next.js

## 📝 Multiple Choice
**1. ¿Dónde se colocan los archivos para definir un endpoint REST en Next.js 14 App Router?**
a) Dentro de `pages/api`  
b) En `routes/api`  
c) Dentro de `app/api/[nombre]/route.ts`  
d) En `server/api`

**2. ¿Cuál de estas funciones es válida dentro de un `route.ts`?**
a) `RECEIVE()`  
b) `SEND()`  
c) `POST()`  
d) `CLIENT()`

**3. ¿Qué método HTTP NO está soportado por defecto en route.ts?**
a) GET
b) POST
c) PUT
d) Todos están soportados

**4. ¿Cuál es la forma correcta de manejar diferentes métodos HTTP en route.ts?**
a) Usando un switch statement
b) Exportando funciones con el nombre del método
c) Usando un objeto de configuración
d) No es posible manejar múltiples métodos

## ✅ Verdadero o Falso
**5.** `NextRequest` se usa para obtener datos del request como body o headers.  
**6.** Un endpoint en `app/api/user/route.ts` genera la ruta `/api/user`.
**7.** Los endpoints en Next.js 14 pueden ser asíncronos.
**8.** Es posible usar middleware en los endpoints de la API.
**9.** Los endpoints pueden acceder a las variables de entorno del servidor.

## ✍️ Completar
**10.** Para leer el body de una request tipo POST se usa `await req.__________()`.

**11.** Para retornar una respuesta JSON se usa `Next__________.json()`.

**12.** Para manejar errores en un endpoint se usa `Next__________.error()`.

**13.** Para obtener parámetros de la URL se usa `req.__________.get()`.

## 💬 Respuesta breve
**14.** ¿Cuál es la diferencia entre usar un endpoint REST y una Server Action para enviar datos?

**15.** Explica cómo se manejan los diferentes métodos HTTP en un archivo route.ts.

**16.** ¿Qué ventajas ofrece NextResponse sobre Response nativa de fetch?

**17.** Describe el proceso de validación de datos en un endpoint de Next.js.

## 🔧 Ejercicio Integrador
**18.** Crear un endpoint `POST /api/contact` que reciba un `nombre` y un `mensaje`, y devuelva un JSON con `Gracias, {nombre}`.

**19.** Implementar un CRUD completo para una API de tareas (todos) con los siguientes endpoints:
- GET /api/todos - Listar todas las tareas
- POST /api/todos - Crear una nueva tarea
- PUT /api/todos/[id] - Actualizar una tarea existente
- DELETE /api/todos/[id] - Eliminar una tarea
Incluir validación de datos y manejo de errores.

**20.** Crear un sistema de autenticación con los siguientes endpoints:
- POST /api/auth/register - Registrar un nuevo usuario
- POST /api/auth/login - Iniciar sesión
- GET /api/auth/me - Obtener información del usuario actual
- POST /api/auth/logout - Cerrar sesión
Implementar:
- Validación de datos
- Manejo de tokens JWT
- Middleware de autenticación
- Respuestas con códigos HTTP apropiados
