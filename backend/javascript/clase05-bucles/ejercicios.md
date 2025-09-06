# Ejercicios Prácticos: Clase 5

Crea un archivo `bucles.js` y realiza los siguientes ejercicios. Usa `console.log` para verificar cada resultado.

---

### ✅ Ejercicio 1: La Tabla de Multiplicar

1.  Usa un bucle `for` para generar la tabla de multiplicar del número 7.
2.  El resultado debe ser una serie de strings en la consola, desde "7 x 1 = 7" hasta "7 x 10 = 35".

    ```javascript
    const numeroTabla = 7;
    console.log(`Tabla de multiplicar del ${numeroTabla}`);
    for (let i = 1; i <= 10; i++) {
        // Tu código aquí para mostrar cada línea de la tabla
        console.log(`${numeroTabla} x ${i} = ${numeroTabla * i}`);
    }
    ```

---

### ✅ Ejercicio 2: Cuenta Regresiva

1.  Usa un bucle `while` para simular una cuenta regresiva para el lanzamiento de un cohete.
2.  El bucle debe empezar en `10` y mostrar en consola los números "10", "9", "8", ..., hasta "1".
3.  Después de que el bucle termine, muestra el mensaje "¡Despegue! 🚀".

    ```javascript
    let cuentaRegresiva = 10;
    console.log("Iniciando cuenta regresiva...");
    while (cuentaRegresiva > 0) {
        // Tu código aquí
        cuentaRegresiva--; // ¡No olvides decrementar el contador!
    }
    // Tu código para el mensaje de despegue aquí
    ```

---

### ✅ Ejercicio 3: Lista de la Compra con `for...of`

1.  Crea un array llamado `listaDeCompras` con al menos 5 productos (strings).
2.  Usa un bucle `for...of` para recorrer el array.
3.  Dentro del bucle, muestra en consola un mensaje para cada producto, por ejemplo: `"No olvidar comprar: Leche"`.

---

### 🏆 Desafío: Buscando al Ganador

Imagina que tienes una lista de participantes en un sorteo y un número ganador.

1.  Crea un array `participantes` con varios nombres.
2.  Crea una `const` `ganador` y asígnale uno de los nombres del array.
3.  Usa un bucle `for...of` para recorrer la lista de `participantes`.
4.  Dentro del bucle, usa una estructura `if` para comprobar si el `participante` actual es el `ganador`.
5.  Si encuentras al ganador, muestra un mensaje como `"¡El ganador es [nombre]!"` y **detén el bucle inmediatamente** (Pista: `break`).
6.  Si el participante no es el ganador, muestra `"[nombre] sigue participando..."`.
