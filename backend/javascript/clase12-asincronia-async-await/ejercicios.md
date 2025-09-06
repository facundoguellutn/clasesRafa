# Ejercicios Prácticos: Clase 12

Crea un archivo `async-await.js` y realiza los siguientes ejercicios. Usaremos la API pública [JSONPlaceholder](https://jsonplaceholder.typicode.com/) para simular peticiones de red reales.

---

### ✅ Ejercicio 1: Refactorizando a `async/await`

1.  Toma la función `verificarUsuario` que creaste en los ejercicios de la Clase 11 (la que devolvía una promesa).
2.  Crea una nueva función `async` llamada `iniciarSesion` que reciba un `nombreUsuario`.
3.  Dentro de `iniciarSesion`, usa un bloque `try...catch`.
4.  En el `try`, usa `await` para llamar a `verificarUsuario`. Si tiene éxito, muestra en consola el mensaje de éxito.
5.  En el `catch`, muestra en consola el mensaje de error.
6.  Llama a `iniciarSesion` dos veces, una con un usuario válido (`"Rafa"`) y otra con uno inválido para probar ambos caminos.

---

### ✅ Ejercicio 2: Petición simple con `fetch`

1.  Crea una función `async` llamada `obtenerPost` que reciba un `id` de post.
2.  Dentro de un `try...catch`, usa `fetch` y `await` para obtener un post de la API. La URL es: `https://jsonplaceholder.typicode.com/posts/[id]` (reemplaza `[id]` por el parámetro).
3.  Recuerda que `fetch` devuelve una respuesta, y necesitas usar `await response.json()` para obtener el cuerpo del post en formato JSON.
4.  La función debe **devolver** el objeto del post.
5.  Llama a la función con un id (ej: `10`) y, como la función devuelve una promesa, usa `.then()` para mostrar el título del post en consola.

---

### ✅ Ejercicio 3: Encadenando Peticiones

El objetivo es obtener un post y luego obtener los datos del autor de ese post.

1.  Crea una función `async` llamada `obtenerPostYAutor` que reciba un `id` de post.
2.  Dentro de un `try...catch`:
    a.  Primero, haz `await` a la petición para obtener el post (como en el ejercicio 2).
    b.  Del objeto `post` que obtienes, extrae la propiedad `userId`.
    c.  Usa ese `userId` para hacer una **segunda petición** con `await` a la URL de usuarios: `https://jsonplaceholder.typicode.com/users/[userId]`.
    d.  Obtén el JSON del usuario.
    e.  Muestra en consola un mensaje combinado, como: `"Post: [título del post] - Escrito por: [nombre del autor]"`.
3.  Llama a `obtenerPostYAutor` con un id de post (ej: `25`).

---

### 🏆 Desafío: Peticiones en Paralelo con `Promise.all`

Quieres cargar varios recursos a la vez para que tu aplicación se inicie más rápido.

1.  Crea un array de IDs de usuarios, por ejemplo: `const idsUsuarios = [1, 3, 5, 7];`
2.  Crea una función `async` llamada `obtenerVariosUsuarios`.
3.  Dentro de la función, usa el método `map` sobre el array `idsUsuarios` para crear un **nuevo array de promesas**. Cada elemento del nuevo array será una llamada a `fetch` para obtener el usuario correspondiente (ej: `fetch('https://.../users/[id]')`). **¡No uses `await` dentro del `map`!**
4.  Usa `await Promise.all()` con el array de promesas que acabas de crear para esperar a que todas se completen.
5.  Las respuestas de `Promise.all` serán un array de objetos `Response`. Usa `map` y `Promise.all` de nuevo para convertir todas las respuestas a JSON.
6.  Finalmente, muestra en consola el array de objetos de usuario.

Este es un patrón muy potente y común para optimizar la carga de datos.
