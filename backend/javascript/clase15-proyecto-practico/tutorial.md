# Clase 15: Proyecto Práctico - Lista de Tareas (To-Do App)

## 🎯 Objetivos del Proyecto

En este proyecto, integraremos todos los conceptos que hemos aprendido para construir una aplicación web interactiva y funcional desde cero. Al finalizar, habrás aplicado:

- **HTML**: Para la estructura semántica del contenido.
- **CSS**: Para dar un estilo básico y feedback visual.
- **JavaScript**:
    - Selección y manipulación del **DOM**.
    - Manejo de **Eventos** (clicks, envío de formularios).
    - Creación dinámica de elementos.
    - Lógica de programación (condicionales, bucles si fueran necesarios).

---

## 🚀 Paso 1: La Estructura (HTML)

Crea un archivo `index.html`. Esta será la base de nuestra aplicación. Fíjate en los `id` y `class`, ya que los usaremos desde JavaScript para seleccionar los elementos.

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Lista de Tareas</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <main class="app-container">
        <h1>Lista de Tareas</h1>
        <form id="formulario-tarea">
            <input type="text" id="input-tarea" placeholder="Ej: Aprender más JavaScript" required>
            <button type="submit">Añadir Tarea</button>
        </form>
        <ul id="lista-tareas"></ul>
    </main>
    <script src="app.js"></script>
</body>
</html>
```

---

## 🎨 Paso 2: El Estilo (CSS)

Crea un archivo `style.css` para que la aplicación se vea ordenada. Lo más importante aquí es la clase `.completada`, que nos dará el feedback visual cuando una tarea esté terminada.

```css
/* (Estilos básicos para centrar y ordenar) */
body { font-family: sans-serif; background-color: #f4f4f4; }
.app-container { max-width: 500px; margin: 50px auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
form { display: flex; margin-bottom: 20px; }
input[type="text"] { flex-grow: 1; padding: 8px; border: 1px solid #ddd; }
button { padding: 8px 12px; border: none; background-color: #007bff; color: white; cursor: pointer; }

/* Estilos de la lista */
ul { list-style-type: none; padding: 0; }
li { display: flex; justify-content: space-between; align-items: center; padding: 10px; border-bottom: 1px solid #eee; }

/* Clase que aplicaremos con JS */
.completada {
    text-decoration: line-through;
    color: #888;
}

.btn-eliminar { background-color: #dc3545; }
```

---

## 🧠 Paso 3: La Lógica (JavaScript)

Crea un archivo `app.js`. Aquí es donde ocurre toda la magia.

### 1. Selección de Elementos del DOM

Primero, necesitamos "agarrar" los elementos de nuestro HTML con los que vamos a interactuar.

```javascript
const formulario = document.getElementById('formulario-tarea');
const inputTarea = document.getElementById('input-tarea');
const listaTareas = document.getElementById('lista-tareas');
```

### 2. Evento Principal: Añadir una Tarea

Escuchamos el evento `submit` del formulario. Esto es mejor que escuchar el `click` del botón, ya que también funciona si el usuario presiona "Enter".

```javascript
formulario.addEventListener('submit', function(event) {
    // Prevenimos el comportamiento por defecto (recargar la página)
    event.preventDefault();

    // Obtenemos el texto del input y quitamos espacios en blanco
    const textoTarea = inputTarea.value.trim();

    // Validamos que no esté vacío
    if (textoTarea !== '') {
        agregarTarea(textoTarea);
        inputTarea.value = ''; // Limpiamos el input
        inputTarea.focus(); // Devolvemos el foco al input
    }
});
```

### 3. Función para Crear y Agregar la Tarea al DOM

Esta función se encarga de la lógica de crear los elementos HTML.

```javascript
function agregarTarea(texto) {
    // 1. Crear el elemento <li>
    const elementoLi = document.createElement('li');
    elementoLi.textContent = texto;

    // 2. Crear el botón de eliminar
    const botonEliminar = document.createElement('button');
    botonEliminar.textContent = 'Eliminar';
    botonEliminar.classList.add('btn-eliminar'); // Añadimos una clase para el estilo

    // 3. Añadir el botón al <li>
    elementoLi.appendChild(botonEliminar);

    // 4. Añadir el <li> a la lista <ul>
    listaTareas.appendChild(elementoLi);
}
```

### 4. Eventos para Completar y Eliminar (Delegación de Eventos)

Para no añadir un listener a cada botón, añadimos uno solo a la lista `<ul>` y usamos `event.target` para saber qué se clickeó.

```javascript
listaTareas.addEventListener('click', function(event) {
    // Si se hizo clic en un botón de eliminar
    if (event.target.classList.contains('btn-eliminar')) {
        const itemAEliminar = event.target.parentElement; // El <li> es el padre del botón
        listaTareas.removeChild(itemAEliminar);
    }
    // Si se hizo clic en un <li> (para marcar como completado)
    else if (event.target.tagName === 'LI') {
        event.target.classList.toggle('completada');
    }
});
```

¡Y con esto tienes una aplicación de lista de tareas completamente funcional! Has integrado todos los conceptos clave del JavaScript del lado del cliente.
