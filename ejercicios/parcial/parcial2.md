# Parcial 2: Formulario de Registro con Validación

## Consigna
Desarrollar un formulario de registro completo que incluya múltiples campos, selects y validación en tiempo real utilizando useState y useEffect.

## Paso a paso
1. Crear el componente principal RegisterForm
2. Implementar los diferentes inputs y selects usando Shadcn/ui
3. Crear estados para cada campo del formulario
4. Implementar validación en tiempo real con useEffect
5. Mostrar mensajes de error cuando corresponda
6. Crear una vista previa de los datos ingresados
7. Implementar el envío del formulario

## Solución

### 1. Tipos (types.ts)
```typescript
export interface FormData {
  nombre: string;
  email: string;
  password: string;
  confirmPassword: string;
  pais: string;
  ocupacion: string;
  intereses: string[];
}

export interface FormErrors {
  nombre?: string;
  email?: string;
  password?: string;
  confirmPassword?: string;
  pais?: string;
  ocupacion?: string;
}
```

### 2. Constantes (constants.ts)
```typescript
export const PAISES = [
  { value: "argentina", label: "Argentina" },
  { value: "brasil", label: "Brasil" },
  { value: "chile", label: "Chile" },
  { value: "uruguay", label: "Uruguay" },
]

export const OCUPACIONES = [
  { value: "estudiante", label: "Estudiante" },
  { value: "profesional", label: "Profesional" },
  { value: "otro", label: "Otro" },
]

export const INTERESES = [
  { value: "tecnologia", label: "Tecnología" },
  { value: "diseño", label: "Diseño" },
  { value: "marketing", label: "Marketing" },
  { value: "negocios", label: "Negocios" },
]
```

