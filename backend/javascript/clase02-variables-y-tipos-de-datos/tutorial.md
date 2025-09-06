# Clase 2: Variables y Tipos de Datos

## 🎯 Objetivos de la Clase

Al finalizar esta clase, serás capaz de:
- Entender qué es una variable y por qué es fundamental en programación.
- Usar `let` y `const` para declarar variables correctamente.
- Identificar y utilizar los principales tipos de datos primitivos en JavaScript.
- Utilizar el operador `typeof` para descubrir el tipo de una variable.

---

## 🤔 ¿Qué es una Variable?

> **Analogía**: Imagina que una variable es una **caja con una etiqueta**.
> - La **etiqueta** es el **nombre de la variable** (ej: `edad`).
> - El **contenido** de la caja es el **valor** de la variable (ej: `30`).

Una variable es un espacio en la memoria de la computadora donde guardamos un dato para poder usarlo y/o modificarlo más tarde. Le ponemos un nombre para poder referirnos a él fácilmente.

---

## 📦 Declarando Variables: `let` y `const`

En JavaScript moderno, tenemos dos formas principales de crear (declarar) variables. La antigua (`var`) ya casi no se usa.

### 1. `let` - La Caja Reutilizable
Usa `let` cuando el valor de la variable **puede cambiar** en el futuro.

```javascript
let puntaje = 100;
console.log("Puntaje inicial:", puntaje); // Muestra 100

puntaje = 150; // El valor cambió. Es válido.
console.log("Puntaje final:", puntaje); // Muestra 150
```

### 2. `const` - La Caja de Seguridad
Usa `const` (de "constante") cuando el valor de la variable **no va a cambiar nunca**. Esto hace tu código más seguro y predecible.

```javascript
const nombre = "Rafa";
console.log("Mi nombre es:", nombre);

// Si intentas cambiarlo, JavaScript te dará un error. ¡Y eso es bueno!
// nombre = "Facu"; // Esto produciría: TypeError: Assignment to constant variable.
```

**Regla de Oro:** Empieza siempre declarando tus variables con `const`. Si después te das cuenta de que necesitas cambiar su valor, cámbiala a `let`.

---

## 🧩 Tipos de Datos Primitivos

JavaScript puede trabajar con diferentes tipos de información. Estos son los más básicos y fundamentales:

### 1. **String (Cadena de texto)**
Cualquier texto. Se escribe entre comillas simples (`' '`) o dobles (`" "`).
```javascript
const saludo = "Hola, mundo";
const jugador = 'Rafa';
```

### 2. **Number (Número)**
Cualquier número, ya sea entero o con decimales.
```javascript
const edad = 30;
const precio = 199.99;
```

### 3. **Boolean (Booleano)**
Representa un valor de verdad: `true` o `false`. Es la base de toda la lógica y las decisiones en programación.
```javascript
const esMayorDeEdad = true;
const tieneDescuento = false;
```

### 4. **Undefined (Indefinido)**
Es el valor que tiene una variable que ha sido declarada pero a la que **todavía no se le ha asignado un valor**.
```javascript
let proximaClase;
console.log(proximaClase); // Muestra undefined
```

### 5. **Null (Nulo)**
Representa la **ausencia intencional de un valor**. Es diferente de `undefined`. Aquí, tú como programador dices explícitamente "esta variable está vacía".
```javascript
let ganador = null; // Todavía no hay ganador, pero la variable existe.
```

---

## 🕵️‍♂️ Descubriendo el Tipo: `typeof`

A veces, querrás saber qué tipo de dato contiene una variable. Para eso, usamos el operador `typeof`.

```javascript
const miNombre = "Rafa";
const miEdad = 30;
const estoyAprendiendo = true;

console.log(typeof miNombre);         // Muestra "string"
console.log(typeof miEdad);           // Muestra "number"
console.log(typeof estoyAprendiendo);  // Muestra "boolean"
```

---

## 🤓 Conceptos Clave para Recordar

- **Variable**: Un nombre para guardar un valor.
- **`let`**: Para valores que pueden cambiar.
- **`const`**: Para valores que no cambiarán (¡úsala por defecto!).
- **Tipos de Datos**: `string` (texto), `number` (números), `boolean` (true/false), `undefined` (sin valor asignado), `null` (valor vacío intencionalmente).
- **`typeof`**: El operador para saber qué tipo de dato tiene una variable.
