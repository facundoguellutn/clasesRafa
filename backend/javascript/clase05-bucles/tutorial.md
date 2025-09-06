# Clase 5: Bucles (Loops)

## 🎯 Objetivos de la Clase

Al finalizar esta clase, serás capaz de:
- Entender la necesidad de repetir tareas en programación.
- Utilizar el bucle `for` para iteraciones con un número conocido de repeticiones.
- Emplear el bucle `while` para repetir acciones mientras se cumpla una condición.
- Recorrer arrays de forma moderna y legible con `for...of`.

---

## 🤔 ¿Qué es un Bucle?

> **Analogía**: Imagina que tienes que lavar 10 platos. No piensas "lavar plato 1, lavar plato 2, lavar plato 3...". Tu cerebro piensa: "**Repetir** la acción de lavar **hasta que** no queden platos".

Un bucle (o loop) es una estructura de control que permite ejecutar un bloque de código repetidamente, ahorrándote escribir la misma lógica una y otra vez.

---

## 🔁 1. El Bucle `for`

Es el bucle más común. Es ideal cuando **sabes de antemano cuántas veces** quieres que se repita el código.

Su estructura tiene tres partes, separadas por punto y coma `( ; )`:
1.  **Inicialización**: Se ejecuta una sola vez, al principio. Aquí se declara e inicializa la variable contadora (normalmente `i` de "índice").
2.  **Condición**: Se evalúa antes de cada repetición. Mientras sea `true`, el bucle continúa.
3.  **Incremento/Decremento**: Se ejecuta al final de cada repetición. Se usa para modificar el contador.

```javascript
//      (1. Inicialización; 2. Condición; 3. Incremento)
for (let i = 1; i <= 5; i++) {
    console.log(`Esta es la vuelta número ${i}`);
}
// Resultado:
// "Esta es la vuelta número 1"
// "Esta es la vuelta número 2"
// ... hasta el 5
```

---

## ❓ 2. El Bucle `while`

Se usa cuando **no sabes cuántas veces** se repetirá el código, pero sabes que debe continuar **mientras** una condición sea verdadera.

```javascript
let contador = 0;
let numeroMagico = 5;

while (contador !== numeroMagico) {
    contador = Math.floor(Math.random() * 10); // Genera un número aleatorio del 0 al 9
    console.log(`El contador es ${contador}, buscando el ${numeroMagico}...`);
}

console.log(`¡Encontramos el número mágico ${numeroMagico}!`);
```
**¡Cuidado!** Es tu responsabilidad asegurarte de que la condición del `while` en algún momento se vuelva `false`. De lo contrario, crearás un **bucle infinito** que colgará tu programa.

---

## 🛒 3. Recorriendo Arrays con `for...of`

Si bien puedes usar un bucle `for` clásico para recorrer un array, existe una forma mucho más moderna, limpia y legible: el bucle `for...of`.

```javascript
const carrito = ["Manzanas", "Pan", "Leche", "Queso"];

// Forma clásica (funciona, pero es más verbosa)
for (let i = 0; i < carrito.length; i++) {
    console.log(`Producto clásico: ${carrito[i]}`);
}

// Forma moderna con for...of (¡mucho mejor!)
for (const producto of carrito) {
    console.log(`Producto moderno: ${producto}`);
}
```
El `for...of` se encarga de todo automáticamente. En cada iteración, la variable `producto` toma el valor de un elemento del array, en orden.

---

## 🤓 Conceptos Clave para Recordar

- **Bucles**: Sirven para repetir código.
- **`for`**: Úsalo cuando sepas el número de iteraciones (ej: 10 veces, o el largo de un array).
- **`while`**: Úsalo cuando la repetición dependa de una condición que puede cambiar (ej: mientras el usuario no escriba "salir").
- **`for...of`**: La forma preferida y más legible para recorrer los elementos de un array.

---

## 🎯 Lo Que Viene en la Próxima Clase

Los bucles nos permiten repetir acciones, pero a menudo esas acciones son complejas. En la **Clase 6**, aprenderemos a encapsular esas acciones en bloques de código reutilizables llamados **Funciones**, llevando nuestra organización del código al siguiente nivel.
