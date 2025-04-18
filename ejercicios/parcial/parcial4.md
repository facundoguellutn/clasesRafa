# Parcial 4: Gestor de Usuarios con Retool API

## Consigna
Crear una aplicación que consuma la API de Retool (https://retoolapi.dev/QCXBVm/data) para gestionar usuarios, permitiendo ver, crear, modificar y eliminar usuarios. La aplicación debe utilizar llamadas asíncronas con async/await, manejo de errores con try/catch y componentes de Shadcn/ui.

## Documentación
- API Generator: https://retool.com/api-generator#iframe-section
- Endpoint Base: https://retoolapi.dev/QCXBVm/data

## Paso a paso
1. Configurar el proyecto con Vite + React + TypeScript
2. Implementar el componente principal UserManager
3. Crear las funciones para consumir la API (GET, POST, PUT, DELETE)
4. Implementar el listado de usuarios
5. Crear formulario para agregar/editar usuarios
6. Implementar la eliminación de usuarios
7. Manejar estados de carga y errores

## Solución

### 1. Estructura de archivos
```typescript
src/
  components/
    UserManager.tsx
    UserList.tsx
    UserForm.tsx
    DeleteAlert.tsx
  types/
    User.ts
  services/
    api.ts
  App.tsx
```

### 2. Tipos (User.ts)
```typescript
export interface User {
  id?: number;
  "Column 1": string;
}

export interface ApiResponse {
  success: boolean;
  error?: string;
}
```

### 3. Servicios (api.ts)
```typescript
import { User, ApiResponse } from "@/types/User"

const API_URL = "https://retoolapi.dev/QCXBVm/data"

export const userService = {
  async getUsers(): Promise<User[]> {
    try {
      const response = await fetch(API_URL)
      if (!response.ok) throw new Error("Error al obtener usuarios")
      return await response.json()
    } catch (error) {
      console.error("Error:", error)
      throw error
    }
  },

  async createUser(userData: Omit<User, "id">): Promise<User> {
    try {
      const response = await fetch(API_URL, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(userData),
      })
      if (!response.ok) throw new Error("Error al crear usuario")
      return await response.json()
    } catch (error) {
      console.error("Error:", error)
      throw error
    }
  },

  async updateUser(id: number, userData: User): Promise<User> {
    try {
      const response = await fetch(`${API_URL}/${id}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(userData),
      })
      if (!response.ok) throw new Error("Error al actualizar usuario")
      return await response.json()
    } catch (error) {
      console.error("Error:", error)
      throw error
    }
  },

  async deleteUser(id: number): Promise<void> {
    try {
      const response = await fetch(`${API_URL}/${id}`, {
        method: "DELETE",
      })
      if (!response.ok) throw new Error("Error al eliminar usuario")
    } catch (error) {
      console.error("Error:", error)
      throw error
    }
  },
}
```

### 4. Componentes

#### UserForm.tsx
```typescript
import { useState } from "react"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { User } from "@/types/User"

interface UserFormProps {
  user?: User;
  onSubmit: (userData: Omit<User, "id">) => Promise<void>;
  onCancel: () => void;
}

export const UserForm = ({ user, onSubmit, onCancel }: UserFormProps) => {
  const [name, setName] = useState(user?.["Column 1"] || "")
  const [loading, setLoading] = useState(false)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!name.trim()) return

    try {
      setLoading(true)
      await onSubmit({ "Column 1": name.trim() })
    } finally {
      setLoading(false)
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <Input
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder="Nombre del usuario"
          disabled={loading}
        />
      </div>
      <div className="flex gap-2">
        <Button type="submit" disabled={loading}>
          {loading ? "Guardando..." : user ? "Actualizar" : "Crear"}
        </Button>
        <Button type="button" variant="outline" onClick={onCancel}>
          Cancelar
        </Button>
      </div>
    </form>
  )
}
```

#### DeleteAlert.tsx
```typescript
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog"

interface DeleteAlertProps {
  isOpen: boolean;
  onConfirm: () => void;
  onCancel: () => void;
}

export const DeleteAlert = ({ isOpen, onConfirm, onCancel }: DeleteAlertProps) => {
  return (
    <AlertDialog open={isOpen}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>¿Estás seguro?</AlertDialogTitle>
          <AlertDialogDescription>
            Esta acción no se puede deshacer. El usuario será eliminado permanentemente.
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel onClick={onCancel}>Cancelar</AlertDialogCancel>
          <AlertDialogAction onClick={onConfirm}>Eliminar</AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  )
}
```

#### UserList.tsx
```typescript
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { Button } from "@/components/ui/button"
import { Pencil, Trash2 } from "lucide-react"
import { User } from "@/types/User"

interface UserListProps {
  users: User[];
  onEdit: (user: User) => void;
  onDelete: (user: User) => void;
}

