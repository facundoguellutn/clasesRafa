
# ⚙️ Tutorial: Server Actions, Componentes Servidor/Cliente y Renderizado Asíncrono en Next.js 14

Este tutorial cubre los conceptos clave sobre **Server Actions**, **componentes servidor y cliente**, el uso de **componentes asíncronos** y el archivo especial `loading.tsx` para manejar estados de carga.

---

## 🌐 1. ¿Qué son los Server Actions?

**Server Actions** son funciones que se ejecutan del lado del **servidor**, directamente desde componentes React (normalmente formularios) sin necesidad de crear un endpoint separado.

### ✅ Ventajas

- No se requiere crear endpoints en `/api`.
- Permite lógica segura del lado del servidor.
- Soporte nativo para TypeScript.

---

## 🛠️ 2. Ejemplo básico de Server Action

```tsx
// app/form-example/page.tsx
"use client";

import { useState } from "react";

async function submitForm(formData: FormData) {
  "use server";
  const name = formData.get("name");
  console.log("Nombre recibido:", name);
}

export default function Page() {
  return (
    <form action={submitForm}>
      <input name="name" type="text" placeholder="Tu nombre" />
      <button type="submit">Enviar</button>
    </form>
  );
}
```

📌 `use server` indica que la función corre en el servidor.

---

## 🧩 3. ¿Qué es un componente servidor vs cliente?

### 🧠 Componente Servidor (por defecto)

- Corre solo en el servidor.
- Tiene acceso directo a la base de datos, archivos, etc.
- No puede usar hooks de React como `useState`, `useEffect`, etc.

### 🖥️ Componente Cliente

- Se ejecuta en el navegador del usuario.
- Necesita la directiva `"use client"` al principio.
- Puede usar hooks y responder a eventos del DOM.

```tsx
// app/example-client/page.tsx
"use client";

import { useState } from "react";

export default function Page() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(count + 1)}>Contador: {count}</button>;
}
```

---

## ⏳ 4. Componentes asíncronos (`async` components)

Los componentes servidor pueden ser `async` para esperar datos antes de renderizar.

```tsx
// app/products/page.tsx
async function getProducts() {
  const res = await fetch("https://fakestoreapi.com/products");
  return res.json();
}

export default async function ProductsPage() {
  const products = await getProducts();

  return (
    <div>
      <h1>Productos</h1>
      <ul>
        {products.map((p: any) => (
          <li key={p.id}>{p.title}</li>
        ))}
      </ul>
    </div>
  );
}
```

🟢 Ideal para SSR (Server-Side Rendering).

---

## 🌀 5. loading.tsx – manejo del estado de carga

Cuando una página es asíncrona, Next.js permite definir un archivo `loading.tsx` que se muestra **mientras se carga**.

### 📁 Estructura:

```
app/
├── products/
│   ├── loading.tsx
│   └── page.tsx
```

### 🧪 Ejemplo:

```tsx
// app/products/loading.tsx
export default function Loading() {
  return <p>Cargando productos...</p>;
}
```

Este archivo se renderiza automáticamente mientras `page.tsx` está esperando datos.

---

## 🧠 Buenas prácticas

- ✅ Usa componentes `async` para cargar datos en SSR.
- ✅ Usa `loading.tsx` para UX fluida mientras se cargan datos.
- ✅ Usa `"use client"` solo cuando es necesario (eventos, hooks).
- ✅ Usa Server Actions para lógica del servidor sin crear endpoints.

---

## 🧪 Ejercicios sugeridos

1. Crear una página `/form` con un formulario que envíe datos al servidor usando Server Action.
2. Crear un contador en `/counter` usando un componente cliente.
3. Crear una página `/posts` que cargue posts desde una API usando un componente `async`.
4. Agregar un archivo `loading.tsx` en `/posts` con un texto personalizado.

---

¡Con esto ya manejás los conceptos clave del nuevo modelo de Next.js 14! 🚀
