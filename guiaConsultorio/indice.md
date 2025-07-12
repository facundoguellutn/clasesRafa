# Índice Maestro - Guía de Desarrollo App Odontológica (Next.js 14)

Esta guía sirve como estructura base para desarrollar paso a paso una aplicación web moderna en **Next.js 14**, pensada para consultorios odontológicos. Cada módulo funcional será detallado a pedido, siguiendo esta guía base.

Además de la guía técnica, este documento incluye una guía conceptual que te ayuda a pensar el **producto digital como un todo**: negocio, base de datos, diseño visual y experiencia de usuario.

---

## ⚠️ IMPORTANTE: Esta es una GUÍA de aprendizaje, NO una implementación completa

### 🎯 Propósito educativo
- **NO** entregamos código completo y funcional
- **SÍ** proporcionamos pasos, conceptos y decisiones a tomar
- **NO** resolvemos todo automáticamente
- **SÍ** guiamos el proceso de pensamiento y desarrollo

### 📚 Metodología de aprendizaje
- **Paso a paso**: Cada módulo se desarrolla gradualmente
- **Decisiones propias**: Tú eliges cómo implementar cada parte
- **Conceptos primero**: Entender el "por qué" antes del "cómo"
- **Práctica guiada**: Aplicar conceptos en tu propio código
- **Preguntas reflexivas**: Para que pienses antes de programar

### 🛠️ Lo que SÍ incluye esta guía
- Estructura y organización del proyecto
- Conceptos y decisiones de negocio
- Pasos de implementación sugeridos
- Preguntas para reflexionar
- Referencias y herramientas recomendadas
- Ejemplos conceptuales (no código completo)

### 🚫 Lo que NO incluye esta guía
- Código completo y funcional
- Implementaciones automáticas
- Soluciones "listas para usar"
- Archivos de configuración completos
- Código copiado y pegado

### 💡 Cómo usar esta guía efectivamente
1. **Lee y reflexiona** sobre cada sección
2. **Toma decisiones** basadas en tu contexto
3. **Implementa paso a paso** siguiendo las sugerencias
4. **Investiga** cuando necesites más detalles
5. **Practica** escribiendo tu propio código
6. **Pregunta** cuando te atasques en conceptos específicos

---

## 🧠 Sección 1: Guía de Pensamiento Estratégico

Esta sección te ayuda a tomar decisiones antes de escribir una sola línea de código.

### 🔸 1. Pensar la lógica de negocio

Para cada funcionalidad, hacete estas preguntas:

- ¿Qué problema real resuelve esta funcionalidad?
- ¿Quién la va a usar y cuándo?
- ¿Qué beneficios genera? (tiempo, dinero, comodidad)
- ¿Cómo se relaciona con otras funciones del sistema?
- ¿Se puede monetizar o es una funcionalidad interna?

### 🔸 2. Diseñar la base de datos pensando en el negocio

Preguntas clave:

- ¿Qué datos necesito guardar para que la funcionalidad funcione?
- ¿Qué datos necesito guardar para analizar o mejorar el negocio?
- ¿Qué datos necesito guardar por ley o por responsabilidad médica?
- ¿Qué relaciones lógicas existen entre los datos?
- ¿Este dato cambia seguido o es estático?

Ejemplo:
> Si quiero monetizar por cantidad de turnos agendados, necesito registrar cada turno con fecha, profesional y paciente. Y tal vez un `userPlan` que limite cuántos turnos puede crear un usuario mensual.

### 🔸 3. Decidir cómo monetizar la app

Modelos posibles:

- **Plan gratuito + pago**: límite de dentistas, turnos o pacientes.
- **Suscripción mensual**: acceso completo mientras paga.
- **Por uso**: se cobra por cada turno/paciente/etc.
- **Por consultorio**: se cobra por cuenta, sin importar el uso.

Cada modelo impacta en cómo diseñás el sistema:

