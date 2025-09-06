# Clase 14: Clases y Programación Orientada a Objetos

## 🎯 Objetivos de la Clase

Al finalizar esta clase, serás capaz de:
- Entender los conceptos básicos de la Programación Orientada a Objetos (POO).
- Definir una "plantilla" para objetos usando la palabra clave `class`.
- Inicializar objetos con propiedades específicas usando el `constructor`.
- Crear múltiples objetos (instancias) a partir de una clase.
- Crear clases que heredan propiedades y métodos de otras usando `extends` y `super`.

---

## 🤔 ¿Qué son las Clases y la POO?

> **Analogía**: Piensa en una **clase** como el **plano de un auto**. El plano define que todos los autos tendrán 4 ruedas, un motor y un volante (propiedades), y que podrán acelerar y frenar (métodos). Un **objeto** (o instancia) es el **auto real** que construyes a partir de ese plano. Puedes construir muchos autos (muchos objetos) a partir del mismo plano, pero cada uno es independiente (uno puede ser rojo, otro azul, etc.).

La Programación Orientada a Objetos es un paradigma que nos permite estructurar nuestro código en torno a "objetos" que agrupan datos (propiedades) y comportamientos (métodos). Las **clases** son la herramienta principal en JavaScript para implementar la POO.

---

## 🚗 1. Definiendo tu Primera Clase

Usamos la palabra clave `class`. Por convención, los nombres de las clases empiezan con mayúscula.

```javascript
class Vehiculo {
    // El constructor es un método especial que se llama automáticamente
    // cuando creamos un nuevo objeto (una instancia) de la clase.
    constructor(marca, modelo, año) {
        // 'this' se refiere a la instancia que se está creando.
        // Aquí definimos las propiedades del objeto.
        this.marca = marca;
        this.modelo = modelo;
        this.año = año;
        this.velocidad = 0;
    }

    // Esto es un método de la clase.
    acelerar(incremento) {
        this.velocidad += incremento;
        console.log(`Acelerando. Velocidad actual: ${this.velocidad} km/h`);
    }

    frenar(decremento) {
        this.velocidad -= decremento;
        console.log(`Frenando. Velocidad actual: ${this.velocidad} km/h`);
    }
}
```

### Creando Instancias

Una vez definida la clase (el plano), podemos crear objetos (los autos) usando la palabra clave `new`.

```javascript
const miToyota = new Vehiculo("Toyota", "Corolla", 2022);
const miFord = new Vehiculo("Ford", "Mustang", 1969);

console.log(miToyota.marca); // "Toyota"
console.log(miFord.modelo);  // "Mustang"

miToyota.acelerar(50);
miFord.acelerar(120);
```

---

##  наследство (Herencia) con `extends`

La herencia nos permite crear una nueva clase (clase hija) que reutiliza y amplía la funcionalidad de una clase existente (clase padre).

Queremos crear una clase `Camion` que sea un tipo de `Vehiculo`, pero que tenga una propiedad adicional: `capacidadCarga`.

```javascript
// Camion hereda de Vehiculo
class Camion extends Vehiculo {
    constructor(marca, modelo, año, capacidadCarga) {
        // `super()` llama al constructor de la clase padre (Vehiculo).
        // Es OBLIGATORIO llamarlo antes de usar 'this' en una clase hija.
        super(marca, modelo, año);

        // Añadimos la propiedad específica de Camion
        this.capacidadCarga = capacidadCarga;
    }

    // Podemos añadir métodos específicos para Camion
    mostrarCarga() {
        console.log(`Capacidad de carga: ${this.capacidadCarga} kg`);
    }

    // También podemos sobreescribir un método del padre
    acelerar(incremento) {
        this.velocidad += incremento * 0.8; // Los camiones aceleran más lento
        console.log(`Camión acelerando lentamente. Velocidad: ${this.velocidad} km/h`);
    }
}

const miScania = new Camion("Scania", "R450", 2020, 25000);

miScania.acelerar(100); // Llama al método sobreescrito de Camion
miScania.frenar(50);    // Llama al método original de Vehiculo
miScania.mostrarCarga(); // Llama al método propio de Camion
```

---

## 🤓 Conceptos Clave para Recordar

- **Clase**: Una plantilla para crear objetos.
- **Objeto/Instancia**: Una ocurrencia específica creada a partir de una clase.
- **`constructor`**: El método que inicializa las propiedades de una nueva instancia.
- **`new`**: La palabra clave para crear una nueva instancia.
- **`this`**: Dentro de una clase, se refiere a la instancia actual.
- **`extends`**: Permite que una clase (hija) herede de otra (padre).
- **`super()`**: Llama al constructor de la clase padre.

---

## 🎯 Lo Que Viene en la Próxima Clase

Ahora que tenemos todas las herramientas fundamentales de JavaScript, en la **Clase 15** daremos un gran paso: uniremos todo lo que hemos aprendido para construir un **Proyecto Práctico**, una aplicación de lista de tareas (To-Do App) completamente funcional.
