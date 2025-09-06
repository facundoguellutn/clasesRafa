# Ejercicios Prácticos: Clase 11

Crea un archivo `promesas.js` y realiza los siguientes ejercicios. Puedes ejecutarlos con Node.js.

---

### ✅ Ejercicio 1: De Callback a Promesa

1.  Crea una función llamada `simularDescarga` que no reciba argumentos.
2.  Dentro de la función, crea y devuelve una `new Promise`.
3.  En el constructor de la promesa, usa un `setTimeout` para simular una descarga de 2.5 segundos.
4.  Después del `setTimeout`, la promesa debe **resolverse** con el mensaje `"¡Descarga completada!"`.
5.  Llama a `simularDescarga()` y usa `.then()` para mostrar el mensaje de éxito en la consola.

---

### ✅ Ejercicio 2: Manejando Errores

1.  Crea una nueva función `verificarUsuario` que reciba un `nombreUsuario`.
2.  La función debe devolver una `new Promise`.
3.  Dentro de la promesa, simula una verificación con un `setTimeout` de 1.5 segundos.
4.  Si el `nombreUsuario` es `"Rafa"`, la promesa debe **resolverse** con un objeto `{ exito: true, mensaje: "Usuario verificado." }`.
5.  Si el `nombreUsuario` es cualquier otro, la promesa debe **rechazarse** con un `new Error("Usuario no encontrado.")`.
6.  Llama a la función dos veces: una con `"Rafa"` y otra con `"Facu"`.
7.  Usa `.then()` para el caso de éxito y `.catch()` para mostrar el mensaje de error en la consola.

---

### ✅ Ejercicio 3: Encadenando Promesas

Imagina que necesitas verificar al usuario y luego obtener sus datos.

1.  Reutiliza la función `verificarUsuario` del ejercicio anterior.
2.  Crea una nueva función `obtenerDatosUsuario` que reciba el objeto de éxito de la verificación. Debe devolver una `new Promise` que se resuelva después de 2 segundos con un objeto de datos de usuario (ej: `{ nombre: 'Rafa', edad: 30, ciudad: 'Bs As' }`).
3.  Llama a `verificarUsuario("Rafa")`.
4.  Encadena un `.then()`: en este primer `.then()`, comprueba si la verificación fue exitosa. Si lo fue, **devuelve la llamada a `obtenerDatosUsuario()`**.
5.  Encadena un segundo `.then()` que recibirá los datos del usuario y los mostrará en consola.
6.  Añade un `.catch()` al final de la cadena para atrapar cualquier error que pueda ocurrir en cualquiera de las dos promesas.

---

### 🏆 Desafío: `Promise.all`

Necesitas cargar la configuración y los datos del usuario al mismo tiempo antes de iniciar tu aplicación.

1.  Crea una función `cargarConfiguracion` que devuelva una promesa que se resuelva en 2 segundos con un objeto `{ tema: 'dark', idioma: 'es' }`.
2.  Crea una función `cargarDatosUsuario` que devuelva una promesa que se resuelva en 3 segundos con un objeto `{ nombre: 'Rafa', email: 'rafa@test.com' }`.
3.  Usa `Promise.all()` para ejecutar ambas funciones al mismo tiempo.
4.  Cuando `Promise.all()` se resuelva, usa `.then()` para recibir el array de resultados.
5.  Desestructura el array de resultados y muestra un mensaje en consola como: `"Configuración y datos listos. Tema: dark, Nombre de usuario: Rafa"`.
