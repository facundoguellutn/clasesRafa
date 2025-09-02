# 🔗 NEXT.JS + SQL: FULL-STACK INTEGRATION - CLASE 16

> **Objetivo**: Crear aplicaciones full-stack modernas integrando Next.js 14 con bases de datos SQL, usando Server Actions, Server Components y el patrón de desarrollo más actualizado.

## 🎯 De Backend Separado a Full-Stack

Hasta ahora hemos trabajado con:
- **Frontend separado** (React/Next.js)
- **Backend separado** (Express.js + API REST)

Ahora aprenderemos el enfoque **moderno**:
- **Next.js Full-Stack** con Server Components
- **Server Actions** para mutaciones
- **Turso** como base de datos en la nube
- **Type-safe** con TypeScript

### 🤔 ¿Por qué Next.js Full-Stack?

```typescript
// ❌ Enfoque anterior: Frontend + API separada
// Frontend (Next.js)
const response = await fetch('/api/usuarios', {
  method: 'POST',
  body: JSON.stringify(userData)
});
const user = await response.json();

// Backend (Express.js)  
app.post('/api/usuarios', async (req, res) => {
  const user = await User.create(req.body);
  res.json(user);
});

// ✅ Enfoque moderno: Full-stack integrado
async function crearUsuario(formData: FormData) {
  'use server'; // Server Action
  
  const userData = {
    nombre: formData.get('nombre'),
    email: formData.get('email')
  };
  
  const user = await db.insert(usuarios).values(userData);
  revalidatePath('/usuarios');
  return user;
}
```

## 🏗️ Arquitectura de la Aplicación

### 📁 Estructura del Proyecto

```
biblioteca-next/
├── app/                    # App Router (Next.js 14)
│   ├── (dashboard)/       # Grupo de rutas con layout
│   │   ├── libros/        
│   │   │   ├── page.tsx
│   │   │   ├── [id]/
│   │   │   │   └── page.tsx
│   │   │   └── nuevo/
│   │   │       └── page.tsx
│   │   ├── usuarios/
│   │   └── prestamos/
│   ├── api/               # API Routes (solo si es necesario)
│   ├── globals.css
│   ├── layout.tsx         # Root Layout
│   └── page.tsx           # Home page
├── components/            # Componentes reutilizables
│   ├── ui/               # Componentes base (Button, Input, etc.)
│   ├── forms/            # Formularios específicos
│   └── layouts/          # Layouts compartidos
├── lib/                  # Utilidades y configuración
│   ├── db/              # Configuración de base de datos
│   │   ├── index.ts     # Conexión
│   │   ├── schema.ts    # Esquema con Drizzle
│   │   └── queries.ts   # Consultas reutilizables
│   ├── actions/         # Server Actions
│   ├── utils.ts         # Utilidades generales
│   └── validations.ts   # Schemas de validación (Zod)
├── types/               # Definiciones de TypeScript
├── .env.local          # Variables de entorno
├── drizzle.config.ts   # Configuración de Drizzle
├── package.json
└── tailwind.config.js
```

## 💾 Setup de Base de Datos

### 🔌 Configuración de Turso + Drizzle

```typescript
// lib/db/index.ts
import { drizzle } from 'drizzle-orm/libsql';
import { createClient } from '@libsql/client';
import * as schema from './schema';

const client = createClient({
  url: process.env.TURSO_DATABASE_URL!,
  authToken: process.env.TURSO_AUTH_TOKEN!,
});

export const db = drizzle(client, { schema });
```

### 📋 Schema con Drizzle ORM

