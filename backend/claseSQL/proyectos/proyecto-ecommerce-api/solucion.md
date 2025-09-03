# Solución: API para E-commerce Simple

Guía paso a paso para construir el proyecto.

---

### Paso 1: Configuración del Proyecto

```bash
# 1. Crear carpeta y navegar a ella
mkdir ecommerce-api
cd ecommerce-api

# 2. Inicializar proyecto de Node.js
npm init -y

# 3. Instalar dependencias
npm install express @prisma/client @libsql/client

# 4. Instalar dependencia de desarrollo
npm install prisma --save-dev

# 5. Inicializar Prisma
npx prisma init
```

---

### Paso 2: Configuración de Prisma y Base de Datos

1.  **`prisma/schema.prisma`**: Reemplaza el contenido con el schema completo.

    ```prisma
    generator client {
      provider = "prisma-client-js"
    }

    datasource db {
      provider = "sqlite"
      url      = env("DATABASE_URL")
    }

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

    model OrderItem {
      id        Int     @id @default(autoincrement())
      order     Order   @relation(fields: [orderId], references: [id])
      orderId   Int
      product   Product @relation(fields: [productId], references: [id])
      productId Int
      quantity  Int
    }
    ```

2.  **`.env`**: Configura la URL de tu base de datos de Turso.

    ```env
    DATABASE_URL="libsql://tu-db.turso.io?authToken=TU_TOKEN"
    ```

3.  **Ejecutar Migración**:

    ```bash
    npx prisma migrate dev --name init-ecommerce-schema
    ```

---

### Paso 3: Código de la Aplicación (`index.js`)

```javascript
const express = require('express');
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();
const app = express();

app.use(express.json());

// --- Rutas para Usuarios y Productos (CRUD Básico) ---
app.post('/users', async (req, res) => {
  const user = await prisma.user.create({ data: req.body });
  res.json(user);
});

app.post('/products', async (req, res) => {
  const product = await prisma.product.create({ data: req.body });
  res.json(product);
});

app.get('/products', async (req, res) => {
  const products = await prisma.product.findMany();
  res.json(products);
});

// --- Ruta para Órdenes (Lógica Transaccional) ---
app.post('/orders', async (req, res) => {
  const { userId, items } = req.body; // items es un array: [{ productId: 1, quantity: 2 }, ...]

  try {
    const newOrder = await prisma.$transaction(async (tx) => {
      // 1. Obtener los productos de la DB para verificar stock y precios
      const productIds = items.map((item) => item.productId);
      const products = await tx.product.findMany({
        where: { id: { in: productIds } },
      });

      let totalPrice = 0;
      for (const item of items) {
        const product = products.find((p) => p.id === item.productId);
        if (!product) {
          throw new Error(`Producto con ID ${item.productId} no encontrado.`);
        }
        if (product.stock < item.quantity) {
          throw new Error(`Stock insuficiente para el producto: ${product.name}.`);
        }
        totalPrice += product.price * item.quantity;
      }

      // 2. Crear la orden
      const order = await tx.order.create({
        data: {
          userId,
          totalPrice,
        },
      });

      // 3. Crear los OrderItems y actualizar el stock de productos
      for (const item of items) {
        await tx.orderItem.create({
          data: {
            orderId: order.id,
            productId: item.productId,
            quantity: item.quantity,
          },
        });

        await tx.product.update({
          where: { id: item.productId },
          data: { stock: { decrement: item.quantity } },
        });
      }

      return order;
    });

    res.status(201).json(newOrder);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// --- Ruta para ver historial de órdenes ---
app.get('/users/:id/orders', async (req, res) => {
    const { id } = req.params;
    const orders = await prisma.order.findMany({
        where: { userId: parseInt(id) },
        include: { 
            items: { 
                include: { product: true }
            }
        }
    });
    res.json(orders);
});

const PORT = 3000;
app.listen(PORT, () => console.log(`Servidor corriendo en http://localhost:${PORT}`));
```

---

### Paso 4: Probar la API

1.  **Inicia el servidor:** `node index.js`

2.  **Crea un usuario:**
    ```bash
    curl -X POST -H "Content-Type: application/json" -d '''{"email":"cliente@test.com", "name":"Cliente Uno"}''' http://localhost:3000/users
    # Guarda el ID del usuario (ej. 1)
    ```

3.  **Crea dos productos:**
    ```bash
    curl -X POST -H "Content-Type: application/json" -d '''{"name":"Laptop Pro", "price":1200, "stock":10}''' http://localhost:3000/products
    # Guarda el ID del producto (ej. 1)

    curl -X POST -H "Content-Type: application/json" -d '''{"name":"Mouse Inalámbrico", "price":50, "stock":30}''' http://localhost:3000/products
    # Guarda el ID del producto (ej. 2)
    ```

4.  **Crea una orden (la prueba de fuego):**
    ```bash
    curl -X POST -H "Content-Type: application/json" -d '''{
        "userId": 1,
        "items": [
            { "productId": 1, "quantity": 1 },
            { "productId": 2, "quantity": 2 }
        ]
    }''' http://localhost:3000/orders
    ```
    Si la orden se crea, verifica el stock de los productos con `GET /products`. Deberías ver que el stock ha disminuido.

5.  **Prueba un fallo de transacción (stock insuficiente):**
    ```bash
    curl -X POST -H "Content-Type: application/json" -d '''{
        "userId": 1,
        "items": [
            { "productId": 1, "quantity": 20 } 
        ]
    }''' http://localhost:3000/orders
    # Deberías recibir un error 400 con el mensaje de stock insuficiente.
    ```

6.  **Consulta el historial del usuario:**
    ```bash
    curl http://localhost:3000/users/1/orders
    ```