### 3. RegisterForm.tsx
```typescript
import { useState, useEffect } from "react"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { Checkbox } from "@/components/ui/checkbox"
import { FormData, FormErrors } from "@/types"
import { PAISES, OCUPACIONES, INTERESES } from "@/constants"

export const RegisterForm = () => {
  const [formData, setFormData] = useState<FormData>({
    nombre: "",
    email: "",
    password: "",
    confirmPassword: "",
    pais: "",
    ocupacion: "",
    intereses: [],
  })

  const [errors, setErrors] = useState<FormErrors>({})
  const [isSubmitting, setIsSubmitting] = useState(false)

  useEffect(() => {
    validateForm()
  }, [formData])

  const validateForm = () => {
    const newErrors: FormErrors = {}

    if (!formData.nombre) {
      newErrors.nombre = "El nombre es requerido"
    }

    if (!formData.email) {
      newErrors.email = "El email es requerido"
    } else if (!/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i.test(formData.email)) {
      newErrors.email = "Email inválido"
    }

    if (!formData.password) {
      newErrors.password = "La contraseña es requerida"
    } else if (formData.password.length < 6) {
      newErrors.password = "La contraseña debe tener al menos 6 caracteres"
    }

    if (formData.password !== formData.confirmPassword) {
      newErrors.confirmPassword = "Las contraseñas no coinciden"
    }

    if (!formData.pais) {
      newErrors.pais = "Seleccione un país"
    }

    if (!formData.ocupacion) {
      newErrors.ocupacion = "Seleccione una ocupación"
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setIsSubmitting(true)

    if (validateForm()) {
      // Aquí iría la lógica para enviar los datos
      console.log("Datos enviados:", formData)
      alert("Registro exitoso!")
    }

    setIsSubmitting(false)
  }

  const handleInteresChange = (value: string) => {
    const currentIntereses = [...formData.intereses]
    const index = currentIntereses.indexOf(value)
    
    if (index === -1) {
      currentIntereses.push(value)
    } else {
      currentIntereses.splice(index, 1)
    }

    setFormData({ ...formData, intereses: currentIntereses })
  }

  return (
    <form onSubmit={handleSubmit} className="max-w-md mx-auto space-y-6 p-6">
      <h1 className="text-2xl font-bold text-center">Registro</h1>

      <div className="space-y-4">
        <div>
          <Input
            placeholder="Nombre"
            value={formData.nombre}
            onChange={(e) => setFormData({ ...formData, nombre: e.target.value })}
          />
          {errors.nombre && <p className="text-red-500 text-sm">{errors.nombre}</p>}
        </div>

        <div>
          <Input
            type="email"
            placeholder="Email"
            value={formData.email}
            onChange={(e) => setFormData({ ...formData, email: e.target.value })}
          />
          {errors.email && <p className="text-red-500 text-sm">{errors.email}</p>}
        </div>

        <div>
          <Input
            type="password"
            placeholder="Contraseña"
            value={formData.password}
            onChange={(e) => setFormData({ ...formData, password: e.target.value })}
          />
          {errors.password && <p className="text-red-500 text-sm">{errors.password}</p>}
        </div>

        <div>
          <Input
            type="password"
            placeholder="Confirmar Contraseña"
            value={formData.confirmPassword}
            onChange={(e) => setFormData({ ...formData, confirmPassword: e.target.value })}
          />
          {errors.confirmPassword && <p className="text-red-500 text-sm">{errors.confirmPassword}</p>}
        </div>

        <div>
          <Select
            value={formData.pais}
            onValueChange={(value) => setFormData({ ...formData, pais: value })}
          >
            <SelectTrigger>
              <SelectValue placeholder="Seleccionar país" />
            </SelectTrigger>
            <SelectContent>
              {PAISES.map((pais) => (
                <SelectItem key={pais.value} value={pais.value}>
                  {pais.label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          {errors.pais && <p className="text-red-500 text-sm">{errors.pais}</p>}
        </div>

        <div>
          <Select
            value={formData.ocupacion}
            onValueChange={(value) => setFormData({ ...formData, ocupacion: value })}
          >
            <SelectTrigger>
              <SelectValue placeholder="Seleccionar ocupación" />
            </SelectTrigger>
            <SelectContent>
              {OCUPACIONES.map((ocupacion) => (
                <SelectItem key={ocupacion.value} value={ocupacion.value}>
                  {ocupacion.label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          {errors.ocupacion && <p className="text-red-500 text-sm">{errors.ocupacion}</p>}
        </div>

        <div className="space-y-2">
          <p className="text-sm font-medium">Intereses:</p>
          {INTERESES.map((interes) => (
            <div key={interes.value} className="flex items-center space-x-2">
              <Checkbox
                checked={formData.intereses.includes(interes.value)}
                onCheckedChange={() => handleInteresChange(interes.value)}
              />
              <label>{interes.label}</label>
            </div>
          ))}
        </div>
      </div>

      <Button
        type="submit"
        className="w-full"
        disabled={isSubmitting || Object.keys(errors).length > 0}
      >
        {isSubmitting ? "Enviando..." : "Registrarse"}
      </Button>

      {formData.nombre && (
        <div className="mt-6 p-4 bg-gray-50 rounded-lg">
          <h3 className="font-medium">Vista previa:</h3>
          <pre className="text-sm mt-2">
            {JSON.stringify(formData, null, 2)}
          </pre>
        </div>
      )}
    </form>
  )
}
```

### 4. App.tsx
```typescript
import { RegisterForm } from "./components/RegisterForm"

function App() {
  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <RegisterForm />
    </div>
  )
}

export default App
```

### Instrucciones de instalación

1. Asegurarse de tener instalados los componentes necesarios de Shadcn/ui:
```bash
npx shadcn-ui@latest add input
npx shadcn-ui@latest add select
npx shadcn-ui@latest add checkbox
npx shadcn-ui@latest add button
```

2. Crear los archivos necesarios en la estructura del proyecto:
```
src/
  components/
    RegisterForm.tsx
  types/
    index.ts
  constants/
    index.ts
  App.tsx
```

3. Ejecutar la aplicación:
```bash
npm run dev
``` 