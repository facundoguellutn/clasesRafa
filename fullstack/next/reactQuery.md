# 📘 Tutorial: Uso de React Query en Next.js 14

## ✅ Introducción

**React Query** es una librería para manejo de estados asincrónicos en aplicaciones React (incluido Next.js). Su propósito es **simplificar la obtención, almacenamiento en caché, sincronización y actualización de datos provenientes de una API**.

> Es ideal para reemplazar el uso manual de `useEffect` + `fetch` + `useState`.

### ⭐ Ventajas

* Cacheo automático de datos
* Evita refetchs innecesarios
* Manejo automático de estados de carga y error
* Refetch automático al volver a la pestaña
* Fácil integración con Next.js

---

## 📚 Instalación

```bash
npm install @tanstack/react-query
```

Para el devtools (opcional):

```bash
npm install @tanstack/react-query-devtools
```

---

## 📚 Setup en Next.js 14

### 1. Crear el proveedor global `QueryClientProvider`

Archivo: `app/providers.tsx`

```tsx
'use client'

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'
import { useState } from 'react'

export function Providers({ children }: { children: React.ReactNode }) {
  const [client] = useState(new QueryClient())
  return (
    <QueryClientProvider client={client}>
      {children}
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  )
}
```

### 2. Integrar en layout.tsx

Archivo: `app/layout.tsx`

```tsx
import { Providers } from './providers'

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <Providers>{children}</Providers>
      </body>
    </html>
  )
}
```

---

## 🌐 Ejemplo básico: Obtener usuarios desde una API

Supongamos que tenemos una API en `/api/users` que devuelve un array de usuarios.

### Paso 1: Crear el fetcher

Archivo: `lib/fetchUsers.ts`

```ts
export const fetchUsers = async () => {
  const res = await fetch('/api/users')
  if (!res.ok) throw new Error('Error al obtener usuarios')
  return res.json()
}
```

### Paso 2: Usar useQuery en un componente cliente

```tsx
'use client'

import { useQuery } from '@tanstack/react-query'
import { fetchUsers } from '@/lib/fetchUsers'

export default function UsersList() {
  const { data, isLoading, error } = useQuery({
    queryKey: ['users'],
    queryFn: fetchUsers,
  })

  if (isLoading) return <p>Cargando...</p>
  if (error) return <p>Error al cargar usuarios</p>

  return (
    <ul>
      {data.map((user: any) => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  )
}
```

---

## 💡 Otras funcionalidades

### Refetch manual

```tsx
const { refetch } = useQuery(...)
<button onClick={() => refetch()}>Actualizar</button>
```

### Invalidate cache tras mutación

```ts
import { useQueryClient } from '@tanstack/react-query'
const queryClient = useQueryClient()
queryClient.invalidateQueries(['users'])
```

---

## ⚠️ Buenas prácticas

* Usar `queryKey` significativos: `['users']`, `['user', userId]`
* Evitar fetchs innecesarios usando `staleTime`
* Siempre manejar `isLoading` y `error`

---

## ✅ Conclusión

React Query es una herramienta poderosa que permite manejar datos remotos de forma eficiente, declarativa y optimizada. Integrarlo en Next.js es directo, y mejora la experiencia del usuario al reducir los tiempos de carga y la complejidad del código.

---

☞ Tip: Explorá también los hooks `useMutation` para crear, editar o borrar datos.

## 🌟 Uso Avanzado de React Query

### 1. Estados y Callbacks

```tsx
'use client'

import { useQuery } from '@tanstack/react-query'
import { fetchUsers } from '@/lib/fetchUsers'

export default function UsersList() {
  const { 
    data,           // Datos de la query
    isLoading,      // Estado de carga inicial
    isFetching,     // Estado de carga en refetch
    isError,        // Estado de error
    error,          // Objeto de error
    isSuccess,      // Estado de éxito
    status,         // Estado general: 'loading' | 'error' | 'success'
    refetch         // Función para forzar refetch
  } = useQuery({
    queryKey: ['users'],
    queryFn: fetchUsers,
    onSuccess: (data) => {
      // Se ejecuta cuando la query es exitosa
      console.log('Datos obtenidos:', data)
    },
    onError: (error) => {
      // Se ejecuta cuando hay un error
      console.error('Error:', error)
    },
    onSettled: (data, error) => {
      // Se ejecuta cuando la query termina (éxito o error)
      console.log('Query finalizada')
    }
  })
}
```

### 2. Control de Refetch y Cache

