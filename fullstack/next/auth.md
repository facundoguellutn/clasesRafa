
# 🔐 Tutorial: Autenticación con Middleware, Cookies y JWT en Next.js 14 + Mongoose

En este tutorial aprenderás a implementar un sistema de autenticación usando:

- MongoDB + Mongoose para gestionar usuarios.
- JSON Web Tokens (JWT) para identificar usuarios autenticados.
- Cookies HTTP con Next.js (`cookies()` de `next/headers`).
- Middleware de Next.js para proteger rutas privadas.
- Server Actions que validan la sesión a través de cookies.

---

## 1️⃣ Setup Inicial

Instalá las dependencias necesarias:

```bash
npm install mongoose jsonwebtoken bcryptjs
```

---

## 2️⃣ Configurar Mongoose

```ts
// lib/mongoose.ts
import mongoose from "mongoose";

const MONGODB_URI = process.env.MONGODB_URI!;

export const connectDB = async () => {
  if (mongoose.connection.readyState >= 1) return;

  return mongoose.connect(MONGODB_URI);
};
```

### Modelo de usuario

```ts
// models/User.ts
import mongoose from "mongoose";

const UserSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true }
});

export const User = mongoose.models.User || mongoose.model("User", UserSchema);
```

---

## 3️⃣ Login y generación de JWT

```ts
// app/api/login/route.ts
import { cookies } from "next/headers";
import { User } from "@/models/User";
import { connectDB } from "@/lib/mongoose";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { NextRequest, NextResponse } from "next/server";

export async function POST(req: NextRequest) {
  await connectDB();
  const { email, password } = await req.json();

  const user = await User.findOne({ email });
  if (!user) return NextResponse.json({ error: "Usuario no encontrado" }, { status: 401 });

  const match = await bcrypt.compare(password, user.password);
  if (!match) return NextResponse.json({ error: "Contraseña incorrecta" }, { status: 401 });

  const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET!, { expiresIn: "7d" });

  cookies().set("token", token, {
    httpOnly: true,
    path: "/",
    secure: process.env.NODE_ENV === "production",
    maxAge: 60 * 60 * 24 * 7,
  });

  return NextResponse.json({ message: "Login exitoso" });
}
```

---

## 4️⃣ Middleware para proteger rutas

```ts
// middleware.ts
import { NextRequest, NextResponse } from "next/server";
import jwt from "jsonwebtoken";

export function middleware(req: NextRequest) {
  const token = req.cookies.get("token")?.value;

  const url = req.nextUrl;

  const isPrivate = url.pathname.startsWith("/dashboard");

  if (isPrivate && !token) {
    return NextResponse.redirect(new URL("/login", req.url));
  }

  if (token) {
    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET!);
      // Podés adjuntar info al request si lo necesitás
    } catch (err) {
      if (isPrivate) return NextResponse.redirect(new URL("/login", req.url));
    }
  }

  return NextResponse.next();
}

// Proteger rutas que empiezan con /dashboard
export const config = {
  matcher: ["/dashboard/:path*"],
};
```

---

## 5️⃣ Acceder al usuario en Server Actions

```ts
// app/dashboard/actions.ts
"use server";

import jwt from "jsonwebtoken";
import { cookies } from "next/headers";
import { connectDB } from "@/lib/mongoose";
import { User } from "@/models/User";

export async function getUserData() {
  await connectDB();
  const token = cookies().get("token")?.value;

  if (!token) throw new Error("No autenticado");

  const decoded = jwt.verify(token, process.env.JWT_SECRET!) as { userId: string };

  const user = await User.findById(decoded.userId).select("-password");

  return user;
}
```

---

## 6️⃣ Ejemplo de uso en una página protegida

```tsx
// app/dashboard/page.tsx
import { getUserData } from "./actions";

export default async function DashboardPage() {
  const user = await getUserData();

  return <h1>Bienvenido {user.email}</h1>;
}
```

---

## 7️⃣ Logout

```ts
// app/api/logout/route.ts
import { cookies } from "next/headers";
import { NextResponse } from "next/server";

export async function POST() {
  cookies().delete("token");
  return NextResponse.json({ message: "Sesión cerrada" });
}
```

---

## ✅ Conclusión

Con este sistema implementás:

- 🔐 Autenticación segura con JWT y cookies.
- 🛡️ Middleware para rutas privadas.
- 🔍 Validación del usuario desde Server Actions.

---

## 🧪 Ejercicios sugeridos

1. Crea un registro (`/api/register`) que hashee la contraseña.
2. Agrega una ruta pública `/public` y una ruta privada `/dashboard`.
3. Muestra información del usuario logueado en `/dashboard` usando Server Actions.

---

¡Ya estás listo para implementar autenticación segura en tu app Next.js 14! 🚀
