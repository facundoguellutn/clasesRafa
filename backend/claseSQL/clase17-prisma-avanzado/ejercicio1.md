# Ejercicio 1: Filtrado y Paginación Avanzada

**Objetivo:** Mejorar la API del blog implementando endpoints más dinámicos que acepten parámetros de consulta (query params) para filtrar, ordenar y paginar los resultados.

---

## Tareas:

### 1. Filtrar el Feed de Posts

Modifica el endpoint `GET /feed` para que acepte un parámetro de consulta `search`.

- **Endpoint:** `GET /feed?search=termino_de_busqueda`
- **Lógica:**
    - Si el query param `search` está presente, el endpoint debe devolver solo los posts publicados (`published: true`) donde el `title` O el `content` contengan el término de búsqueda (sin distinguir mayúsculas/minúsculas).
    - Si `search` no está presente, debe funcionar como antes, devolviendo todos los posts publicados.

**Pista:** Necesitarás usar un `where` con `AND` y `OR`, y el filtro `contains`. Para la insensibilidad a mayúsculas/minúsculas, añade `mode: 'insensitive'` (esto funciona en bases de datos como PostgreSQL, pero en SQLite el comportamiento por defecto ya suele ser insensible).

```javascript
// Ejemplo de la lógica del where
where: {
  published: true,
  OR: [
    { title: { contains: search, mode: 'insensitive' } },
    { content: { contains: search, mode: 'insensitive' } },
  ],
}
```

### 2. Paginación para el Feed

Añade paginación al mismo endpoint `GET /feed` usando los query params `page` y `pageSize`.

- **Endpoint:** `GET /feed?page=2&pageSize=5`
- **Lógica:**
    - `page`: El número de página a devolver. Si no se especifica, debe ser `1` por defecto.
    - `pageSize`: El número de resultados por página. Si no se especifica, puede ser `10` por defecto.
    - Debes usar `skip` y `take` de Prisma para implementar esto. Recuerda convertir los query params (que son strings) a números.

### 3. Ordenamiento Dinámico

Permite que el cliente decida cómo ordenar los resultados del `GET /feed`.

- **Endpoint:** `GET /feed?sortBy=title&order=desc`
- **Lógica:**
    - `sortBy`: El campo por el cual ordenar (ej. `title`, `createdAt`).
    - `order`: La dirección del orden (`asc` o `desc`).
    - Debes construir dinámicamente el objeto `orderBy` para Prisma.

---

## Desafío Final: Combinar Todo

Asegúrate de que los tres mecanismos (filtrado, paginación y ordenamiento) puedan funcionar juntos en una sola petición.

**Ejemplo de petición final:**
`GET /feed?search=prisma&page=1&pageSize=5&sortBy=title&order=asc`

Esta petición debería:
1.  Buscar posts publicados que contengan "prisma".
2.  Ordenarlos por título de la A a la Z.
3.  Devolver los primeros 5 resultados de esa búsqueda.

**Implementación en Express:**

```javascript
app.get('/feed', async (req, res) => {
  const { search, page = 1, pageSize = 10, sortBy = 'createdAt', order = 'desc' } = req.query;

  const where = { published: true };
  if (search) {
    where.OR = [
      { title: { contains: search, mode: 'insensitive' } },
      { content: { contains: search, mode: 'insensitive' } },
    ];
  }

  const posts = await prisma.post.findMany({
    where,
    include: { author: true },
    orderBy: {
      [sortBy]: order,
    },
    skip: (parseInt(page) - 1) * parseInt(pageSize),
    take: parseInt(pageSize),
  });

  res.json(posts);
});
```
Este es un ejemplo base. ¡Adáptalo y pruébalo a fondo!
