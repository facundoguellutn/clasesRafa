# Tutorial: Aplicación de Marcador de Voleibol con Next.js

## Introducción
Este tutorial te guiará paso a paso en la creación de una aplicación web para registrar y seguir partidos de voleibol. La aplicación permitirá registrar puntos, mostrar estadísticas y gestionar el progreso del partido.

> **Demo en vivo**: Puedes ver la aplicación funcionando en [https://v0.dev/chat/wWQoTzIkt1b](https://v0.dev/chat/wWQoTzIkt1b)

## Estructura del Proyecto
La aplicación está organizada en tres páginas principales:
1. Página de inicio (`/`) - Para ingresar los nombres de los equipos
2. Página del partido (`/match`) - Para registrar puntos y seguir el partido
3. Página de resultados (`/results`) - Para ver estadísticas y resultados finales

## Paso 1: Configuración Inicial

### 1.1 Crear un nuevo proyecto Next.js
```bash
npx create-next-app@latest volleyball-scorer --typescript --tailwind --eslint
```

### 1.2 Instalar dependencias necesarias
```bash
npm install @radix-ui/react-select @radix-ui/react-tabs @radix-ui/react-scroll-area
```

## Paso 2: Definición de Tipos e Interfaces

Antes de comenzar con el código, necesitamos definir las interfaces que usaremos:

```typescript
type PointType = "attack" | "serve" | "block" | "forcedError" | "unforced"

interface PointLog {
  team: string
  type: PointType
  setNumber: number
  score: {
    team1: number
    team2: number
  }
}

interface SetData {
  team1Points: number
  team2Points: number
  pointsLog: PointLog[]
}

interface TeamData {
  name: string
  sets: number
  points: PointLog[]
  pointsByType: Record<PointType, number>
}

interface MatchData {
  team1: TeamData
  team2: TeamData
  currentSet: number
  sets: SetData[]
  matchFinished: boolean
}
```

## Paso 3: Página de Inicio (page.tsx)

### 3.1 Estado Inicial
```typescript
const [team1Name, setTeam1Name] = useState("")
const [team2Name, setTeam2Name] = useState("")
const [error, setError] = useState("")
```

### 3.2 Lógica de Inicio
La función `handleStartMatch` valida los nombres y crea la estructura inicial del partido:
```typescript
const handleStartMatch = () => {
  if (!team1Name || !team2Name) {
    setError("Por favor ingresa el nombre de ambos equipos")
    return
  }

  if (team1Name === team2Name) {
    setError("Los nombres de los equipos deben ser diferentes")
    return
  }

  localStorage.setItem(
    "volleyballMatch",
    JSON.stringify({
      team1: {
        name: team1Name,
        sets: 0,
        points: [],
        pointsByType: {
          attack: 0,
          serve: 0,
          block: 0,
          forcedError: 0,
          unforced: 0,
        },
      },
      team2: {
        name: team2Name,
        sets: 0,
        points: [],
        pointsByType: {
          attack: 0,
          serve: 0,
          block: 0,
          forcedError: 0,
          unforced: 0,
        },
      },
      currentSet: 1,
      sets: [{ team1Points: 0, team2Points: 0, pointsLog: [] }],
      matchFinished: false,
    })
  )

  router.push("/match")
}
```

## Paso 4: Página del Partido (match/page.tsx)

### 4.1 Estado y Efectos
```typescript
const [matchData, setMatchData] = useState<MatchData | null>(null)
const [selectedPointType, setSelectedPointType] = useState<PointType>("attack")
const [loading, setLoading] = useState(true)

useEffect(() => {
  const storedData = localStorage.getItem("volleyballMatch")
  if (storedData) {
    setMatchData(JSON.parse(storedData))
  } else {
    router.push("/")
  }
  setLoading(false)
}, [router])
```

### 4.2 Lógica de Puntos
La función `addPoint` maneja la lógica de anotación de puntos. Esta es una de las funciones más importantes de la aplicación ya que maneja toda la lógica del juego:

```typescript
const addPoint = (teamNumber: 1 | 2) => {
  // Verificación inicial de seguridad
  if (!matchData) return

  // Obtenemos el índice del set actual (restando 1 porque los arrays empiezan en 0)
  const currentSet = matchData.currentSet - 1
  
  // Creamos copias de los datos para no mutar el estado directamente
  const newMatchData = { ...matchData }
  const currentSetData = { ...newMatchData.sets[currentSet] }

  // Actualización de puntos según el equipo que anotó
  if (teamNumber === 1) {
    currentSetData.team1Points += 1
  } else {
    currentSetData.team2Points += 1
  }

  // Creamos un registro detallado del punto
  const pointLog: PointLog = {
    // Guardamos el nombre del equipo que anotó
    team: newMatchData[teamNumber === 1 ? "team1" : "team2"].name,
    // Guardamos el tipo de punto (ataque, saque, etc.)
    type: selectedPointType,
    // Guardamos el número del set actual
    setNumber: matchData.currentSet,
    // Guardamos el marcador actual
    score: {
      team1: currentSetData.team1Points,
      team2: currentSetData.team2Points,
    },
  }

  // Actualizamos todos los registros necesarios
  // 1. Agregamos el punto al log del set actual
  currentSetData.pointsLog.push(pointLog)
  // 2. Actualizamos los datos del set en el partido
  newMatchData.sets[currentSet] = currentSetData
  // 3. Agregamos el punto al historial del equipo
  newMatchData[teamNumber === 1 ? "team1" : "team2"].points.push(pointLog)
  // 4. Incrementamos el contador de puntos por tipo para el equipo
  newMatchData[teamNumber === 1 ? "team1" : "team2"].pointsByType[selectedPointType] += 1

  // Verificamos si el set ha terminado
  // Un set termina cuando un equipo llega a 25 puntos y tiene 2 puntos de ventaja
  const isSetFinished =
    (currentSetData.team1Points >= 25 && currentSetData.team1Points - currentSetData.team2Points >= 2) ||
    (currentSetData.team2Points >= 25 && currentSetData.team2Points - currentSetData.team1Points >= 2)

  if (isSetFinished) {
    // Si el set terminó, actualizamos los sets ganados
    if (currentSetData.team1Points > currentSetData.team2Points) {
      newMatchData.team1.sets += 1
    } else {
      newMatchData.team2.sets += 1
    }

    // Verificamos si el partido ha terminado (mejor de 5 sets)
    if (newMatchData.team1.sets === 3 || newMatchData.team2.sets === 3) {
      // Marcamos el partido como terminado
      newMatchData.matchFinished = true
      // Guardamos los datos actualizados
      updateMatchData(newMatchData)
      // Redirigimos a la página de resultados
      router.push("/results")
      return
    }

    // Si el partido no terminó, iniciamos un nuevo set
    newMatchData.currentSet += 1
    newMatchData.sets.push({
      team1Points: 0,
      team2Points: 0,
      pointsLog: [],
    })
  }

  // Guardamos todos los cambios realizados
  updateMatchData(newMatchData)
}
```

## Paso 5: Página de Resultados (results/page.tsx)

### 5.1 Carga de Datos
```typescript
useEffect(() => {
  const storedData = localStorage.getItem("volleyballMatch")
  if (storedData) {
    const data = JSON.parse(storedData)
    setMatchData(data)

    if (!data.matchFinished) {
      router.push("/match")
    }
  } else {
    router.push("/")
  }
  setLoading(false)
}, [router])
```

### 5.2 Visualización de Estadísticas
La página de resultados muestra:
- Resultado final del partido
- Resumen por sets
- Estadísticas detalladas por equipo
- Opciones para continuar o iniciar nuevo partido

## Paso 6: Persistencia de Datos

La aplicación utiliza `localStorage` para mantener los datos del partido entre páginas:
```typescript
const updateMatchData = (newData: MatchData) => {
  setMatchData(newData)
  localStorage.setItem("volleyballMatch", JSON.stringify(newData))
}
```

## Paso 7: Navegación

La aplicación utiliza el router de Next.js para la navegación entre páginas:
```typescript
const router = useRouter()
```

## Paso 8: Estilos y UI

La aplicación utiliza Tailwind CSS para los estilos y componentes de Radix UI para la interfaz de usuario:
- Cards para contenedores
- Select para selección de tipo de punto
- Tabs para organizar estadísticas
- ScrollArea para listas largas

## Conclusión

Esta aplicación demuestra varios conceptos importantes de desarrollo web:
1. Gestión de estado con React hooks
2. Persistencia de datos con localStorage
3. Navegación entre páginas
4. Validación de datos
5. Interfaz de usuario responsiva
6. Tipado fuerte con TypeScript

## Próximos Pasos

Para mejorar la aplicación, podrías considerar:
1. Agregar autenticación de usuarios
2. Implementar una base de datos para guardar partidos
3. Agregar más estadísticas y análisis
4. Implementar modo offline
5. Agregar animaciones y efectos visuales
