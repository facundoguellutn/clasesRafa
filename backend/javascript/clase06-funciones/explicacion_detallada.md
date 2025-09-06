# Explicación Detallada: El Universo de las Funciones

## 🎯 Objetivo de este Documento

Explorar conceptos avanzados sobre funciones como el ámbito (scope), el hoisting y el comportamiento de `this`, que son fundamentales para entender cómo funciona JavaScript por dentro.

---

## 🌐 Ámbito (Scope): ¿Dónde Viven mis Variables?

El ámbito determina la accesibilidad y visibilidad de las variables en tu código.

- **Ámbito Global (Global Scope)**: Una variable declarada fuera de cualquier función es global. Es accesible desde cualquier parte de tu programa. **Es una mala práctica** depender de variables globales, ya que pueden ser modificadas por cualquier parte del código, llevando a errores difíciles de rastrear.

  ```javascript
  const appVersion = "1.0"; // Variable global

  function mostrarVersion() {
      console.log(`Versión: ${appVersion}`); // Accesible aquí
  }
  ```

- **Ámbito de Función (Function Scope)**: Variables declaradas con `var` dentro de una función solo existen dentro de esa función.

- **Ámbito de Bloque (Block Scope)**: Variables declaradas con `let` y `const` dentro de un bloque (`{...}`, como en un `if` o un `for`) solo existen dentro de ese bloque. Esto proporciona un control mucho más granular y predecible.

  ```javascript
  function testScope() {
      const x = 10; // Ámbito de función
      if (true) {
          const y = 20; // Ámbito de bloque
          console.log(x); // 10 (accesible)
      }
      // console.log(y); // ReferenceError: y is not defined
  }
  ```

---

## 🚀 Hoisting (Elevación): ¿Llamar antes de Declarar?

JavaScript procesa las declaraciones antes de ejecutar el código. Este comportamiento se llama hoisting.

- **Declaraciones de Función (`function miFuncion() {}`)**: Son **completamente elevadas**. Tanto el nombre como el cuerpo de la función se mueven al principio de su ámbito. Por eso puedes llamar a una función antes de haberla escrito en el código.

- **Expresiones de Función y Variables (`var`, `let`, `const`)**: Solo se eleva la **declaración**, no la asignación.
    - `var`: Se eleva y se inicializa con `undefined`.
      ```javascript
      console.log(miVar); // undefined
      var miVar = 5;
      ```
    - `let` y `const`: Se elevan, pero entran en la "Temporal Dead Zone" (TDZ). No se inicializan y cualquier intento de acceder a ellas antes de su declaración resulta en un `ReferenceError`. Esto es bueno, ya que previene errores.

---

## 👉 El Misterio de `this`

La palabra clave `this` es una de las más confusas de JavaScript. Su valor se determina por **cómo se llama a la función**.

### `this` en Funciones Normales

- **Llamada simple**: `this` es el objeto global (`window` en navegadores, `global` en Node.js) o `undefined` en modo estricto.
- **Como método de un objeto**: `this` es el objeto a la izquierda del punto.

  ```javascript
  const persona = {
      nombre: "Rafa",
      saludar: function() {
          // 'this' se refiere al objeto 'persona'
          console.log(`Hola, soy ${this.nombre}`); 
      }
  };

  persona.saludar(); // "Hola, soy Rafa"
  ```

### `this` en Funciones Flecha (Arrow Functions)

Aquí está la diferencia clave: **Las funciones flecha no tienen su propio `this`**. Heredan el `this` del contexto en el que fueron creadas (su ámbito léxico).

```javascript
const auto = {
    marca: "Toyota",
    modelos: ["Corolla", "Hilux", "Yaris"],

    mostrarModelos: function() {
        console.log(`Modelos de la marca ${this.marca}:`);
        
        // Si usáramos una función normal aquí, 'this' sería 'undefined' o 'window'
        // porque no se llama como un método de un objeto.
        this.modelos.forEach(modelo => {
            // Gracias a la función flecha, 'this' sigue siendo el objeto 'auto'
            console.log(`- ${modelo} (Marca: ${this.marca})`);
        });
    }
};

auto.mostrarModelos();
```
Esta es la razón principal por la que las funciones flecha son tan populares y útiles en callbacks y métodos de clase, ya que evitan los problemas tradicionales con `this`.

---

## 🧼 Funciones Puras e Impuras

- **Función Pura**: Una función que, para la misma entrada, siempre produce la misma salida y no tiene "efectos secundarios" (no modifica nada fuera de su propio ámbito).
  ```javascript
  // Pura: siempre devuelve lo mismo para los mismos a y b
  const sumar = (a, b) => a + b; 
  ```
- **Función Impura**: Una función que depende de o modifica estados fuera de su ámbito.
  ```javascript
  let total = 0;
  // Impura: modifica una variable externa
  function añadirAlTotal(valor) {
      total += valor;
  }
  ```
El código basado en funciones puras es más fácil de probar, predecir y razonar. La programación funcional se basa en este principio.
