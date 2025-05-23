# 🎉 Tutorial: Invitación a Cumpleaños con Confirmación, Email y Dashboard en Next.js 14

Este tutorial cubre paso a paso la implementación de una app completa con Next.js 14, MongoDB, Resend y funcionalidades de admin para gestionar una invitación de cumpleaños con confirmaciones, notificaciones, panel privado, envío de recordatorios y QR de acceso.

---

## 📦 Tecnologías Usadas

* **Next.js 14 App Router**
* **Server Actions**
* **MongoDB + Mongoose**
* **Tailwind CSS + Shadcn UI**
* **Resend (email)**
* **qrcode.react (QR)**

---

## 🔧 1. Inicialización del Proyecto

```bash
npx create-next-app@latest birthday-invite --app --ts --tailwind
cd birthday-invite
npm install mongoose @resend/node qrcode.react jsonwebtoken bcryptjs
```

---

## 🧱 2. Modelos con Mongoose

### `models/Confirmation.ts`

```ts
import mongoose from "mongoose"

const ConfirmationSchema = new mongoose.Schema({
  name: String,
  attending: Boolean,
  guests: Number,
  comment: String,
  createdAt: {
    type: Date,
    default: Date.now,
  },
})

export default mongoose.models.Confirmation || mongoose.model("Confirmation", ConfirmationSchema)
```

### `lib/db.ts`

```ts
import mongoose from "mongoose"

export const connectDB = async () => {
  if (mongoose.connection.readyState >= 1) return
  await mongoose.connect(process.env.MONGODB_URI!)
}
```

---

## 📄 3. Server Action para Confirmar Asistencia

### `app/actions/confirm.ts`

```ts
'use server'
import { connectDB } from '@/lib/db'
import Confirmation from '@/models/Confirmation'
import { Resend } from 'resend'

export const confirmAttendance = async (formData: FormData) => {
  await connectDB()

  const data = {
    name: formData.get('name'),
    attending: formData.get('attending') === 'yes',
    guests: Number(formData.get('guests') || 1),
    comment: formData.get('comment')?.toString() || ''
  }

  await Confirmation.create(data)

  const resend = new Resend(process.env.RESEND_API_KEY)
  await resend.emails.send({
    from: 'invitaciones@tucumple.com',
    to: 'organizador@correo.com',
    subject: 'Nueva confirmación de asistencia',
    html: `<strong>${data.name}</strong> confirmó su asistencia. Invitados: ${data.guests}.` +
      (data.comment ? `<br/>Comentario: ${data.comment}` : '')
  })
}
```

---

## 🖊 4. Formulario de Confirmación

### `app/page.tsx`

```tsx
'use client'
import { confirmAttendance } from './actions/confirm'
import { useState } from 'react'

export default function HomePage() {
  const [status, setStatus] = useState('')

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    const formData = new FormData(e.currentTarget)
    await confirmAttendance(formData)
    setStatus('Gracias por confirmar tu asistencia!')
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4 p-6 max-w-md mx-auto">
      <input name="name" required placeholder="Tu nombre" className="input" />
      <select name="attending" required className="select">
        <option value="yes">Voy a asistir</option>
        <option value="no">No puedo ir</option>
      </select>
      <input name="guests" type="number" min={1} defaultValue={1} className="input" />
      <textarea name="comment" placeholder="Comentarios especiales" className="textarea" />
      <button type="submit" className="btn">Confirmar</button>
      {status && <p>{status}</p>}
    </form>
  )
}
```

---

## 🔐 5. Autenticación Simple para Panel Admin

* Crear un login simple con JWT y cookies.
* Proteger ruta `/admin` con middleware (`middleware.ts`).

---

## 📊 6. Panel Admin con Lista y Estadísticas

### `app/admin/page.tsx`

```tsx
import { connectDB } from '@/lib/db'
import Confirmation from '@/models/Confirmation'

export default async function AdminPage() {
  await connectDB()
  const confirmations = await Confirmation.find()

  const confirmed = confirmations.filter(c => c.attending)
  const totalGuests = confirmed.reduce((sum, c) => sum + c.guests, 0)

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold">Panel de Confirmaciones</h1>
      <p>Total confirmados: {confirmed.length}</p>
      <p>Invitados en total: {totalGuests}</p>
      <ul>
        {confirmed.map(c => (
          <li key={c._id}>{c.name} - {c.guests} personas</li>
        ))}
      </ul>
    </div>
  )
}
```

---

## ✉️ 7. Enviar Recordatorio a Todos los Confirmados

### `app/actions/send-reminder.ts`

```ts
'use server'
import { Resend } from 'resend'
import Confirmation from '@/models/Confirmation'
import { connectDB } from '@/lib/db'

export const sendReminderEmails = async () => {
  await connectDB()
  const confirmed = await Confirmation.find({ attending: true })

  const resend = new Resend(process.env.RESEND_API_KEY)

  for (const user of confirmed) {
    await resend.emails.send({
      from: 'invitaciones@tucumple.com',
      to: user.email || 'organizador@correo.com',
      subject: 'Recordatorio: Fiesta de cumpleaños',
      html: `<p>Hola ${user.name}, te recordamos que estás invitado al cumple! Nos vemos pronto 🎉</p>`
    })
  }
}
```

---

## 🔳 8. Código QR para Compartir Invitación

### `app/components/QRCode.tsx`

```tsx
'use client'
import { QRCodeCanvas } from 'qrcode.react'

export default function QRCode() {
  return (
    <div className="p-6">
      <p>Escaneá este código para ver la invitación:</p>
      <QRCodeCanvas value="https://tucumple.vercel.app/" size={200} />
    </div>
  )
}
```

Agregarlo en la página principal o en una sección de "compartir" del admin.

---

## 🚀 9. Despliegue en Vercel

* Subir a GitHub.
* Crear proyecto en [https://vercel.com](https://vercel.com).
* Configurar variables:

  ```env
  MONGODB_URI=...
  RESEND_API_KEY=...
  JWT_SECRET=...
  ```

---

## ✅ Resultado Final

Una aplicación que permite:

* Enviar invitaciones con formulario online.
* Confirmar asistencia.
* Enviar notificaciones automáticas.
* Visualizar estadísticas en panel privado.
* Compartir con código QR.

---
