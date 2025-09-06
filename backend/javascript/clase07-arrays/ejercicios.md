# Ejercicios Prácticos: Clase 7

Crea un archivo `arrays.js` y realiza los siguientes ejercicios. Usa `console.log` para verificar cada resultado.

---

### ✅ Ejercicio 1: Manipulación Básica

1.  Crea un array vacío llamado `miPlaylist`.
2.  Usa `push()` para añadir tres de tus canciones favoritas al array.
3.  Muestra en consola la cantidad de canciones en la playlist (usando `.length`).
4.  Usa `pop()` para eliminar la última canción que añadiste.
5.  Usa `unshift()` para añadir una nueva canción al **principio** de la lista.
6.  Muestra en consola la playlist final.

---

### ✅ Ejercicio 2: Transformando con `map`

1.  Dado el siguiente array de objetos:
    ```javascript
    const usuarios = [
        { id: 1, nombre: 'Rafa', edad: 30 },
        { id: 2, nombre: 'Ana', edad: 25 },
        { id: 3, nombre: 'Carlos', edad: 42 }
    ];
    ```
2.  Usa el método `map` para crear un **nuevo array** que contenga solo los nombres de los usuarios.
3.  Usa `map` de nuevo para crear otro array que contenga strings con el formato `"ID: [id] - Nombre: [nombre]"`.
4.  Muestra ambos arrays nuevos en la consola.

---

### ✅ Ejercicio 3: Filtrando con `filter`

1.  Dado el siguiente array de números:
    ```javascript
    const notas = [10, 4, 8, 2, 9, 7, 5, 6];
    ```
2.  Usa el método `filter` para crear un nuevo array llamado `notasAprobadas` que contenga solo las notas mayores o iguales a 6.
3.  Usa `filter` sobre el array de `usuarios` del ejercicio anterior para crear un nuevo array que contenga solo a los usuarios mayores de 35 años.
4.  Muestra ambos arrays nuevos en la consola.

---

### 🏆 Desafío: Consolidando con `reduce`

1.  Dado el siguiente array de compras:
    ```javascript
    const carrito = [
        { producto: 'Leche', precio: 2.50 },
        { producto: 'Pan', precio: 1.80 },
        { producto: 'Queso', precio: 5.00 },
        { producto: 'Manzanas', precio: 3.20 }
    ];
    ```
2.  Usa el método `reduce` para calcular el **costo total** de todos los productos en el carrito.
3.  **Pista**: El `valorInicial` del `reduce` debería ser `0`. En cada iteración, debes sumar al `acumulador` el `precio` del producto actual.
4.  Muestra el costo total en la consola.

**Súper Desafío (Opcional)**: Usa `reduce` sobre el mismo carrito para obtener un string que liste todos los nombres de los productos, separados por una coma. Ejemplo: `"Productos: Leche, Pan, Queso, Manzanas"`.
