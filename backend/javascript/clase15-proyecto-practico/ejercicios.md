# Ejercicios y Mejoras del Proyecto

El objetivo ahora es tomar la aplicación base y extenderla con nuevas funcionalidades. Cada uno de estos ejercicios representa una mejora significativa en la usabilidad y robustez de la aplicación.

---

### ✅ Ejercicio 1: Implementación Base

1.  Sigue el `tutorial.md` paso a paso para construir la versión inicial y funcional de la Lista de Tareas.
2.  Asegúrate de entender cada parte, especialmente la lógica de la delegación de eventos para completar y eliminar tareas.

---

### ✅ Ejercicio 2: Validación de Input

**Mejora**: Evitar que el usuario pueda añadir tareas vacías.

1.  En el `addEventListener` del formulario, ya tienes la línea `const textoTarea = inputTarea.value.trim();`.
2.  La lógica `if (textoTarea !== '')` ya previene que se agregue la tarea.
3.  **Tu tarea**: Añade un `else` a esa condición. Si el `textoTarea` está vacío, muestra una `alert` al usuario que diga "Por favor, escribe una tarea antes de añadirla".

---

### 🏆 Desafío 1: Persistencia con `localStorage`

**Mejora**: Hacer que las tareas no se borren al recargar la página.

1.  **Refactoriza tu código para usar un array como fuente de verdad**, como se explica en el `explicacion_detallada.md`.
    -   Crea un array `let tareas = [];`.
    -   Modifica tu lógica para que, en lugar de manipular el DOM directamente, manipules este array (añadiendo, eliminando y cambiando el estado `completada` de los objetos).
    -   Crea una función `renderizar()` que genere el HTML de la lista a partir del estado actual del array `tareas`.

2.  **Implementa `localStorage`:**
    -   Crea una función `guardarEnLocalStorage()` que convierta tu array `tareas` a JSON y lo guarde.
    -   Llama a esta función cada vez que modifiques el array `tareas`.
    -   Al inicio de tu script, intenta cargar las tareas desde `localStorage`. Si existen, conviértelas de JSON a un array y úsalas como el estado inicial. Si no, empieza con un array vacío.
    -   Llama a `renderizar()` al final de la carga inicial.

---

### 🏆 Desafío 2: Edición de Tareas

**Mejora**: Permitir al usuario editar el texto de una tarea existente.

1.  En la función donde creas cada `<li>`, añade un botón de "Editar".
2.  Usando delegación de eventos, escucha los clics en este botón.
3.  Cuando se haga clic en "Editar":
    -   Oculta el texto de la tarea y el botón de editar.
    -   Muestra un campo `<input type="text">` en su lugar, con el texto actual de la tarea.
    -   Dale el foco a ese input.
4.  Cuando el usuario presione "Enter" o el input pierda el foco (`blur` event), guarda el nuevo texto en tu array de estado, y vuelve a renderizar la lista.

---

### 🏆 Desafío 3: Filtros de Visualización

**Mejora**: Añadir botones para filtrar las tareas visibles.

1.  Añade tres botones al HTML: "Todas", "Activas", "Completadas".
2.  Crea una variable de estado para el filtro actual, ej: `let filtroActual = 'todas';`.
3.  Añade event listeners a los botones de filtro. Cuando se hace clic, deben actualizar la variable `filtroActual` y volver a llamar a `renderizar()`.
4.  Modifica tu función `renderizar()`:
    -   Antes del bucle que crea los `<li>`, filtra el array `tareas` basándote en `filtroActual`.
    -   Si el filtro es `'activas'`, muestra solo las tareas donde `completada` es `false`.
    -   Si el filtro es `'completadas'`, muestra solo las que tienen `completada` en `true`.
    -   Usa este nuevo array filtrado para generar los `<li>`.
