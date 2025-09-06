# Ejercicios Prácticos: Clase 8

Crea un archivo `objetos.js` y realiza los siguientes ejercicios. Usa `console.log` para verificar cada resultado.

---

### ✅ Ejercicio 1: Creación y Manipulación de un Objeto

1.  Crea un objeto `const` llamado `pelicula` con las siguientes propiedades:
    -   `titulo`: Tu película favorita.
    -   `director`: El director de la película.
    -   `año`: El año de estreno.
    -   `generos`: Un array de strings con los géneros de la película.
2.  Muestra en consola el objeto completo.
3.  Muestra en consola el `titulo` usando notación de punto.
4.  Muestra en consola el `año` usando notación de corchetes.
5.  Añade una nueva propiedad `calificacion` con un valor numérico del 1 al 10.
6.  Actualiza el valor del `año` a un nuevo año.
7.  Muestra en consola el objeto final para ver los cambios.

---

### ✅ Ejercicio 2: Añadiendo Métodos

1.  Al objeto `pelicula` del ejercicio anterior, añádele un método llamado `mostrarInfo`.
2.  Este método debe usar `this` para construir y mostrar en consola un string con el formato: `"[titulo], dirigida por [director], se estrenó en [año]."`
3.  Añade otro método llamado `añadirGenero` que acepte un parámetro `nuevoGenero` y lo añada al array `generos`.
4.  Llama a `mostrarInfo()` para ver el mensaje.
5.  Llama a `añadirGenero("Aventura")` y luego muestra la propiedad `generos` para confirmar que se añadió.

---

### ✅ Ejercicio 3: Desestructuración y Spread Syntax

1.  Crea un objeto `const` llamado `jugador` con las propiedades `nombre`, `equipo`, `posicion` y `goles`.
2.  Usa la **desestructuración** para extraer las propiedades `nombre` y `equipo` en dos variables separadas.
3.  Muestra estas dos variables en consola.
4.  Crea un segundo objeto `const` llamado `estadisticasAdicionales` con las propiedades `asistencias` y `tarjetasRojas`.
5.  Usa el **spread syntax (`...`)** para crear un nuevo objeto `jugadorCompleto` que combine las propiedades de `jugador` y `estadisticasAdicionales`.
6.  Muestra el objeto `jugadorCompleto` en consola.

---

### 🏆 Desafío: Recorriendo un Objeto

Dado el siguiente objeto:
```javascript
const producto = {
    id: "PROD001",
    nombre: "Teclado Mecánico RGB",
    precio: 150,
    disponible: true
};
```

1.  Usa `Object.keys()` para obtener un array con las claves del objeto `producto`.
2.  Usa un bucle `for...of` para recorrer ese array de claves.
3.  Dentro del bucle, muestra en consola cada clave y su valor correspondiente del objeto `producto`.
    -   **Pista**: Necesitarás usar la notación de corchetes para acceder al valor dinámicamente (`producto[clave]`).

El resultado en consola debería ser:
```
id: PROD001
nombre: Teclado Mecánico RGB
precio: 150
disponible: true
```
