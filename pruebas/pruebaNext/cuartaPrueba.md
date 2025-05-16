# 📘 Parcial 4: Autenticación con Cookies, Middleware y JWT

## 📝 Multiple Choice
**1. ¿Qué función se usa para acceder a las cookies en Next.js?**
a) `getCookies()`  
b) `useCookies()`  
c) `cookies()`  
d) `readCookie()`

**2. ¿Cuál es el objetivo del middleware en Next.js?**
a) Estilizar componentes  
b) Autenticar rutas antes de renderizarlas  
c) Limpiar memoria del servidor  
d) Validar datos en el cliente

**3. ¿Cuál es la forma correcta de configurar una cookie segura en Next.js?**
a) `{ secure: false, httpOnly: false }`  
b) `{ secure: true, httpOnly: true }`  
c) `{ secure: false, httpOnly: true }`  
d) `{ secure: true, httpOnly: false }`

**4. ¿Qué método de JWT se utiliza para firmar un token?**
a) `jwt.verify()`  
b) `jwt.decode()`  
c) `jwt.sign()`  
d) `jwt.create()`

## ✅ Verdadero o Falso
**5.** Las cookies HTTP en Next.js pueden ser leídas tanto desde el servidor como desde el cliente.  
**6.** Un middleware puede proteger rutas usando expresiones como `matcher`.  
**7.** Las cookies `httpOnly` son accesibles mediante JavaScript en el navegador.  
**8.** El middleware en Next.js se ejecuta antes de que la página sea renderizada.  
**9.** JWT puede almacenar información sensible como contraseñas de forma segura.

## ✍️ Completar
**10.** Para proteger rutas privadas, el middleware se declara en el archivo `______________`.  
**11.** El método de JWT para verificar un token es `jwt.________()`.  
**12.** Para acceder a las cookies en el servidor se usa `cookies().________()`.  
**13.** La propiedad `________` en las cookies evita que sean accesibles por JavaScript.  
**14.** El middleware debe exportar una función llamada `________`.

## 💬 Respuesta breve
**15.** ¿Por qué se recomienda usar `httpOnly` al guardar una cookie de autenticación?  
**16.** Explica la diferencia entre autenticación basada en sesiones y JWT.  
**17.** ¿Cuál es la ventaja de usar middleware para la autenticación en Next.js?  
**18.** Describe el flujo de autenticación usando JWT y cookies.

## 🔧 Ejercicio Integrador
**19.** Simular un login donde:
- Se reciba un email y contraseña desde un `POST`
- Se verifique en la base de datos
- Se genere un JWT con `userId`
- Se guarde en cookies con `httpOnly`

**20.** Implementar un sistema de logout que:
- Elimine la cookie de autenticación
- Invalide el token JWT
- Redirija al usuario a la página de login

**21.** Crear un middleware que:
- Proteja todas las rutas bajo `/dashboard`
- Verifique la existencia y validez del token JWT
- Redirija a login si no hay token válido
- Permita acceso a rutas públicas sin autenticación
