# Ejercicios Prácticos: Clase 9

Para estos ejercicios, necesitarás un archivo `index.html` y un `app.js` enlazado.

### Archivo `index.html` base:

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Práctica DOM</title>
    <style>
        .destacado {
            background-color: yellow;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <h1 id="titulo-principal">Mi Lista de Tareas</h1>

    <p class="descripcion">Una lista simple de cosas por hacer.</p>

    <ul id="lista-tareas">
        <li class="tarea">Lavar el auto</li>
        <li class="tarea">Hacer las compras</li>
        <li class="tarea">Estudiar JavaScript</li>
    </ul>

    <div id="contenedor-extra"></div>

    <script src="app.js"></script>
</body>
</html>
```

Copia este código en tu `index.html` y crea un `app.js` vacío. Ahora, ¡a resolver los ejercicios en `app.js`!

---

### ✅ Ejercicio 1: Selección y Modificación

1.  Selecciona el `<h1>` por su `id` (`titulo-principal`) y cambia su `textContent` a "Mi Súper Lista de Tareas".
2.  Selecciona el `<p>` que tiene la clase `descripcion` usando `querySelector`.
3.  Cambia el estilo de ese párrafo para que el color del texto sea `blue` (`elemento.style.color = 'blue';`).

---

### ✅ Ejercicio 2: Modificando Múltiples Elementos

1.  Selecciona **todos** los elementos `<li>` que tienen la clase `tarea` usando `querySelectorAll`.
2.  Usa un bucle `for...of` para recorrer la lista de tareas que seleccionaste.
3.  Dentro del bucle, añade la clase `destacado` a cada `<li>`. (Usa `elemento.classList.add('destacado')`).
4.  Después del bucle, cambia el `innerHTML` de la segunda tarea (`<li>` en el índice 1 de tu selección) para que incluya una etiqueta `<strong>`: `"Hacer las compras <strong>(urgente)</strong>"`.

---

### ✅ Ejercicio 3: Creación y Adición de Elementos

1.  Crea un nuevo elemento `<li>` usando `document.createElement()`.
2.  Asígnale el `textContent` "Pasear al perro".
3.  Añádele la clase `tarea`.
4.  Selecciona la lista `<ul>` por su `id` (`lista-tareas`).
5.  Añade el nuevo `<li>` que creaste al final de la lista `<ul>` usando `appendChild()`.

---

### 🏆 Desafío: Crear Elementos desde un Array

1.  Crea un array de strings con nombres de tus hobbies. Ejemplo: `["Leer", "Correr", "Programar"]`.
2.  Selecciona el `div` con el `id` `contenedor-extra`.
3.  Crea un nuevo elemento `<h2>` y ponle el `textContent` "Mis Hobbies". Añádelo al `div`.
4.  Crea un nuevo elemento `<ul>` y añádelo también al `div`.
5.  Ahora, usa un bucle para recorrer tu array de hobbies.
6.  Dentro del bucle, por cada hobby, crea un `<li>`, asigna el hobby como su `textContent`, y añádelo al `<ul>` que acabas de crear.

Al final, deberías ver una nueva sección "Mis Hobbies" en tu página con una lista generada completamente desde JavaScript.
