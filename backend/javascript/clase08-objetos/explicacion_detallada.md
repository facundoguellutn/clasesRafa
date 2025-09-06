# Explicación Detallada: Técnicas Avanzadas con Objetos

## 🎯 Objetivo de este Documento

Dominar las técnicas modernas de JavaScript (ES6+) para trabajar con objetos de una manera más eficiente, segura y expresiva, como la desestructuración, el spread syntax y el optional chaining.

---

## ✨ 1. Desestructuración (Destructuring)

La desestructuración es una sintaxis que permite "desempacar" valores de arrays o propiedades de objetos en distintas variables. Es extremadamente útil y la verás en todos lados.

```javascript
const usuario = {
    nombre: "Rafa",
    edad: 30,
    rol: "Admin",
    direccion: { // Objeto anidado
        calle: "Av. Siempre Viva",
        numero: 742
    }
};

// Forma clásica
// const nombre = usuario.nombre;
// const rol = usuario.rol;

// Con desestructuración
const { nombre, rol } = usuario;
console.log(nombre); // "Rafa"
console.log(rol);    // "Admin"

// Desestructuración anidada
const { direccion: { calle } } = usuario;
console.log(calle); // "Av. Siempre Viva"

// Asignando a nuevos nombres de variable
const { edad: añosDeVida } = usuario;
console.log(añosDeVida); // 30

// Con valores por defecto
const { pais = "Argentina" } = usuario;
console.log(pais); // "Argentina"
```

---

## 🚀 2. Spread Syntax (`...`) y Rest Properties

El operador de propagación (`...`) permite expandir los elementos de un iterable (como un array u objeto) en lugares donde se esperan múltiples elementos o propiedades.

### Copiar y Fusionar Objetos
Es la forma moderna de crear una copia superficial de un objeto o de fusionar varios objetos.

```javascript
const datosPersonales = { nombre: "Ana", edad: 25 };
const datosContacto = { email: "ana@test.com", telefono: "12345" };

// Copia superficial
const copiaDatos = { ...datosPersonales };

// Fusión de objetos
const perfilCompleto = { ...datosPersonales, ...datosContacto, activa: true };
// Si hay claves repetidas, la última en aparecer gana.

console.log(perfilCompleto);
// { nombre: "Ana", edad: 25, email: "ana@test.com", telefono: "12345", activa: true }
```

### Rest Properties (`...` en desestructuración)
Permite agrupar el "resto" de las propiedades de un objeto en un nuevo objeto.

```javascript
const jugador = { id: 1, nombre: "Leo", equipo: "Inter Miami", posicion: "Delantero" };

const { id, ...infoJugador } = jugador;

console.log(id); // 1
console.log(infoJugador); // { nombre: "Leo", equipo: "Inter Miami", posicion: "Delantero" }
```

---

## 🛠️ 3. Métodos Estáticos de `Object`

Son funciones útiles que viven en el constructor `Object` y sirven para trabajar con objetos.

- **`Object.keys(obj)`**: Devuelve un array con los nombres de las claves (propiedades) de un objeto.
- **`Object.values(obj)`**: Devuelve un array con los valores de las propiedades.
- **`Object.entries(obj)`**: Devuelve un array de arrays, donde cada subarray es un par `[clave, valor]`.

```javascript
const auto = { marca: "Ford", modelo: "Mustang", año: 1969 };

console.log(Object.keys(auto));   // ["marca", "modelo", "año"]
console.log(Object.values(auto)); // ["Ford", "Mustang", 1969]
console.log(Object.entries(auto)); // [["marca", "Ford"], ["modelo", "Mustang"], ["año", 1969]]
```
`Object.entries` es especialmente útil para poder iterar sobre un objeto usando bucles de array como `for...of` o `forEach`.

---

## 🔗 4. Optional Chaining (`?.`)

Esta es una característica moderna (ES2020) que salva vidas. Permite leer el valor de una propiedad ubicada profundamente dentro de una cadena de objetos conectados sin tener que validar expresamente que cada referencia en la cadena sea válida.

```javascript
const usuarioA = { nombre: "Rafa", direccion: { calle: "Falsa 123" } };
const usuarioB = { nombre: "Ana" }; // No tiene dirección

// Forma clásica (El "infierno" de los if)
let calleUsuarioA, calleUsuarioB;
if (usuarioA && usuarioA.direccion) {
    calleUsuarioA = usuarioA.direccion.calle;
}

// Forma moderna con Optional Chaining
calleUsuarioA = usuarioA?.direccion?.calle; // "Falsa 123"
calleUsuarioB = usuarioB?.direccion?.calle; // undefined (¡y no da error!)

console.log(calleUsuarioA);
console.log(calleUsuarioB);
```
Si en la cadena de `?.` una de las propiedades es `null` o `undefined`, la expresión se detiene y devuelve `undefined`, evitando el típico error "Cannot read properties of undefined".
