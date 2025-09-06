# Clase 10: Eventos

## 🎯 Objetivos de la Clase

Al finalizar esta clase, serás capaz de:
- Entender el modelo de eventos de JavaScript para crear páginas interactivas.
- Escuchar y reaccionar a las acciones del usuario, como clics y pulsaciones de teclas.
- Utilizar el objeto `event` para obtener información sobre la interacción.
- Prevenir los comportamientos por defecto de los elementos, como el envío de un formulario.

---

## 🤔 ¿Qué es un Evento?

> **Analogía**: Piensa que los elementos de tu página (botones, inputs, etc.) son **timbres**. Un **evento** es la **acción** de que alguien presione un timbre (un `click`). Tu código JavaScript puede tener un **"oído"** pegado a ese timbre (`addEventListener`) para que, cuando suene, ejecute una acción específica (la **función de callback**).

Los eventos son señales que ocurren en la página web. Pueden ser iniciados por el usuario (como un `click` o `keydown`) o por el navegador (como el evento `load`, que se dispara cuando la página ha terminado de cargar).

---

## 🎧 1. Escuchando Eventos: `addEventListener`

Es el método principal y moderno para manejar eventos. Se añade a un elemento del DOM y necesita tres cosas:

1.  **El nombre del evento** que queremos escuchar (ej: `'click'`).
2.  **Una función de callback**: La función que se ejecutará **cuando** ocurra el evento.
3.  (Opcional) Un objeto de opciones.

```html
<button id="mi-boton">Haz Clic Aquí</button>
<p id="mensaje"></p>
```
```javascript
// 1. Seleccionamos los elementos
const boton = document.getElementById('mi-boton');
const mensaje = document.getElementById('mensaje');

// 2. Añadimos el "escuchador" de eventos
boton.addEventListener('click', function() {
    // 3. Esta función es el callback, se ejecuta al hacer clic
    mensaje.textContent = "¡Gracias por hacer clic!";
});
```

---

## 🎉 2. Eventos Más Comunes

- **Eventos de Ratón**:
  - `click`: Se dispara con un clic.
  - `mouseover`: El puntero del ratón entra en el área de un elemento.
  - `mouseout`: El puntero del ratón sale del área de un elemento.

- **Eventos de Teclado**:
  - `keydown`: Se presiona una tecla.
  - `keyup`: Se suelta una tecla.

- **Eventos de Formulario**:
  - `submit`: Se intenta enviar un formulario.
  - `input`: El valor de un `<input>`, `<select>`, o `<textarea>` ha cambiado.
  - `focus`: Un elemento (como un input) ha recibido el foco.
  - `blur`: Un elemento ha perdido el foco.

- **Eventos de Ventana**:
  - `load`: Se dispara en el objeto `window` cuando toda la página (HTML, CSS, imágenes) ha cargado.
  - `DOMContentLoaded`: Se dispara cuando el HTML ha sido cargado y el DOM está listo, pero sin esperar a las hojas de estilo e imágenes. Es más rápido que `load`.

---

## 📦 3. El Objeto `event`

La función de callback recibe automáticamente un argumento: el **objeto `event`**. Este objeto contiene muchísima información útil sobre la interacción que acaba de ocurrir.

```javascript
const inputTexto = document.querySelector('input');

inputTexto.addEventListener('keydown', function(event) {
    // event.key contiene la tecla que se presionó
    console.log(`Tecla presionada: ${event.key}`);
});
```

Una de las propiedades más útiles es `event.target`, que es una referencia al **elemento exacto que originó el evento**.

---

## ✋ 4. Previniendo Comportamientos por Defecto

Algunos elementos tienen un comportamiento por defecto. Por ejemplo, un link `<a>` navega a una URL y un formulario `<form>` se envía y recarga la página. Podemos prevenir esto con `event.preventDefault()`.

```html
<form id="mi-formulario">
    <input type="text" id="nombre-input" placeholder="Tu nombre">
    <button type="submit">Enviar</button>
</form>
```
```javascript
const formulario = document.getElementById('mi-formulario');

formulario.addEventListener('submit', function(event) {
    // Prevenimos que la página se recargue
    event.preventDefault();

    const input = document.getElementById('nombre-input');
    console.log(`Formulario enviado con el nombre: ${input.value}`);
    alert("¡Gracias por registrarte!");
});
```
Esto es fundamental para crear aplicaciones de una sola página (SPAs) donde controlamos toda la navegación y el envío de datos con JavaScript.

---

## 🤓 Conceptos Clave para Recordar

- **Eventos**: Señales que nos avisan que algo ha pasado.
- **`addEventListener('evento', callback)`**: La forma de escuchar esas señales.
- **Callback**: La función que se ejecuta como respuesta al evento.
- **Objeto `event`**: Contiene información sobre la interacción.
- **`event.target`**: El elemento que originó el evento.
- **`event.preventDefault()`**: Detiene el comportamiento por defecto del navegador.

---

## 🎯 Lo Que Viene en la Próxima Clase

Muchas veces, las acciones del usuario (eventos) requieren que pidamos datos a un servidor. En la **Clase 11**, nos introduciremos en el mundo de la **Asincronía**, aprendiendo cómo manejar operaciones que toman tiempo, como las peticiones de red, sin bloquear nuestra aplicación.
