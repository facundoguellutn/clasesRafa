# Proyecto 2: API para E-commerce Simple

**Objetivo:** Construir la API para un pequeño sistema de e-commerce. El foco principal de este proyecto es el manejo de relaciones entre modelos y la implementación de transacciones para operaciones críticas como la creación de una orden.

---

### Requisitos Funcionales:

1.  **Gestión de Productos:**
    - CRUD completo para productos (Crear, Leer, Actualizar, Eliminar).
    - Un producto debe tener nombre, descripción, precio y stock.

2.  **Gestión de Usuarios:**
    - CRUD simple para usuarios (nombre, email).

3.  **Creación de Órdenes:**
    - Un usuario debe poder crear una orden.
    - Una orden consiste en uno o más productos con sus respectivas cantidades.
    - **Requisito Crítico:** La creación de una orden debe ser una **transacción atómica**. Debe:
        a.  Verificar que hay stock suficiente para cada producto en la orden.
        b.  Si no hay stock para algún producto, la transacción debe fallar y no se debe crear la orden.
        c.  Si hay stock, se debe crear la orden y se debe **descontar** la cantidad correspondiente del stock de cada producto.

4.  **Consulta de Órdenes:**
    - Un usuario debe poder ver su historial de órdenes.

---

### Stack Tecnológico:

-   **Backend:** Express.js
-   **Base de Datos:** Turso
-   **ORM:** Prisma

---

### Schema de Prisma:

```prisma
model User {
  id     Int     @id @default(autoincrement())
  email  String  @unique
  name   String?
  orders Order[]
}

model Product {
  id          Int         @id @default(autoincrement())
  name        String
  description String?
  price       Float
  stock       Int
  orderItems  OrderItem[]
}

model Order {
  id         Int         @id @default(autoincrement())
  user       User        @relation(fields: [userId], references: [id])
  userId     Int
  createdAt  DateTime    @default(now())
  totalPrice Float
  items      OrderItem[]
}

// Tabla de unión para la relación muchos-a-muchos entre Order y Product
model OrderItem {
  id        Int     @id @default(autoincrement())
  order     Order   @relation(fields: [orderId], references: [id])
  orderId   Int
  product   Product @relation(fields: [productId], references: [id])
  productId Int
  quantity  Int
}
```

---

### Endpoints de la API:

| Método | Ruta | Descripción |
| :--- | :--- | :--- |
| `POST` | `/users` | Crea un usuario. |
| `POST` | `/products` | Crea un producto. |
| `GET` | `/products` | Lista todos los productos. |
| `POST` | `/orders` | Crea una nueva orden (la ruta transaccional). |
| `GET` | `/users/:id/orders` | Muestra todas las órdenes de un usuario. |
