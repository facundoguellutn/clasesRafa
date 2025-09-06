# Ejercicios Prácticos: Clase 10

Para estos ejercicios, usa el mismo `index.html` y `app.js` de la clase anterior, o crea uno nuevo con estos elementos:

### Archivo `index.html` base:

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Práctica Eventos</title>
</head>
<body>

    <h1 id="titulo">Eventos en JavaScript</h1>

    <button id="mi-boton">Cambiar Fondo</button>

    <hr>

    <form id="mi-formulario">
        <label for="nombre">Nombre:</label>
        <input type="text" id="nombre-input" placeholder="Escribe algo...">
        <button type="submit">Registrar</button>
    </form>
    <p id="saludo"></p>

    <hr>

    <ul id="lista-items">
        <li>Item 1</li>
        <li>Item 2</li>
        <li>Item 3</li>
    </ul>

    <script src="app.js"></script>
</body>
</html>
```

---

### ✅ Ejercicio 1: Evento de Clic

1.  Selecciona el botón con `id="mi-boton"`.
2.  Añádele un `addEventListener` para el evento `click`.
3.  En la función de callback, cambia el color de fondo del `<body>` a un color diferente cada vez que se hace clic. 
    -   **Pista**: Puedes tener un array de colores y seleccionar uno diferente en cada clic.

---

### ✅ Ejercicio 2: Eventos de Teclado y de Input

1.  Selecciona el campo de texto con `id="nombre-input"`.
2.  Selecciona el párrafo con `id="saludo"`.
3.  Añade un `addEventListener` para el evento `input` al campo de texto.
4.  Cada vez que el usuario escriba algo (cada vez que el valor del input cambie), la función de callback debe actualizar el `textContent` del párrafo `#saludo` para que muestre en tiempo real: `"Hola, [valor del input]"`.
    -   **Pista**: Puedes acceder al valor del input con `event.target.value`.

---

### ✅ Ejercicio 3: Evento de Formulario

1.  Selecciona el formulario con `id="mi-formulario"`.
2.  Añádele un `addEventListener` para el evento `submit`.
3.  Dentro de la función de callback, lo primero que debes hacer es `event.preventDefault()` para evitar que la página se recargue.
4.  Después, obtén el valor del campo de texto y muéstralo en una alerta (`alert()`) que diga `"¡Formulario enviado con el nombre: [valor del input]!"`.

---

### 🏆 Desafío: Delegación de Eventos

1.  **No añadas listeners a los `<li>` directamente**.
2.  Selecciona el contenedor `<ul>` con `id="lista-items"`.
3.  Añade un **único** `addEventListener` para el evento `click` al `<ul>`.
4.  Dentro de la función de callback, comprueba si el elemento que originó el clic (`event.target`) es un `<li>`.
    -   **Pista**: `if (event.target.tagName === 'LI') { ... }`
5.  Si lo es, cambia el color del texto de **ese `<li>` específico** a rojo.

Con este desafío, si añadieras más `<li>` a la lista con JavaScript, el evento seguiría funcionando para ellos sin necesidad de añadirles nuevos listeners.
