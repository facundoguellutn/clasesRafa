# Clase 17: Conceptos Avanzados de Prisma

En el taller práctico construimos una API funcional. Ahora, vamos a profundizar en las herramientas y conceptos de Prisma que te darán superpoderes para manejar casos más complejos.

---

## 1. Consultas Avanzadas: Filtrado, Ordenamiento y Paginación

Prisma ofrece un API muy rico para construir consultas complejas de forma segura.

### Filtrado (`where`)

Puedes usar `AND`, `OR` y `NOT` para combinar condiciones.

- **AND (implícito):** Múltiples condiciones en un `where` son unidas por `AND`.
  ```javascript
  // Encontrar posts publicados del autor con ID 1
  const posts = await prisma.post.findMany({
    where: {
      published: true,
      authorId: 1,
    },
  });
  ```

- **OR:** Para buscar registros que cumplan una de varias condiciones.
  ```javascript
  // Encontrar posts cuyo título o contenido incluyan "Prisma"
  const posts = await prisma.post.findMany({
    where: {
      OR: [
        { title: { contains: 'Prisma' } },
        { content: { contains: 'Prisma' } },
      ],
    },
  });
  ```

- **NOT:** Para excluir registros.
  ```javascript
  // Encontrar todos los posts MENOS los del autor con ID 1
  const posts = await prisma.post.findMany({
    where: {
      NOT: {
        authorId: 1,
      },
    },
  });
  ```

### Ordenamiento (`orderBy`)

Puedes ordenar los resultados por uno o más campos.

```javascript
// Obtener usuarios ordenados por nombre (A-Z)
const users = await prisma.user.findMany({
  orderBy: {
    name: 'asc', // 'desc' para descendente
  },
});
```

### Paginación (`skip` y `take`)

Esencial para cualquier aplicación que devuelva listas largas de datos.
- `take`: Especifica cuántos registros devolver (el tamaño de la página).
- `skip`: Especifica cuántos registros saltar (el offset).

```javascript
// Obtener la página 2 de posts, con 10 posts por página
const page = 2;
const pageSize = 10;

const posts = await prisma.post.findMany({
  skip: (page - 1) * pageSize,
  take: pageSize,
});
```

---

## 2. Transacciones: Garantizando la Integridad de los Datos

Una transacción es un grupo de operaciones que deben ejecutarse como una sola unidad: o todas tienen éxito, o ninguna lo tiene. Si algo falla a la mitad, la base de datos revierte todos los cambios hechos dentro de la transacción.

**Caso de uso:** Registrar un usuario y crear su perfil al mismo tiempo. No queremos un usuario sin perfil o un perfil sin usuario.

Prisma ofrece el método `prisma.$transaction()`:

```javascript
app.post('/signup', async (req, res) => {
  const { email, name, bio } = req.body;

  try {
    const result = await prisma.$transaction(async (tx) => {
      // 1. Crear el usuario
      const user = await tx.user.create({
        data: { email, name },
      });

      // Si algo fallara aquí, el usuario creado arriba se eliminaría (rollback).

      // 2. Crear el perfil asociado
      const profile = await tx.profile.create({
        data: {
          bio,
          userId: user.id,
        },
      });

      return { user, profile };
    });

    res.json(result);

  } catch (error) {
    // Si la transacción falla, Prisma lanza un error.
    res.status(500).json({ error: "No se pudo registrar al usuario." });
  }
});
```
Dentro de la función de `$transaction`, usas `tx` en lugar de `prisma` para asegurarte de que todas las operaciones formen parte de la misma transacción.

---

## 3. Acceso a SQL Raw

Aunque Prisma abstrae el SQL, a veces necesitas ejecutar una consulta específica que no es fácil de expresar con el API de Prisma, o necesitas usar una función nativa de tu base de datos.

**¡ADVERTENCIA!** Usar SQL raw puede exponerte a inyecciones SQL si no lo haces correctamente.

Prisma ofrece métodos seguros para esto:

- **`$queryRaw`**: Para consultas que devuelven datos (un `SELECT`).
- **`$executeRaw`**: Para operaciones que no devuelven datos (un `UPDATE`, `DELETE` o `INSERT`).

**Uso correcto (con parámetros):**
Usa `Prisma.sql` para construir la consulta y pasar los valores de forma segura.

```javascript
import { Prisma } from '@prisma/client';

// Obtener usuarios cuyo email coincide con un patrón
const pattern = '%@test.com';
const users = await prisma.$queryRaw(
  Prisma.sql`SELECT * FROM User WHERE email LIKE ${pattern}`
);
```
Prisma se encarga de "sanitizar" el valor de `pattern` para prevenir ataques.

---

## 4. Prisma Studio: Tu Aliado Visual

Prisma Studio es una interfaz gráfica que te permite ver y editar los datos de tu base de datos directamente en el navegador. Es increíblemente útil para desarrollo y depuración.

**Para iniciarlo:**
```bash
npx prisma studio
```
Se abrirá una pestaña en tu navegador en `http://localhost:5555`. Podrás:
- Ver los datos de todos tus modelos.
- Crear, editar y eliminar registros con una interfaz amigable.
- Probar cómo tus cambios en el schema afectan los datos.