```typescript
// lib/db/schema.ts
import { sqliteTable, integer, text, real, primaryKey } from 'drizzle-orm/sqlite-core';
import { relations } from 'drizzle-orm';

// Tabla de autores
export const autores = sqliteTable('autores', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  nombre: text('nombre').notNull(),
  nacionalidad: text('nacionalidad'),
  fechaNacimiento: text('fecha_nacimiento'), // SQLite date as text
  createdAt: text('created_at').default('CURRENT_TIMESTAMP'),
  updatedAt: text('updated_at').default('CURRENT_TIMESTAMP'),
});

// Tabla de géneros
export const generos = sqliteTable('generos', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  nombre: text('nombre').notNull().unique(),
  descripcion: text('descripcion'),
  createdAt: text('created_at').default('CURRENT_TIMESTAMP'),
});

// Tabla de libros
export const libros = sqliteTable('libros', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  titulo: text('titulo').notNull(),
  isbn: text('isbn').unique(),
  autorId: integer('autor_id').notNull().references(() => autores.id),
  generoId: integer('genero_id').references(() => generos.id),
  fechaPublicacion: text('fecha_publicacion'),
  paginas: integer('paginas'),
  disponible: integer('disponible', { mode: 'boolean' }).default(true),
  precioReposicion: real('precio_reposicion'),
  resumen: text('resumen'),
  imagenUrl: text('imagen_url'),
  createdAt: text('created_at').default('CURRENT_TIMESTAMP'),
  updatedAt: text('updated_at').default('CURRENT_TIMESTAMP'),
});

// Tabla de usuarios
export const usuarios = sqliteTable('usuarios', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  nombre: text('nombre').notNull(),
  email: text('email').notNull().unique(),
  telefono: text('telefono'),
  fechaNacimiento: text('fecha_nacimiento'),
  fechaRegistro: text('fecha_registro').default('CURRENT_DATE'),
  activo: integer('activo', { mode: 'boolean' }).default(true),
  multaAcumulada: real('multa_acumulada').default(0),
  createdAt: text('created_at').default('CURRENT_TIMESTAMP'),
  updatedAt: text('updated_at').default('CURRENT_TIMESTAMP'),
});

// Tabla de préstamos
export const prestamos = sqliteTable('prestamos', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  libroId: integer('libro_id').notNull().references(() => libros.id),
  usuarioId: integer('usuario_id').notNull().references(() => usuarios.id),
  fechaPrestamo: text('fecha_prestamo').default('CURRENT_DATE'),
  fechaDevolucionEsperada: text('fecha_devolucion_esperada').notNull(),
  fechaDevolucionReal: text('fecha_devolucion_real'),
  multa: real('multa').default(0),
  estado: text('estado', { 
    enum: ['activo', 'devuelto', 'vencido', 'perdido'] 
  }).default('activo'),
  observaciones: text('observaciones'),
  createdAt: text('created_at').default('CURRENT_TIMESTAMP'),
  updatedAt: text('updated_at').default('CURRENT_TIMESTAMP'),
});

// Relaciones para joins automáticos
export const librosRelations = relations(libros, ({ one, many }) => ({
  autor: one(autores, {
    fields: [libros.autorId],
    references: [autores.id],
  }),
  genero: one(generos, {
    fields: [libros.generoId], 
    references: [generos.id],
  }),
  prestamos: many(prestamos),
}));

export const prestamosRelations = relations(prestamos, ({ one }) => ({
  libro: one(libros, {
    fields: [prestamos.libroId],
    references: [libros.id],
  }),
  usuario: one(usuarios, {
    fields: [prestamos.usuarioId],
    references: [usuarios.id],
  }),
}));

// Tipos TypeScript inferidos automáticamente
export type Libro = typeof libros.$inferSelect;
export type NuevoLibro = typeof libros.$inferInsert;
export type Usuario = typeof usuarios.$inferSelect;
export type Prestamo = typeof prestamos.$inferSelect;
```

## ⚡ Server Actions: La Nueva Forma de Manejar Datos

### 📝 Server Actions para CRUD

```typescript
// lib/actions/libros.ts
'use server';

import { db } from '@/lib/db';
import { libros, autores, generos } from '@/lib/db/schema';
import { eq, desc, like, and, sql } from 'drizzle-orm';
import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';
import { z } from 'zod';

// Schema de validación con Zod
const LibroSchema = z.object({
  titulo: z.string().min(1, 'El título es requerido').max(200),
  isbn: z.string().regex(/^978-\d{10}$/, 'ISBN debe tener formato 978-XXXXXXXXXX').optional(),
  autorId: z.number().int().positive('Debe seleccionar un autor'),
  generoId: z.number().int().positive().optional(),
  fechaPublicacion: z.string().optional(),
  paginas: z.number().int().min(1).max(10000).optional(),
  precioReposicion: z.number().positive().optional(),
  resumen: z.string().optional(),
});

// Crear nuevo libro
export async function crearLibro(formData: FormData) {
  const validatedFields = LibroSchema.safeParse({
    titulo: formData.get('titulo'),
    isbn: formData.get('isbn'),
    autorId: Number(formData.get('autorId')),
    generoId: Number(formData.get('generoId')) || undefined,
    fechaPublicacion: formData.get('fechaPublicacion') || undefined,
    paginas: Number(formData.get('paginas')) || undefined,
    precioReposicion: Number(formData.get('precioReposicion')) || undefined,
    resumen: formData.get('resumen') || undefined,
  });

  if (!validatedFields.success) {
    return {
      errors: validatedFields.error.flatten().fieldErrors,
    };
  }

  const { data } = validatedFields;

  try {
    await db.insert(libros).values({
      titulo: data.titulo,
      isbn: data.isbn,
      autorId: data.autorId,
      generoId: data.generoId,
      fechaPublicacion: data.fechaPublicacion,
      paginas: data.paginas,
      precioReposicion: data.precioReposicion,
      resumen: data.resumen,
      updatedAt: new Date().toISOString(),
    });

    revalidatePath('/libros');
    redirect('/libros');
    
  } catch (error) {
    return {
      message: 'Error al crear el libro. Verifica que el ISBN no exista.',
    };
  }
}

// Actualizar libro
export async function actualizarLibro(id: number, formData: FormData) {
  const validatedFields = LibroSchema.safeParse({
    titulo: formData.get('titulo'),
    isbn: formData.get('isbn'),
    autorId: Number(formData.get('autorId')),
    generoId: Number(formData.get('generoId')) || undefined,
    fechaPublicacion: formData.get('fechaPublicacion') || undefined,
    paginas: Number(formData.get('paginas')) || undefined,
    precioReposicion: Number(formData.get('precioReposicion')) || undefined,
    resumen: formData.get('resumen') || undefined,
  });

  if (!validatedFields.success) {
    return {
      errors: validatedFields.error.flatten().fieldErrors,
    };
  }

  const { data } = validatedFields;

  try {
    await db
      .update(libros)
      .set({
        ...data,
        updatedAt: new Date().toISOString(),
      })
      .where(eq(libros.id, id));

    revalidatePath('/libros');
    revalidatePath(`/libros/${id}`);
    redirect('/libros');
    
  } catch (error) {
    return {
      message: 'Error al actualizar el libro.',
    };
  }
}

// Eliminar libro (soft delete)
export async function eliminarLibro(id: number) {
  try {
    // Verificar que no tenga préstamos activos
    const prestamosActivos = await db
      .select({ count: sql<number>`count(*)` })
      .from(prestamos)
      .where(and(
        eq(prestamos.libroId, id),
        eq(prestamos.estado, 'activo')
      ));

    if (prestamosActivos[0].count > 0) {
      return {
        message: 'No se puede eliminar un libro con préstamos activos.',
      };
    }

    await db
      .update(libros)
      .set({ 
        disponible: false,
        updatedAt: new Date().toISOString(),
      })
      .where(eq(libros.id, id));

    revalidatePath('/libros');
    
  } catch (error) {
    return {
      message: 'Error al eliminar el libro.',
    };
  }
}

// Buscar libros (para autocompletado y filtros)
export async function buscarLibros(query: string) {
  return await db
    .select({
      id: libros.id,
      titulo: libros.titulo,
      autor: autores.nombre,
      disponible: libros.disponible,
    })
    .from(libros)
    .leftJoin(autores, eq(libros.autorId, autores.id))
    .where(
      and(
        libros.disponible,
        like(libros.titulo, `%${query}%`)
      )
    )
    .limit(10);
}
```

