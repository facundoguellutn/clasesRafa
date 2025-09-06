# Clase 9: El DOM (Document Object Model)

## 🎯 Objetivos de la Clase

Al finalizar esta clase, serás capaz de:
- Entender qué es el DOM y cómo conecta JavaScript con tu página HTML.
- Seleccionar cualquier elemento de la página usando diferentes métodos.
- Modificar el contenido, los estilos y los atributos de los elementos seleccionados.
- Crear nuevos elementos y añadirlos a la página dinámicamente.

---

## 🤔 ¿Qué es el DOM?

> **Analogía**: Piensa en tu archivo HTML como el **plano de una casa**. El navegador construye la casa basándose en ese plano. El **DOM es la casa ya construida**, pero una casa mágica donde puedes mover paredes, pintar habitaciones y cambiar los muebles en tiempo real. **JavaScript es el control remoto** que te permite hacer todos esos cambios.

El DOM (Modelo de Objetos del Documento) es una representación en forma de árbol de tu documento HTML. El navegador crea este "árbol" de objetos, y cada etiqueta HTML, atributo y texto se convierte en un "nodo" en ese árbol. JavaScript puede acceder y manipular este árbol de objetos para cambiar dinámicamente la estructura y el contenido de la página web sin tener que recargarla.

---

## 🔎 1. Seleccionando Elementos (El Primer Paso)

Para manipular un elemento, primero debes "agarrarlo".

### a) `document.getElementById('id')`
El más rápido y específico. Úsalo cuando un elemento tiene un `id` único.

```html
<h1 id="titulo-principal">Mi Página</h1>
```
```javascript
const titulo = document.getElementById('titulo-principal');
```

### b) `document.querySelector('selector')`
El más versátil y moderno. Usa cualquier **selector de CSS** que ya conoces. Devuelve el **primer elemento** que encuentra que coincide con el selector.

```html
<p class="parrafo-destacado">Un párrafo importante.</p>
<div class="caja">...</div>
```
```javascript
const parrafo = document.querySelector('.parrafo-destacado');
const caja = document.querySelector('div.caja');
```

### c) `document.querySelectorAll('selector')`
Similar a `querySelector`, pero devuelve **todos** los elementos que coinciden, en una colección especial llamada `NodeList` (que se parece mucho a un array).

```html
<ul>
    <li class="item-lista">Manzana</li>
    <li class="item-lista">Banana</li>
    <li class="item-lista">Naranja</li>
</ul>
```
```javascript
const items = document.querySelectorAll('.item-lista');
// 'items' es una NodeList con 3 elementos <li>

// Podemos recorrerla con for...of
for (const item of items) {
    console.log(item.textContent);
}
```

---

## ✍️ 2. Modificando Elementos

Una vez que tienes un elemento seleccionado, puedes cambiar casi todo sobre él.

### Contenido: `.textContent` vs `.innerHTML`
- **`.textContent`**: Cambia solo el texto dentro de un elemento. Es más **seguro** y rápido.
- **`.innerHTML`**: Cambia todo el HTML dentro de un elemento. Es más potente pero **peligroso** si insertas contenido de un usuario (riesgo de ataques XSS).

```javascript
const titulo = document.getElementById('titulo-principal');
titulo.textContent = "¡Página Interactiva!"; // Cambia el texto

const seccion = document.querySelector('.caja');
seccion.innerHTML = '<h2>Nueva Sección</h2><p>Este contenido fue añadido por JS.</p>';
```

### Estilos: `.style`
Puedes cambiar los estilos CSS de un elemento. Las propiedades CSS con guiones (ej: `background-color`) se escriben en camelCase (ej: `backgroundColor`).

```javascript
titulo.style.color = 'blue';
titulo.style.backgroundColor = 'lightgray';
```

### Atributos: `.setAttribute()` y `.getAttribute()`

```javascript
const link = document.querySelector('a');
link.setAttribute('href', 'https://www.google.com');
console.log(link.getAttribute('href'));
```

---

## ✨ 3. Creando y Eliminando Elementos

También puedes crear elementos desde cero y añadirlos al DOM.

```javascript
// 1. Crear el nuevo elemento
const nuevaImagen = document.createElement('img');

// 2. Configurar sus atributos y propiedades
nuevaImagen.setAttribute('src', 'https://via.placeholder.com/150');
nuevaImagen.alt = "Imagen de ejemplo";

// 3. Seleccionar el contenedor donde lo añadiremos
const contenedor = document.querySelector('.caja');

// 4. Añadir el nuevo elemento al contenedor
contenedor.appendChild(nuevaImagen);

// Para eliminar un elemento
// nuevaImagen.remove();
```

---

## 🤓 Conceptos Clave para Recordar

- **DOM**: La representación de tu HTML como un árbol de objetos que JS puede manipular.
- **Seleccionar**: El primer paso siempre es seleccionar el elemento (`getElementById`, `querySelector`).
- **Modificar**: Puedes cambiar el contenido (`textContent`), los estilos (`style`) y los atributos (`setAttribute`).
- **Crear**: Puedes generar nuevos elementos (`createElement`) y añadirlos a la página (`appendChild`).

---

## 🎯 Lo Que Viene en la Próxima Clase

Ya sabemos cómo manipular la página. Pero, ¿cómo reaccionamos a lo que hace el usuario? En la **Clase 10**, aprenderemos a manejar **Eventos** para ejecutar nuestro código en respuesta a clics, escritura en el teclado, y mucho más.
