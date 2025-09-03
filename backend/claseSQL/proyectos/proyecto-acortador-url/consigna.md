# Proyecto 1: Acortador de URL

**Objetivo:** Crear una API simple que tome una URL larga y devuelva una URL corta. Al acceder a la URL corta, el usuario debe ser redirigido a la URL original.

---

### Requisitos Funcionales:

1.  **Acortar URL:** La API debe tener un endpoint que reciba una URL larga.
    - Debe generar un código corto y único.
    - Debe guardar en la base de datos la URL original junto con su código corto.
    - Debe devolver la URL corta completa (ej. `http://localhost:3000/abcdef`).

2.  **Redirigir URL:** La API debe tener un endpoint que reciba un código corto.
    - Debe buscar el código en la base de datos.
    - Si lo encuentra, debe redirigir al usuario a la URL original correspondiente.
    - Si no lo encuentra, debe devolver un error 404.

3.  **Estadísticas (Opcional):** La API puede tener un endpoint que muestre cuántas veces se ha visitado una URL corta.

---

### Stack Tecnológico:

-   **Backend:** Express.js
-   **Base de Datos:** Turso
-   **ORM:** Prisma

---

### Schema de Prisma:

Se necesita un único modelo para almacenar las URLs.

```prisma
// prisma/schema.prisma

model Url {
  id          Int      @id @default(autoincrement())
  originalUrl String
  shortCode   String   @unique
  visitCount  Int      @default(0)
  createdAt   DateTime @default(now())
}
```

---

### Endpoints de la API:

| Método | Ruta | Descripción |
| :--- | :--- | :--- |
| `POST` | `/shorten` | Recibe `{ "url": "..." }` y crea una URL corta. |
| `GET` | `/:shortCode` | Redirige a la URL original. |
| `GET` | `/stats/:shortCode` | Muestra las estadísticas de una URL corta. |