## 🖥️ Server Components: Renderizado en el Servidor

### 📚 Página de Listado de Libros

```typescript
// app/(dashboard)/libros/page.tsx
import { db } from '@/lib/db';
import { libros, autores, generos } from '@/lib/db/schema';
import { eq, desc, like, and } from 'drizzle-orm';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { BuscarLibros } from '@/components/buscar-libros';
import { TarjetaLibro } from '@/components/tarjeta-libro';

interface Props {
  searchParams: {
    q?: string;
    genero?: string;
    autor?: string;
  };
}

// Server Component - se ejecuta en el servidor
export default async function LibrosPage({ searchParams }: Props) {
  // Consulta directa a la base de datos en el servidor
  const librosConDetalles = await db
    .select({
      id: libros.id,
      titulo: libros.titulo,
      isbn: libros.isbn,
      autor: autores.nombre,
      genero: generos.nombre,
      disponible: libros.disponible,
      fechaPublicacion: libros.fechaPublicacion,
      resumen: libros.resumen,
      imagenUrl: libros.imagenUrl,
    })
    .from(libros)
    .leftJoin(autores, eq(libros.autorId, autores.id))
    .leftJoin(generos, eq(libros.generoId, generos.id))
    .where(
      and(
        libros.disponible,
        searchParams.q ? like(libros.titulo, `%${searchParams.q}%`) : undefined,
        searchParams.genero ? eq(generos.id, Number(searchParams.genero)) : undefined,
        searchParams.autor ? eq(autores.id, Number(searchParams.autor)) : undefined
      )
    )
    .orderBy(desc(libros.createdAt));

  // Obtener géneros y autores para filtros
  const generosDisponibles = await db
    .select({ id: generos.id, nombre: generos.nombre })
    .from(generos)
    .orderBy(generos.nombre);

  const autoresDisponibles = await db
    .select({ id: autores.id, nombre: autores.nombre })
    .from(autores)
    .orderBy(autores.nombre);

  return (
    <div className="container mx-auto py-6 space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold">Biblioteca</h1>
          <p className="text-muted-foreground">
            Gestiona tu colección de libros
          </p>
        </div>
        <Button asChild>
          <Link href="/libros/nuevo">
            Agregar Libro
          </Link>
        </Button>
      </div>

      {/* Búsqueda y Filtros */}
      <BuscarLibros 
        generos={generosDisponibles}
        autores={autoresDisponibles}
        searchParams={searchParams}
      />

      {/* Resultados */}
      {librosConDetalles.length === 0 ? (
        <div className="text-center py-12">
          <h3 className="text-lg font-medium mb-2">No se encontraron libros</h3>
          <p className="text-muted-foreground mb-4">
            {searchParams.q ? 'Intenta con otros términos de búsqueda' : 'Comienza agregando tu primer libro'}
          </p>
          <Button asChild>
            <Link href="/libros/nuevo">Agregar Libro</Link>
          </Button>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {librosConDetalles.map((libro) => (
            <TarjetaLibro key={libro.id} libro={libro} />
          ))}
        </div>
      )}

      {/* Estadísticas */}
      <div className="border rounded-lg p-4 bg-muted/50">
        <p className="text-sm text-muted-foreground">
          Mostrando {librosConDetalles.length} libros
          {searchParams.q && ` para "${searchParams.q}"`}
        </p>
      </div>
    </div>
  );
}
```

