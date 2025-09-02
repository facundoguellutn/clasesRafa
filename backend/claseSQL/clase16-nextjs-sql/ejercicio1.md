# Ejercicio 1: Creando una Página de Listado con Server Components

## 🎯 Objetivo

Practicar el concepto fundamental de los Server Components para buscar y mostrar datos de una base de datos directamente en un componente de página de Next.js.

---

## 📖 Escenario

Queremos crear una nueva página en nuestra aplicación de biblioteca que muestre una lista completa de todos los autores registrados en la base de datos. Esta página será de solo lectura.

**Página a Implementar**: `app/autores/page.tsx`

---

## 🏋️‍♀️ Tu Tarea

### Parte 1: Crear la Estructura de Archivos

1.  Dentro de la carpeta `app/`, creá una nueva carpeta llamada `autores`.
2.  Dentro de `app/autores/`, creá un nuevo archivo llamado `page.tsx`.

### Parte 2: Escribir el Server Component

Dentro de `app/autores/page.tsx`, escribí el código para el componente de página. Debe seguir estos pasos:

1.  **Importar dependencias**: Necesitarás importar tu cliente de base de datos (`db`) y el esquema de la tabla `autores`.
2.  **Definir el Componente Asíncrono**: Creá una función `export default async function AutoresPage() { ... }`.
3.  **Consultar la Base de Datos**: Dentro de la función, usá `await` para llamar a `db.select().from(autores)` y obtener todos los autores. Podés ordenarlos por nombre si querés.
4.  **Renderizar los Datos**: En el `return` del componente, usá JSX para renderizar un título (`<h1>Lista de Autores</h1>`) y luego mapeá el array de autores que obtuviste para renderizar una lista no ordenada (`<ul>`) donde cada `<li>` muestre el nombre y la nacionalidad del autor.
5.  **Manejar el Caso Vacío**: Si no hay autores, mostrá un mensaje como "No hay autores registrados."

---

## 💡 Solución Propuesta

<details>
<summary>Click para ver la solución</summary>

**`app/autores/page.tsx`**

```typescript
import { db } from '@/lib/db';
import { autores } from '@/lib/db/schema';
import { desc } from 'drizzle-orm';

// Este es un Server Component, se ejecuta en el servidor.
export default async function AutoresPage() {
  // 1. Consulta directa a la base de datos.
  const todosLosAutores = await db
    .select()
    .from(autores)
    .orderBy(desc(autores.createdAt));

  return (
    <div className="container mx-auto py-8">
      <h1 className="text-3xl font-bold mb-6">Lista de Autores</h1>

      {todosLosAutores.length === 0 ? (
        <p className="text-muted-foreground">No hay autores registrados todavía.</p>
      ) : (
        <div className="bg-white shadow rounded-lg border">
          <ul className="divide-y divide-gray-200">
            {/* 2. Mapeo y renderizado de los datos */}
            {todosLosAutores.map((autor) => (
              <li key={autor.id} className="px-6 py-4 flex items-center justify-between">
                <div>
                  <p className="text-lg font-medium text-gray-900">{autor.nombre}</p>
                  <p className="text-sm text-gray-500">{autor.nacionalidad || 'Nacionalidad no especificada'}</p>
                </div>
                <span className="text-xs text-gray-400">ID: {autor.id}</span>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}
```

</details>
