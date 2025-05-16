
# 📡 Tutorial: Creación de Endpoints en Next.js 14 con TypeScript

En este tutorial vas a aprender cómo crear **API endpoints** en una aplicación de **Next.js 14 con TypeScript**, utilizando la nueva estructura del directorio `/app`.

---

## 📁 1. ¿Dónde se crean los endpoints?

En Next.js 14 con la App Router, los endpoints se crean dentro de la carpeta `app` usando archivos especiales llamados **route handlers** en una carpeta `/route.ts`.

### 📌 Estructura:

```
app/
├── api/
│   └── hello/
│       └── route.ts
```

El endpoint estará disponible en: `http://localhost:3000/api/hello`

---

## 🛠️ 2. Crear un endpoint básico (GET)

```ts
// app/api/hello/route.ts
import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({ message: "Hola desde el backend de Next.js!" });
}
```

📌 Resultado en el navegador: `{"message":"Hola desde el backend de Next.js!"}`

---

## 📩 3. Endpoint con método POST y body

```ts
// app/api/contact/route.ts
import { NextRequest, NextResponse } from "next/server";

export async function POST(req: NextRequest) {
  const body = await req.json();
  const { name, email } = body;

  if (!name || !email) {
    return NextResponse.json({ error: "Faltan campos" }, { status: 400 });
  }

  return NextResponse.json({ message: `Gracias ${name}, te contactaremos pronto.` });
}
```

### 🧪 Ejemplo de `fetch` desde el frontend:

```ts
await fetch("/api/contact", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ name: "Facu", email: "facu@example.com" })
});
```

---

## 🗂️ 4. Métodos disponibles

Podés usar los siguientes handlers:

```ts
export async function GET(req: NextRequest) {}
export async function POST(req: NextRequest) {}
export async function PUT(req: NextRequest) {}
export async function DELETE(req: NextRequest) {}
export async function PATCH(req: NextRequest) {}
```

También se puede usar el objeto `request` para acceder a:

- `req.json()` – para leer el body en JSON.
- `req.headers` – para ver los headers.
- `req.nextUrl.searchParams` – para acceder a query params.

---

## 🔍 5. Acceso a query params en GET

```ts
// app/api/search/route.ts
import { NextRequest, NextResponse } from "next/server";

export async function GET(req: NextRequest) {
  const searchParams = req.nextUrl.searchParams;
  const term = searchParams.get("term");

  return NextResponse.json({ result: `Buscando: ${term}` });
}
```

📌 Ejemplo: `/api/search?term=camiseta`

---

## 🔐 6. Manejo de errores y status

```ts
// app/api/login/route.ts
import { NextRequest, NextResponse } from "next/server";

export async function POST(req: NextRequest) {
  try {
    const { user, pass } = await req.json();

    if (user === "admin" && pass === "1234") {
      return NextResponse.json({ ok: true });
    } else {
      return NextResponse.json({ error: "Credenciales inválidas" }, { status: 401 });
    }
  } catch (error) {
    return NextResponse.json({ error: "Error del servidor" }, { status: 500 });
  }
}
```

---

## ✅ Buenas prácticas

- ✅ Validar el body antes de usarlo.
- ✅ Retornar códigos HTTP correctos (200, 400, 401, 500).
- ✅ Usar funciones `async` y `await` correctamente.
- ✅ Usar TypeScript para tipar los datos si vas a conectarlo con una base de datos.

---

## 🧪 Ejercicios propuestos

1. Crea un endpoint `GET` en `/api/users` que devuelva una lista de usuarios.
2. Crea un endpoint `POST` en `/api/users` que permita agregar un nuevo usuario con nombre y edad.
3. Agrega validación: que no se pueda enviar una edad negativa.
4. Crea un endpoint `GET` en `/api/users?id=2` que devuelva solo el usuario con ese ID.

---

¡Con esto ya tenés una base sólida para empezar a construir tu API con Next.js 14 y TypeScript!
