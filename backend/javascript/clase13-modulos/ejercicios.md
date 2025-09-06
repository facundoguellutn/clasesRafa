# Ejercicios Prácticos: Clase 13

### Preparación

1.  Crea una nueva carpeta para este proyecto, por ejemplo `app-modulos`.
2.  Dentro, crea los siguientes archivos:
    -   `index.html`
    -   `main.js`
    -   `matematicas.js`
    -   `saludos.js`
3.  En `index.html`, pon la estructura básica y enlaza `main.js` como un módulo:
    ```html
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <title>Mi App con Módulos</title>
    </head>
    <body>
        <h1 id="titulo">App con Módulos</h1>
        <script type="module" src="main.js"></script>
    </body>
    </html>
    ```

---

### ✅ Ejercicio 1: Exportaciones Nombradas

1.  **En `matematicas.js`:**
    -   Crea y exporta (usando `export`) una función `sumar(a, b)`.
    -   Crea y exporta (usando `export`) una función `multiplicar(a, b)`.
    -   Crea y exporta (usando `export`) una constante `PI` con el valor `3.14`.

2.  **En `main.js`:**
    -   Importa `sumar` y `PI` desde `matematicas.js`.
    -   Usa las funciones importadas para calcular `5 + 10` y el área de un círculo con radio 2 (`PI * radio^2`).
    -   Muestra los resultados en la consola.

---

### ✅ Ejercicio 2: Exportación por Defecto

1.  **En `saludos.js`:**
    -   Crea una función `generarSaludo(nombre)` que devuelva un string como `"¡Hola, [nombre]! Bienvenido."`.
    -   Exporta esta función como la **exportación por defecto** del módulo.

2.  **En `main.js`:**
    -   Importa la función por defecto desde `saludos.js`. Puedes darle el nombre que quieras al importarla (ej: `crearSaludo`).
    -   Llama a la función con tu nombre y muestra el resultado en la consola.

---

### ✅ Ejercicio 3: Mezclando Importaciones y Renombrando

1.  **En `matematicas.js`:**
    -   Añade una nueva función `restar(a, b)` y expórtala también como una exportación nombrada.

2.  **En `main.js`:**
    -   Modifica tu línea de importación de `matematicas.js` para que también traiga la función `restar`.
    -   Al importarla, renombra `restar` a `diferencia` usando la palabra clave `as`.
    -   Usa la función `diferencia` para calcular `100 - 45` y muéstralo en consola.

---

### 🏆 Desafío: Módulos para el DOM

1.  Crea un nuevo archivo `dom-utils.js`.
2.  Dentro de `dom-utils.js`, crea y exporta una función `cambiarTitulo(nuevoTitulo)`.
    -   Esta función debe seleccionar el `<h1>` del `index.html` por su `id` (`titulo`) y cambiar su `textContent` al `nuevoTitulo` que recibe como parámetro.
3.  Crea y exporta otra función `agregarParrafo(texto)`.
    -   Esta función debe crear un nuevo elemento `<p>`, asignarle el `texto` a su `textContent`, y añadirlo al `<body>` del documento.
4.  **En `main.js`:**
    -   Importa ambas funciones desde `dom-utils.js`.
    -   Llama a `cambiarTitulo` para cambiar el título de la página a "¡Módulos en Acción!".
    -   Llama a `agregarParrafo` para añadir un nuevo párrafo a la página con el texto que tú quieras.

Al abrir `index.html` en el navegador, deberías ver los cambios en el DOM realizados desde tu módulo de utilidades.