### 📄 Página de Detalle de Libro

```typescript
// app/(dashboard)/libros/[id]/page.tsx
import { db } from '@/lib/db';
import { libros, autores, generos, prestamos } from '@/lib/db/schema';
import { eq, and, desc } from 'drizzle-orm';
import { notFound } from 'next/navigation';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { EliminarLibroButton } from '@/components/eliminar-libro-button';
import { HistorialPrestamos } from '@/components/historial-prestamos';

interface Props {
  params: { id: string };
}

export default async function LibroDetallePage({ params }: Props) {
  const libroId = Number(params.id);

  // Obtener libro con detalles
  const libro = await db
    .select({
      id: libros.id,
      titulo: libros.titulo,
      isbn: libros.isbn,
      autor: autores.nombre,
      autorId: libros.autorId,
      genero: generos.nombre,
      generoId: libros.generoId,
      fechaPublicacion: libros.fechaPublicacion,
      paginas: libros.paginas,
      disponible: libros.disponible,
      precioReposicion: libros.precioReposicion,
      resumen: libros.resumen,
      imagenUrl: libros.imagenUrl,
      createdAt: libros.createdAt,
      updatedAt: libros.updatedAt,
    })
    .from(libros)
    .leftJoin(autores, eq(libros.autorId, autores.id))
    .leftJoin(generos, eq(libros.generoId, generos.id))
    .where(eq(libros.id, libroId))
    .then(results => results[0]);

  if (!libro) {
    notFound();
  }

  // Obtener historial de préstamos
  const historialPrestamos = await db
    .select({
      id: prestamos.id,
      fechaPrestamo: prestamos.fechaPrestamo,
      fechaDevolucionEsperada: prestamos.fechaDevolucionEsperada,
      fechaDevolucionReal: prestamos.fechaDevolucionReal,
      estado: prestamos.estado,
      multa: prestamos.multa,
      usuario: {
        id: usuarios.id,
        nombre: usuarios.nombre,
        email: usuarios.email,
      },
    })
    .from(prestamos)
    .leftJoin(usuarios, eq(prestamos.usuarioId, usuarios.id))
    .where(eq(prestamos.libroId, libroId))
    .orderBy(desc(prestamos.createdAt))
    .limit(10);

  return (
    <div className="container mx-auto py-6 max-w-4xl">
      {/* Breadcrumb */}
      <nav className="mb-6">
        <Link 
          href="/libros" 
          className="text-muted-foreground hover:text-foreground transition-colors"
        >
          ← Volver a Libros
        </Link>
      </nav>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
        {/* Imagen del libro */}
        <div className="space-y-4">
          <div className="aspect-[3/4] bg-muted rounded-lg flex items-center justify-center">
            {libro.imagenUrl ? (
              <img
                src={libro.imagenUrl}
                alt={libro.titulo}
                className="w-full h-full object-cover rounded-lg"
              />
            ) : (
              <div className="text-muted-foreground text-center p-4">
                <BookIcon className="h-16 w-16 mx-auto mb-2" />
                <p className="text-sm">Sin imagen</p>
              </div>
            )}
          </div>
          
          <div className="flex gap-2">
            <Button asChild className="flex-1">
              <Link href={`/libros/${libro.id}/editar`}>
                Editar
              </Link>
            </Button>
            <EliminarLibroButton libroId={libro.id} />
          </div>
        </div>

        {/* Detalles del libro */}
        <div className="md:col-span-2 space-y-6">
          <div>
            <div className="flex items-center gap-3 mb-2">
              <h1 className="text-3xl font-bold">{libro.titulo}</h1>
              <Badge variant={libro.disponible ? 'default' : 'secondary'}>
                {libro.disponible ? 'Disponible' : 'No disponible'}
              </Badge>
            </div>
            
            {libro.autor && (
              <p className="text-xl text-muted-foreground">
                por {libro.autor}
              </p>
            )}
          </div>

          {/* Información básica */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            {libro.isbn && (
              <div>
                <dt className="font-medium text-muted-foreground">ISBN</dt>
                <dd className="font-mono">{libro.isbn}</dd>
              </div>
            )}
            
            {libro.genero && (
              <div>
                <dt className="font-medium text-muted-foreground">Género</dt>
                <dd>{libro.genero}</dd>
              </div>
            )}
            
            {libro.fechaPublicacion && (
              <div>
                <dt className="font-medium text-muted-foreground">Publicación</dt>
                <dd>{new Date(libro.fechaPublicacion).getFullYear()}</dd>
              </div>
            )}
            
            {libro.paginas && (
              <div>
                <dt className="font-medium text-muted-foreground">Páginas</dt>
                <dd>{libro.paginas}</dd>
              </div>
            )}
            
            {libro.precioReposicion && (
              <div>
                <dt className="font-medium text-muted-foreground">Precio de reposición</dt>
                <dd>${libro.precioReposicion.toLocaleString()}</dd>
              </div>
            )}
          </div>

          {/* Resumen */}
          {libro.resumen && (
            <div>
              <h3 className="font-medium mb-2">Resumen</h3>
              <p className="text-muted-foreground leading-relaxed">
                {libro.resumen}
              </p>
            </div>
          )}

          {/* Acciones rápidas */}
          <div className="flex gap-2">
            <Button asChild>
              <Link href={`/prestamos/nuevo?libro=${libro.id}`}>
                Crear Préstamo
              </Link>
            </Button>
            <Button variant="outline" asChild>
              <Link href={`/libros?autor=${libro.autorId}`}>
                Ver más de {libro.autor}
              </Link>
            </Button>
          </div>
        </div>
      </div>

      {/* Historial de préstamos */}
      {historialPrestamos.length > 0 && (
        <div className="mt-12">
          <h2 className="text-2xl font-bold mb-6">Historial de Préstamos</h2>
          <HistorialPrestamos prestamos={historialPrestamos} />
        </div>
      )}
    </div>
  );
}

// Metadata dinámica para SEO
export async function generateMetadata({ params }: Props) {
  const libroId = Number(params.id);
  
  const libro = await db
    .select({ titulo: libros.titulo, autor: autores.nombre })
    .from(libros)
    .leftJoin(autores, eq(libros.autorId, autores.id))
    .where(eq(libros.id, libroId))
    .then(results => results[0]);

  return {
    title: libro ? `${libro.titulo} - Biblioteca` : 'Libro no encontrado',
    description: libro ? `${libro.titulo} por ${libro.autor}` : 'El libro solicitado no existe',
  };
}
```

