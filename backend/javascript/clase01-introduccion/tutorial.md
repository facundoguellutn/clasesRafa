# Clase 1: Introducción a JavaScript

## 🎯 Objetivos de la Clase

Al finalizar esta clase, serás capaz de:
- Entender qué es JavaScript y cuál es su rol fundamental en la web.
- Diferenciar entre JavaScript en el navegador (Frontend) y en el servidor (Backend con Node.js).
- Escribir y ejecutar tus primeras líneas de código JavaScript.
- Entender cómo se integra JavaScript en un archivo HTML.

---

## 🤔 ¿Qué es JavaScript y Para Qué Sirve?

Imagina que una página web es un cuerpo humano:
- **HTML** es el **esqueleto**: define la estructura y el contenido básico (títulos, párrafos, imágenes).
- **CSS** es la **piel y la ropa**: define la apariencia, los colores, la tipografía y el diseño.
- **JavaScript** es el **sistema nervioso y los músculos**: se encarga de la interactividad, el movimiento y la lógica.

JavaScript es el lenguaje de programación que da vida a las páginas web. Permite crear desde simples alertas y animaciones hasta complejas aplicaciones web como Google Maps, Instagram o Netflix.

**Roles de JavaScript:**
1.  **Frontend (Navegador)**: Es su rol original. Se ejecuta en el navegador del usuario para manipular el HTML y CSS, reaccionar a las acciones del usuario (clics, scroll), y comunicarse con servidores para obtener datos.
2.  **Backend (Servidor con Node.js)**: Gracias a Node.js, JavaScript también puede correr en un servidor. Esto te permite crear APIs, conectarte a bases de datos y construir toda la lógica de un servidor, tal como lo hacemos con Express.

---

## 🚀 ¿Cómo Empezamos a Escribir Código?

Existen tres formas principales de ejecutar JavaScript:

### 1. La Consola del Navegador (Tu Laboratorio Personal)
Es la forma más rápida de probar código.
1.  En tu navegador (Chrome, Firefox, etc.), haz clic derecho en cualquier parte de la página y selecciona **"Inspeccionar"**.
2.  Se abrirán las "Herramientas para Desarrolladores". Busca y haz clic en la pestaña **"Consola"**.
3.  ¡Listo! Este es un entorno donde puedes escribir JavaScript y ver el resultado al instante.

**Probá esto:** Escribí `2 + 2` y presioná Enter. Luego, escribí tu primer "Hola, Mundo":
```javascript
console.log("¡Hola, Mundo desde la consola!");
```
`console.log()` es la herramienta fundamental para "imprimir" mensajes y ver qué está pasando en tu código.

### 2. Dentro de un Archivo HTML (Inline)
Puedes poner tu código directamente en el HTML usando la etiqueta `<script>`.

```html
<!DOCTYPE html>
<html>
<head>
    <title>Mi Primera Página con JS</title>
</head>
<body>
    <h1>Hola</h1>

    <script>
        // Este código se ejecuta cuando el navegador lee esta parte
        alert("¡Bienvenido a mi página!");
    </script>
</body>
</html>
```
El `alert()` mostrará una ventana emergente. Es útil para pruebas rápidas, pero no es ideal para código complejo.

### 3. En un Archivo Externo (La Forma Correcta)
Para cualquier aplicación real, separarás tu JavaScript en su propio archivo (`.js`).

**Paso 1: Crea `index.html`**
```html
<!DOCTYPE html>
<html>
<head>
    <title>Mi App de JS</title>
</head>
<body>
    <h1>Mi Aplicación</h1>
    
    <!-- Enlazamos nuestro archivo JS. Se suele poner al final del body -->
    <script src="app.js"></script>
</body>
</html>
```

**Paso 2: Crea `app.js` en la misma carpeta**
```javascript
// app.js
console.log("El archivo app.js se ha cargado correctamente.");
// A partir de aquí escribiremos la lógica de nuestra aplicación.
```
Al abrir `index.html` en el navegador, verás el mensaje en la consola. Esta es la práctica estándar porque mantiene el código organizado y limpio.

---

## 🤓 Conceptos Clave para Recordar

- **JavaScript da interactividad a la web.** Es el "músculo" y el "cerebro".
- **Puede correr en el Frontend (navegador) y en el Backend (Node.js).**
- **La Consola** es tu mejor amiga para experimentar y depurar.
- **`console.log()`** es la herramienta para mostrar mensajes.
- **La etiqueta `<script>`** es la que conecta JavaScript con HTML.
- **Separar el código en archivos `.js`** es la mejor práctica.

---

## 🎯 Lo Que Viene en la Próxima Clase

En la **Clase 2** vamos a sumergirnos en los ladrillos fundamentales de cualquier programa:
- **Variables**: Cómo guardar y nombrar datos.
- **Tipos de Datos**: Los diferentes tipos de información que podemos manejar (texto, números, etc.).