- ¿Qué datos necesito guardar del usuario?
- ¿Qué límite tengo que controlar?
- ¿Cuándo se bloquea una acción?
- ¿Qué aviso o advertencia doy antes de bloquear?

### 🔸 4. Definir estilo visual y diseño de experiencia (UX/UI)

#### Estilo visual (UI)

- ¿Qué transmite la app? (confianza, claridad, profesionalismo)
- ¿Qué paleta de colores usar? (evitar colores estridentes)
- ¿Qué tipografía usar? (legible, profesional, accesible)
- ¿Qué íconos o componentes usar? (Lucide, Shadcn)

#### Experiencia de usuario (UX)

- ¿Cuál es el recorrido típico de un usuario? (flujo)
- ¿Dónde puede confundirse o frustrarse?
- ¿Cómo guiarlo paso a paso?
- ¿Qué feedback le doy en cada acción?

#### Pasos para pensar la experiencia de usuario:

1. Mapear los flujos principales (ej: agendar turno, registrar paciente).
2. Identificar decisiones importantes que toma el usuario.
3. Pensar en el mínimo de pasos necesarios.
4. Agregar ayudas visuales: loading, mensajes, validaciones.
5. Revisar en dispositivo móvil.

---

## 🧭 Sección 2: Guía Global de Implementación Técnica

Cada módulo funcional se desarrollará siguiendo esta estructura de implementación.

### 1. Objetivo del módulo
¿Qué funcionalidad resuelve?

### 2. Modelo de datos
Definición de la estructura y relaciones necesarias.

### 3. Interfaz de usuario (UI)
Diseño del formulario, vista, botones, etc.

### 4. Rutas
¿Qué páginas lo implementan? Ej: `/appointments`

### 5. Lógica de servidor
Server Actions o API Routes con operaciones CRUD.

### 6. Componentes cliente
Componentes, hooks, estados y conexión con servidor.

### 7. Validaciones
Uso de Zod o lógica manual para validar datos.

### 8. Feedback visual
Toasts, loaders, animaciones, mensajes de éxito/error.

### 9. Testing (opcional)
Tests manuales o automáticos.

### 10. Integraciones externas
API de Google Calendar, Resend para emails, etc.

---

## 🧱 Sección 3: Módulos funcionales de la app

A desarrollar individualmente a pedido.

- 🧑‍⚕️ **Dentistas**: registro, edición, listado, relación con turnos.
- 👤 **Pacientes**: carga, historial, búsqueda.
- 📅 **Turnos**: agenda, disponibilidad, superposición.
- 💬 **Recordatorios**: notificaciones automáticas por email.
- 📆 **Google Calendar**: integración con eventos.
- 💸 **Pagos**: registro y consulta de pagos.
- 📊 **Reportes**: métricas y estadísticas.
- 🔐 **Autenticación y roles**: acceso con permisos.
- ⚙️ **Configuración**: info del consultorio, horarios, etc.
- 🧪 **Notas clínicas** (futuro)

---

## 🛠️ Herramientas recomendadas

- **Next.js 14** con App Router y Server Actions
- **MongoDB** y **Mongoose**
- **Tailwind CSS** + **Shadcn UI**
- **Zod** para validaciones
- **Lucide** para íconos
- **TanStack Table** para listados
- **Google Calendar API**
- **Resend** para emails
- **React Query** (opcional)
- **Clerk/Auth.js/NextAuth** para login

---

## 📋 Cómo usar esta guía

Usá esta guía como contexto para pedirle a la IA que te genere una guía paso a paso.  
Ejemplos de prompts:

- `Quiero que me desarrolles una guía para el módulo de pagos siguiendo la estructura de la guía odontológica.`
- `Ayudame a pensar la lógica de negocio para el módulo de turnos.`
- `Mostrame los pasos para decidir cómo monetizar esta app.`
- `Dame una guía para definir la experiencia de usuario del flujo de agendado de turnos.`

---

## ✅ Estado del desarrollo

Este archivo es un índice base. Cada módulo será detallado a pedido siguiendo esta estructura.