## 📝 Formularios Interactivos con Server Actions

### 📖 Formulario de Crear/Editar Libro

```typescript
// app/(dashboard)/libros/nuevo/page.tsx
import { db } from '@/lib/db';
import { autores, generos } from '@/lib/db/schema';
import { FormularioLibro } from '@/components/forms/formulario-libro';

export default async function NuevoLibroPage() {
  // Cargar datos necesarios para el formulario
  const [autoresData, generosData] = await Promise.all([
    db.select({ id: autores.id, nombre: autores.nombre })
      .from(autores)
      .orderBy(autores.nombre),
      
    db.select({ id: generos.id, nombre: generos.nombre })
      .from(generos)
      .orderBy(generos.nombre)
  ]);

  return (
    <div className="container mx-auto py-6 max-w-2xl">
      <div className="mb-6">
        <h1 className="text-3xl font-bold">Agregar Nuevo Libro</h1>
        <p className="text-muted-foreground">
          Completa la información del libro para agregarlo a la biblioteca
        </p>
      </div>

      <FormularioLibro 
        autores={autoresData}
        generos={generosData}
        modo="crear"
      />
    </div>
  );
}
```

```typescript
// components/forms/formulario-libro.tsx
'use client';

import { useFormState } from 'react-dom';
import { crearLibro, actualizarLibro } from '@/lib/actions/libros';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';

interface Props {
  autores: Array<{ id: number; nombre: string }>;
  generos: Array<{ id: number; nombre: string }>;
  modo: 'crear' | 'editar';
  libroInicial?: {
    id: number;
    titulo: string;
    isbn?: string;
    autorId: number;
    generoId?: number;
    fechaPublicacion?: string;
    paginas?: number;
    precioReposicion?: number;
    resumen?: string;
  };
}

export function FormularioLibro({ autores, generos, modo, libroInicial }: Props) {
  const action = modo === 'crear' 
    ? crearLibro 
    : actualizarLibro.bind(null, libroInicial!.id);
    
  const [state, formAction] = useFormState(action, { errors: {} });

  return (
    <form action={formAction} className="space-y-6">
      {/* Campo Título */}
      <div className="space-y-2">
        <Label htmlFor="titulo">Título *</Label>
        <Input
          id="titulo"
          name="titulo"
          defaultValue={libroInicial?.titulo}
          className={state.errors?.titulo ? 'border-destructive' : ''}
          placeholder="Ej: Cien años de soledad"
        />
        {state.errors?.titulo && (
          <p className="text-sm text-destructive">{state.errors.titulo[0]}</p>
        )}
      </div>

      {/* Campo ISBN */}
      <div className="space-y-2">
        <Label htmlFor="isbn">ISBN</Label>
        <Input
          id="isbn"
          name="isbn"
          defaultValue={libroInicial?.isbn}
          className={state.errors?.isbn ? 'border-destructive' : ''}
          placeholder="978-XXXXXXXXXX"
          pattern="978-\d{10}"
        />
        {state.errors?.isbn && (
          <p className="text-sm text-destructive">{state.errors.isbn[0]}</p>
        )}
        <p className="text-sm text-muted-foreground">
          Formato: 978-XXXXXXXXXX (opcional)
        </p>
      </div>

      {/* Selección de Autor */}
      <div className="space-y-2">
        <Label htmlFor="autorId">Autor *</Label>
        <select
          id="autorId"
          name="autorId"
          defaultValue={libroInicial?.autorId}
          className={`w-full px-3 py-2 border rounded-md ${
            state.errors?.autorId ? 'border-destructive' : 'border-input'
          }`}
        >
          <option value="">Selecciona un autor</option>
          {autores.map((autor) => (
            <option key={autor.id} value={autor.id}>
              {autor.nombre}
            </option>
          ))}
        </select>
        {state.errors?.autorId && (
          <p className="text-sm text-destructive">{state.errors.autorId[0]}</p>
        )}
      </div>

      {/* Selección de Género */}
      <div className="space-y-2">
        <Label htmlFor="generoId">Género</Label>
        <select
          id="generoId"
          name="generoId"
          defaultValue={libroInicial?.generoId}
          className="w-full px-3 py-2 border rounded-md border-input"
        >
          <option value="">Selecciona un género (opcional)</option>
          {generos.map((genero) => (
            <option key={genero.id} value={genero.id}>
              {genero.nombre}
            </option>
          ))}
        </select>
      </div>

      {/* Grid de campos numéricos */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {/* Fecha de Publicación */}
        <div className="space-y-2">
          <Label htmlFor="fechaPublicacion">Fecha de Publicación</Label>
          <Input
            id="fechaPublicacion"
            name="fechaPublicacion"
            type="date"
            defaultValue={libroInicial?.fechaPublicacion}
          />
        </div>

        {/* Páginas */}
        <div className="space-y-2">
          <Label htmlFor="paginas">Páginas</Label>
          <Input
            id="paginas"
            name="paginas"
            type="number"
            min="1"
            max="10000"
            defaultValue={libroInicial?.paginas}
            className={state.errors?.paginas ? 'border-destructive' : ''}
          />
          {state.errors?.paginas && (
            <p className="text-sm text-destructive">{state.errors.paginas[0]}</p>
          )}
        </div>

        {/* Precio de Reposición */}
        <div className="space-y-2">
          <Label htmlFor="precioReposicion">Precio de Reposición</Label>
          <Input
            id="precioReposicion"
            name="precioReposicion"
            type="number"
            min="0"
            step="0.01"
            defaultValue={libroInicial?.precioReposicion}
            placeholder="0.00"
          />
        </div>
      </div>

      {/* Resumen */}
      <div className="space-y-2">
        <Label htmlFor="resumen">Resumen</Label>
        <Textarea
          id="resumen"
          name="resumen"
          defaultValue={libroInicial?.resumen}
          rows={4}
          placeholder="Descripción breve del libro..."
        />
      </div>

      {/* Mensaje de error general */}
      {state.message && (
        <div className="p-4 border border-destructive/20 bg-destructive/10 text-destructive rounded-md">
          <p className="text-sm">{state.message}</p>
        </div>
      )}

      {/* Botones de acción */}
      <div className="flex justify-end gap-3 pt-6">
        <Button type="button" variant="outline" onClick={() => history.back()}>
          Cancelar
        </Button>
        <Button type="submit">
          {modo === 'crear' ? 'Crear Libro' : 'Actualizar Libro'}
        </Button>
      </div>
    </form>
  );
}
```

