# Clase 4: Estructuras de Control

## 🎯 Objetivos de la Clase

Al finalizar esta clase, serás capaz de:
- Dirigir el flujo de tu programa usando la estructura `if / else if / else`.
- Utilizar `switch` para manejar múltiples casos de forma limpia.
- Escribir condicionales de una sola línea con el operador ternario.
- Entender los conceptos de "truthy" y "falsy" para escribir código más conciso.

---

## 🤔 ¿Qué son las Estructuras de Control?

> **Analogía**: Imagina que tu código es una ruta. Hasta ahora, ha sido una carretera recta. Las **estructuras de control son las bifurcaciones, rotondas y desvíos**. Permiten que tu programa tome diferentes caminos y tome decisiones basadas en las condiciones que aprendimos a crear en la clase anterior.

---

## 🛣️ 1. `if / else if / else` - La Bifurcación

Es la estructura de control más fundamental. Evalúa una condición y, si es `true`, ejecuta un bloque de código.

### `if` simple

```javascript
const edad = 20;

if (edad >= 18) {
    console.log("Es mayor de edad. Puede pasar.");
}
```

### `if / else` - Dos caminos

```javascript
const temperatura = 15;

if (temperatura > 25) {
    console.log("Hace calor, ¡ponete la remera!");
} else {
    console.log("Hace frío, ¡llevate un buzo!");
}
```

### `if / else if / else` - Múltiples caminos

Permite encadenar varias condiciones. Se evalúan en orden, y la primera que sea `true` se ejecuta.

```javascript
const nota = 7;

if (nota >= 9) {
    console.log("Excelente");
} else if (nota >= 6) {
    console.log("Aprobado");
} else {
    console.log("Desaprobado, a estudiar más.");
}
```

---

## 🚦 2. `switch` - La Rotonda

Es una alternativa más limpia a un `if / else if / else` largo cuando estás comparando **una sola variable** contra múltiples valores posibles.

```javascript
const diaDeLaSemana = "miércoles";

switch (diaDeLaSemana) {
    case "lunes":
        console.log("Arrancando la semana con todo.");
        break; // ¡El 'break' es crucial! Evita que el código siga al siguiente caso.

    case "miércoles":
        console.log("Mitad de semana, ¡vamos!");
        break;

    case "viernes":
        console.log("¡Hoy se sale!");
        break;

    default:
        // El 'default' se ejecuta si ninguno de los 'case' coincide.
        console.log("Es un día cualquiera.");
        break;
}
```

---

## ⚡ 3. Operador Ternario - El Atajo

Es una forma súper compacta de escribir un `if / else` simple en una sola línea. Es ideal para asignar un valor a una variable basándose en una condición.

La sintaxis es: `condicion ? valor_si_es_true : valor_si_es_false`

```javascript
const edadUsuario = 25;

// Forma larga con if/else
let mensaje;
if (edadUsuario >= 18) {
    mensaje = "Puede votar";
} else {
    mensaje = "No puede votar";
}

// Forma corta con operador ternario
const mensajeTernario = edadUsuario >= 18 ? "Puede votar" : "No puede votar";

console.log(mensajeTernario); // "Puede votar"
```

---

## ✅/❌ Valores "Truthy" y "Falsy"

En JavaScript, no solo `true` y `false` se evalúan en las condiciones. Hay valores que, sin ser `false`, se comportan como si lo fueran.

- **Valores Falsy**: `false`, `0`, `""` (string vacío), `null`, `undefined`, `NaN`.
- **Valores Truthy**: ¡Todo lo demás! (incluyendo `" "`, `[]`, `{}`).

Esto te permite escribir código más conciso:

```javascript
let nombreUsuario = ""; // El usuario no ha introducido nada

// En lugar de: if (nombreUsuario !== "")
if (nombreUsuario) { 
    console.log(`Bienvenido, ${nombreUsuario}`);
} else {
    console.log("Bienvenido, invitado. Por favor, inicia sesión.");
}
// Se ejecuta el 'else' porque un string vacío es 'falsy'.
```

---

## 🤓 Conceptos Clave para Recordar

- **`if/else`**: La herramienta principal para tomar decisiones.
- **`switch`**: Ideal para comparar una variable contra una lista de valores específicos.
- **Operador Ternario**: Un atajo elegante para condicionales simples.
- **Truthy/Falsy**: Entender qué valores se comportan como `false` te permite escribir `if` más limpios.

---

## 🎯 Lo Que Viene en la Próxima Clase

Ya podemos tomar decisiones. En la **Clase 5**, aprenderemos a **repetir acciones** un número determinado de veces o mientras se cumpla una condición, usando los **Bucles** (`for`, `while`).
