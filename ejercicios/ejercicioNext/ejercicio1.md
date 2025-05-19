# Ejercicio Fullstack con Next.js 14

## Objetivo

Crear una mini aplicación de blog con navegación entre usuarios y sus publicaciones, utilizando rutas, layouts, API routes y server actions. Usaremos datos reales del servicio gratuito JSONPlaceholder.

---

## Funcionalidad esperada

* Página principal (`/`) con un listado de usuarios.
* Al hacer clic en un usuario, navegar a `/users/[id]` y ver información y posts.
* Usar `layout.tsx` para mostrar una navegación persistente.
* Una API route `/api/posts` que consuma `https://jsonplaceholder.typicode.com/posts` y devuelva los primeros 10.
* Una server action que consuma `https://jsonplaceholder.typicode.com/users/[id]` y retorne el detalle del usuario.

---

## Requisitos

1. **Navegación**

   * Crear enlaces entre páginas usando `<Link />`.
   * Usar `useRouter` para navegación programática opcional.

2. **Layouts**

   * Crear un layout general para toda la app (`app/layout.tsx`).
   * Crear un layout anidado para `/users` que agregue un subtítulo o navegación lateral.

3. **API Route**

   * Crear un archivo en `app/api/posts/route.ts` que haga un fetch a JSONPlaceholder y retorne un JSON con los primeros 10 posts.

4. **Server Actions**

   * En el archivo `app/users/[id]/page.tsx`, usar una `async function` para obtener el detalle del usuario y mostrar su info.

5. **Estilos**

   * Usar Tailwind CSS.
   * Agregar componentes visuales simples para navegación.

---

## Estructura sugerida

```
/app
  /api
    /posts
      route.ts
  /users
    layout.tsx
    /[id]
      page.tsx
  layout.tsx
  page.tsx
/components
  UserList.tsx
  UserCard.tsx
  PostList.tsx
/lib
  actions.ts
```

---

## Tips de implementación

### API Route `/api/posts/route.ts`

```ts
// app/api/posts/route.ts
import { NextResponse } from 'next/server';

export async function GET() {
  const res = await fetch('https://jsonplaceholder.typicode.com/posts');
  const data = await res.json();
  return NextResponse.json(data.slice(0, 10));
}
```

### Server Action `/lib/actions.ts`

```ts
export async function getUserById(id: string) {
  const res = await fetch(`https://jsonplaceholder.typicode.com/users/${id}`);
  return res.json();
}
```

### Layout General `/app/layout.tsx`

```tsx
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="p-6 font-sans">
        <header className="text-xl font-bold mb-6">Mi Blog</header>
        {children}
      </body>
    </html>
  );
}
```

### Página principal `/app/page.tsx`

```tsx
import Link from 'next/link';

export default async function HomePage() {
  const res = await fetch('https://jsonplaceholder.typicode.com/users');
  const users = await res.json();

  return (
    <div>
      <h1 className="text-2xl mb-4">Usuarios</h1>
      <ul className="space-y-2">
        {users.map((user: any) => (
          <li key={user.id}>
            <Link className="text-blue-600 hover:underline" href={`/users/${user.id}`}>{user.name}</Link>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

### Página de usuario `/app/users/[id]/page.tsx`

```tsx
import { getUserById } from '@/lib/actions';

export default async function UserPage({ params }: { params: { id: string } }) {
  const user = await getUserById(params.id);

  return (
    <div>
      <h1 className="text-2xl font-bold">{user.name}</h1>
      <p className="text-gray-600">{user.email}</p>
    </div>
  );
}
```

---

## Desafío opcional 🧠

* Mostrar debajo del usuario una lista de sus posts usando `fetch` desde `https://jsonplaceholder.typicode.com/posts?userId={id}`.
* Crear una pequeña navegación entre `/users`, `/api/posts`, y `/`.
* Aplicar loading.tsx para mostrar un spinner mientras carga el usuario.

---

## ¿Qué se practica?

✅ Navegación y rutas dinámicas
✅ Layouts en Next.js 14
✅ API Routes personalizadas
✅ Server Actions
✅ Integración de API externa (JSONPlaceholder)

---

## Recursos útiles

* [https://nextjs.org/docs/app/building-your-application/routing](https://nextjs.org/docs/app/building-your-application/routing)
* [https://nextjs.org/docs/app/building-your-application/data-fetching/server-actions](https://nextjs.org/docs/app/building-your-application/data-fetching/server-actions)
* [https://tailwindcss.com/docs](https://tailwindcss.com/docs)
* [https://jsonplaceholder.typicode.com/](https://jsonplaceholder.typicode.com/)