```tsx
const { data } = useQuery({
  queryKey: ['users'],
  queryFn: fetchUsers,
  staleTime: 5 * 60 * 1000,    // Datos considerados frescos por 5 minutos
  cacheTime: 30 * 60 * 1000,   // Datos en cache por 30 minutos
  refetchOnWindowFocus: true,  // Refetch al volver a la pestaña
  refetchOnMount: true,        // Refetch al montar el componente
  refetchOnReconnect: true,    // Refetch al reconectar
  retry: 3,                    // Número de reintentos en caso de error
  retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 30000)
})
```

### 3. Query Dependiente (enabled)

```tsx
'use client'

import { useQuery } from '@tanstack/react-query'

export default function UserProfile({ userId }: { userId: string }) {
  // Primero obtenemos el perfil básico
  const { data: profile } = useQuery({
    queryKey: ['profile', userId],
    queryFn: () => fetch(`/api/profile/${userId}`).then(res => res.json())
  })

  // Luego obtenemos los detalles solo si tenemos el perfil
  const { data: details } = useQuery({
    queryKey: ['profile-details', userId],
    queryFn: () => fetch(`/api/profile/${userId}/details`).then(res => res.json()),
    enabled: !!profile, // Solo se ejecuta si profile existe
  })
}
```

### 4. Mutaciones con useMutation

```tsx
'use client'

import { useMutation, useQueryClient } from '@tanstack/react-query'

export default function CreateUser() {
  const queryClient = useQueryClient()

  const mutation = useMutation({
    mutationFn: (newUser) => {
      return fetch('/api/users', {
        method: 'POST',
        body: JSON.stringify(newUser)
      })
    },
    onSuccess: () => {
      // Invalidar y refetch
      queryClient.invalidateQueries({ queryKey: ['users'] })
    },
    onError: (error) => {
      console.error('Error al crear usuario:', error)
    }
  })

  return (
    <button
      onClick={() => {
        mutation.mutate({ name: 'Nuevo Usuario' })
      }}
      disabled={mutation.isPending}
    >
      {mutation.isPending ? 'Creando...' : 'Crear Usuario'}
    </button>
  )
}
```

### 5. Optimistic Updates

```tsx
const mutation = useMutation({
  mutationFn: updateUser,
  onMutate: async (newUser) => {
    // Cancelar queries en curso
    await queryClient.cancelQueries({ queryKey: ['users'] })

    // Snapshot del estado anterior
    const previousUsers = queryClient.getQueryData(['users'])

    // Actualización optimista
    queryClient.setQueryData(['users'], (old: any[]) => [
      ...old,
      newUser
    ])

    return { previousUsers }
  },
  onError: (err, newUser, context) => {
    // Rollback en caso de error
    queryClient.setQueryData(['users'], context.previousUsers)
  },
  onSettled: () => {
    // Refetch para asegurar sincronización
    queryClient.invalidateQueries({ queryKey: ['users'] })
  }
})
```

### 6. Infinite Queries

```tsx
import { useInfiniteQuery } from '@tanstack/react-query'

function InfiniteUsers() {
  const {
    data,
    error,
    fetchNextPage,
    hasNextPage,
    isFetchingNextPage,
    status,
  } = useInfiniteQuery({
    queryKey: ['users'],
    queryFn: ({ pageParam = 1 }) => fetchUsers(pageParam),
    getNextPageParam: (lastPage, pages) => {
      return lastPage.hasMore ? pages.length + 1 : undefined
    },
  })

  return (
    <div>
      {status === 'loading' ? (
        <p>Cargando...</p>
      ) : status === 'error' ? (
        <p>Error: {error.message}</p>
      ) : (
        <>
          {data.pages.map((group, i) => (
            <div key={i}>
              {group.users.map(user => (
                <div key={user.id}>{user.name}</div>
              ))}
            </div>
          ))}
          <button
            onClick={() => fetchNextPage()}
            disabled={!hasNextPage || isFetchingNextPage}
          >
            {isFetchingNextPage
              ? 'Cargando más...'
              : hasNextPage
              ? 'Cargar más'
              : 'No hay más datos'}
          </button>
        </>
      )}
    </div>
  )
}
```

---

## 🎯 Tips Avanzados

1. **Prefetching**: Usar `queryClient.prefetchQuery()` para cargar datos antes de que el usuario los necesite
2. **Suspense**: React Query soporta React Suspense para manejar estados de carga
3. **Select**: Usar la opción `select` para transformar los datos antes de que lleguen al componente
4. **Parallel Queries**: Ejecutar múltiples queries en paralelo usando `useQueries`
5. **Query Keys**: Usar arrays para query keys más específicos: `['todos', { status, page }]`

---