## 🎨 Componentes Reutilizables

### 🃏 Tarjeta de Libro

```typescript
// components/tarjeta-libro.tsx
import Link from 'next/link';
import { Badge } from '@/components/ui/badge';
import { BookOpenIcon } from '@heroicons/react/24/outline';

interface Props {
  libro: {
    id: number;
    titulo: string;
    autor?: string | null;
    genero?: string | null;
    disponible: boolean;
    fechaPublicacion?: string | null;
    resumen?: string | null;
    imagenUrl?: string | null;
  };
}

export function TarjetaLibro({ libro }: Props) {
  return (
    <Link href={`/libros/${libro.id}`} className="group">
      <div className="border rounded-lg overflow-hidden hover:shadow-lg transition-shadow duration-200">
        {/* Imagen */}
        <div className="aspect-[3/4] bg-muted flex items-center justify-center overflow-hidden">
          {libro.imagenUrl ? (
            <img
              src={libro.imagenUrl}
              alt={libro.titulo}
              className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-200"
            />
          ) : (
            <BookOpenIcon className="h-16 w-16 text-muted-foreground" />
          )}
        </div>
        
        {/* Contenido */}
        <div className="p-4 space-y-2">
          {/* Título */}
          <h3 className="font-semibold line-clamp-2 group-hover:text-primary transition-colors">
            {libro.titulo}
          </h3>
          
          {/* Autor */}
          {libro.autor && (
            <p className="text-sm text-muted-foreground">
              por {libro.autor}
            </p>
          )}
          
          {/* Badges */}
          <div className="flex items-center gap-2 flex-wrap">
            <Badge variant={libro.disponible ? 'default' : 'secondary'}>
              {libro.disponible ? 'Disponible' : 'No disponible'}
            </Badge>
            
            {libro.genero && (
              <Badge variant="outline">
                {libro.genero}
              </Badge>
            )}
          </div>
          
          {/* Resumen truncado */}
          {libro.resumen && (
            <p className="text-xs text-muted-foreground line-clamp-2">
              {libro.resumen}
            </p>
          )}
          
          {/* Fecha de publicación */}
          {libro.fechaPublicacion && (
            <p className="text-xs text-muted-foreground">
              {new Date(libro.fechaPublicacion).getFullYear()}
            </p>
          )}
        </div>
      </div>
    </Link>
  );
}
```

## 📊 Dashboard con Datos en Tiempo Real

