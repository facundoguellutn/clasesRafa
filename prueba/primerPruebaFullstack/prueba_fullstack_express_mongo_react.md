
# 🧪 Prueba Teórica: Fullstack con Express, MongoDB y React

## 🧩 Sección 1: Opción Múltiple

**1.** ¿Cuál es la forma correcta de conectar Mongoose a una base de datos MongoDB?  
- a) `mongoose.connect("mongodb+srv://user:pass@cluster.mongodb.net")`  
- b) `mongoose.connect("mongo://localhost/dbname")`  
- c) `mongo.connect("mongodb://localhost/dbname")`  
- d) `mongoose.init("localhost")`  

**2.** ¿Cuál es la principal función de un middleware en Express?  
- a) Manejar conexiones de base de datos  
- b) Prevenir errores de cliente  
- c) Interceptar y procesar requests antes de llegar a una ruta  
- d) Renderizar componentes de React  

**3.** ¿Qué método HTTP se usa para actualizar parcialmente un recurso?  
- a) `GET`  
- b) `PUT`  
- c) `POST`  
- d) `PATCH`  

**4.** ¿Qué hook de React usarías para obtener datos de una API al cargar un componente?  
- a) `useMemo`  
- b) `useEffect`  
- c) `useCallback`  
- d) `useReducer`  

**5.** ¿Cómo se pasan datos por la URL en una query?  
- a) `req.body.name`  
- b) `req.headers.name`  
- c) `req.query.name`  
- d) `req.params.name`  

**6.** ¿Cuál es una buena práctica al estructurar un proyecto con Express?  
- a) Definir todas las rutas en `index.js`  
- b) Separar controladores, rutas y modelos  
- c) Poner toda la lógica en las rutas  
- d) Evitar middlewares personalizados  

**7.** ¿Qué método usamos en React para actualizar el estado de un formulario controlado?  
- a) `setFormState`  
- b) `updateState`  
- c) `useInput`  
- d) `setState`  

**8.** ¿Cuál de las siguientes opciones es válida para usar parámetros en rutas de Express?  
- a) `/user{id}`  
- b) `/user/:id`  
- c) `/user?{id}`  
- d) `/user={id}`  

**9.** ¿Qué función de MongoDB devuelve todos los documentos de una colección?  
- a) `findById()`  
- b) `getAll()`  
- c) `find()`  
- d) `fetch()`  

**10.** ¿Qué librería se suele usar junto a React para manejar peticiones asincrónicas y estados de carga/error?  
- a) `axios-react`  
- b) `react-query`  
- c) `redux-load`  
- d) `mongo-hooks`  

---

## 🔍 Sección 2: Preguntas de respuesta directa

**1.** ¿Con qué método podemos buscar un usuario por su ID si el modelo es `User`?  
👉

**2.** ¿Cómo accedemos a un parámetro dinámico en la ruta `/users/:id` dentro de un controlador de Express?  
👉

**3.** ¿Qué propiedad de `req` usamos para acceder a los datos enviados desde un formulario `POST` en JSON?  
👉

**4.** ¿Con qué método eliminamos un documento en MongoDB por ID?  
👉

**5.** ¿Cómo guardamos un nuevo usuario con Mongoose?  
👉

**6.** ¿Qué función usamos en React para ejecutar código cuando el componente se monta por primera vez?  
👉

**7.** ¿Cómo mostramos un mensaje de error en React si una petición falla?  
👉

**8.** ¿Con qué método de JavaScript transformamos un objeto en JSON para enviarlo por fetch?  
👉

**9.** ¿Cómo accedemos a los parámetros de búsqueda en una URL desde Express?  
👉

**10.** ¿Cómo definimos una ruta protegida con middleware en Express? (ejemplo corto)  
👉

---

## 🧠 Sección 3: Preguntas de desarrollo

**1. Estructura de Proyecto Express**  
Describí cómo estructurarías un proyecto Express que incluye usuarios y productos, considerando rutas, controladores, modelos y middlewares.

**2. CRUD Completo**  
Implementá el código para las siguientes rutas:
- POST `/users`: crear un usuario
- GET `/users`: obtener todos los usuarios
- GET `/users/:id`: obtener un usuario por ID
- PUT `/users/:id`: actualizar un usuario
- DELETE `/users/:id`: eliminar un usuario

Asumí que el modelo se llama `User`.

**3. Uso de Middleware**  
Creá un middleware que registre en consola la hora y la URL de cada request, y explicá cómo se aplica globalmente.

**4. Integración con React**  
Describí cómo harías una pantalla en React que:
- Busque usuarios mediante un input de texto
- Muestre un spinner mientras se carga la información
- Guarde un nuevo usuario mediante un formulario
- Muestre un mensaje de error si falla el guardado

**5. Fetch con manejo de estado**  
Implementá un ejemplo en React donde se obtenga una lista de productos desde una API y se maneje el estado de carga y error.

**6. Diseño de esquema Mongoose con relaciones**  
Definí un esquema de `Comment` que tenga una relación con `User` y explicá cómo se hace un `.populate()`.

**7. Crear un endpoint de búsqueda por nombre usando query**  
Escribí la ruta en Express que permita buscar usuarios por nombre usando `req.query.name` y devolvé los resultados.

