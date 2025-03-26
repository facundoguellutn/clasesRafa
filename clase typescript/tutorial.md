# Tutorial de TypeScript con React 🚀

## ¿Qué es TypeScript?

TypeScript es un superset de JavaScript que añade tipado estático opcional a la programación. Fue desarrollado por Microsoft y es especialmente útil para proyectos grandes y complejos.

### ¿Por qué usar TypeScript?

1. **Detección temprana de errores**: Encuentra errores antes de ejecutar el código
2. **Mejor autocompletado**: Los IDEs proporcionan mejor sugerencias
3. **Documentación integrada**: Los tipos sirven como documentación
4. **Mantenibilidad**: Código más fácil de mantener y refactorizar

## Conceptos Básicos

### Tipos Básicos

```typescript
// Tipos primitivos
let nombre: string = "Juan";
let edad: number = 25;
let esActivo: boolean = true;
let lista: string[] = ["item1", "item2"];
let tupla: [string, number] = ["hola", 42];

// Tipos especiales
let nulo: null = null;
let indefinido: undefined = undefined;
let cualquier: any = "cualquier cosa"; // Evitar usar any
```

### Interfaces

```typescript
interface Usuario {
  id: number;
  nombre: string;
  email: string;
  edad?: number; // Opcional
}

const usuario: Usuario = {
  id: 1,
  nombre: "Juan",
  email: "juan@ejemplo.com"
};
```

### Types

```typescript
type Direccion = {
  calle: string;
  numero: number;
  ciudad: string;
};

type Persona = {
  nombre: string;
  direccion: Direccion;
};
```

### Genéricos

```typescript
function obtenerPrimerElemento<T>(array: T[]): T {
  return array[0];
}

const numeros = [1, 2, 3];
const primerNumero = obtenerPrimerElemento<number>(numeros);

const strings = ["a", "b", "c"];
const primerString = obtenerPrimerElemento<string>(strings);
```

## TypeScript con React

### Componentes Funcionales

```typescript
interface Props {
  nombre: string;
  edad?: number;
}

const MiComponente: React.FC<Props> = ({ nombre, edad }) => {
  return <div>Hola {nombre}</div>;
};
```

### useState con TypeScript

```typescript
interface Estado {
  contador: number;
  texto: string;
}

const [estado, setEstado] = useState<Estado>({
  contador: 0,
  texto: ""
});
```

### Eventos de Formularios

```typescript
const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
  e.preventDefault();
};

const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
  setEstado(e.target.value);
};

const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => {
  // Manejar click
};
```

### useRef con TypeScript

```typescript
const inputRef = useRef<HTMLInputElement>(null);
```

### useEffect con TypeScript

```typescript
useEffect(() => {
  // Código aquí
}, [dependencias]);
```

## Ejercicios Prácticos

### Ejercicio 1: Formulario Tipado
Crea un formulario de registro con los siguientes campos:
- Nombre (string)
- Email (string)
- Edad (number)
- Contraseña (string)
- Aceptar términos (boolean)

Tipar el estado y los manejadores de eventos.

### Ejercicio 2: Lista de Tareas
Crea una aplicación de lista de tareas donde:
- Cada tarea tenga un id (number), título (string), completada (boolean)
- Implementa funciones para agregar, eliminar y marcar como completada
- Usa interfaces para tipar las tareas
- Implementa un filtro por estado (completadas/pendientes)

### Ejercicio 3: API Call
Crea una función que haga una llamada a una API y maneje la respuesta tipada:

```typescript
interface Post {
  id: number;
  title: string;
  body: string;
  userId: number;
}

const fetchPosts = async (): Promise<Post[]> => {
  const response = await fetch('https://jsonplaceholder.typicode.com/posts');
  return response.json();
};
```

## Mejores Prácticas

1. **Evitar `any`**: Usa tipos específicos siempre que sea posible
2. **Interfaces vs Types**:
   - Usa interfaces para objetos que pueden ser extendidos
   - Usa types para uniones, intersecciones o tipos primitivos
3. **Tipos estrictos**: Habilita `strict: true` en tsconfig.json
4. **Componentes reutilizables**: Usa genéricos para componentes flexibles
5. **Props opcionales**: Marca props opcionales con `?`

## Recursos Adicionales

- [Documentación oficial de TypeScript](https://www.typescriptlang.org/docs/)
- [TypeScript con React](https://www.typescriptlang.org/docs/handbook/react.html)
- [React TypeScript Cheatsheet](https://github.com/typescript-cheatsheets/react) 