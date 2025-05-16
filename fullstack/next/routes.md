
# 🚀 Tutorial Inicial de Next.js 14 con TypeScript

Este tutorial cubre los fundamentos para comenzar un proyecto en Next.js 14 usando TypeScript. Aprenderás sobre la estructura de archivos, rutas, páginas dinámicas, layouts, y manejo de parámetros de búsqueda.

---

## 📦 1. Instalación y estructura básica del proyecto

Primero, instalamos Next.js con soporte para TypeScript:

```bash
npx create-next-app@latest mi-proyecto --typescript
```

Esto genera una estructura básica como esta:

```
mi-proyecto/
├── app/
│   ├── layout.tsx
│   ├── page.tsx
│   └── (otras carpetas/páginas)
├── public/
├── styles/
├── tsconfig.json
├── next.config.js
└── package.json
```

### 🔍 Descripción rápida de carpetas

- `app/`: Define las rutas y vistas. Cada archivo `page.tsx` representa una página.
- `public/`: Archivos estáticos como imágenes.
- `styles/`: Estilos globales.
- `layout.tsx`: Componente layout principal.
- `tsconfig.json`: Configuración de TypeScript.

---

## 🛣️ 2. Rutas en Next.js (Pages Routing)

Cada carpeta en `app/` representa una ruta.

### 📝 Página simple

```tsx
// app/about/page.tsx
export default function AboutPage() {
  return <h1>Sobre nosotros</h1>;
}
```

Esto genera la ruta: `http://localhost:3000/about`

### 📝 Página de inicio

Ya viene por defecto: `app/page.tsx` → `http://localhost:3000`

---

## 🔄 3. Páginas dinámicas

Para rutas como `/products/123`, usamos corchetes:

```tsx
// app/products/[id]/page.tsx
type Props = {
  params: { id: string };
};

export default function ProductPage({ params }: Props) {
  return <h1>Producto ID: {params.id}</h1>;
}
```

Esto crea páginas dinámicas como `/products/42`.

---

## 🧩 4. Layouts

Los layouts permiten envolver varias páginas con una misma estructura.

### 📄 Layout global

```tsx
// app/layout.tsx
import "./globals.css";
import { ReactNode } from "react";

export const metadata = {
  title: "Mi App",
  description: "App en Next.js",
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="es">
      <body>
        <header>Mi Header</header>
        <main>{children}</main>
        <footer>Mi Footer</footer>
      </body>
    </html>
  );
}
```

### 📄 Layout por sección

```tsx
// app/dashboard/layout.tsx
export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <div>
      <aside>Menú Dashboard</aside>
      <section>{children}</section>
    </div>
  );
}
```

Esto afecta solo las páginas bajo `/dashboard`.

---

## 🔎 5. Parámetros de búsqueda (Query Params)

### En componentes cliente

```tsx
// app/search/page.tsx
"use client";

import { useSearchParams } from "next/navigation";

export default function SearchPage() {
  const searchParams = useSearchParams();
  const query = searchParams.get("query");

  return <h1>Buscando: {query}</h1>;
}
```

### En componentes servidor (page.tsx)

```tsx
// app/products/[id]/page.tsx
type Props = {
  params: { id: string };
  searchParams: { highlight?: string };
};

export default function ProductPage({ params, searchParams }: Props) {
  return (
    <div>
      <h1>Producto: {params.id}</h1>
      {searchParams.highlight && <p>Resaltado: {searchParams.highlight}</p>}
    </div>
  );
}
```

Ejemplo: `/products/5?highlight=oferta`

---

## ✅ Resumen

| Concepto                | Archivo                          | Ruta resultante            |
|------------------------|----------------------------------|----------------------------|
| Página simple          | `app/about/page.tsx`             | `/about`                   |
| Página dinámica        | `app/products/[id]/page.tsx`     | `/products/123`            |
| Layout global          | `app/layout.tsx`                 | En toda la app             |
| Layout por sección     | `app/dashboard/layout.tsx`       | Solo `/dashboard/*`        |
| Query Params (cliente) | `useSearchParams()`              | `/search?query=zapatos`    |
| Query Params (servidor)| `searchParams` en `page.tsx`     | `/products/1?highlight=promo` |

---

## 🧪 Ejercicios sugeridos

1. Crea una página en `/contact` con un formulario básico.
2. Crea rutas dinámicas para un blog: `/blog/[slug]`.
3. Agrega un layout personalizado para `/admin`.
4. Implementa una búsqueda con query param en `/search`.

---

¡Listo! Ahora ya tenés las bases para empezar tu proyecto con Next.js 14 y TypeScript.
