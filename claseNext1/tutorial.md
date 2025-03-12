# Tutorial de Next.js 14+

## ¿Qué es Next.js?

Next.js es un framework de React que permite crear aplicaciones web modernas con características avanzadas como renderizado del lado del servidor (SSR), generación estática de sitios (SSG), y renderizado del lado del cliente (CSR). La versión 14 introduce mejoras significativas en el App Router y nuevas características de rendimiento.

## Características Principales

### 1. App Router (Nuevo)
- **Server Components**: Componentes renderizados en el servidor por defecto
- **Client Components**: Componentes interactivos con 'use client'
- **Server Actions**: Funciones que se ejecutan en el servidor
- **Streaming y Suspense**: Carga progresiva de contenido

### 2. Sistema de Archivos
```plaintext
app/
├── layout.js      # Layout principal
├── page.js        # Página principal
├── about/
│   └── page.js    # Página /about
├── blog/
│   ├── page.js    # Página /blog
│   └── [slug]/
│       └── page.js # Página dinámica /blog/[slug]
└── api/
    └── route.js   # API Routes
```

### 3. Optimizaciones
- **Turbopack**: Compilador más rápido
- **Partial Prerendering**: Renderizado parcial de páginas
- **Server Actions**: Optimización de formularios
- **Image Component**: Mejoras en optimización de imágenes

## Conceptos Fundamentales

### 1. Server Components
```jsx
// app/page.js
export default async function Home() {
  const data = await fetchData()
  
  return (
    <main>
      <h1>Bienvenido</h1>
      <DataDisplay data={data} />
    </main>
  )
}
```

### 2. Client Components
```jsx
'use client'

import { useState } from 'react'

export default function Counter() {
  const [count, setCount] = useState(0)
  
  return (
    <button onClick={() => setCount(count + 1)}>
      Contador: {count}
    </button>
  )
}
```

### 3. Server Actions
```jsx
// app/actions.js
'use server'

export async function submitForm(formData) {
  // Procesar datos en el servidor
  await saveToDatabase(formData)
  return { success: true }
}

// app/page.js
import { submitForm } from './actions'

export default function Form() {
  return (
    <form action={submitForm}>
      <input name="title" />
      <button type="submit">Enviar</button>
    </form>
  )
}
```

### 4. Layouts y Templates
```jsx
// app/layout.js
export default function RootLayout({ children }) {
  return (
    <html lang="es">
      <body>
        <nav>Navegación</nav>
        {children}
      </body>
    </html>
  )
}

// app/template.js
export default function Template({ children }) {
  return (
    <div className="template">
      {children}
    </div>
  )
}
```

### 5. Loading y Error States
```jsx
// app/loading.js
export default function Loading() {
  return <div>Cargando...</div>
}

// app/error.js
'use client'

export default function Error({ error, reset }) {
  return (
    <div>
      <h2>Algo salió mal</h2>
      <button onClick={() => reset()}>Reintentar</button>
    </div>
  )
}
```

## Características Avanzadas

### 1. Metadata API
```jsx
// app/layout.js
export const metadata = {
  title: 'Mi Sitio',
  description: 'Descripción del sitio',
}

// Metadata dinámica
export async function generateMetadata({ params }) {
  return {
    title: `Post ${params.slug}`,
  }
}
```

### 2. Route Handlers
```typescript
// app/api/route.ts
export async function GET() {
  return Response.json({ message: 'Hola desde la API' })
}

export async function POST(request: Request) {
  const data = await request.json()
  return Response.json({ data })
}
```

### 3. Middleware
```typescript
// middleware.ts
export function middleware(request: Request) {
  // Lógica de middleware
  return NextResponse.next()
}

export const config = {
  matcher: '/api/:path*',
}
```

## Mejores Prácticas

1. **Estructura del Proyecto**
   - Usar el App Router como estructura principal
   - Organizar componentes por funcionalidad
   - Separar Server y Client Components

2. **Optimización**
   - Aprovechar Server Components por defecto
   - Usar Client Components solo cuando sea necesario
   - Implementar Suspense para carga progresiva

3. **Rendimiento**
   - Utilizar Server Actions para formularios
   - Implementar streaming con Suspense
   - Optimizar imágenes con next/image

4. **SEO y Metadata**
   - Usar la Metadata API
   - Implementar metadatos dinámicos
   - Optimizar para motores de búsqueda

## Recursos Adicionales

Para profundizar en el desarrollo con Next.js 14+, puedes consultar:

[Tutorial Completo de Next.js](https://v0.dev/chat/next-js-tutorial-VtTuWVwbdsp?b=b_BiFtlEwjM01) - Una guía detallada que cubre todos los aspectos importantes de Next.js, desde conceptos básicos hasta técnicas avanzadas.

[Ejercicios Prácticos de Next.js](https://v0.dev/chat/next-js-practice-pages-s2AzJuhFN4A?b=b_HjTCDJGP10y) - Una colección de ejercicios prácticos para mejorar tus habilidades con Next.js, incluyendo ejemplos de páginas y componentes reales. 