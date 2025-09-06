# Ejercicios Prácticos: Clase 2

Estos ejercicios te ayudarán a solidificar tu comprensión de las variables y los tipos de datos. Trabaja en un archivo `app.js` y observa los resultados en la consola del navegador.

---

### ✅ Ejercicio 1: Declarando Variables Personales

1.  Declara una variable `const` llamada `nombre` y asígnale tu nombre como valor.
2.  Declara una variable `let` llamada `edad` y asígnale tu edad.
3.  Declara una variable `const` llamada `ciudad` y asígnale el nombre de tu ciudad.
4.  Usa `console.log` para mostrar un mensaje que se presente, usando estas variables. Por ejemplo: `"Hola, mi nombre es Rafa, tengo 30 años y vivo en Buenos Aires."`
    -   **Pista**: Puedes unir strings con el operador `+`.

    ```javascript
    console.log("Hola, mi nombre es " + nombre + ", tengo " + edad + " años y vivo en " + ciudad + ".");
    ```

---

### ✅ Ejercicio 2: `let` vs. `const`

1.  Debajo del código anterior, intenta reasignar un nuevo nombre a tu variable `nombre`.
    ```javascript
    // nombre = "Facundo";
    ```
    -   Descomenta esa línea. ¿Qué error te muestra la consola? ¿Por qué? (Responde en un comentario en tu código). Vuelve a comentarla para seguir.

2.  Ahora, reasigna un nuevo valor a tu variable `edad` (por ejemplo, tu edad + 1).
    ```javascript
    edad = edad + 1;
    ```
3.  Muestra la nueva edad en la consola. ¿Funcionó? ¿Por qué? (Responde en un comentario).

---

### ✅ Ejercicio 3: El Operador `typeof`

1.  Crea las siguientes variables:
    ```javascript
    const esEstudiante = true;
    const altura = 1.80;
    let equipoFavorito = null;
    let proximoViaje; 
    ```
2.  Usa `console.log` y el operador `typeof` para mostrar el tipo de dato de cada una de las variables que has creado hasta ahora (`nombre`, `edad`, `esEstudiante`, `altura`, `equipoFavorito`, `proximoViaje`).

**Reflexión**: ¿Qué diferencia notas entre el resultado de `typeof equipoFavorito` y `typeof proximoViaje`? `typeof null` es un error histórico famoso de JavaScript, ¡búscalo en Google!

---

### 🏆 Desafío: Template Literals

JavaScript tiene una forma más moderna y legible de construir strings con variables, llamada "Template Literals" o "Template Strings". Usan comillas invertidas (`` ` ``) en lugar de comillas simples o dobles.

Investiga cómo funcionan y rehaz el `console.log` del Ejercicio 1 usando esta técnica.

**Pista**: La sintaxis se ve algo así: `` `Hola, mi nombre es ${variable}` ``.
