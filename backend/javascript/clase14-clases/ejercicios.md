# Ejercicios Prácticos: Clase 14

Crea un archivo `clases.js` y realiza los siguientes ejercicios. Usa `console.log` para verificar cada resultado.

---

### ✅ Ejercicio 1: Clase `Persona`

1.  Crea una clase llamada `Persona`.
2.  El `constructor` debe aceptar dos parámetros: `nombre` y `edad`.
3.  Dentro del constructor, asigna estos parámetros a las propiedades `this.nombre` y `this.edad`.
4.  Añade un método llamado `presentarse` que muestre en consola un mensaje como: `"Hola, mi nombre es [nombre] y tengo [edad] años."`.
5.  Crea dos instancias de la clase `Persona` con diferentes datos y llama al método `presentarse` en ambas.

---

### ✅ Ejercicio 2: Herencia de `Estudiante`

1.  Crea una clase `Estudiante` que **herede** de la clase `Persona` (`class Estudiante extends Persona`).
2.  El `constructor` de `Estudiante` debe aceptar tres parámetros: `nombre`, `edad` y `curso`.
3.  Dentro del constructor, debes llamar a `super(nombre, edad)` para pasarle los datos al constructor de la clase padre (`Persona`).
4.  Asigna el parámetro `curso` a la propiedad `this.curso`.
5.  **Sobrescribe** el método `presentarse` en la clase `Estudiante`. Este nuevo método debe llamar al método `presentarse` del padre y luego añadir un mensaje sobre el curso. El resultado debe ser: `"Hola, mi nombre es [nombre] y tengo [edad] años. Estoy en el curso de [curso]."`
    -   **Pista**: Puedes llamar al método del padre usando `super.presentarse()`.
6.  Crea una instancia de `Estudiante` y llama a su método `presentarse`.

---

### ✅ Ejercicio 3: Getters y Setters

1.  Crea una clase `Rectangulo` con `ancho` y `alto` en el constructor.
2.  Añade un **getter** llamado `area` que calcule y devuelva el área del rectángulo (`this.ancho * this.alto`).
3.  Crea una instancia de `Rectangulo` y muestra su área en consola (recuerda que los getters se usan como propiedades, sin paréntesis: `miRectangulo.area`).
4.  (Opcional) Añade un **setter** para `area`. Si se intenta asignar un área, debe calcular y ajustar el `ancho` y el `alto` de forma proporcional (ej: manteniendo la relación de aspecto).

---

### 🏆 Desafío: Métodos Estáticos y Privados

Crea una clase `Circulo`.

1.  El `constructor` debe aceptar un `radio`.
2.  Añade un **campo privado** `#radio` para almacenar el radio, asegurando que no se pueda modificar desde fuera de la clase.
3.  Crea un **getter** público `radio` para poder leer el valor del radio.
4.  Crea un **getter** público `area` que use el radio privado para calcular el área (`PI * radio^2`).
5.  Añade un **método estático** a la clase `Circulo` llamado `comparar(circuloA, circuloB)`.
    -   Este método debe aceptar dos instancias de `Circulo` y devolver el círculo con el radio más grande.

**Para probarlo:**
```javascript
const c1 = new Circulo(5);
const c2 = new Circulo(8);

console.log(`Área del círculo 1: ${c1.area}`);
console.log(`Área del círculo 2: ${c2.area}`);

const circuloMasGrande = Circulo.comparar(c1, c2);
console.log(`El círculo con el radio más grande es el que tiene radio ${circuloMasGrande.radio}`);
```
