# Ejercicios Prácticos: Clase 3

Para estos ejercicios, crea un archivo `operadores.js` y ejecuta el código (puedes usar la consola del navegador o Node.js) para verificar tus resultados.

---

### ✅ Ejercicio 1: Calculadora de Compras

1.  Declara tres variables `const` para representar tres productos en un carrito de compras:
    -   `precioProducto1` con valor `25.99`
    -   `precioProducto2` con valor `10.50`
    -   `precioProducto3` con valor `5.75`

2.  Calcula el `subtotal` de la compra (la suma de los tres productos) y guárdalo en una variable `let`.
3.  Define una `const` llamada `IVA` con el valor `0.21` (21%).
4.  Calcula el `totalConIVA` (subtotal + subtotal * IVA) y guárdalo en una variable.
5.  Usa `console.log` para mostrar el subtotal y el total con IVA de una forma clara. Por ejemplo:
    ```
    Subtotal: 42.24
    Total con IVA: 51.11
    ```

---

### ✅ Ejercicio 2: Simulador de Puntos de Juego

1.  Declara una variable `let` llamada `puntos` e inicialízala en `0`.
2.  Simula que el jugador ha ganado puntos. Usa el operador de asignación `+=` para sumarle `10` puntos.
3.  Simula que el jugador ha perdido puntos. Usa el operador `-=` para restarle `3` puntos.
4.  Muestra los puntos actuales en la consola.
5.  Ahora, declara una `const` `PUNTOS_PARA_GANAR` con el valor `50`.
6.  Usa un operador de comparación para crear una variable booleana `haGanado` que sea `true` si `puntos` es mayor o igual a `PUNTOS_PARA_GANAR`.
7.  Muestra en consola si el jugador ha ganado. Ejemplo: `"¿El jugador ha ganado?: true"`.

---

### ✅ Ejercicio 3: Lógica de Acceso

1.  Crea las siguientes variables:
    ```javascript
    const estaLogueado = true;
    const esAdmin = false;
    const tienePermisosEspeciales = false;
    ```
2.  Crea una variable `puedeAccederAlPanel` que sea `true` solo si `estaLogueado` es `true` Y `esAdmin` es `true`.
3.  Crea una variable `puedeVerContenidoPrivado` que sea `true` si `estaLogueado` es `true` O `tienePermisosEspeciales` es `true`.
4.  Crea una variable `puedeBorrarUsuarios` que sea `true` solo si `estaLogueado`, `esAdmin` Y `tienePermisosEspeciales` son todos `true`.
5.  Usa el operador `!` (NOT) para crear una variable `esUsuarioNormal` que sea `true` si `esAdmin` es `false`.
6.  Muestra todas estas nuevas variables en la consola para verificar los resultados.

---

### 🏆 Desafío: El Poder del Módulo y el Cortocircuito

1.  **Divisibilidad**: Declara una variable `numero` con un valor (ej: `20`). Crea una variable `esDivisiblePor5` que sea `true` si `numero` es divisible por 5. (Pista: ¿qué resultado da el operador módulo `%` cuando un número es divisible por otro?).

2.  **Asignación con Cortocircuito**: Imagina que tienes una variable `configuracionUsuario` que puede ser `null` o un objeto. Quieres crear una variable `tema` que sea igual a `configuracionUsuario.tema` si existe, o `'dark'` por defecto si no.

    ```javascript
    let configuracionUsuario = null; // o { tema: 'light' };
    const tema = (configuracionUsuario && configuracionUsuario.tema) || 'dark';
    console.log("Tema aplicado:", tema);
    ```
    -   Prueba este código con `configuracionUsuario` siendo `null` y luego siendo `{ tema: 'light' }`. ¿Entiendes por qué funciona? Explícalo con un comentario.
