# Ejercicios Prácticos: Clase 4

Crea un archivo `control-flujo.js` y realiza los siguientes ejercicios. Usa `console.log` para verificar cada resultado.

---

### ✅ Ejercicio 1: Calificación de Examen

1.  Declara una variable `let` llamada `nota` y asígnale un número del 0 al 10.
2.  Usando una estructura `if / else if / else`, muestra en consola un mensaje según la nota:
    -   Si la nota es 9 o 10, muestra "Sobresaliente".
    -   Si la nota es entre 6 y 8 (inclusive), muestra "Aprobado".
    -   Si la nota es entre 0 y 5 (inclusive), muestra "Desaprobado".
    -   Para cualquier otro valor, muestra "Nota no válida".
3.  Prueba tu código cambiando el valor de `nota` varias veces para asegurarte de que todos los caminos funcionan.

---

### ✅ Ejercicio 2: Menú del Día con `switch`

1.  Declara una variable `const` llamada `dia` y asígnale un día de la semana en minúsculas (ej: `'lunes'`).
2.  Usa una estructura `switch` para determinar el plato del día:
    -   `'lunes'`: "Milanesa con puré"
    -   `'martes'`: "Pastel de papas"
    -   `'miércoles'`: "Fideos con tuco"
    -   `'jueves'`: "Guiso de lentejas"
    -   `'viernes'`: "Pizza"
    -   `'sábado'` y `'domingo'`: "Asado"
    -   Para cualquier otro valor, el `default` debe ser "Día no válido".
3.  **Pista**: ¿Cómo puedes hacer para que `'sábado'` y `'domingo'` muestren el mismo plato sin repetir código? (Revisa el concepto de "fall-through" en la explicación detallada).
4.  Muestra el plato del día en la consola.

---

### ✅ Ejercicio 3: Acceso a un Evento con Operador Ternario

1.  Declara una variable `let` llamada `edadUsuario` con un valor numérico.
2.  Declara una variable `const` llamada `TIENE_TICKET` con un valor booleano (`true` o `false`).
3.  Usando **un solo `console.log`** y el operador ternario, muestra el mensaje "Puede acceder" o "No puede acceder".
4.  La condición es que el usuario debe ser mayor o igual a 18 **Y** `TIENE_TICKET` debe ser `true`.

    ```javascript
    // Ejemplo de la estructura que debes usar
    console.log( (condicion_compleja) ? "Puede acceder" : "No puede acceder" );
    ```

---

### 🏆 Desafío: Lógica de "Truthy" y "Falsy"

Imagina que estás recibiendo datos de un formulario. Un campo `nombre` puede llegar como un string con el nombre, o como un string vacío `""` si el usuario no lo llenó.

1.  Declara una variable `let` llamada `nombreIngresado`.
2.  Asígnale un nombre, por ejemplo, `'Rafa'`. Luego, prueba asignándole `''`.
3.  Escribe una estructura `if/else` que **no use una comparación explícita** como `nombreIngresado !== ""`.
4.  Si `nombreIngresado` tiene un valor (es "truthy"), debe mostrar `"Bienvenido, [nombreIngresado]"`.
5.  Si `nombreIngresado` está vacío (es "falsy"), debe mostrar `"Por favor, complete su nombre."`.

Este es un patrón muy común para validar entradas de usuario de forma rápida.
