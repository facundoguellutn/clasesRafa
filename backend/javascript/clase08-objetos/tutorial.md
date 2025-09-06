# Clase 8: Objetos

## 🎯 Objetivos de la Clase

Al finalizar esta clase, serás capaz de:
- Entender qué es un objeto y cómo representa entidades del mundo real.
- Crear objetos y definir sus propiedades y valores.
- Acceder y modificar la información de un objeto.
- Añadir funcionalidades a los objetos a través de métodos.

---

## 🤔 ¿Qué es un Objeto?

> **Analogía**: Si un array es una lista ordenada (un tren), un objeto es una **ficha de datos o un perfil**. No importa el orden, sino la **etiqueta** de cada dato. Piensa en una ficha de un auto en tu concesionaria: tiene una etiqueta "Marca" con el valor "Toyota", una etiqueta "Modelo" con el valor "Corolla", etc.

Un objeto en JavaScript es una colección de **pares clave-valor** (key-value pairs). Es la forma principal de agrupar y estructurar datos que están relacionados entre sí.

---

## 🛠️ 1. Creación y Estructura

La forma más común de crear un objeto es con la **sintaxis literal**, usando llaves `{}`.

```javascript
const auto = {
    // clave: valor
    marca: "Toyota",
    modelo: "Corolla",
    año: 2022,
    coloresDisponibles: ["Rojo", "Blanco", "Negro"],
    estaEnStock: true
};
```
- **Clave (Key)**: Es un string que actúa como el nombre de la propiedad.
- **Valor (Value)**: Puede ser cualquier tipo de dato: un string, un número, un booleano, un array, e incluso otro objeto.

---

## 📥 2. Accediendo a las Propiedades

Hay dos maneras de acceder a los valores de un objeto.

### a) Notación de Punto (Dot Notation)
Es la forma más común y legible. Se usa cuando la clave es un identificador válido de JavaScript (sin espacios ni caracteres especiales).

```javascript
console.log(auto.marca); // "Toyota"
console.log(auto.año);   // 2022
```

### b) Notación de Corchetes (Bracket Notation)
Se usa cuando la clave es un string que no es un identificador válido (ej: contiene espacios) o cuando la clave es dinámica (está guardada en una variable).

```javascript
const autoConDetalles = {
    marca: "Ford",
    "año de fabricación": 2021 // Clave con espacios
};

console.log(autoConDetalles["año de fabricación"]); // 2021

// Ejemplo con clave dinámica
const propiedadAconsultar = "marca";
console.log(autoConDetalles[propiedadAconsultar]); // "Ford"
```

---

## 🔄 3. Modificando y Añadiendo Propiedades

Puedes cambiar el valor de una propiedad existente o añadir una nueva simplemente asignándole un valor.

```javascript
const persona = {
    nombre: "Rafa",
    edad: 30
};

// Modificar una propiedad existente
persona.edad = 31;

// Añadir una nueva propiedad
persona.ciudad = "Buenos Aires";

console.log(persona); // { nombre: "Rafa", edad: 31, ciudad: "Buenos Aires" }
```

---

## ⚙️ 4. Métodos: Funciones dentro de Objetos

Cuando el valor de una propiedad es una función, se le llama **método**. Los métodos definen el comportamiento o las acciones que un objeto puede realizar.

```javascript
const producto = {
    nombre: "Laptop Gamer",
    precio: 1200,
    stock: 10,

    // Esto es un método
    mostrarInfo: function() {
        // 'this' se refiere al objeto 'producto' en sí mismo
        console.log(`Producto: ${this.nombre}, Precio: USD ${this.precio}`);
    },

    // Método para vender
    vender: function() {
        if (this.stock > 0) {
            this.stock--; // Decrementa el stock
            console.log(`Venta realizada. Stock restante: ${this.stock}`);
        } else {
            console.log("Producto sin stock.");
        }
    }
};

producto.mostrarInfo(); // Llama al método mostrarInfo
producto.vender();      // Llama al método vender
```

La palabra clave `this` es fundamental. Dentro de un método, `this` se refiere al propio objeto, permitiéndote acceder a sus otras propiedades (`this.nombre`, `this.stock`).

---

## 🤓 Conceptos Clave para Recordar

- **Objeto**: Una colección de pares `clave: valor` para estructurar datos.
- **Clave (Key)**: El nombre de una propiedad (un string).
- **Valor (Value)**: El dato asociado a una clave.
- **Notación de Punto (`.`)**: La forma estándar de acceder a propiedades.
- **Notación de Corchetes (`[]`)**: Para claves con espacios o dinámicas.
- **Método**: Una función que es propiedad de un objeto.
- **`this`**: Dentro de un método, se refiere al objeto que lo contiene.

---

## 🎯 Lo Que Viene en la Próxima Clase

Ahora que conocemos arrays y objetos, en la **Clase 9** daremos el salto para conectar nuestro JavaScript con la página web. Aprenderemos sobre el **DOM (Document Object Model)**, que nos permitirá seleccionar, leer y modificar elementos HTML desde nuestro código.
