# Explicación Detallada: El Funcionamiento Interno de las Clases

## 🎯 Objetivo de este Documento

Explorar las características avanzadas de las clases en JavaScript, incluyendo getters, setters, métodos estáticos, campos privados y la relación de las clases con el sistema de prototipos de JavaScript.

---

## 🍬 1. Las Clases son "Azúcar Sintáctico"

Esta es la idea más importante a nivel conceptual. JavaScript no tuvo clases desde el principio. Su sistema de herencia se basa en **prototipos**. Una clase es, en gran medida, una sintaxis más limpia y amigable para hacer lo que ya se podía hacer con prototipos.

```javascript
class MiClase {}

console.log(typeof MiClase); // "function"
```

Saber esto te ayuda a entender por qué las clases se comportan como lo hacen y a comprender código más antiguo que usa herencia prototípica directamente.

---

## accessor-properties (Getters y Setters)

Los getters y setters te permiten definir métodos que se comportan como si fueran propiedades. Son útiles para ejecutar lógica cuando se lee o se escribe una propiedad.

- **`get`**: Se ejecuta cuando lees la propiedad. Debe devolver un valor.
- **`set`**: Se ejecuta cuando asignas un valor a la propiedad. Recibe el valor como argumento.

```javascript
class Usuario {
    constructor(nombre, apellido) {
        this.nombre = nombre;
        this.apellido = apellido;
    }

    // GETTER: Se usa como una propiedad -> usuario.nombreCompleto
    get nombreCompleto() {
        console.log("Ejecutando getter...");
        return `${this.nombre} ${this.apellido}`;
    }

    // SETTER: Se usa como una propiedad -> usuario.nombreCompleto = "..."
    set nombreCompleto(valor) {
        console.log("Ejecutando setter...");
        const [nuevoNombre, nuevoApellido] = valor.split(' ');
        this.nombre = nuevoNombre;
        this.apellido = nuevoApellido;
    }
}

const user = new Usuario("Rafa", "Perez");
console.log(user.nombreCompleto); // Ejecuta el getter

user.nombreCompleto = "Facu Gomez"; // Ejecuta el setter
console.log(user.nombre); // "Facu"
```

---

## 🏛️ 3. Métodos y Propiedades Estáticas (`static`)

Normalmente, los métodos y propiedades pertenecen a las **instancias** de una clase. Los métodos estáticos pertenecen a la **clase en sí misma**. Son como funciones de utilidad que están lógicamente agrupadas con la clase, pero no dependen de ninguna instancia en particular.

```javascript
class Matematicas {
    static PI = 3.14159;

    static sumar(a, b) {
        return a + b;
    }
}

// Se llaman directamente desde la Clase, no desde una instancia
console.log(Matematicas.PI);
console.log(Matematicas.sumar(5, 5));

// const m = new Matematicas();
// m.sumar(5, 5); // ESTO DARÍA ERROR
```

---

## 🔒 4. Campos Privados (Encapsulación)

La encapsulación es un principio de la POO que dice que el estado interno de un objeto debe estar protegido del acceso exterior. Durante años, en JavaScript esto se hacía por convención (ej: `_propiedadPrivada`). Las clases modernas introdujeron una sintaxis de campos privados usando un `#`.

Las propiedades y métodos privados solo son accesibles **desde dentro** de la clase.

```javascript
class CuentaBancaria {
    // Campo privado
    #saldo;

    constructor(saldoInicial) {
        this.#saldo = saldoInicial;
    }

    depositar(monto) {
        this.#saldo += monto;
        this.#logTransaccion("Depósito", monto);
    }

    retirar(monto) {
        if (monto > this.#saldo) {
            console.error("Fondos insuficientes");
            return;
        }
        this.#saldo -= monto;
        this.#logTransaccion("Retiro", monto);
    }

    // Método privado
    #logTransaccion(tipo, monto) {
        console.log(`${tipo} de ${monto}. Saldo actual: ${this.#saldo}`);
    }

    // Getter público para acceder al saldo de forma controlada
    get saldoActual() {
        return this.#saldo;
    }
}

const miCuenta = new CuentaBancaria(1000);
miCuenta.depositar(500);
miCuenta.retirar(200);

console.log(miCuenta.saldoActual); // 1300
// console.log(miCuenta.#saldo); // SyntaxError: Campo privado inaccesible
// miCuenta.#logTransaccion(); // SyntaxError: Método privado inaccesible
```

---

## 🧐 5. El Operador `instanceof`

Permite comprobar si un objeto es una instancia de una clase particular. Es útil para verificar el tipo de un objeto en tiempo de ejecución.

```javascript
class Animal {}
class Perro extends Animal {}

const miPerro = new Perro();

console.log(miPerro instanceof Perro);   // true
console.log(miPerro instanceof Animal);  // true (porque Perro hereda de Animal)
console.log(miPerro instanceof Object); // true (todas las clases heredan de Object)
```
