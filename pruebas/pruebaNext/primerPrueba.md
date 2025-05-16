# 📘 Parcial 1: Introducción a Next.js 14 y Estructura de Proyecto

## 📝 Multiple Choice
**1. ¿Cuál de las siguientes opciones es correcta respecto a las rutas en Next.js 14?**
a) Las rutas se configuran en `routes.js` manualmente.  
b) Cada carpeta dentro de `app/` representa una ruta.  
c) Se deben declarar en el archivo `next.config.js`.  
d) Las rutas sólo se generan usando `pages/`.

**2. ¿Qué archivo representa la página principal del sitio?**
a) `index.tsx`  
b) `main.tsx`  
c) `page.tsx` dentro de `app/`  
d) `layout.tsx`

**3. ¿Cuál es la diferencia principal entre `use client` y `use server` en Next.js 14?**
a) `use client` es para componentes del servidor y `use server` para el cliente
b) `use client` marca código que se ejecuta en el navegador y `use server` en el servidor
c) Son sinónimos y se pueden usar indistintamente
d) `use client` es para páginas y `use server` para layouts

**4. ¿Qué función cumple el archivo `loading.tsx` en Next.js 14?**
a) Define la configuración de carga de la aplicación
b) Muestra un estado de carga mientras se carga una página o sección
c) Configura el tiempo de carga de los recursos
d) Es un archivo obsoleto en Next.js 14

## ✅ Verdadero o Falso
**5.** `layout.tsx` se ejecuta por cada ruta que se visita.  
**6.** En Next.js 14 los archivos `page.tsx` pueden tener código asíncrono en el servidor.
**7.** Los archivos `error.tsx` son necesarios para manejar errores en cada ruta.
**8.** `metadata.ts` se usa para definir metadatos de SEO en Next.js 14.

## ✍️ Completar
**9.** Para crear una página dinámica como `/producto/[id]`, se debe crear el archivo `___________`.

**10.** En `page.tsx`, el objeto que contiene los parámetros dinámicos de la URL se llama `___________`.

**11.** Para crear una ruta que capture todos los segmentos restantes de la URL, se usa el patrón `___________`.

**12.** El archivo `___________` se usa para definir la configuración de la aplicación Next.js.

## 💬 Respuesta breve
**13.** ¿Cuál es la función principal del archivo `layout.tsx`?

**14.** Explica la diferencia entre Server Components y Client Components en Next.js 14.

**15.** ¿Qué ventajas ofrece el sistema de rutas basado en carpetas de Next.js 14?

**16.** Describe el propósito de los archivos `not-found.tsx` y `error.tsx`.

## 🔧 Ejercicio Integrador
**17.** Crear una estructura de carpetas en `app/` que incluya:
- Una página `/about`
- Una página dinámica `/blog/[slug]`
- Un layout general y uno para una sección `/admin`

**18.** Implementar una página de productos que:
- Muestre una lista de productos en `/productos`
- Tenga páginas individuales en `/productos/[id]`
- Incluya un layout específico para la sección de productos
- Implemente manejo de errores y estados de carga

**19.** Crear una estructura de autenticación que incluya:
- Página de login en `/auth/login`
- Página de registro en `/auth/register`
- Layout específico para la sección de autenticación
- Middleware para proteger rutas privadas

**20.** Desarrollar un blog con:
- Página principal en `/blog`
- Páginas de categorías en `/blog/categoria/[slug]`
- Páginas de posts en `/blog/[slug]`
- Sistema de búsqueda y filtrado
