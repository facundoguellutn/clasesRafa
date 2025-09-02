# Ejercicio 2: Diseñando un Blog Simple

## 🎯 Objetivo

Practicar el diseño y creación de tablas desde cero para un escenario del mundo real: un sistema de blog con usuarios, posts y comentarios.

---

## 📖 Escenario

Queremos construir la base de datos para un blog simple. Los requisitos son:

1.  **Usuarios**:
    *   Necesitamos guardar un `id`, `nombre de usuario` (único y obligatorio), `email` (único y obligatorio) y una `contraseña` (obligatoria).
    *   También queremos saber la `fecha de registro`, que debería ser la fecha actual por defecto.
    *   Debe haber un estado `activo` que por defecto sea `true`.

2.  **Posts (Artículos)**:
    *   Cada post tiene un `id`, un `título` (obligatorio), el `contenido` del post (un texto largo, obligatorio), y una `fecha de publicación` (que se pone por defecto al crearse).
    *   Los posts deben estar asociados a un **autor** (un usuario). Necesitaremos una forma de conectar el post con el `id` del usuario que lo escribió.
    *   El `título` de un post no puede tener más de 150 caracteres (Pista: `CHECK(length(titulo) <= 150)`).

3.  **Comentarios**:
    *   Cada comentario tiene un `id`, un `texto` (obligatorio), y una `fecha` (por defecto, la actual).
    *   Un comentario debe estar asociado a un **post** específico.
    *   Un comentario también debe estar asociado a un **usuario** que lo escribió.

---

## 🏋️‍♀️ Tu Tarea

Escribí las sentencias `CREATE TABLE` para las tres tablas: `usuarios`, `posts` y `comentarios`.

*   Elegí los tipos de datos más apropiados.
*   Aplicá todos los `constraints` necesarios (`PRIMARY KEY`, `NOT NULL`, `UNIQUE`, `DEFAULT`, `CHECK`) según los requisitos.
*   Usá campos `*_id` para representar las relaciones (ej: `usuario_id`, `post_id`).

```sql
-- Tu código para la tabla 'usuarios' aquí


-- Tu código para la tabla 'posts' aquí


-- Tu código para la tabla 'comentarios' aquí

```

### 📝 Extra: Insertá Datos de Ejemplo

Una vez que hayas creado las tablas, escribí sentencias `INSERT` para simular el siguiente escenario:

1.  Un usuario llamado "Rafa" con email "rafa@blog.com" se registra.
2.  Rafa escribe un post titulado "Mi Primer Post" con el contenido "¡Hola mundo del SQL!".
3.  Otro usuario, "Facu", se registra y comenta en el post de Rafa: "¡Excelente post, bienvenido!".

```sql
-- Tus sentencias INSERT aquí

```

---

## 💡 Solución Propuesta

<details>
<summary>Click para ver la solución</summary>

```sql
-- Tabla de Usuarios
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre_usuario TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    contraseña TEXT NOT NULL,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    activo BOOLEAN DEFAULT TRUE
);

-- Tabla de Posts
CREATE TABLE posts (
    id INTEGER PRIMARY KEY,
    usuario_id INTEGER NOT NULL, -- Clave foránea (conceptual) a usuarios.id
    titulo TEXT NOT NULL CHECK(length(titulo) <= 150),
    contenido TEXT NOT NULL,
    fecha_publicacion DATE DEFAULT CURRENT_DATE
);

-- Tabla de Comentarios
CREATE TABLE comentarios (
    id INTEGER PRIMARY KEY,
    post_id INTEGER NOT NULL,    -- Clave foránea a posts.id
    usuario_id INTEGER NOT NULL, -- Clave foránea a usuarios.id
    texto TEXT NOT NULL,
    fecha DATE DEFAULT CURRENT_DATE
);

-- --- INSERTS DE EJEMPLO ---

-- 1. Rafa se registra (supongamos que su ID será 1)
INSERT INTO usuarios (nombre_usuario, email, contraseña) 
VALUES ('Rafa', 'rafa@blog.com', 'password123');

-- 2. Rafa escribe un post
INSERT INTO posts (usuario_id, titulo, contenido) 
VALUES (1, 'Mi Primer Post', '¡Hola mundo del SQL!');

-- 3. Facu se registra (supongamos que su ID será 2)
INSERT INTO usuarios (nombre_usuario, email, contraseña) 
VALUES ('Facu', 'facu@blog.com', 'securepass');

-- 4. Facu comenta en el post de Rafa (que tiene post_id = 1)
INSERT INTO comentarios (post_id, usuario_id, texto) 
VALUES (1, 2, '¡Excelente post, bienvenido!');

```

</details>
