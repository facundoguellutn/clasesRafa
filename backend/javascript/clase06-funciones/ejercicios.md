# Ejercicios Prácticos: Clase 6

Crea un archivo `funciones.js` y realiza los siguientes ejercicios. Usa `console.log` para verificar el resultado de cada función.

---

### ✅ Ejercicio 1: Calculadora de Área

1.  Escribe una **declaración de función** llamada `calcularAreaRectangulo`.
2.  Debe aceptar dos parámetros: `base` y `altura`.
3.  Dentro de la función, debe calcular el área (`base * altura`) y **devolver** el resultado.
4.  Llama a la función con una base de `5` y una altura de `3` y muestra el resultado en consola.

---

### ✅ Ejercicio 2: Convertidor de Temperatura

1.  Escribe una **expresión de función** y asígnala a una constante llamada `convertirFahrenheitACelsius`.
2.  Debe aceptar un parámetro: `gradosFahrenheit`.
3.  La fórmula para convertir es: `(gradosFahrenheit - 32) * 5 / 9`.
4.  La función debe devolver la temperatura calculada en grados Celsius.
5.  Llama a la función con un valor de `68` grados Fahrenheit y muestra el resultado.

---

### ✅ Ejercicio 3: Generador de Nombres de Usuario

1.  Escribe una **función flecha (arrow function)** llamada `generarNombreUsuario`.
2.  Debe aceptar dos parámetros: `nombre` y `apellido`.
3.  La función debe devolver un nombre de usuario combinando la primera letra del nombre, el apellido completo en minúsculas y un número aleatorio del 1 al 100. 
    -   Ejemplo: para "Rafa" y "Perez", podría devolver `"rperez83"`.
    -   **Pistas**: 
        -   Puedes acceder al primer carácter de un string con `nombre[0]`.
        -   Puedes convertir un string a minúsculas con `.toLowerCase()`.
        -   Puedes generar un número aleatorio con `Math.random()`.
4.  Llama a la función con tu nombre y apellido y muestra el nombre de usuario generado.

---

### 🏆 Desafío: Validador de Contraseñas

Crea una función `esContraseñaValida` que acepte un string de contraseña y devuelva `true` o `false` según las siguientes reglas:

1.  Debe tener al menos 8 caracteres de longitud.
2.  Debe contener al menos una letra mayúscula.

**Pistas**:
-   Puedes obtener la longitud de un string con `.length`.
-   Para chequear si tiene una mayúscula, puedes comparar la contraseña con su versión en minúsculas (`contraseña !== contraseña.toLowerCase()`). Si no son iguales, significa que había al menos una mayúscula.

```javascript
function esContraseñaValida(password) {
    // Tu lógica aquí dentro
    const tieneLongitudMinima = password.length >= 8;
    const tieneMayuscula = password.toLowerCase() !== password;

    return tieneLongitudMinima && tieneMayuscula;
}

// Pruebas
console.log(esContraseñaValida("password"));      // Debería ser false
console.log(esContraseñaValida("Pass"));          // Debería ser false
console.log(esContraseñaValida("Password123"));   // Debería ser true
```

Intenta implementar la lógica por tu cuenta y luego compárala con la solución de la pista.
