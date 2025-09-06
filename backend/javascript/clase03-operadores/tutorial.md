# Clase 3: Operadores

## 🎯 Objetivos de la Clase

Al finalizar esta clase, serás capaz de:
- Realizar cálculos matemáticos usando operadores aritméticos.
- Modificar variables de forma concisa con los operadores de asignación.
- Comparar valores de forma segura y eficaz.
- Combinar condiciones para tomar decisiones complejas usando operadores lógicos.

---

## 🤔 ¿Qué son los Operadores?

> **Analogía**: Si las variables son los "sustantivos" (las cosas) en programación, los **operadores son los "verbos"** (las acciones). Son símbolos especiales que realizan operaciones sobre uno o más valores (operandos) para producir un resultado.

---

## 🧮 1. Operadores Aritméticos

Son los que ya conoces de las matemáticas. Se usan para realizar cálculos con números.

- `+` (Suma): `5 + 3`  // Resultado: 8
- `-` (Resta): `10 - 4` // Resultado: 6
- `*` (Multiplicación): `7 * 3` // Resultado: 21
- `/` (División): `15 / 3` // Resultado: 5
- `**` (Exponenciación): `2 ** 3` // Resultado: 8 (2 elevado a 3)
- `%` (Módulo): `10 % 3` // Resultado: 1 (es el **resto** de la división 10 / 3)

El operador módulo (`%`) es súper útil para saber si un número es par (`numero % 2 === 0`) o para tareas cíclicas.

---

## ✍️ 2. Operadores de Asignación

Se usan para asignar un valor a una variable. El más básico es `=`.

```javascript
let puntaje = 100;
```

Pero existen atajos muy comunes para modificar una variable basándose en su propio valor:

- `+=` (Suma y asigna): `puntaje += 50;` // Equivale a: `puntaje = puntaje + 50;`
- `-=` (Resta y asigna): `puntaje -= 20;` // Equivale a: `puntaje = puntaje - 20;`
- `*=` (Multiplica y asigna): `puntaje *= 2;`
- `/=` (Divide y asigna): `puntaje /= 4;`

---

## ⚖️ 3. Operadores de Comparación

Producen un resultado booleano (`true` o `false`). Son la base de la toma de decisiones.

- `>` (Mayor que): `10 > 5` // true
- `<` (Menor que): `10 < 5` // false
- `>=` (Mayor o igual que): `10 >= 10` // true
- `<=` (Menor o igual que): `5 <= 10` // true

### La Comparación Más Importante: `==` vs. `===`

- `==` (Igualdad "suelta"): Compara si dos valores son iguales, **pero primero intenta convertirlos al mismo tipo**. Esto puede dar resultados inesperados.
  `5 == "5"` // true (Malo)

- `===` (Igualdad "estricta"): Compara si dos valores son iguales **Y si son del mismo tipo**. No hace conversiones mágicas.
  `5 === "5"` // false (Bueno)

- `!=` (Desigualdad "suelta") y `!==` (Desigualdad "estricta") siguen la misma lógica.

> **Regla de Oro Absoluta**: Usa **SIEMPRE** `===` y `!==` para comparar. Te salvará de incontables errores.

---

## 🧠 4. Operadores Lógicos

Permiten combinar múltiples condiciones booleanas.

- `&&` (AND / Y): Devuelve `true` solo si **ambas** condiciones son verdaderas.
  ```javascript
  const esMayor = edad >= 18;
  const tieneCarnet = true;
  const puedeConducir = esMayor && tieneCarnet; // true
  ```

- `||` (OR / O): Devuelve `true` si **al menos una** de las condiciones es verdadera.
  ```javascript
  const esAdmin = false;
  const esEditor = true;
  const puedeEditarContenido = esAdmin || esEditor; // true
  ```

- `!` (NOT / NO): Invierte un valor booleano. Convierte `true` en `false` y viceversa.
  ```javascript
  const estaLogueado = false;
  console.log(!estaLogueado); // true
  ```

---

## 🤓 Conceptos Clave para Recordar

- **Operadores**: Son los verbos que actúan sobre tus datos.
- **Aritméticos**: Para hacer matemáticas. No olvides el `%` (módulo).
- **Asignación**: `+=` y `-=` son atajos que usarás todo el tiempo.
- **Comparación**: La regla es **`===` siempre**. La igualdad estricta es tu amiga.
- **Lógicos**: `&&` (ambos), `||` (alguno), `!` (el contrario).

---

## 🎯 Lo Que Viene en la Próxima Clase

Ahora que sabemos cómo crear condiciones (`edad > 18`), en la **Clase 4** usaremos las **Estructuras de Control** (`if`, `else`, `switch`) para que nuestro programa pueda tomar caminos diferentes basados en esas condiciones.