### 📈 Página Principal del Dashboard

```typescript
// app/(dashboard)/page.tsx
import { db } from '@/lib/db';
import { libros, usuarios, prestamos } from '@/lib/db/schema';
import { sql, eq, and, gte } from 'drizzle-orm';
import { MetricaCard } from '@/components/dashboard/metrica-card';
import { GraficoRecentActivity } from '@/components/dashboard/grafico-actividad';
import { LibrosRecientes } from '@/components/dashboard/libros-recientes';
import { PrestamosPendientes } from '@/components/dashboard/prestamos-pendientes';

export default async function DashboardPage() {
  // Métricas principales (queries en paralelo)
  const [
    totalLibros,
    librosDisponibles,
    totalUsuarios,
    prestamosActivos,
    prestamosVencidos,
    actividadReciente
  ] = await Promise.all([
    // Total de libros
    db.select({ count: sql<number>`count(*)` })
      .from(libros)
      .where(eq(libros.disponible, true)),
      
    // Libros disponibles para préstamo
    db.select({ count: sql<number>`count(*)` })
      .from(libros)
      .leftJoin(prestamos, and(
        eq(libros.id, prestamos.libroId),
        eq(prestamos.estado, 'activo')
      ))
      .where(and(
        eq(libros.disponible, true),
        sql`${prestamos.id} IS NULL`
      )),
      
    // Total de usuarios activos
    db.select({ count: sql<number>`count(*)` })
      .from(usuarios)
      .where(eq(usuarios.activo, true)),
      
    // Préstamos activos
    db.select({ count: sql<number>`count(*)` })
      .from(prestamos)
      .where(eq(prestamos.estado, 'activo')),
      
    // Préstamos vencidos
    db.select({ count: sql<number>`count(*)` })
      .from(prestamos)
      .where(and(
        eq(prestamos.estado, 'activo'),
        sql`DATE(${prestamos.fechaDevolucionEsperada}) < DATE('now')`
      )),
      
    // Actividad reciente (últimos 7 días)
    db.select({
      fecha: sql<string>`DATE(${prestamos.fechaPrestamo})`,
      prestamos: sql<number>`count(*)`,
    })
    .from(prestamos)
    .where(gte(prestamos.fechaPrestamo, sql`DATE('now', '-7 days')`))
    .groupBy(sql`DATE(${prestamos.fechaPrestamo})`)
    .orderBy(sql`DATE(${prestamos.fechaPrestamo})`)
  ]);

  // Libros agregados recientemente
  const librosRecientes = await db
    .select({
      id: libros.id,
      titulo: libros.titulo,
      autor: autores.nombre,
      createdAt: libros.createdAt,
    })
    .from(libros)
    .leftJoin(autores, eq(libros.autorId, autores.id))
    .where(eq(libros.disponible, true))
    .orderBy(sql`${libros.createdAt} DESC`)
    .limit(5);

  // Préstamos que vencen pronto
  const prestamosPorVencer = await db
    .select({
      id: prestamos.id,
      fechaDevolucionEsperada: prestamos.fechaDevolucionEsperada,
      libro: libros.titulo,
      usuario: usuarios.nombre,
      diasRestantes: sql<number>`
        JULIANDAY(${prestamos.fechaDevolucionEsperada}) - JULIANDAY('now')
      `,
    })
    .from(prestamos)
    .leftJoin(libros, eq(prestamos.libroId, libros.id))
    .leftJoin(usuarios, eq(prestamos.usuarioId, usuarios.id))
    .where(and(
      eq(prestamos.estado, 'activo'),
      sql`JULIANDAY(${prestamos.fechaDevolucionEsperada}) - JULIANDAY('now') <= 3`
    ))
    .orderBy(prestamos.fechaDevolucionEsperada)
    .limit(10);

  return (
    <div className="container mx-auto py-6 space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-bold">Dashboard de Biblioteca</h1>
        <p className="text-muted-foreground">
          Resumen general del estado de tu biblioteca
        </p>
      </div>

      {/* Métricas principales */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
        <MetricaCard
          titulo="Total Libros"
          valor={totalLibros[0].count}
          icono="📚"
          descripcion="En la biblioteca"
        />
        
        <MetricaCard
          titulo="Disponibles"
          valor={librosDisponibles[0].count}
          icono="✅"
          descripcion="Para préstamo"
          color="green"
        />
        
        <MetricaCard
          titulo="Usuarios"
          valor={totalUsuarios[0].count}
          icono="👥"
          descripcion="Activos"
        />
        
        <MetricaCard
          titulo="Préstamos"
          valor={prestamosActivos[0].count}
          icono="📖"
          descripcion="Activos"
          color="blue"
        />
        
        <MetricaCard
          titulo="Vencidos"
          valor={prestamosVencidos[0].count}
          icono="⚠️"
          descripcion="Requieren atención"
          color="red"
        />
      </div>

      {/* Gráficos y listas */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Actividad reciente */}
        <div className="border rounded-lg p-6">
          <h2 className="text-xl font-semibold mb-4">Actividad de la Semana</h2>
          <GraficoRecentActivity data={actividadReciente} />
        </div>

        {/* Préstamos por vencer */}
        <div className="border rounded-lg p-6">
          <h2 className="text-xl font-semibold mb-4">Próximos a Vencer</h2>
          <PrestamosPendientes prestamos={prestamosPorVencer} />
        </div>
      </div>

      {/* Libros recientes */}
      <div className="border rounded-lg p-6">
        <h2 className="text-xl font-semibold mb-4">Libros Agregados Recientemente</h2>
        <LibrosRecientes libros={librosRecientes} />
      </div>
    </div>
  );
}
```

