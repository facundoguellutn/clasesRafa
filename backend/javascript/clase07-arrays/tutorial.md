# Clase 7: Arrays

## 🎯 Objetivos de la Clase

Al finalizar esta clase, serás capaz de:
- Entender qué es un array y cómo se utiliza para almacenar listas de datos.
- Crear arrays y acceder y modificar sus elementos.
- Utilizar métodos básicos para añadir y eliminar elementos (`push`, `pop`, `shift`, `unshift`).
- Recorrer arrays de forma eficiente con el bucle `for...of`.

---

## 🤔 ¿Qué es un Array?

> **Analogía**: Piensa en un array como un **tren de carga**. El tren completo es el array, y cada **vagón** es un elemento que contiene un dato. Cada vagón tiene un **número de posición** único y ordenado, empezando desde el 0.

Un array es una estructura de datos fundamental que permite almacenar una colección ordenada de valores. Estos valores pueden ser de cualquier tipo: números, strings, booleanos, e incluso otros arrays u objetos.

---

## 🛠️ 1. Creación y Acceso

La forma más común de crear un array es usando corchetes `[]`.

```javascript
// Un array de strings
const playlist = ["Bohemian Rhapsody", "Stairway to Heaven", "Hotel California"];

// Un array de números
const notas = [10, 8, 9, 7];

// Un array con datos mixtos (¡es posible!)
const datosVarios = ["Rafa", 30, true, null];
```

### Acceder a Elementos (Indexación)

Para acceder a un elemento, usamos su **índice** (su posición) entre corchetes. **¡Importante! El primer elemento siempre tiene el índice 0.**

```javascript
console.log(playlist[0]); // "Bohemian Rhapsody"
console.log(playlist[2]); // "Hotel California"
```

### Modificar Elementos

Puedes cambiar el valor de un elemento accediendo a él por su índice.

```javascript
console.log("Antes:", notas[1]); // 8
notas[1] = 6; // Cambiamos el 8 por un 6
console.log("Después:", notas[1]); // 6
```

### La Propiedad `.length`

Te dice cuántos elementos hay en el array.

```javascript
console.log(`Mi playlist tiene ${playlist.length} canciones.`); // 3
```

---

## ➕➖ 2. Métodos Básicos para Añadir y Quitar

Los arrays vienen con "funciones integradas" (métodos) muy útiles.

### Al Final del Array
- **`push(elemento)`**: Añade uno o más elementos al **final** del array.
- **`pop()`**: Elimina y devuelve el último elemento del array.

```javascript
const carrito = ["manzanas", "pan"];
carrito.push("leche"); // carrito ahora es ["manzanas", "pan", "leche"]
console.log(carrito);

const ultimoElemento = carrito.pop(); // ultimoElemento es "leche"
console.log(ultimoElemento);
console.log(carrito); // carrito vuelve a ser ["manzanas", "pan"]
```

### Al Principio del Array
- **`unshift(elemento)`**: Añade uno o más elementos al **principio** del array.
- **`shift()`**: Elimina y devuelve el primer elemento del array.

```javascript
const colaAtencion = ["Ana", "Pedro"];
colaAtencion.unshift("Maria"); // colaAtencion es ["Maria", "Ana", "Pedro"]
console.log(colaAtencion);

const primerCliente = colaAtencion.shift(); // primerCliente es "Maria"
console.log(primerCliente);
console.log(colaAtencion); // colaAtencion ahora es ["Ana", "Pedro"]
```

---

## 🔁 3. Recorrer Arrays

Como vimos en la clase de bucles, la forma moderna y preferida para recorrer los elementos de un array es `for...of`.

```javascript
const notasFinales = [8, 5, 9, 10, 4];

for (const nota of notasFinales) {
    console.log(`Calificación: ${nota}`);
}
```

---

## 🤓 Conceptos Clave para Recordar

- **Array**: Una lista ordenada de datos.
- **Índice (Index)**: La posición de un elemento, comenzando en `0`.
- **`.length`**: La propiedad que te dice el tamaño del array.
- **`push()` / `pop()`**: Métodos para añadir/quitar al **final**.
- **`unshift()` / `shift()`**: Métodos para añadir/quitar al **principio**.
- **`for...of`**: La mejor manera de recorrer sus elementos.

---

## 🎯 Lo Que Viene en la Próxima Clase

Los arrays nos permiten guardar listas de datos. Pero, ¿cómo guardamos datos más complejos y estructurados, con nombres y propiedades? En la **Clase 8**, exploraremos los **Objetos**, la otra estructura de datos fundamental en JavaScript.
