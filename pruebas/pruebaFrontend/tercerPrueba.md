# Evaluación 3: Login, credenciales y protección de datos

## Parte 1: Verdadero o Falso

1. ( ) Al hacer login con `fetch`, es necesario enviar el `Content-Type` como `application/json` si se manda un objeto.
2. ( ) Las cookies se envían automáticamente con `fetch` sin configurar nada.
3. ( ) Para mantener la sesión iniciada entre peticiones se puede usar `credentials: 'include'`.
4. ( ) Es buena práctica guardar el JWT en el localStorage.
5. ( ) `fetch` puede utilizar headers personalizados como `Authorization`.

## Parte 2: Completar

6. Para autenticar rutas privadas, muchos servidores utilizan un token llamado `__________`.
7. El header `Authorization` se usa para enviar `___________` junto con la petición.
8. En Next.js, para leer cookies del lado del servidor, usamos `__________` del request.
9. Al hacer login, el servidor puede devolver una cookie usando el header `_________`.
10. El atributo que indica que una cookie no puede ser accedida desde JS es `__________`.

## Parte 3: Múltiple opción

11. ¿Cuándo debemos usar `credentials: 'include'` en una petición?

* A) Siempre que se use `POST`
* B) Solo al usar `PUT`
* C) Cuando trabajamos con cookies para mantener la sesión
* D) Cuando usamos `useEffect`

12. Si un servidor espera un token en el header, ¿cuál es la forma correcta de enviarlo?

* A) `headers: { token: user.token }`
* B) `headers: { Authorization: 'Bearer ' + token }`
* C) `headers: { accessToken: token }`
* D) `headers: { Content-Type: token }`

13. En el contexto de login, ¿cuál es una razón para que el login funcione en Postman pero no en el navegador?

* A) El token está mal generado
* B) No se está usando `credentials: 'include'`
* C) El fetch está en un `useEffect`
* D) Falta el method

14. En Next.js, ¿cuál es una forma segura de leer la cookie de sesión en el servidor?

* A) `document.cookie`
* B) `req.headers.cookie`
* C) `localStorage.getItem()`
* D) `window.cookie`

15. ¿Cuál es un riesgo de guardar tokens en `localStorage`?

* A) Es difícil de acceder para el servidor
* B) El token se borra cada vez que se recarga la página
* C) Puede ser accedido por scripts maliciosos (XSS)
* D) No hay ningún riesgo

## Parte 4: Desarrollo

16. Explica paso a paso cómo funciona un login con `fetch` y cookies.

17. Describe qué configuraciones deben hacerse en `fetch` para que las cookies funcionen.

18. ¿Qué diferencias hay entre guardar un token en cookies vs en localStorage?

19. Escribe un ejemplo de `fetch` donde se envíe un token en el header para acceder a una ruta protegida.

20. ¿Cómo usarías `useEffect` para verificar si el usuario está logueado apenas carga una página?

---

**Fin de la Evaluación 3**
