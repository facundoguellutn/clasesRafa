# Explicación Detallada: Arquitectura y Mejoras del Proyecto

## 🎯 Objetivo de este Documento

Analizar la arquitectura de nuestra To-Do App, entender sus limitaciones y explorar cómo podríamos mejorarla y escalarla usando conceptos más avanzados como la persistencia de datos y la separación de responsabilidades.

---

## 🏛️ 1. Arquitectura Actual: El DOM como Estado

En nuestro proyecto, la **"única fuente de verdad"** sobre el estado de nuestra aplicación (la lista de tareas) es el propio **DOM**. Cuando queremos saber qué tareas hay, las leemos del HTML. Cuando queremos añadir una, la añadimos al HTML. Cuando la borramos, la quitamos del HTML.

**Ventajas:**
- Es simple y directo para aplicaciones pequeñas.
- Es fácil de entender al principio.

**Desventajas:**
- **No es escalable**: Si la aplicación crece, manejar el estado se vuelve un caos.
- **Pérdida de datos**: Al recargar la página, todo el estado se pierde porque el DOM se reinicia.
- **Acoplamiento**: La lógica de la aplicación está fuertemente acoplada a la estructura del DOM. Un cambio en el HTML puede romper el JavaScript.

---

## ✨ 2. Mejora: Separando el Estado de la Vista

Una arquitectura mucho mejor es tener el estado de la aplicación en una variable de JavaScript (normalmente un array de objetos) y tratar el DOM solo como una **representación visual** de ese estado.

1.  **El Estado (La Fuente de Verdad)**: Un array en JavaScript.
    ```javascript
    let tareas = [
        { id: 1, texto: "Lavar el auto", completada: false },
        { id: 2, texto: "Hacer las compras", completada: true }
    ];
    ```

2.  **La Función de Renderizado**: Una función que borra la lista actual en el DOM y la reconstruye basándose en el array de `tareas`.
    ```javascript
    function renderizarTareas() {
        listaTareas.innerHTML = ''; // Borra la lista actual
        for (const tarea of tareas) {
            // Crea el <li>, le añade la clase si está completada, etc.
            // ... y lo añade al DOM
        }
    }
    ```

3.  **Los Eventos**: Ahora, los eventos no manipulan el DOM directamente. Manipulan el **array de estado** y luego llaman a `renderizarTareas()` para que la vista se actualice.
    ```javascript
    // Al añadir una tarea
    function onFormSubmit() {
        // ...
        const nuevaTarea = { id: Date.now(), texto: textoInput, completada: false };
        tareas.push(nuevaTarea);
        renderizarTareas(); // Re-dibuja la lista completa
    }

    // Al completar una tarea
    function onTareaClick(id) {
        const tarea = tareas.find(t => t.id === id);
        tarea.completada = !tarea.completada;
        renderizarTareas();
    }
    ```

Este patrón (Estado -> Renderizar) es el **corazón de todas las librerías y frameworks modernos como React, Vue y Angular**.

---

## 💾 3. Persistencia de Datos con `localStorage`

Para que nuestras tareas no se pierdan al recargar la página, podemos usar el `localStorage` del navegador. Es un almacenamiento simple de tipo clave-valor que persiste entre sesiones.

- **`localStorage.setItem(clave, valor)`**: Guarda un valor (debe ser un string).
- **`localStorage.getItem(clave)`**: Obtiene un valor.
- **`localStorage.removeItem(clave)`**: Elimina un valor.

Como solo podemos guardar strings, necesitamos convertir nuestro array de tareas a un string antes de guardarlo, y viceversa al cargarlo. Para esto usamos `JSON`.

- **`JSON.stringify(objeto)`**: Convierte un objeto o array de JavaScript a un string en formato JSON.
- **`JSON.parse(string)`**: Convierte un string JSON de vuelta a un objeto/array de JavaScript.

**Implementación:**

1.  **Guardar**: Cada vez que el array `tareas` cambie (al añadir, completar o borrar), llama a una función `guardarTareas()`.
    ```javascript
    function guardarTareas() {
        localStorage.setItem('mis_tareas', JSON.stringify(tareas));
    }
    ```

2.  **Cargar**: Al inicio de la aplicación, comprueba si hay tareas guardadas en `localStorage`.
    ```javascript
    function cargarTareas() {
        const tareasGuardadas = localStorage.getItem('mis_tareas');
        if (tareasGuardadas) {
            tareas = JSON.parse(tareasGuardadas);
        }
        renderizarTareas();
    }

    // Llama a esta función cuando el script se carga por primera vez.
    cargarTareas();
    ```

Combinando la separación del estado y el `localStorage`, obtenemos una aplicación mucho más robusta, escalable y con una mejor experiencia de usuario.
