# Tutorial de Zod con React

## Introducción a Zod

Zod es una biblioteca de validación de esquemas para TypeScript que permite definir y validar datos de manera segura y declarativa. Es especialmente útil en aplicaciones React para validar formularios, props, y datos de API.

## Instalación

```bash
npm install zod
```

## Conceptos Básicos

### 1. Definición de Esquemas

```typescript
import { z } from 'zod';

// Esquema básico
const userSchema = z.object({
  name: z.string(),
  age: z.number(),
  email: z.string().email(),
  isActive: z.boolean()
});
```

### 2. Validación de Datos

```typescript
const data = {
  name: "Juan",
  age: 25,
  email: "juan@example.com",
  isActive: true
};

try {
  const validatedData = userSchema.parse(data);
  console.log(validatedData);
} catch (error) {
  console.error(error.errors);
}
```

### 3. Uso de safeParse

`safeParse` es una alternativa más segura a `parse` que no lanza excepciones. En su lugar, devuelve un objeto con la información del resultado de la validación. Esto es especialmente útil cuando no queremos manejar excepciones o cuando necesitamos más control sobre el flujo de la validación.

```typescript
const result = userSchema.safeParse(data);

if (result.success) {
  // Los datos son válidos
  console.log(result.data);
} else {
  // Los datos son inválidos
  console.log(result.error.errors);
}
```

Un ejemplo más completo con React:

```typescript
import { useState } from 'react';
import { z } from 'zod';

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6)
});

function LoginForm() {
  const [formData, setFormData] = useState({
    email: '',
    password: ''
  });
  const [errors, setErrors] = useState<Record<string, string>>({});

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    const result = loginSchema.safeParse(formData);
    
    if (!result.success) {
      // Mapear los errores a un formato más amigable
      const newErrors: Record<string, string> = {};
      result.error.errors.forEach((err) => {
        if (err.path) {
          newErrors[err.path[0]] = err.message;
        }
      });
      setErrors(newErrors);
      return;
    }
    
    // Los datos son válidos, proceder con el login
    console.log('Datos válidos:', result.data);
    // Aquí iría la lógica de autenticación
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>Email:</label>
        <input
          type="email"
          value={formData.email}
          onChange={(e) => setFormData({...formData, email: e.target.value})}
        />
        {errors.email && <span className="error">{errors.email}</span>}
      </div>
      <div>
        <label>Password:</label>
        <input
          type="password"
          value={formData.password}
          onChange={(e) => setFormData({...formData, password: e.target.value})}
        />
        {errors.password && <span className="error">{errors.password}</span>}
      </div>
      <button type="submit">Login</button>
    </form>
  );
}
```

Ventajas de usar `safeParse`:

1. **Control de Flujo**: No interrumpe la ejecución del programa con excepciones.
2. **Tipado Seguro**: TypeScript puede inferir correctamente el tipo del resultado.
3. **Manejo Predictivo**: Siempre devuelve un objeto con una estructura conocida.
4. **Mejor para Validaciones en Tiempo Real**: Ideal para validaciones mientras el usuario escribe.

## Uso con React

### 1. Validación de Formularios

```typescript
import { useState } from 'react';
import { z } from 'zod';

const formSchema = z.object({
  username: z.string().min(3),
  password: z.string().min(6),
  email: z.string().email()
});

function LoginForm() {
  const [formData, setFormData] = useState({
    username: '',
    password: '',
    email: ''
  });
  const [errors, setErrors] = useState<Record<string, string>>({});

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const validatedData = formSchema.parse(formData);
      // Procesar datos válidos
      console.log(validatedData);
    } catch (error) {
      if (error instanceof z.ZodError) {
        const newErrors: Record<string, string> = {};
        error.errors.forEach((err) => {
          if (err.path) {
            newErrors[err.path[0]] = err.message;
          }
        });
        setErrors(newErrors);
      }
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>Username:</label>
        <input
          type="text"
          value={formData.username}
          onChange={(e) => setFormData({...formData, username: e.target.value})}
        />
        {errors.username && <span>{errors.username}</span>}
      </div>
      {/* Más campos del formulario */}
      <button type="submit">Submit</button>
    </form>
  );
}
```

