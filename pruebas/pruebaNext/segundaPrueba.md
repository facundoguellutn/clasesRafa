# 📘 Parcial 2: Server Actions, Componentes Cliente/Servidor, Asincronismo

## 📝 Multiple Choice
**1. ¿Cuál de estas afirmaciones sobre componentes cliente es correcta?**
a) Pueden acceder a la base de datos.  
b) Usan `use client` al final del archivo.  
c) Pueden usar `useState` y `useEffect`.  
d) Solo pueden renderizar HTML estático.

**2. ¿Qué directiva se usa para declarar una Server Action?**
a) `"use fetch"`  
b) `"server"`  
c) `"use server"`  
d) `"action server"`

**3. ¿Cuál es la diferencia principal entre un componente servidor y uno cliente?**
a) Los componentes servidor no pueden usar hooks
b) Los componentes cliente no pueden hacer peticiones HTTP
c) Los componentes servidor no pueden usar eventos del DOM
d) Los componentes cliente no pueden usar async/await

**4. ¿Qué hook NO está disponible en componentes servidor?**
a) `useState`
b) `useEffect`
c) `useRouter`
d) Todos los anteriores

## ✅ Verdadero o Falso
**5.** Las Server Actions permiten ejecutar código del lado servidor desde formularios sin endpoints.  
**6.** `loading.tsx` es obligatorio en cada ruta.
**7.** Los componentes cliente pueden acceder directamente a variables de entorno del servidor.
**8.** Un componente servidor puede usar el hook `useState`.
**9.** Las Server Actions pueden ser invocadas desde cualquier componente cliente.

## ✍️ Completar
**10.** El archivo que se renderiza mientras se espera la carga de un componente asíncrono es `____________`.

**11.** Un componente cliente debe comenzar con la línea `__________`.

**12.** Para manejar errores en componentes asíncronos, se usa el archivo `____________`.

**13.** La directiva para declarar una Server Action debe ir al `____________` del archivo.

## 💬 Respuesta breve
**14.** ¿Para qué sirve `loading.tsx` y qué ventaja ofrece en la UX?

**15.** Explica la diferencia entre un componente servidor y uno cliente en Next.js.

**16.** ¿Por qué es importante usar Server Actions en lugar de endpoints tradicionales?

**17.** Describe el flujo de datos cuando se usa una Server Action en un formulario.

## 🔧 Ejercicio Integrador
**18.** Crear un formulario de login que use una Server Action para imprimir en consola el `email` ingresado. Mostrar en un `loading.tsx` un mensaje de "Procesando login..." mientras se carga.

**19.** Implementar un componente que muestre una lista de usuarios obtenida de una API, utilizando:
- Un componente servidor para la obtención de datos
- Un componente cliente para la interactividad
- Un archivo loading.tsx para el estado de carga
- Un archivo error.tsx para manejar errores

**20.** Crear un sistema de comentarios donde:
- Los usuarios puedan agregar comentarios usando Server Actions
- Se muestre un estado de carga mientras se procesa el comentario
- Se actualice la lista de comentarios sin recargar la página
- Se manejen los errores apropiadamente
