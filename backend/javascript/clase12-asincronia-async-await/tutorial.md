# Clase 12: Asincronía - `async / await`

## 🎯 Objetivos de la Clase

Al finalizar esta clase, serás capaz de:
- Escribir código asíncrono de una manera más limpia y legible usando `async/await`.
- Refactorizar código basado en `.then()` y `.catch()` a la nueva sintaxis.
- Manejar errores en código asíncrono de forma natural con `try...catch`.
- Realizar peticiones de red a APIs externas usando `fetch` con `async/await`.

---

## 🤔 ¿Qué es `async / await`?

> **Analogía**: Si las promesas con `.then()` son como seguir una receta con instrucciones del tipo "haga esto, y *luego* haga aquello", `async/await` es como tener una receta que puedes leer de arriba a abajo, como si cada paso fuera instantáneo. La magia de `await` es que **pausa la receta** en los pasos que toman tiempo (como esperar a que el horno se caliente) sin que te des cuenta, y luego continúa donde la dejó.

`async/await` es "azúcar sintáctico" sobre las promesas. No reemplaza a las promesas, sino que nos da una sintaxis mucho más cómoda y legible para trabajar con ellas.

---

## 🛠️ 1. La Sintaxis

Se compone de dos palabras clave:

### a) `async`
Se coloca antes de la declaración de una función. Automáticamente hace dos cosas:
1.  Hace que la función devuelva implícitamente una **promesa**.
2.  Permite que usemos la palabra clave `await` **dentro** de esa función.

```javascript
async function miFuncion() {
    return "¡Hola!";
}

miFuncion().then(alert); // Podemos usar .then() porque devuelve una promesa
```

### b) `await`
Solo se puede usar **dentro de una función `async`**. `await` pausa la ejecución de la función, espera a que una promesa se resuelva, y luego resume la ejecución, devolviendo el valor resuelto de la promesa.

```javascript
function crearPromesa() {
    return new Promise(resolve => {
        setTimeout(() => resolve("Promesa resuelta"), 2000);
    });
}

async function ejecutar() {
    console.log("1. Iniciando ejecución...");
    const resultado = await crearPromesa(); // Pausa aquí por 2 segundos
    console.log(`2. ${resultado}`); // Se ejecuta después de la pausa
    console.log("3. Fin de la ejecución.");
}

ejecutar();
```

---

## ✨ 2. Refactorizando de `.then()` a `async/await`

Veamos la magia. Este es el código de la clase anterior con `.then()`:

```javascript
// Versión con .then()
function obtenerUsuarioThen() {
    fetch('https://jsonplaceholder.typicode.com/users/1')
        .then(response => response.json())
        .then(user => console.log(user.name))
        .catch(error => console.error(error));
}
```

Y esta es la versión equivalente con `async/await`. ¡Mucho más limpia!

```javascript
// Versión con async/await
async function obtenerUsuarioAsync() {
    const response = await fetch('https://jsonplaceholder.typicode.com/users/1');
    const user = await response.json();
    console.log(user.name);
}
```

---

## 🚨 3. Manejo de Errores con `try...catch`

¿Y qué pasa con el `.catch()`? Con `async/await`, podemos usar los bloques `try...catch` que ya conocemos del código síncrono. Es una forma muy natural de manejar errores.

```javascript
async function obtenerUsuarioSeguro() {
    try {
        console.log("Intentando obtener usuario...");
        const response = await fetch('https://jsonplaceholder.typicode.com/users/1');
        
        if (!response.ok) { // Comprobamos si la petición fue exitosa
            throw new Error(`Error HTTP: ${response.status}`);
        }

        const user = await response.json();
        console.log(user.name);

    } catch (error) {
        console.error("Algo salió mal:", error.message);
    }
}

obtenerUsuarioSeguro();
```
El código dentro del bloque `try` se ejecuta. Si cualquier `await` resulta en una promesa rechazada (o si lanzamos un error manualmente con `throw`), la ejecución salta inmediatamente al bloque `catch`.

---

## 🤓 Conceptos Clave para Recordar

- **`async/await`**: Azúcar sintáctico para hacer el código de promesas más legible.
- **`async`**: Convierte una función en una que devuelve una promesa.
- **`await`**: Pausa la ejecución de una función `async` hasta que una promesa se resuelva.
- **`try...catch`**: La forma estándar de manejar errores con `async/await`.
- `async/await` no reemplaza a las promesas, solo mejora la forma en que las usamos.

---

## 🎯 Lo Que Viene en la Próxima Clase

Hemos dominado cómo obtener datos de forma asíncrona. En la **Clase 13**, aprenderemos a organizar nuestro código en archivos separados y reutilizables usando **Módulos de ES6** (`import` y `export`), una pieza clave para construir aplicaciones grandes y mantenibles.
