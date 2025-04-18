# Parcial 1: Gestión de Tareas con Estados

## Consigna
Crear una aplicación de gestión de tareas utilizando React + Typescript que permita agregar, eliminar y marcar como completadas diferentes tareas. La aplicación debe utilizar componentes de Shadcn/ui y manejar estados con useState.

## Paso a paso
1. Crear un nuevo proyecto con Vite + React + TypeScript
2. Instalar y configurar Shadcn/ui
3. Crear un componente principal TaskManager
4. Implementar un formulario con input para nuevas tareas
5. Crear la lista de tareas con opciones para marcar como completadas y eliminar
6. Implementar el estado para manejar las tareas
7. Estilizar la aplicación usando Shadcn/ui

## Solución

### 1. Estructura de archivos
```tsx
src/
  components/
    TaskManager.tsx
    TaskItem.tsx
  types/
    Task.ts
  App.tsx
```

### 2. Definición de tipos (Task.ts)
```typescript
export interface Task {
  id: string;
  text: string;
  completed: boolean;
}
```

### 3. Componente TaskItem.tsx
```typescript
import { Checkbox } from "@/components/ui/checkbox"
import { Button } from "@/components/ui/button"
import { Task } from "@/types/Task"

interface TaskItemProps {
  task: Task;
  onToggle: (id: string) => void;
  onDelete: (id: string) => void;
}

export const TaskItem = ({ task, onToggle, onDelete }: TaskItemProps) => {
  return (
    <div className="flex items-center space-x-4 p-2 border rounded-lg">
      <Checkbox
        checked={task.completed}
        onCheckedChange={() => onToggle(task.id)}
      />
      <span className={task.completed ? "line-through text-gray-500" : ""}>
        {task.text}
      </span>
      <Button
        variant="destructive"
        size="sm"
        onClick={() => onDelete(task.id)}
      >
        Eliminar
      </Button>
    </div>
  )
}
```

### 4. Componente TaskManager.tsx
```typescript
import { useState } from "react"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { TaskItem } from "./TaskItem"
import { Task } from "@/types/Task"

export const TaskManager = () => {
  const [tasks, setTasks] = useState<Task[]>([])
  const [newTask, setNewTask] = useState("")

  const handleAddTask = () => {
    if (newTask.trim()) {
      const task: Task = {
        id: Date.now().toString(),
        text: newTask.trim(),
        completed: false
      }
      setTasks([...tasks, task])
      setNewTask("")
    }
  }

  const handleToggleTask = (id: string) => {
    setTasks(tasks.map(task =>
      task.id === id ? { ...task, completed: !task.completed } : task
    ))
  }

  const handleDeleteTask = (id: string) => {
    setTasks(tasks.filter(task => task.id !== id))
  }

  return (
    <div className="max-w-md mx-auto p-6 space-y-6">
      <h1 className="text-2xl font-bold text-center">Gestor de Tareas</h1>
      
      <div className="flex space-x-2">
        <Input
          value={newTask}
          onChange={(e) => setNewTask(e.target.value)}
          placeholder="Nueva tarea..."
          onKeyPress={(e) => e.key === "Enter" && handleAddTask()}
        />
        <Button onClick={handleAddTask}>Agregar</Button>
      </div>

      <div className="space-y-2">
        {tasks.map(task => (
          <TaskItem
            key={task.id}
            task={task}
            onToggle={handleToggleTask}
            onDelete={handleDeleteTask}
          />
        ))}
      </div>
    </div>
  )
}
```

### 5. App.tsx
```typescript
import { TaskManager } from "./components/TaskManager"

function App() {
  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <TaskManager />
    </div>
  )
}

export default App
```

### Instrucciones de instalación
1. Crear proyecto:
```bash
npm create vite@latest my-task-app -- --template react-ts
cd my-task-app
npm install
```

2. Instalar y configurar Shadcn/ui:
```bash
npx shadcn-ui@latest init
```

3. Instalar componentes necesarios:
```bash
npx shadcn-ui@latest add button
npx shadcn-ui@latest add input
npx shadcn-ui@latest add checkbox
```

4. Ejecutar la aplicación:
```bash
npm run dev
``` 