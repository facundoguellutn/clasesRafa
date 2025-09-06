# Explicación Detallada: Variables y Tipos a Fondo

## 🎯 Objetivo de este Documento

Profundizar en los matices de las variables y los tipos de datos en JavaScript. Entender estos detalles te ayudará a evitar errores comunes y a escribir código más robusto.

---

## 🔬 `var` vs. `let` vs. `const`: El Ámbito (Scope) y el Hoisting

Ya vimos la diferencia de mutabilidad, pero la diferencia más importante es el **ámbito (scope)**.

- **Ámbito**: Es la zona de tu código donde una variable es accesible.

### `var`: Ámbito de Función
Las variables declaradas con `var` solo existen dentro de la **función** más cercana. Si no están en una función, son **globales**.

```javascript
function miFuncion() {
    var miVariable = "Soy local de la función";
    if (true) {
        var miVariable = "¡He sido sobreescrita!"; // ¡CUIDADO! Esta es la MISMA variable
        console.log(miVariable); // "¡He sido sobreescrita!"
    }
    console.log(miVariable); // "¡He sido sobreescrita!"
}
```
Este comportamiento es confuso y propenso a errores.

### `let` y `const`: Ámbito de Bloque
Las variables con `let` y `const` existen solo dentro del **bloque** (`{ ... }`) más cercano.

```javascript
function miFuncion() {
    let miVariable = "Soy del ámbito de la función";
    if (true) {
        let miVariable = "Soy una NUEVA variable, solo del if";
        console.log(miVariable); // "Soy una NUEVA variable, solo del if"
    }
    console.log(miVariable); // "Soy del ámbito de la función"
}
```
Esto es mucho más predecible y es la razón principal para usar `let` y `const`.

### Hoisting (Elevación)
- **`var`**: Las declaraciones con `var` son "elevadas" (hoisted) al principio de su ámbito, pero su asignación no. Se inicializan con `undefined`.
  ```javascript
  console.log(x); // Muestra undefined, no da error
  var x = 5;
  ```
- **`let` y `const`**: También son elevadas, pero no se inicializan. Entran en una "Temporal Dead Zone" (TDZ) hasta que la línea de su declaración es alcanzada. Intentar acceder a ellas antes produce un `ReferenceError`.
  ```javascript
  // console.log(y); // ReferenceError: Cannot access 'y' before initialization
  let y = 10;
  ```
Esta es otra protección que nos dan `let` y `const` contra errores.

---

## 🔄 Coerción de Tipos (Type Coercion)

JavaScript es un lenguaje de "tipado débil", lo que significa que a menudo intentará convertir un tipo de dato a otro automáticamente. Esto se llama coerción.

- **Coerción Implícita**: Ocurre automáticamente.
  ```javascript
  console.log("5" - 3);      // 2 (JS convierte "5" a número)
  console.log("5" + 3);      // "53" (JS convierte 3 a string y concatena)
  console.log(5 == "5");     // true (coerción de tipo antes de comparar)
  ```
- **Coerción Explícita**: La haces tú a propósito.
  ```javascript
  const numeroString = "123";
  const numero = Number(numeroString); // Convierte a número
  
  const valor = 0;
  const esBooleano = Boolean(valor); // Convierte a booleano (false)
  ```

El operador `+` es especialmente tramposo. Si uno de los operandos es un string, siempre realizará concatenación. El `==` también es fuente de muchos bugs por la coerción. Por eso, **siempre usa `===` para comparar**, que no hace coerción de tipos.

---

## 💎 Primitivos vs. Objetos (Tipos por Valor vs. Tipos por Referencia)

Este es uno de los conceptos más importantes para entender el comportamiento de JavaScript.

### Tipos Primitivos (Por Valor)
- `string`, `number`, `boolean`, `null`, `undefined`, `symbol`, `bigint`.
- Cuando asignas o pasas un primitivo a una función, se **copia el valor**.

```javascript
let a = 10;
let b = a; // `b` es una COPIA de `a`

b = 20; // Cambiar `b` no afecta a `a`

console.log(a); // 10
console.log(b); // 20
```

### Tipos de Objeto (Por Referencia)
- `object` (incluyendo `array`, `function`).
- Cuando asignas o pasas un objeto, se **copia la referencia** (la "dirección" en memoria donde está el objeto), no el objeto en sí.

```javascript
let persona1 = { nombre: "Rafa" };
let persona2 = persona1; // `persona2` y `persona1` apuntan a la MISMA dirección

persona2.nombre = "Facu"; // Modificamos el objeto a través de `persona2`

console.log(persona1.nombre); // "Facu" (¡`persona1` también cambió!)
```

**¿Y qué pasa con `const` y los objetos?**
`const` hace que la **referencia** sea constante, no el contenido del objeto.

```javascript
const auto = { marca: "Toyota" };

// auto = { marca: "Ford" }; // ERROR: No puedes reasignar la referencia

auto.marca = "Ford"; // VÁLIDO: Puedes modificar el contenido del objeto
console.log(auto.marca); // "Ford"
```
Entender esto es clave para trabajar con arrays y objetos en React y otras librerías.
