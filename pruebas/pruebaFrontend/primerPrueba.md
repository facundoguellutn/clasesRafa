# Evaluación 1: Formularios en React y uso de `useEffect`

## Parte 1: Verdadero o Falso

1. ( ) En React, los formularios siempre deben manejarse usando `useRef`.
2. ( ) La propiedad `onChange` es utilizada para detectar cambios en un input de texto.
3. ( ) Para evitar que un formulario recargue la página al enviarlo, se debe usar `event.preventDefault()`.
4. ( ) El estado de un formulario se puede manejar con `useState`.
5. ( ) Es incorrecto usar un `useEffect` para hacer un fetch de datos al montar el componente.

## Parte 2: Completar la frase

6. Para capturar el texto de un input y actualizar el estado usamos el evento `________`.
7. El hook `__________` nos permite ejecutar una función cuando se monta un componente.
8. En React, al trabajar con formularios controlados, el valor de un input debe estar vinculado a una variable de `________`.
9. Para evitar bucles infinitos en `useEffect`, se debe proveer una lista de \_\_\_\_\_\_\_\_\_\_.
10. El atributo HTML que dispara el submit del formulario es `__________`.

## Parte 3: Selección múltiple (una sola respuesta)

11. ¿Cuál de las siguientes opciones representa una forma correcta de capturar el valor de un input de texto?

* A) `const value = document.querySelector('#miInput').value`
* B) `const value = e.target.value`
* C) `const value = e.input.value`
* D) `const value = this.value`

12. ¿Dónde se recomienda realizar la carga inicial de datos en un componente funcional?

* A) Dentro de `useState`
* B) Dentro de `useMemo`
* C) Dentro de `useEffect`
* D) Fuera del componente

13. Al enviar un formulario en React con `fetch`, ¿cuál es el tipo de contenido correcto en el header?

* A) `Content-Type: application/x-www-form-urlencoded`
* B) `Content-Type: multipart/form-data`
* C) `Content-Type: application/json`
* D) `Content-Type: text/plain`

14. El array de dependencias en `useEffect` sirve para:

* A) Cancelar renders innecesarios
* B) Especificar condiciones bajo las que se ejecuta el efecto
* C) Establecer los headers de la petición
* D) Evitar errores en el DOM

15. Si queremos evitar que el formulario se envie por defecto al presionar Enter, debemos:

* A) Usar `e.stopPropagation()`
* B) Usar `e.preventDefault()`
* C) Usar `e.block()`
* D) Eliminar el submit del formulario

## Parte 4: Desarrollo breve

16. Explica qué es un formulario controlado en React.

17. Describe cómo harías para mostrar errores de validación en un formulario antes de enviar.

18. Menciona una ventaja de usar `useEffect` para cargar datos al inicio del componente.

19. Describe cómo podrías manejar un formulario que tiene muchos campos sin repetir código para cada `onChange`.

20. ¿Qué problemas pueden surgir si olvidas el array de dependencias en un `useEffect`?

---

**Fin de la Evaluación 1**
