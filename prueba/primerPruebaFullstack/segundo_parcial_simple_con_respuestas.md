
# 🧪 Segundo Parcial Teórico: MongoDB, Mongoose, Autenticación y React

## 🧩 Sección 1: Completá el código o indicá qué falta (10 pts)

**1.** ¿Qué propiedad falta para que esta petición `fetch` funcione correctamente al enviar datos en JSON?

```js
fetch("/api/login", {
  method: "POST",
  body: JSON.stringify({ username, password }),
});
```

👉 ___________________________________________________________

**2.** Completá la línea faltante para hashear una contraseña con bcrypt:

```js
const bcrypt = require("bcrypt");
const password = "123456";
const hashedPassword = await _________;
```

👉 ___________________________________________________________

**3.** ¿Qué falta en este useEffect para que la búsqueda se ejecute al cambiar searchTerm?

```js
useEffect(() => {
  fetch(`/api/users?name=${searchTerm}`)
    .then((res) => res.json())
    .then((data) => setUsers(data));
});
```

👉 ___________________________________________________________

**4.** ¿Qué método de Mongoose se usa para crear un documento?

👉 ___________________________________________________________

**5.** ¿Cómo accedemos a un parámetro llamado `id` en una ruta dinámica como `/users/:id`?

👉 ___________________________________________________________

**6.** Completá esta línea para guardar una cookie:

```js
res._____________("token", token, { httpOnly: true });
```

👉 ___________________________________________________________

**7.** ¿Qué propiedad falta para enviar cookies desde el cliente al backend?

```js
fetch("/api/session", {
  method: "GET",
  _____________
});
```

👉 ___________________________________________________________

**8.** ¿Qué falta en esta ruta para que responda con un usuario buscado por ID?

```js
app.get("/api/users/:id", async (req, res) => {
  const user = await User.___________(req.params.id);
  res.json(user);
});
```

👉 ___________________________________________________________

**9.** ¿Qué propiedad de `req` usamos para leer los datos de un POST enviado en JSON?

👉 ___________________________________________________________

**10.** ¿Qué función de Mongoose usamos para eliminar un documento por ID?

👉 ___________________________________________________________

---

## ✅ Sección 2: Verdadero o Falso (10 pts)

**1.** `bcrypt.hash` es una función síncrona.  
👉 _______________

**2.** Para poder leer cookies en Express, tenemos que usar un middleware como `cookie-parser`.  
👉 _______________

**3.** El método `findById` de Mongoose acepta como parámetro un string con el ID.  
👉 _______________

**4.** Para proteger una ruta, se puede usar un middleware que revise si existe una cookie válida.  
👉 _______________

**5.** Las cookies `httpOnly` pueden leerse desde JavaScript en el navegador.  
👉 _______________

**6.** `useEffect` se ejecuta cada vez que cambia alguna de las dependencias del array final.  
👉 _______________

**7.** Las rutas en Express deben declararse antes de hacer el `app.listen`.  
👉 _______________

**8.** En MongoDB los documentos deben tener un campo `_id` único.  
👉 _______________

**9.** Para enviar datos desde un formulario en React a una API necesitamos usar `fetch` o alguna librería similar.  
👉 _______________

**10.** Podemos usar `mongoose.Schema.Types.ObjectId` para referenciar otro documento.  
👉 _______________

---

## 🧠 Sección 3: Desarrollo corto (10 pts)

**1.** Mostrá cómo guardar un nuevo usuario con Mongoose y contraseña hasheada.

**2.** Hacé un middleware que verifique si existe una cookie llamada `token`, y si no, devuelva error 401.

**3.** Escribí un `useEffect` en React que haga una búsqueda a `/api/users?name=...` y guarde la respuesta en estado.

**4.** Mostrá cómo eliminar un usuario por ID en Express.

**5.** Escribí el código necesario para crear un esquema `Comment` en Mongoose que tenga una referencia a un `User` y populá el usuario al hacer una búsqueda.

---

## ✅ Respuestas

### Sección 1
1. `headers: { "Content-Type": "application/json" }`  
2. `bcrypt.hash(password, 10)`  
3. `}, [searchTerm]);`  
4. `User.create(...)`  
5. `req.params.id`  
6. `cookie`  
7. `credentials: "include"`  
8. `findById`  
9. `req.body`  
10. `findByIdAndDelete(...)`  

### Sección 2
1. ❌ (es asíncrona, devuelve promesa)  
2. ✅  
3. ✅  
4. ✅  
5. ❌  
6. ✅  
7. ✅  
8. ✅  
9. ✅  
10. ✅  

