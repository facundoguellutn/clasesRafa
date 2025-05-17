# Evaluación 2: Uso de `fetch`, métodos HTTP y cabeceras

## Parte 1: Verdadero o Falso

1. ( ) El método `fetch` permite realizar peticiones HTTP desde el navegador.
2. ( ) Los métodos `POST`, `PUT` y `DELETE` siempre deben tener un body.
3. ( ) Se puede usar `fetch` dentro de `useEffect` sincrónicamente.
4. ( ) Las cabeceras (headers) permiten definir cosas como el tipo de contenido y autorización.
5. ( ) `credentials: 'include'` permite enviar cookies con la petición.

## Parte 2: Completar la frase

6. El método HTTP que se utiliza para obtener información sin modificar datos es `_________`.
7. El método que se usa para eliminar un recurso es `_________`.
8. La opción `method` de `fetch` define el tipo de \_\_\_\_\_\_\_\_\_\_ HTTP a usar.
9. Para enviar JSON al servidor debemos serializar los datos usando `___________`.
10. Para recibir cookies del servidor, `fetch` debe tener configurado `credentials: __________`.

## Parte 3: Múltiple opción (una sola respuesta)

11. ¿Cuál de los siguientes métodos HTTP es idempotente?

* A) POST
* B) PUT
* C) DELETE
* D) Todos

12. En una petición `fetch`, ¿cuál es el header correcto para indicar que enviamos JSON?

* A) `Accept: application/json`
* B) `Authorization: Bearer token`
* C) `Content-Type: application/json`
* D) `Type: json`

13. Para capturar un error de red en `fetch`, se debe usar:

* A) `.then(error => { })`
* B) `.catch(error => { })`
* C) `.resolve(error => { })`
* D) `.error(error => { })`

14. ¿Cuándo se recomienda usar `POST` en lugar de `GET`?

* A) Cuando queremos enviar datos al servidor
* B) Cuando queremos recibir una lista de datos
* C) Cuando usamos `useEffect`
* D) Cuando trabajamos con cookies

15. ¿Cuál es una razón común para recibir un error CORS al usar `fetch`?

* A) El servidor respondió con 200
* B) La petición fue bloqueada por el navegador por origen distinto
* C) El JSON está mal formateado
* D) `useEffect` no está presente

## Parte 4: Desarrollo breve

16. Explica cuál es la diferencia entre `GET` y `POST` en una petición HTTP.

17. Menciona tres headers comunes que se usan en peticiones `fetch`.

18. ¿Por qué es importante manejar los errores en `fetch`?

19. ¿Qué sucede si olvidas convertir la respuesta con `res.json()`?

20. Escribe un ejemplo de petición `POST` usando `fetch`, enviando un objeto con nombre y edad, incluyendo el header correcto.

---

**Fin de la Evaluación 2**
