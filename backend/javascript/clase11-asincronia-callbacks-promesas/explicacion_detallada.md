# Explicación Detallada: El Motor de la Asincronía

## 🎯 Objetivo de este Documento

Explorar el funcionamiento interno del modelo de asincronía de JavaScript (el Event Loop) y profundizar en las capacidades avanzadas de las Promesas.

---

## ⚙️ El Event Loop: El Secreto de la Asincronía

Ya mencionamos que JavaScript es de un solo hilo. ¿Cómo gestiona las operaciones asíncronas sin bloquearse? Lo hace a través de varios componentes que trabajan juntos:

1.  **Call Stack (Pila de Llamadas)**: Donde se ejecuta el código síncrono. Solo una cosa a la vez.
2.  **Web APIs (APIs del Navegador/Node.js)**: Son parte del entorno, no del motor de JS. Aquí es donde viven las operaciones asíncronas mientras se completan (`setTimeout`, `fetch`, manipulación del DOM).
3.  **Task Queue (o Callback Queue)**: Una cola donde se colocan los callbacks de las Web APIs que han terminado (ej: la función de un `setTimeout`).
4.  **Microtask Queue**: Una cola especial y de **alta prioridad**. Aquí es donde se colocan los callbacks de las Promesas (los `.then`, `.catch`, `.finally`).
5.  **Event Loop (Bucle de Eventos)**: Su único trabajo es vigilar el Call Stack y las colas. Su regla es: **"Si el Call Stack está vacío, revisa la Microtask Queue. Si hay algo, pásalo al Call Stack. Si no, revisa la Task Queue y pasa lo que haya".**

> **La clave**: Las microtareas (Promesas) siempre tienen prioridad sobre las macrotareas (setTimeout, clicks). Esto asegura que los resultados de las promesas se procesen lo antes posible.

---

## 🛠️ Creando tus Propias Promesas

A menudo consumirás promesas de APIs como `fetch`, pero también puedes crear las tuyas para "prometizar" operaciones basadas en callbacks.

Se usa el constructor `new Promise()`, que recibe una función con dos argumentos: `resolve` y `reject`.

- `resolve(valor)`: Llama a esta función cuando tu operación asíncrona termina con éxito. El `valor` se pasará al `.then()`.
- `reject(error)`: Llama a esta función cuando la operación falla. El `error` se pasará al `.catch()`.

```javascript
function descargarArchivo(url) {
    return new Promise((resolve, reject) => {
        console.log(`Descargando desde ${url}...`);
        setTimeout(() => {
            if (url.includes('google')) {
                resolve("Contenido del archivo de Google");
            } else {
                reject(new Error("URL no permitida"));
            }
        }, 3000);
    });
}

descargarArchivo('https://google.com')
    .then(contenido => console.log(contenido))
    .catch(err => console.error(err.message));
```

---

## ✨ Métodos Estáticos de `Promise`

Son herramientas para manejar múltiples promesas a la vez.

### `Promise.all(arrayDePromesas)`
Espera a que **todas** las promesas del array se cumplan. Si una sola falla, toda la `Promise.all` se rechaza inmediatamente.

**Caso de uso**: Necesitas datos de dos APIs diferentes antes de poder renderizar una vista.

```javascript
const promesaUsuario = fetch('https://.../user/1');
const promesaPosts = fetch('https://.../user/1/posts');

Promise.all([promesaUsuario, promesaPosts])
    .then(arrayDeRespuestas => {
        // arrayDeRespuestas[0] es la respuesta de la primera promesa
        // arrayDeRespuestas[1] es la respuesta de la segunda
        return Promise.all(arrayDeRespuestas.map(res => res.json()));
    })
    .then(([datosUsuario, datosPosts]) => {
        console.log("Usuario:", datosUsuario.name);
        console.log("Posts:", datosPosts.length);
    })
    .catch(err => console.error("Alguna de las promesas falló", err));
```

### `Promise.race(arrayDePromesas)`
Espera a que la **primera** promesa del array se cumpla o se rechace. Tan pronto como una termina (para bien o para mal), `Promise.race` se resuelve o se rechaza con el resultado de esa primera promesa.

**Caso de uso**: Tienes varios servidores redundantes y quieres la respuesta del que conteste más rápido.

### `Promise.allSettled(arrayDePromesas)`
Espera a que **todas** las promesas terminen, sin importar si se cumplieron o se rechazaron. Devuelve un array de objetos que describen el resultado de cada promesa.

**Caso de uso**: Quieres intentar cargar varios recursos, pero no te importa si alguno falla; quieres saber el estado de todos al final.

### `Promise.any(arrayDePromesas)`
Espera a que la **primera** promesa se **cumpla**. Ignora todas las que se rechazan, a menos que todas se rechacen, en cuyo caso se rechaza `Promise.any`.

---

## 🔗 Encadenamiento y `finally`

- **Retorno en `.then()`**: Si un `.then()` devuelve un valor, ese valor se pasa como argumento al siguiente `.then()`. Si devuelve una **nueva promesa**, el siguiente `.then()` esperará a que esa nueva promesa se resuelva.
- **`.finally(callback)`**: Se ejecuta siempre al final, sin importar si la promesa se cumplió o se rechazó. No recibe ningún argumento. Es ideal para tareas de limpieza, como ocultar un spinner de carga.

```javascript
mostrarSpinner();
descargarArchivo('...')
    .then(procesar)
    .catch(mostrarError)
    .finally(() => ocultarSpinner());
```
