# Clase 13: Módulos de ES6

## 🎯 Objetivos de la Clase

Al finalizar esta clase, serás capaz de:
- Entender por qué es crucial dividir el código en múltiples archivos.
- Utilizar `export` para exponer funciones, variables y clases desde un módulo.
- Utilizar `import` para consumir código de otros módulos.
- Diferenciar entre exportaciones por defecto y nombradas.
- Configurar un proyecto simple en el navegador para que utilice módulos.

---

## 🤔 ¿Por Qué Usar Módulos?

> **Analogía**: Imagina que estás construyendo un auto. No fabricas todas las piezas (motor, ruedas, chasis) en un solo taller gigante y desordenado. Tienes talleres especializados para cada componente. Los **módulos son esos talleres especializados**. Cada uno tiene una responsabilidad clara y se pueden ensamblar para crear el auto completo.

Cuando una aplicación crece, tener todo el código en un solo archivo se vuelve insostenible:
- Es difícil de leer y navegar.
- Es casi imposible que varias personas trabajen en él al mismo tiempo.
- Un error puede romper todo.

Los módulos nos permiten dividir nuestro programa en piezas más pequeñas, lógicas y reutilizables.

---

## 📤 1. Exportando Código: `export`

Para que algo dentro de un archivo (módulo) esté disponible para otros archivos, necesitas exportarlo.

Existen dos tipos de exportaciones:

### a) Exportaciones Nombradas (Named Exports)

Puedes tener **muchas** exportaciones nombradas por módulo. Son ideales para exportar varias utilidades.

```javascript
// ---- archivo: /utils/matematicas.js ----

export const PI = 3.14159;

export function sumar(a, b) {
    return a + b;
}

export function restar(a, b) {
    return a - b;
}
```

### b) Exportación por Defecto (Default Export)

Puedes tener **solo una** exportación por defecto por módulo. Se usa para la funcionalidad principal o la pieza central que el módulo representa.

```javascript
// ---- archivo: /componentes/Boton.js ----

export default function Boton(texto) {
    console.log(`Creando un botón con el texto: ${texto}`);
    // ...lógica para crear un botón
}
```

---

## 📥 2. Importando Código: `import`

Para usar el código de otro módulo, necesitas importarlo.

### a) Importando Exportaciones Nombradas
Se usan llaves `{}` para especificar qué quieres importar.

```javascript
// ---- archivo: main.js ----

import { sumar, PI } from './utils/matematicas.js';

console.log(`El valor de PI es ${PI}`);
console.log(`2 + 3 = ${sumar(2, 3)}`);
```

### b) Importando una Exportación por Defecto
No se usan llaves y puedes darle el nombre que quieras al importarlo.

```javascript
// ---- archivo: main.js ----

import MiBotonPersonalizado from './componentes/Boton.js';

MiBotonPersonalizado("Enviar");
```

### c) Importando Ambos Tipos a la Vez

```javascript
// ---- archivo: main.js ----

import MiBoton, { sumar, PI } from './algun-modulo.js';
```

---

## 🌐 3. Módulos en el Navegador

Para que este sistema de `import`/`export` funcione en un navegador, debes enlazar tu script principal en el HTML con el atributo `type="module"`.

```html
<!DOCTYPE html>
<html>
<head>
    <title>Mi App con Módulos</title>
</head>
<body>
    <h1>Revisa la consola</h1>

    <!-- ¡Esto es crucial! -->
    <script type="module" src="main.js"></script>
</body>
</html>
```

---

## 🤓 Conceptos Clave para Recordar

- **Módulos**: Archivos de JavaScript que se importan y exportan entre sí.
- **`export`**: La palabra clave para hacer que el código sea accesible desde fuera.
- **`import`**: La palabra clave para traer código de otro módulo.
- **Exportaciones Nombradas**: `export const ...` - Múltiples por archivo, se importan con `{}`.
- **Exportación por Defecto**: `export default ...` - Una por archivo, se importa sin `{}`.
- **`<script type="module">`**: Indispensable para usar módulos en el navegador.

---

## 🎯 Lo Que Viene en la Próxima Clase

Ahora que sabemos organizar nuestro código, en la **Clase 14** aprenderemos a crear "plantillas" para nuestros objetos usando **Clases**, introduciéndonos en los conceptos de la Programación Orientada a Objetos.
