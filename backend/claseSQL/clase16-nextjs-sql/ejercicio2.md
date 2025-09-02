# Ejercicio 2: Creando una Página de Detalle Dinámica

## 🎯 Objetivo

Crear una ruta dinámica en Next.js (ej: `/libros/[id]`) que utilice los parámetros de la URL para buscar y mostrar los detalles de un único registro de la base de datos.

---

## 📖 Escenario

Queremos que al hacer clic en un libro de la lista principal, el usuario sea llevado a una página de detalle que muestre toda la información de ese libro específico, incluyendo el nombre de su autor.

**Página a Implementar**: `app/libros/[id]/page.tsx`

---

## 🏋️‍♀️ Tu Tarea

### Parte 1: Crear la Estructura de Ruta Dinámica

1.  Dentro de la carpeta `app/libros/`, creá una nueva carpeta llamada `[id]` (con los corchetes).
2.  Dentro de `app/libros/[id]/`, creá un nuevo archivo llamado `page.tsx`.

### Parte 2: Escribir el Componente de Página Dinámica

Dentro de `app/libros/[id]/page.tsx`, escribí el código para el componente.

1.  **Importar Dependencias**: Importá `db`, los esquemas necesarios (`libros`, `autores`) y la función `notFound` de `next/navigation`.
2.  **Definir Props**: El componente recibirá `params` como prop. Definí una interfaz para las props: `interface PageProps { params: { id: string } }`.
3.  **Componente Asíncrono**: Creá la función `export default async function LibroDetallePage({ params }: PageProps) { ... }`.
4.  **Obtener el ID**: Extraé el `id` de `params` y convertilo a número.
5.  **Consultar la Base de Datos**: Escribí una consulta que busque un único libro por su ID. Hacé un `LEFT JOIN` con la tabla `autores` para obtener también el nombre del autor.
6.  **Manejar "No Encontrado"**: Después de la consulta, verificá si el libro existe. Si no, llamá a la función `notFound()` para que Next.js muestre la página 404.
7.  **Renderizar los Detalles**: Si el libro se encuentra, mostrá su `titulo`, `resumen`, el `nombre` del autor y cualquier otra información que consideres relevante.

---

## 💡 Solución Propuesta

<details>
<summary>Click para ver la solución</summary>

**`app/libros/[id]/page.tsx`**

```typescript
import { db } from '@/lib/db';
import { libros, autores } from '@/lib/db/schema';
import { eq } from 'drizzle-orm';
import { notFound } from 'next/navigation';
import Link from 'next/link';

interface PageProps {
  params: { id: string };
}

// Este Server Component recibe el ID de la URL a través de params
export default async function LibroDetallePage({ params }: PageProps) {
  const libroId = parseInt(params.id, 10);

  // 1. Consulta a la DB usando el ID, con un JOIN para traer el nombre del autor
  const libro = await db
    .select({
      titulo: libros.titulo,
      resumen: libros.resumen,
      isbn: libros.isbn,
      paginas: libros.paginas,
      fechaPublicacion: libros.fechaPublicacion,
      autorNombre: autores.nombre,
    })
    .from(libros)
    .leftJoin(autores, eq(libros.autorId, autores.id))
    .where(eq(libros.id, libroId))
    .then((results) => results[0]); // .then() para obtener el primer resultado o undefined

  // 2. Si la consulta no devuelve nada, mostramos la página 404
  if (!libro) {
    notFound();
  }

  return (
    <div className="container mx-auto py-8 max-w-3xl">
      <Link href="/libros" className="text-blue-500 hover:underline mb-6 block">
        &larr; Volver a la lista de libros
      </Link>

      <article className="prose lg:prose-xl">
        {/* 3. Renderizado de los detalles del libro */}
        <h1>{libro.titulo}</h1>
        <p className="lead text-gray-600">por {libro.autorNombre || 'Autor desconocido'}</p>
        
        {libro.resumen && <p>{libro.resumen}</p>}

        <div className="mt-8 p-4 border-t">
          <h3 className="text-lg font-semibold">Detalles Adicionales</h3>
          <ul>
            {libro.isbn && <li><strong>ISBN:</strong> {libro.isbn}</li>}
            {libro.paginas && <li><strong>Páginas:</strong> {libro.paginas}</li>}
            {libro.fechaPublicacion && <li><strong>Publicado en:</strong> {libro.fechaPublicacion}</li>}
          </ul>
        </div>
      </article>
    </div>
  );
}
```

</details>