### 2. Validación de Props

```typescript
import { z } from 'zod';

const userPropsSchema = z.object({
  name: z.string(),
  age: z.number().min(18),
  role: z.enum(['admin', 'user', 'guest'])
});

type UserProps = z.infer<typeof userPropsSchema>;

function UserProfile({ name, age, role }: UserProps) {
  return (
    <div>
      <h1>{name}</h1>
      <p>Age: {age}</p>
      <p>Role: {role}</p>
    </div>
  );
}
```

## Características Avanzadas

### 1. Transformación de Datos

```typescript
const numberSchema = z.string().transform((val) => parseInt(val, 10));

const result = numberSchema.parse("42"); // 42 (number)
```

### 2. Validación Personalizada

```typescript
const passwordSchema = z.string()
  .min(8)
  .refine((val) => /[A-Z]/.test(val), {
    message: "Password must contain at least one uppercase letter"
  })
  .refine((val) => /[0-9]/.test(val), {
    message: "Password must contain at least one number"
  });
```

### 3. Validación de Arrays y Objetos Anidados

```typescript
const addressSchema = z.object({
  street: z.string(),
  city: z.string(),
  zipCode: z.string()
});

const userWithAddressSchema = z.object({
  name: z.string(),
  addresses: z.array(addressSchema)
});
```

## Ejercicios

### Ejercicio 1: Validación de Formulario de Registro

Crea un formulario de registro con los siguientes campos:
- Nombre completo (mínimo 3 caracteres)
- Email (formato válido)
- Contraseña (mínimo 8 caracteres, una mayúscula y un número)
- Confirmación de contraseña (debe coincidir con la contraseña)

```typescript
// Solución
const registrationSchema = z.object({
  fullName: z.string().min(3),
  email: z.string().email(),
  password: z.string()
    .min(8)
    .refine((val) => /[A-Z]/.test(val), {
      message: "Password must contain at least one uppercase letter"
    })
    .refine((val) => /[0-9]/.test(val), {
      message: "Password must contain at least one number"
    }),
  confirmPassword: z.string()
}).refine((data) => data.password === data.confirmPassword, {
  message: "Passwords don't match",
  path: ["confirmPassword"]
});
```

### Ejercicio 2: Validación de Producto

Crea un esquema para validar un producto con:
- ID (string o número)
- Nombre (string)
- Precio (número positivo)
- Categoría (enum: 'electronics', 'clothing', 'food')
- Stock (número entero no negativo)
- Tags (array de strings)

```typescript
// Solución
const productSchema = z.object({
  id: z.union([z.string(), z.number()]),
  name: z.string(),
  price: z.number().positive(),
  category: z.enum(['electronics', 'clothing', 'food']),
  stock: z.number().int().nonnegative(),
  tags: z.array(z.string())
});
```

## Mejores Prácticas

1. **Reutilización de Esquemas**: Crea esquemas base y extiéndelos según sea necesario.
2. **Mensajes de Error Personalizados**: Proporciona mensajes de error claros y descriptivos.
3. **Validación Temprana**: Valida los datos tan pronto como sea posible.
4. **Tipos Inferidos**: Utiliza `z.infer<typeof schema>` para obtener tipos TypeScript.
5. **Transformación de Datos**: Usa transformaciones para convertir datos cuando sea necesario.

## Recursos Adicionales

- [Documentación Oficial de Zod](https://zod.dev/)
- [Ejemplos de Zod con React](https://github.com/colinhacks/zod#examples)
- [Zod con Formik](https://formik.org/docs/guides/validation#validation-schema)
- [Zod con React Hook Form](https://react-hook-form.com/get-started#SchemaValidation)

## Conclusión

Zod es una herramienta poderosa para la validación de datos en aplicaciones React. Su integración con TypeScript y su API intuitiva lo hacen ideal para garantizar la integridad de los datos en tu aplicación. Con este tutorial, deberías tener una base sólida para comenzar a usar Zod en tus proyectos React.
