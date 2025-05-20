
# 🧪 Ejercicio Fullstack: Registro, Login y Dashboard Protegido con JWT en Next.js 14

## 🎯 Objetivo

Construir una pequeña aplicación en Next.js 14 donde el usuario pueda:

1. Registrarse con nombre, edad, email y contraseña.
2. Iniciar sesión con email y contraseña.
3. Acceder a un `/dashboard` que muestre su información personal.
4. Proteger la ruta `/dashboard` y la API que entrega los datos personales usando Middleware y JWT guardado en cookies.
5. Guardar los datos en MongoDB usando Mongoose.

---

## 🧠 Parte 1 - Modelo de Usuario

Archivo: `models/User.ts`

```ts
import mongoose, { Schema, model, models } from 'mongoose'

const UserSchema = new Schema({
  name: { type: String, required: true },
  age: { type: Number, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true }, // será hasheada
})

const User = models.User || model('User', UserSchema)
export default User
```

---

## 🌐 Parte 2 - Conexión a MongoDB

Archivo: `lib/db.ts`

```ts
import mongoose from 'mongoose'

export const connectDB = async () => {
  if (mongoose.connections[0].readyState) return
  await mongoose.connect(process.env.MONGO_URI!)
}
```

Archivo: `.env.local`

```
MONGO_URI=mongodb+srv://<usuario>:<password>@cluster.mongodb.net/registroDB
JWT_SECRET=mitokensecretoseguro
```

---

## 📝 Parte 3 - Server Actions para registro y login

Archivo: `app/actions/auth.ts`

```ts
'use server'

import { connectDB } from '@/lib/db'
import User from '@/models/User'
import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import { cookies } from 'next/headers'

export async function registerUser(formData: FormData) {
  await connectDB()

  const name = formData.get('name') as string
  const age = Number(formData.get('age'))
  const email = formData.get('email') as string
  const password = formData.get('password') as string

  const existing = await User.findOne({ email })
  if (existing) throw new Error('Email ya registrado')

  const hashedPassword = await bcrypt.hash(password, 10)

  const newUser = await User.create({
    name, age, email, password: hashedPassword,
  })

  return { success: true }
}

export async function loginUser(formData: FormData) {
  await connectDB()

  const email = formData.get('email') as string
  const password = formData.get('password') as string

  const user = await User.findOne({ email })
  if (!user) throw new Error('Usuario no encontrado')

  const isMatch = await bcrypt.compare(password, user.password)
  if (!isMatch) throw new Error('Contraseña incorrecta')

  const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET!, {
    expiresIn: '7d',
  })

  cookies().set('token', token, {
    httpOnly: true,
    path: '/',
  })

  return { success: true }
}
```

---

## 🧾 Parte 4 - Formularios de Registro y Login

Archivo: `app/register/page.tsx`

```tsx
'use client'

import { registerUser } from '../actions/auth'
import { useRouter } from 'next/navigation'

export default function RegisterPage() {
  const router = useRouter()

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const formData = new FormData(e.currentTarget)
    await registerUser(formData)
    router.push('/login')
  }

  return (
    <form onSubmit={handleSubmit}>
      <input name="name" placeholder="Nombre" required />
      <input name="age" type="number" placeholder="Edad" required />
      <input name="email" type="email" placeholder="Email" required />
      <input name="password" type="password" placeholder="Contraseña" required />
      <button type="submit">Registrarse</button>
    </form>
  )
}
```

Archivo: `app/login/page.tsx`

```tsx
'use client'

import { loginUser } from '../actions/auth'
import { useRouter } from 'next/navigation'

export default function LoginPage() {
  const router = useRouter()

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const formData = new FormData(e.currentTarget)
    await loginUser(formData)
    router.push('/dashboard')
  }

  return (
    <form onSubmit={handleSubmit}>
      <input name="email" type="email" placeholder="Email" required />
      <input name="password" type="password" placeholder="Contraseña" required />
      <button type="submit">Iniciar Sesión</button>
    </form>
  )
}
```

---

## 🛡️ Parte 5 - Middleware para proteger el dashboard

Archivo: `middleware.ts`

```ts
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'
import jwt from 'jsonwebtoken'

export function middleware(request: NextRequest) {
  const token = request.cookies.get('token')?.value

  if (!token) return NextResponse.redirect(new URL('/login', request.url))

  try {
    jwt.verify(token, process.env.JWT_SECRET!)
    return NextResponse.next()
  } catch {
    return NextResponse.redirect(new URL('/login', request.url))
  }
}

export const config = {
  matcher: ['/dashboard'],
}
```

---

## 📄 Parte 6 - Ruta `/dashboard` protegida + server action para traer datos

Archivo: `app/actions/getUser.ts`

```ts
'use server'

import { cookies } from 'next/headers'
import jwt from 'jsonwebtoken'
import { connectDB } from '@/lib/db'
import User from '@/models/User'

export async function getUserData() {
  const token = cookies().get('token')?.value
  if (!token) throw new Error('No autenticado')

  const { userId } = jwt.verify(token, process.env.JWT_SECRET!) as any

  await connectDB()
  const user = await User.findById(userId).select('-password')

  return user
}
```

Archivo: `app/dashboard/page.tsx`

```tsx
import { getUserData } from '../actions/getUser'

export default async function DashboardPage() {
  const user = await getUserData()

  return (
    <div>
      <h1>Bienvenido, {user.name}</h1>
      <p>Edad: {user.age}</p>
      <p>Email: {user.email}</p>
    </div>
  )
}
```

---

## ✅ Resultado Esperado

1. El usuario puede registrarse.
2. Luego iniciar sesión.
3. Se crea un JWT que se guarda en cookies.
4. Al acceder a `/dashboard`:
   - El middleware verifica si está autenticado.
   - La página muestra los datos personales del usuario autenticado.

---

## 🧩 Extras Opcionales

- Agregá un botón de logout que borre la cookie `token`.
- Usá Shadcn UI o Tailwind para estilizar el formulario.
- Mostrá errores de validación si el email ya existe o la contraseña es incorrecta.
