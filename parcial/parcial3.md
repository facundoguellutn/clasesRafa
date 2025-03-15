# Parcial 3: Explorador de Películas con TMDB API

## Consigna
Crear una aplicación que consuma la API de The Movie Database (TMDB) para mostrar películas populares, permitir búsquedas y ver detalles de cada película. La aplicación debe utilizar llamadas asíncronas, manejar estados de carga y errores, y utilizar componentes de Shadcn/ui.

## Paso a paso
1. Registrarse en TMDB y obtener una API key en https://developer.themoviedb.org/reference/intro/getting-started
2. Configurar el proyecto con Vite + React + TypeScript
3. Implementar el componente principal MovieExplorer
4. Crear las funciones para consumir la API
5. Implementar la búsqueda de películas
6. Mostrar detalles de películas en un modal
7. Manejar estados de carga y errores

## Solución

### 1. Estructura de archivos
```typescript
src/
  components/
    MovieExplorer.tsx
    MovieCard.tsx
    MovieModal.tsx
    SearchBar.tsx
  types/
    Movie.ts
  services/
    tmdb.ts
  config/
    constants.ts
  App.tsx
```

### 2. Tipos (Movie.ts)
```typescript
export interface Movie {
  id: number;
  title: string;
  overview: string;
  poster_path: string;
  release_date: string;
  vote_average: number;
}

export interface MovieDetails extends Movie {
  genres: { id: number; name: string }[];
  runtime: number;
  tagline: string;
  status: string;
}
```

### 3. Configuración (constants.ts)
```typescript
export const TMDB_API_KEY = "TU_API_KEY" // Reemplazar con tu API key
export const TMDB_BASE_URL = "https://api.themoviedb.org/3"
export const TMDB_IMAGE_BASE_URL = "https://image.tmdb.org/t/p/w500"
```

### 4. Servicios (tmdb.ts)
```typescript
import { TMDB_API_KEY, TMDB_BASE_URL } from "@/config/constants"
import { Movie, MovieDetails } from "@/types/Movie"

const headers = {
  Authorization: `Bearer ${TMDB_API_KEY}`,
  "Content-Type": "application/json",
}

export const tmdbService = {
  async getPopularMovies(): Promise<Movie[]> {
    try {
      const response = await fetch(`${TMDB_BASE_URL}/movie/popular`, { headers })
      const data = await response.json()
      return data.results
    } catch (error) {
      console.error("Error fetching popular movies:", error)
      throw error
    }
  },

  async searchMovies(query: string): Promise<Movie[]> {
    try {
      const response = await fetch(
        `${TMDB_BASE_URL}/search/movie?query=${encodeURIComponent(query)}`,
        { headers }
      )
      const data = await response.json()
      return data.results
    } catch (error) {
      console.error("Error searching movies:", error)
      throw error
    }
  },

  async getMovieDetails(id: number): Promise<MovieDetails> {
    try {
      const response = await fetch(`${TMDB_BASE_URL}/movie/${id}`, { headers })
      const data = await response.json()
      return data
    } catch (error) {
      console.error("Error fetching movie details:", error)
      throw error
    }
  },
}
```

### 5. Componentes

#### SearchBar.tsx
```typescript
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { useState } from "react"

interface SearchBarProps {
  onSearch: (query: string) => void;
}

export const SearchBar = ({ onSearch }: SearchBarProps) => {
  const [query, setQuery] = useState("")

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    if (query.trim()) {
      onSearch(query.trim())
    }
  }

  return (
    <form onSubmit={handleSubmit} className="flex gap-2">
      <Input
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Buscar películas..."
        className="flex-1"
      />
      <Button type="submit">Buscar</Button>
    </form>
  )
}
```

#### MovieCard.tsx
```typescript
import { Card, CardContent } from "@/components/ui/card"
import { TMDB_IMAGE_BASE_URL } from "@/config/constants"
import { Movie } from "@/types/Movie"

interface MovieCardProps {
  movie: Movie;
  onClick: () => void;
}

export const MovieCard = ({ movie, onClick }: MovieCardProps) => {
  return (
    <Card className="cursor-pointer hover:opacity-75 transition" onClick={onClick}>
      <CardContent className="p-0">
        <img
          src={`${TMDB_IMAGE_BASE_URL}${movie.poster_path}`}
          alt={movie.title}
          className="w-full h-[300px] object-cover rounded-t-lg"
        />
        <div className="p-4">
          <h3 className="font-bold truncate">{movie.title}</h3>
          <p className="text-sm text-gray-500">
            {new Date(movie.release_date).getFullYear()}
          </p>
          <div className="flex items-center mt-2">
            <span className="text-yellow-500">★</span>
            <span className="ml-1">{movie.vote_average.toFixed(1)}</span>
          </div>
        </div>
      </CardContent>
    </Card>
  )
}
```

