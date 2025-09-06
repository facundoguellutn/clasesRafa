# Ejercicios Prácticos: Clase 1

El objetivo de estos ejercicios es que te familiarices con las herramientas y el flujo de trabajo básico para escribir JavaScript.

---

### ✅ Ejercicio 1: Tu Laboratorio, la Consola

1.  Abre tu navegador web (Google Chrome recomendado).
2.  Haz clic derecho en cualquier lugar de una página en blanco (`about:blank`) y selecciona **"Inspeccionar"**.
3.  Ve a la pestaña **"Consola"**.
4.  **Realiza las siguientes acciones directamente en la consola:**
    -   Escribe `console.log("¡Hola, Rafa!");` y presiona Enter.
    -   Realiza algunas operaciones matemáticas simples, como `5 * 4` o `100 / 2`.
    -   Escribe `alert("Esto es una alerta desde la consola");` y presiona Enter.

**Reflexión**: ¿Ves la diferencia entre `console.log` y `alert`? Uno es para nosotros (los desarrolladores) y el otro interrumpe al usuario.

---

### ✅ Ejercicio 2: JavaScript Dentro de HTML (Inline)

1.  En tu computadora, crea una nueva carpeta llamada `clase-js-1`.
2.  Dentro de esa carpeta, crea un archivo llamado `inline.html`.
3.  Abre `inline.html` con tu editor de código (Visual Studio Code) y pega el siguiente contenido:

    ```html
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <title>JS Inline</title>
    </head>
    <body>
        <h1>Bienvenido</h1>
        <p>Esta página tiene JavaScript dentro.</p>

        <!-- Tu código va aquí abajo -->
        <script>
            console.log("Página cargada y script ejecutado.");
            alert("¡El script inline funciona!");
        </script>
    </body>
    </html>
    ```
4.  Guarda el archivo y ábrelo con tu navegador web (puedes hacer doble clic en el archivo). Deberías ver la alerta.

---

### ✅ Ejercicio 3: Usando un Archivo Externo (La Forma Correcta)

1.  Dentro de la misma carpeta `clase-js-1`, crea dos archivos: `app.html` y `app.js`.
2.  **En `app.html`, pega este código:**

    ```html
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <title>Mi App con JS Externo</title>
    </head>
    <body>
        <h1 id="titulo">Mi Aplicación con JS</h1>
        
        <!-- Enlazamos nuestro archivo JS externo -->
        <script src="app.js"></script>
    </body>
    </html>
    ```

3.  **En `app.js`, escribe este código:**

    ```javascript
    // app.js
    console.log("El archivo app.js se ha cargado.");
    alert("¡El script externo funciona!");
    ```

4.  Guarda ambos archivos y abre `app.html` en tu navegador. El resultado debería ser similar al del ejercicio 2.

---

### 🏆 Desafío: Modificando el HTML desde JavaScript

Este es un adelanto de lo que veremos más adelante (manipulación del DOM), ¡pero puedes intentarlo!

1.  **Modifica tu archivo `app.js`** del ejercicio 3. Borra el `alert` y reemplázalo con este código:

    ```javascript
    // app.js
    console.log("El archivo app.js se ha cargado.");

    // 1. Seleccionamos el elemento H1 que tiene el id "titulo"
    const tituloDeLaPagina = document.getElementById("titulo");

    // 2. Cambiamos su contenido de texto
    tituloDeLaPagina.textContent = "¡Cambiado por JavaScript!";
    ```

2.  Guarda `app.js` y refresca `app.html` en tu navegador.
3.  **Observa**: ¿Qué pasó con el título `<h1>`? Acabas de usar JavaScript para manipular el contenido de tu página web. ¡Este es el poder fundamental de JS en el frontend!