export const UserList = ({ users, onEdit, onDelete }: UserListProps) => {
  return (
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>ID</TableHead>
          <TableHead>Nombre</TableHead>
          <TableHead>Acciones</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        {users.map((user) => (
          <TableRow key={user.id}>
            <TableCell>{user.id}</TableCell>
            <TableCell>{user["Column 1"]}</TableCell>
            <TableCell>
              <div className="flex gap-2">
                <Button
                  variant="outline"
                  size="icon"
                  onClick={() => onEdit(user)}
                >
                  <Pencil className="h-4 w-4" />
                </Button>
                <Button
                  variant="outline"
                  size="icon"
                  onClick={() => onDelete(user)}
                >
                  <Trash2 className="h-4 w-4" />
                </Button>
              </div>
            </TableCell>
          </TableRow>
        ))}
      </TableBody>
    </Table>
  )
}
```

#### UserManager.tsx
```typescript
import { useState, useEffect } from "react"
import { userService } from "@/services/api"
import { User } from "@/types/User"
import { UserList } from "./UserList"
import { UserForm } from "./UserForm"
import { DeleteAlert } from "./DeleteAlert"
import { Button } from "@/components/ui/button"
import { Alert, AlertDescription } from "@/components/ui/alert"
import { Loader2 } from "lucide-react"

export const UserManager = () => {
  const [users, setUsers] = useState<User[]>([])
  const [selectedUser, setSelectedUser] = useState<User | null>(null)
  const [userToDelete, setUserToDelete] = useState<User | null>(null)
  const [showForm, setShowForm] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    loadUsers()
  }, [])

  const loadUsers = async () => {
    try {
      setLoading(true)
      setError(null)
      const data = await userService.getUsers()
      setUsers(data)
    } catch (error) {
      setError("Error al cargar usuarios")
    } finally {
      setLoading(false)
    }
  }

  const handleCreateUser = async (userData: Omit<User, "id">) => {
    try {
      setError(null)
      const newUser = await userService.createUser(userData)
      setUsers([...users, newUser])
      setShowForm(false)
    } catch (error) {
      setError("Error al crear usuario")
    }
  }

  const handleUpdateUser = async (userData: Omit<User, "id">) => {
    if (!selectedUser?.id) return

    try {
      setError(null)
      const updatedUser = await userService.updateUser(selectedUser.id, {
        ...userData,
        id: selectedUser.id,
      })
      setUsers(users.map((u) => (u.id === selectedUser.id ? updatedUser : u)))
      setSelectedUser(null)
      setShowForm(false)
    } catch (error) {
      setError("Error al actualizar usuario")
    }
  }

  const handleDeleteConfirm = async () => {
    if (!userToDelete?.id) return

    try {
      setError(null)
      await userService.deleteUser(userToDelete.id)
      setUsers(users.filter((u) => u.id !== userToDelete.id))
      setUserToDelete(null)
    } catch (error) {
      setError("Error al eliminar usuario")
    }
  }

  return (
    <div className="container mx-auto p-6 space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold">Gestión de Usuarios</h1>
        <Button onClick={() => setShowForm(true)}>Nuevo Usuario</Button>
      </div>

      {error && (
        <Alert variant="destructive">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      )}

      {loading ? (
        <div className="flex justify-center">
          <Loader2 className="h-8 w-8 animate-spin" />
        </div>
      ) : (
        <UserList
          users={users}
          onEdit={(user) => {
            setSelectedUser(user)
            setShowForm(true)
          }}
          onDelete={setUserToDelete}
        />
      )}

      {showForm && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4">
          <div className="bg-white rounded-lg p-6 max-w-md w-full">
            <h2 className="text-xl font-bold mb-4">
              {selectedUser ? "Editar Usuario" : "Nuevo Usuario"}
            </h2>
            <UserForm
              user={selectedUser || undefined}
              onSubmit={selectedUser ? handleUpdateUser : handleCreateUser}
              onCancel={() => {
                setShowForm(false)
                setSelectedUser(null)
              }}
            />
          </div>
        </div>
      )}

      <DeleteAlert
        isOpen={!!userToDelete}
        onConfirm={handleDeleteConfirm}
        onCancel={() => setUserToDelete(null)}
      />
    </div>
  )
}
```

### 5. App.tsx
```typescript
import { UserManager } from "./components/UserManager"

function App() {
  return (
    <div className="min-h-screen bg-gray-50">
      <UserManager />
    </div>
  )
}

export default App
```

### Instrucciones de instalación

1. Crear proyecto:
```bash
npm create vite@latest user-manager -- --template react-ts
cd user-manager
npm install
```

2. Instalar y configurar Shadcn/ui:
```bash
npx shadcn-ui@latest init
```

3. Instalar componentes necesarios:
```bash
npx shadcn-ui@latest add table
npx shadcn-ui@latest add alert
npx shadcn-ui@latest add alert-dialog
npx shadcn-ui@latest add input
npx shadcn-ui@latest add button
```

4. Instalar dependencias adicionales:
```bash
npm install lucide-react
```

5. Ejecutar la aplicación:
```bash
npm run dev
```

### Notas importantes
- La API tiene un límite de 150 registros
- Los datos persisten entre llamadas
- La API se elimina después de 30 días sin uso
- Implementa manejo de errores más robusto en producción
- Considera agregar paginación si la lista crece demasiado 