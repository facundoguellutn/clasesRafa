# Clase 6: Funciones

## 🎯 Objetivos de la Clase

Al finalizar esta clase, serás capaz de:
- Entender el propósito de las funciones para organizar y reutilizar código.
- Definir y llamar a tus propias funciones.
- Pasar información a las funciones a través de parámetros.
- Obtener resultados de las funciones usando la palabra clave `return`.
- Conocer las diferentes sintaxis para crear funciones (declaración, expresión y flecha).

---

## 🤔 ¿Qué es una Función?

> **Analogía**: Piensa en una función como una **receta de cocina especializada** o una **máquina en una fábrica**.
> - **Recibe ingredientes** (los **parámetros**).
> - **Realiza una serie de pasos** (el **cuerpo** de la función).
> - **Produce un resultado final** (el **valor de retorno**).

Una función es un bloque de código diseñado para realizar una tarea específica. Es reutilizable, lo que significa que puedes "llamarla" (ejecutarla) tantas veces como quieras sin tener que reescribir el código.

---

## 🛠️ 1. Anatomía y Llamada de una Función

La forma más clásica de definir una función es con una **declaración de función**.

```javascript
// DEFINICIÓN de la función
function saludar(nombre) { // 'nombre' es el PARÁMETRO
    const mensaje = `Hola, ${nombre}. ¡Bienvenido!`;
    return mensaje; // Devuelve el resultado
}

// LLAMADA a la función
const saludoParaRafa = saludar("Rafa"); // "Rafa" es el ARGUMENTO
console.log(saludoParaRafa); // Muestra "Hola, Rafa. ¡Bienvenido!"

const saludoParaFacu = saludar("Facu");
console.log(saludoParaFacu); // Muestra "Hola, Facu. ¡Bienvenido!"
```

- **Parámetros vs. Argumentos**: Un **parámetro** es la variable que listas en la definición de la función (`nombre`). Un **argumento** es el valor real que pasas a la función cuando la llamas (`"Rafa"`).

- **`return`**: La palabra clave `return` finaliza la ejecución de la función y especifica el valor que debe "devolver" al código que la llamó. Si una función no tiene `return`, devuelve `undefined` por defecto.

---

## ✍️ 2. Formas de Escribir Funciones

Existen varias sintaxis para crear funciones. Todas logran algo similar, pero tienen diferencias sutiles.

### a) Declaración de Función (Function Declaration)
La que ya vimos. Son "elevadas" (hoisted), lo que significa que puedes llamarlas antes de definirlas en tu código.

```javascript
console.log(sumar(5, 3)); // Funciona, muestra 8

function sumar(a, b) {
    return a + b;
}
```

### b) Expresión de Función (Function Expression)
Aquí, asignas una función anónima a una variable. No son "elevadas", por lo que solo puedes llamarlas *después* de su definición.

```javascript
// console.log(restar(5, 3)); // ERROR: Cannot access 'restar' before initialization

const restar = function(a, b) {
    return a - b;
};

console.log(restar(5, 3)); // Funciona, muestra 2
```

### c) Funciones Flecha (Arrow Functions - ES6)
Una sintaxis más corta y moderna, introducida en ES6. Son la forma más común de escribir funciones hoy en día, especialmente para operaciones cortas.

```javascript
// Versión larga
const multiplicar = (a, b) => {
    return a * b;
};

// Versión corta (con "return implícito")
// Si la función solo tiene una línea y es un return, puedes omitir las llaves {} y la palabra 'return'.
const dividir = (a, b) => a / b;

console.log(multiplicar(5, 3)); // 15
console.log(dividir(10, 2));   // 5
```

---

## 🎁 3. Parámetros por Defecto

Puedes dar un valor por defecto a un parámetro para los casos en que no se proporciona un argumento al llamar a la función.

```javascript
function registrarUsuario(nombre, rol = "invitado") { // 'rol' es 'invitado' por defecto
    console.log(`Usuario: ${nombre}, Rol: ${rol}`);
}

registrarUsuario("Rafa", "admin"); // Usuario: Rafa, Rol: admin
registrarUsuario("Ana");         // Usuario: Ana, Rol: invitado
```

---

## 🤓 Conceptos Clave para Recordar

- **Funciones**: Bloques de código reutilizables que realizan una tarea.
- **DRY (Don't Repeat Yourself)**: El principio de "No te repitas". Las funciones son la herramienta principal para lograrlo.
- **Parámetros**: Los "ingredientes" que una función necesita.
- **`return`**: La forma de obtener un "resultado" de una función.
- **Declaración vs. Expresión vs. Flecha**: Diferentes formas de escribir funciones, siendo las flecha las más modernas y concisas.

---

## 🎯 Lo Que Viene en la Próxima Clase

Ahora que podemos organizar nuestro código en funciones, en la **Clase 7** nos sumergiremos en una de las estructuras de datos más importantes de JavaScript: los **Arrays**, y aprenderemos a manipular listas de datos de manera eficiente.
