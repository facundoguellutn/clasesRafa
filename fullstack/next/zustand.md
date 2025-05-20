# Tutorial de Zustand en React

## ¿Qué es Zustand?

Zustand es una biblioteca de gestión de estado para React que se caracteriza por su simplicidad y minimalismo. A diferencia de Redux, que puede ser más complejo y verboso, Zustand ofrece una API más sencilla y directa para manejar el estado global de tu aplicación.

## Ventajas de Zustand

- 🚀 Ligero y rápido
- 📦 Bundle size pequeño (~1KB)
- 🔧 API simple y directa
- ⚡ No requiere providers o wrappers
- 🔄 Compatible con React concurrent features
- 🛠 Herramientas de desarrollo incluidas

## Instalación

```bash
# Usando npm
npm install zustand

# Usando yarn
yarn add zustand

# Usando pnpm
pnpm add zustand
```

## Uso Básico

### 1. Crear un Store

```typescript
import create from 'zustand'

interface BearState {
  bears: number
  increase: () => void
  decrease: () => void
}

const useStore = create<BearState>((set) => ({
  bears: 0,
  increase: () => set((state) => ({ bears: state.bears + 1 })),
  decrease: () => set((state) => ({ bears: state.bears - 1 })),
}))
```

### 2. Usar el Store en Componentes

```typescript
function BearCounter() {
  const bears = useStore((state) => state.bears)
  return <h1>{bears} osos alrededor!</h1>
}

function Controls() {
  const increase = useStore((state) => state.increase)
  const decrease = useStore((state) => state.decrease)
  
  return (
    <div>
      <button onClick={increase}>Añadir oso</button>
      <button onClick={decrease}>Quitar oso</button>
    </div>
  )
}
```

## Casos Prácticos de Uso

### 1. Carrito de Compras

```typescript
interface Product {
  id: number
  name: string
  price: number
}

interface CartState {
  items: Product[]
  addItem: (product: Product) => void
  removeItem: (productId: number) => void
  total: () => number
}

const useCartStore = create<CartState>((set, get) => ({
  items: [],
  addItem: (product) => 
    set((state) => ({ 
      items: [...state.items, product]
    })),
  removeItem: (productId) =>
    set((state) => ({
      items: state.items.filter(item => item.id !== productId)
    })),
  total: () => get().items.reduce((sum, item) => sum + item.price, 0)
}))
```

### 2. Autenticación

```typescript
interface AuthState {
  user: User | null
  isAuthenticated: boolean
  login: (credentials: Credentials) => Promise<void>
  logout: () => void
}

const useAuthStore = create<AuthState>((set) => ({
  user: null,
  isAuthenticated: false,
  login: async (credentials) => {
    const user = await apiLogin(credentials)
    set({ user, isAuthenticated: true })
  },
  logout: () => set({ user: null, isAuthenticated: false })
}))
```

## Persistencia del Estado

Zustand ofrece una manera sencilla de persistir el estado entre recargas de página usando middleware:

### 1. Persistencia Básica

```typescript
import create from 'zustand'
import { persist } from 'zustand/middleware'

interface State {
  fishes: number
  addFish: () => void
}

const useFishStore = create<State>()(
  persist(
    (set) => ({
      fishes: 0,
      addFish: () => set((state) => ({ fishes: state.fishes + 1 })),
    }),
    {
      name: 'fish-storage', // nombre único para el storage
      storage: localStorage, // por defecto usa localStorage
    }
  )
)
```

### 2. Persistencia Selectiva

```typescript
const useStore = create(
  persist(
    (set) => ({
      user: null,
      preferences: {},
      token: null,
    }),
    {
      name: 'user-storage',
      partialize: (state) => ({
        // solo persiste estas propiedades
        preferences: state.preferences,
        token: state.token,
      }),
    }
  )
)
```

## Consejos y Mejores Prácticas

1. **Separación de Stores**: Divide tu estado global en múltiples stores según la funcionalidad.

2. **Selectores Memoizados**: Usa selectores memoizados para mejor rendimiento:
```typescript
const todos = useStore(
  (state) => state.todos.filter((todo) => todo.completed),
  (a, b) => JSON.stringify(a) === JSON.stringify(b)
)
```

3. **Acciones Asíncronas**: Maneja acciones asíncronas directamente en el store:
```typescript
const useStore = create((set) => ({
  todos: [],
  fetchTodos: async () => {
    const response = await fetch('/api/todos')
    const todos = await response.json()
    set({ todos })
  }
}))
```

4. **DevTools**: Habilita las herramientas de desarrollo:
```typescript
import { devtools } from 'zustand/middleware'

const useStore = create(devtools(store))
```

## Conclusión

Zustand es una excelente opción para la gestión de estado en React cuando buscas:
- Simplicidad y facilidad de uso
- Rendimiento óptimo
- Mínima configuración
- Flexibilidad en la estructura de tu estado

Es especialmente útil para aplicaciones pequeñas y medianas, aunque también puede escalar bien para aplicaciones más grandes si se estructura correctamente.
