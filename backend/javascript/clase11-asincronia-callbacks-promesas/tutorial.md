# Clase 11: Asincronía - Callbacks y Promesas

## 🎯 Objetivos de la Clase

Al finalizar esta clase, serás capaz de:
- Diferenciar entre código síncrono y asíncrono.
- Entender el rol de los callbacks en el manejo de la asincronía.
- Reconocer el problema del "Callback Hell".
- Entender qué es una Promesa y cómo resuelve este problema.
- Consumir promesas usando `.then()` para el éxito y `.catch()` para el error.

---

## 🤔 ¿Síncrono vs. Asíncrono?

JavaScript solo puede hacer una cosa a la vez (es de un solo hilo o *single-threaded*).

- **Código Síncrono (Bloqueante)**: Es como una llamada telefónica. Haces una petición y tienes que esperar a que termine para poder continuar. Si una tarea tarda mucho (ej: leer un archivo grande), toda la página se congela.

- **Código Asíncrono (No Bloqueante)**: Es como enviar un mensaje de WhatsApp. Envías la petición, y puedes seguir haciendo otras cosas. Cuando la respuesta llega, una "notificación" (un callback o una promesa) te avisa para que la proceses. Esto es esencial para tareas como peticiones a un servidor, para que la interfaz nunca se congele.

---

## 📞 1. Callbacks: La Forma Clásica

Un **callback** es simplemente una función que se pasa como argumento a otra función, con la intención de que sea ejecutada más tarde, cuando una operación asíncrona haya terminado.

`setTimeout` es el ejemplo perfecto. Le pides que ejecute una función (el callback) después de un cierto tiempo.

```javascript
console.log("1. Inicio del programa.");

setTimeout(function() { // Este es el callback
    console.log("2. La operación asíncrona (setTimeout) ha terminado.");
}, 2000); // 2000 milisegundos = 2 segundos

console.log("3. El programa continúa sin esperar.");

// El orden en la consola será: 1, 3, 2
```

### El Problema: "Callback Hell" (El Infierno de los Callbacks)

¿Qué pasa si necesitas hacer varias operaciones asíncronas una después de la otra? Terminas anidando callbacks dentro de callbacks, creando una estructura piramidal difícil de leer y de manejar errores.

```javascript
// NO HAGAS ESTO EN CASA
api.obtenerUsuario('rafa', function(usuario) {
    api.obtenerPosts(usuario.id, function(posts) {
        api.obtenerComentarios(posts[0].id, function(comentarios) {
            console.log(comentarios);
        }, function(errorComentarios) { /* ... */ });
    }, function(errorPosts) { /* ... */ });
}, function(errorUsuario) { /* ... */ });
```

---

## 🤞 2. Promesas (Promises): La Solución

> **Analogía**: Una **Promesa** es como un **comprobante de compra**. Cuando pides algo que tarda en llegar (ej: un café), no te quedas parado esperando. Te dan un ticket (la Promesa) y sigues con tu vida. El ticket te "promete" que en el futuro recibirás tu café (la promesa se **resuelve**) o te dirán que se acabó el grano (la promesa se **rechaza**).

Una Promesa es un objeto que representa el resultado eventual (éxito o fracaso) de una operación asíncrona.

### Los 3 Estados de una Promesa
1.  **Pending (Pendiente)**: El estado inicial. La operación aún no ha terminado.
2.  **Fulfilled (Cumplida/Resuelta)**: La operación terminó con éxito.
3.  **Rejected (Rechazada)**: La operación falló.

### Consumiendo Promesas: `.then()` y `.catch()`

En lugar de anidar callbacks, encadenamos métodos a la promesa.

```javascript
// fetch() es una función del navegador que devuelve una promesa
const promesaDeDatos = fetch('https://jsonplaceholder.typicode.com/users/1');

console.log("Promesa creada. Estado: Pending.");

promesaDeDatos
    .then(function(respuesta) { // Se ejecuta si la promesa es FULFILLED
        console.log("Promesa cumplida. Procesando respuesta...");
        return respuesta.json(); // .json() también devuelve una promesa
    })
    .then(function(datosDeUsuario) { // Se encadena al .then anterior
        console.log("Datos finales:", datosDeUsuario.name);
    })
    .catch(function(error) { // Se ejecuta si la promesa es REJECTED en cualquier punto
        console.error("¡Hubo un error!", error);
    });
```

Observa cómo el código es plano y mucho más legible que el Callback Hell. Cada `.then` maneja un paso de la operación.

---

## 🤓 Conceptos Clave para Recordar

- **Asincronía**: Permite que JavaScript realice tareas largas sin bloquear la aplicación.
- **Callback**: Una función pasada como argumento para ser ejecutada después.
- **Callback Hell**: El problema de anidar callbacks, haciendo el código ilegible.
- **Promesa**: Un objeto que representa un valor futuro. Es la solución al Callback Hell.
- **`.then()`**: Se encadena a una promesa para manejar el caso de éxito.
- **`.catch()`**: Se encadena para manejar el caso de error.

---

## 🎯 Lo Que Viene en la Próxima Clase

Las promesas son fantásticas, pero JavaScript nos ofrece una forma aún más limpia y moderna de trabajar con ellas. En la **Clase 12**, aprenderemos sobre **`async/await`**, una sintaxis que nos permite escribir código asíncrono como si fuera síncrono.