## 🎯 Performance y Optimización

### ⚡ Técnicas de Optimización

```typescript
// lib/queries.ts - Queries optimizadas y reutilizables
import { db } from '@/lib/db';
import { libros, autores, generos, prestamos, usuarios } from '@/lib/db/schema';
import { eq, and, desc, sql, like } from 'drizzle-orm';
import { unstable_cache } from 'next/cache';

// Cache de datos que cambian poco
export const getGenerosCache = unstable_cache(
  async () => {
    return db.select().from(generos).orderBy(generos.nombre);
  },
  ['generos'],
  { revalidate: 3600 } // 1 hora
);

export const getAutoresCache = unstable_cache(
  async () => {
    return db.select().from(autores).orderBy(autores.nombre);
  },
  ['autores'],
  { revalidate: 3600 }
);

// Query optimizada para listado de libros con paginación
export async function getLibrosPaginados(
  page: number = 1, 
  limit: number = 20,
  filters?: {
    q?: string;
    genero?: number;
    autor?: number;
  }
) {
  const offset = (page - 1) * limit;
  
  const whereConditions = [
    eq(libros.disponible, true),
    filters?.q ? like(libros.titulo, `%${filters.q}%`) : undefined,
    filters?.genero ? eq(libros.generoId, filters.genero) : undefined,
    filters?.autor ? eq(libros.autorId, filters.autor) : undefined,
  ].filter(Boolean);

  const [items, total] = await Promise.all([
    // Items de la página
    db.select({
      id: libros.id,
      titulo: libros.titulo,
      isbn: libros.isbn,
      autor: autores.nombre,
      genero: generos.nombre,
      disponible: libros.disponible,
      fechaPublicacion: libros.fechaPublicacion,
      resumen: libros.resumen,
      imagenUrl: libros.imagenUrl,
    })
    .from(libros)
    .leftJoin(autores, eq(libros.autorId, autores.id))
    .leftJoin(generos, eq(libros.generoId, generos.id))
    .where(and(...whereConditions))
    .orderBy(desc(libros.createdAt))
    .limit(limit)
    .offset(offset),
    
    // Total de items para paginación
    db.select({ count: sql<number>`count(*)` })
      .from(libros)
      .leftJoin(autores, eq(libros.autorId, autores.id))
      .leftJoin(generos, eq(libros.generoId, generos.id))
      .where(and(...whereConditions))
  ]);

  return {
    items,
    pagination: {
      page,
      limit,
      total: total[0].count,
      totalPages: Math.ceil(total[0].count / limit),
      hasNext: page < Math.ceil(total[0].count / limit),
      hasPrev: page > 1,
    }
  };
}

// Query para estadísticas del dashboard con cache
export const getDashboardStats = unstable_cache(
  async () => {
    const [
      librosStats,
      usuariosStats,
      prestamosStats
    ] = await Promise.all([
      db.select({
        total: sql<number>`count(*)`,
        disponibles: sql<number>`sum(case when ${libros.disponible} then 1 else 0 end)`,
      }).from(libros),
      
      db.select({
        total: sql<number>`count(*)`,
        activos: sql<number>`sum(case when ${usuarios.activo} then 1 else 0 end)`,
      }).from(usuarios),
      
      db.select({
        activos: sql<number>`sum(case when ${prestamos.estado} = 'activo' then 1 else 0 end)`,
        vencidos: sql<number>`
          sum(case when ${prestamos.estado} = 'activo' 
              and date(${prestamos.fechaDevolucionEsperada}) < date('now') 
              then 1 else 0 end)
        `,
      }).from(prestamos),
    ]);

    return {
      libros: librosStats[0],
      usuarios: usuariosStats[0], 
      prestamos: prestamosStats[0],
    };
  },
  ['dashboard-stats'],
  { revalidate: 300 } // 5 minutos
);
```

## 🚀 Próxima Clase: ORMs Avanzados

En la siguiente clase profundizaremos en:
- **Prisma vs Drizzle** comparación detallada
- **Migrations avanzadas** y versionado
- **Relationships complejas** y consultas optimizadas
- **Integración con TypeScript** para mayor seguridad

---

## 📋 Resumen

1. **Next.js Full-Stack**: App Router + Server Components + Server Actions
2. **Type-Safe**: Drizzle ORM + TypeScript para desarrollo seguro
3. **Modern Patterns**: Sin APIs REST separadas, todo integrado
4. **Performance**: Caching, optimistic updates, consultas eficientes  
5. **DX**: Excelente experiencia de desarrollo con herramientas modernas

**¡Ahora Rafa puede crear aplicaciones full-stack modernas de nivel profesional! 🚀**