#### MovieModal.tsx
```typescript
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { TMDB_IMAGE_BASE_URL } from "@/config/constants"
import { MovieDetails } from "@/types/Movie"

interface MovieModalProps {
  movie: MovieDetails | null;
  isOpen: boolean;
  onClose: () => void;
}

export const MovieModal = ({ movie, isOpen, onClose }: MovieModalProps) => {
  if (!movie) return null

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-3xl">
        <DialogHeader>
          <DialogTitle>{movie.title}</DialogTitle>
        </DialogHeader>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <img
            src={`${TMDB_IMAGE_BASE_URL}${movie.poster_path}`}
            alt={movie.title}
            className="w-full rounded-lg"
          />
          <div className="space-y-4">
            <p className="italic text-gray-500">{movie.tagline}</p>
            <p>{movie.overview}</p>
            <div className="space-y-2">
              <p>
                <span className="font-bold">Géneros:</span>{" "}
                {movie.genres.map((g) => g.name).join(", ")}
              </p>
              <p>
                <span className="font-bold">Duración:</span> {movie.runtime} minutos
              </p>
              <p>
                <span className="font-bold">Estreno:</span>{" "}
                {new Date(movie.release_date).toLocaleDateString()}
              </p>
              <p>
                <span className="font-bold">Calificación:</span>{" "}
                {movie.vote_average.toFixed(1)}/10
              </p>
            </div>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  )
}
```

#### MovieExplorer.tsx
```typescript
import { useState, useEffect } from "react"
import { tmdbService } from "@/services/tmdb"
import { Movie, MovieDetails } from "@/types/Movie"
import { SearchBar } from "./SearchBar"
import { MovieCard } from "./MovieCard"
import { MovieModal } from "./MovieModal"
import { Alert, AlertDescription } from "@/components/ui/alert"
import { Loader2 } from "lucide-react"

export const MovieExplorer = () => {
  const [movies, setMovies] = useState<Movie[]>([])
  const [selectedMovie, setSelectedMovie] = useState<MovieDetails | null>(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    loadPopularMovies()
  }, [])

  const loadPopularMovies = async () => {
    try {
      setLoading(true)
      setError(null)
      const popularMovies = await tmdbService.getPopularMovies()
      setMovies(popularMovies)
    } catch (error) {
      setError("Error al cargar las películas populares")
    } finally {
      setLoading(false)
    }
  }

  const handleSearch = async (query: string) => {
    try {
      setLoading(true)
      setError(null)
      const searchResults = await tmdbService.searchMovies(query)
      setMovies(searchResults)
    } catch (error) {
      setError("Error al buscar películas")
    } finally {
      setLoading(false)
    }
  }

  const handleMovieClick = async (movieId: number) => {
    try {
      const details = await tmdbService.getMovieDetails(movieId)
      setSelectedMovie(details)
    } catch (error) {
      setError("Error al cargar los detalles de la película")
    }
  }

  return (
    <div className="container mx-auto p-6 space-y-6">
      <h1 className="text-3xl font-bold text-center">Explorador de Películas</h1>
      
      <SearchBar onSearch={handleSearch} />

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
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {movies.map((movie) => (
            <MovieCard
              key={movie.id}
              movie={movie}
              onClick={() => handleMovieClick(movie.id)}
            />
          ))}
        </div>
      )}

      <MovieModal
        movie={selectedMovie}
        isOpen={!!selectedMovie}
        onClose={() => setSelectedMovie(null)}
      />
    </div>
  )
}
```

### 6. App.tsx
```typescript
import { MovieExplorer } from "./components/MovieExplorer"

function App() {
  return (
    <div className="min-h-screen bg-gray-50">
      <MovieExplorer />
    </div>
  )
}

export default App
```

### Instrucciones de instalación

1. Crear proyecto:
```bash
npm create vite@latest movie-explorer -- --template react-ts
cd movie-explorer
npm install
```

2. Instalar y configurar Shadcn/ui:
```bash
npx shadcn-ui@latest init
```

3. Instalar componentes necesarios:
```bash
npx shadcn-ui@latest add card
npx shadcn-ui@latest add dialog
npx shadcn-ui@latest add input
npx shadcn-ui@latest add button
npx shadcn-ui@latest add alert
```

4. Instalar dependencias adicionales:
```bash
npm install lucide-react
```

5. Configurar la API key:
- Registrarse en TMDB: https://www.themoviedb.org/signup
- Obtener API key en la sección de configuración de la cuenta
- Reemplazar `TU_API_KEY` en `constants.ts` con tu API key

6. Ejecutar la aplicación:
```bash
npm run dev
```

### Notas importantes
- Asegúrate de no compartir tu API key en el control de versiones
- Considera usar variables de entorno para las claves de API
- La API tiene límites de uso, revisa la documentación para más detalles
- Implementa manejo de errores más robusto en producción 