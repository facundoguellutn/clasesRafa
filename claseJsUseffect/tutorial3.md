# Ejercicios Prácticos de Fetch y Async/Await

## Ejercicio 1: Fetch Anidado con API de Posts y Comentarios

En este ejercicio, practicaremos el uso de fetch anidado para obtener posts y sus comentarios relacionados.

### Objetivo
Crear una aplicación React que:
1. Obtenga una lista de posts
2. Para cada post, obtener sus comentarios
3. Mostrar toda la información de manera organizada

### Código Base
```jsx
import React, { useState, useEffect } from 'react';

function PostsConComentarios() {
    const [posts, setPosts] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        cargarPosts();
    }, []);

    const cargarPosts = async () => {
        try {
            // Obtener posts
            const responsePosts = await fetch('https://jsonplaceholder.typicode.com/posts');
            if (!responsePosts.ok) throw new Error('Error al cargar posts');
            const postsData = await responsePosts.json();

            // Para cada post, obtener sus comentarios
            const postsConComentarios = await Promise.all(
                postsData.slice(0, 5).map(async (post) => {
                    const responseComentarios = await fetch(
                        `https://jsonplaceholder.typicode.com/posts/${post.id}/comments`
                    );
                    if (!responseComentarios.ok) throw new Error('Error al cargar comentarios');
                    const comentarios = await responseComentarios.json();
                    return { ...post, comentarios };
                })
            );

            setPosts(postsConComentarios);
            setLoading(false);
        } catch (error) {
            setError(error.message);
            setLoading(false);
        }
    };

    if (loading) return <div>Cargando...</div>;
    if (error) return <div>Error: {error}</div>;

    return (
        <div className="container mx-auto p-4">
            <h1 className="text-2xl font-bold mb-4">Posts con Comentarios</h1>
            {posts.map(post => (
                <div key={post.id} className="mb-8 p-4 border rounded-lg">
                    <h2 className="text-xl font-semibold mb-2">{post.title}</h2>
                    <p className="mb-4">{post.body}</p>
                    
                    <h3 className="font-semibold mb-2">Comentarios:</h3>
                    <div className="pl-4">
                        {post.comentarios.map(comentario => (
                            <div key={comentario.id} className="mb-2 p-2 bg-gray-50 rounded">
                                <p className="font-medium">{comentario.email}</p>
                                <p>{comentario.body}</p>
                            </div>
                        ))}
                    </div>
                </div>
            ))}
        </div>
    );
}

export default PostsConComentarios;
```

## Ejercicio 2: API de Rick and Morty

Este ejercicio más completo utiliza la API de Rick and Morty para practicar fetching de datos y manejo de estado.

### Objetivo
Crear una aplicación que:
1. Muestre una lista de personajes
2. Permita filtrar por estado (vivo, muerto, desconocido)
3. Implemente paginación
4. Muestre detalles de cada personaje

### Código Completo
```jsx
import React, { useState, useEffect } from 'react';

function RickAndMorty() {
    const [personajes, setPersonajes] = useState([]);
    const [pagina, setPagina] = useState(1);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [filtroEstado, setFiltroEstado] = useState('');
    const [totalPaginas, setTotalPaginas] = useState(0);

    useEffect(() => {
        cargarPersonajes();
    }, [pagina, filtroEstado]);

    const cargarPersonajes = async () => {
        try {
            setLoading(true);
            const url = `https://rickandmortyapi.com/api/character/?page=${pagina}${
                filtroEstado ? `&status=${filtroEstado}` : ''
            }`;
            
            const response = await fetch(url);
            if (!response.ok) throw new Error('Error al cargar datos');
            
            const data = await response.json();
            setPersonajes(data.results);
            setTotalPaginas(data.info.pages);
            setLoading(false);
        } catch (error) {
            setError(error.message);
            setLoading(false);
        }
    };

    const obtenerColorEstado = (estado) => {
        switch (estado.toLowerCase()) {
            case 'alive':
                return 'text-green-500';
            case 'dead':
                return 'text-red-500';
            default:
                return 'text-gray-500';
        }
    };

    if (loading) return <div className="text-center p-4">Cargando...</div>;
    if (error) return <div className="text-center p-4 text-red-500">Error: {error}</div>;

    return (
        <div className="container mx-auto p-4">
            <h1 className="text-3xl font-bold mb-6 text-center">Rick and Morty Personajes</h1>
            
            {/* Filtros */}
            <div className="mb-6 flex justify-center">
                <select
                    value={filtroEstado}
                    onChange={(e) => {
                        setFiltroEstado(e.target.value);
                        setPagina(1);
                    }}
                    className="p-2 border rounded"
                >
                    <option value="">Todos</option>
                    <option value="alive">Vivo</option>
                    <option value="dead">Muerto</option>
                    <option value="unknown">Desconocido</option>
                </select>
            </div>

            {/* Lista de Personajes */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {personajes.map(personaje => (
                    <div key={personaje.id} className="border rounded-lg overflow-hidden shadow-lg">
                        <img 
                            src={personaje.image} 
                            alt={personaje.name}
                            className="w-full h-64 object-cover"
                        />
                        <div className="p-4">
                            <h2 className="text-xl font-bold mb-2">{personaje.name}</h2>
                            <p className={`mb-2 ${obtenerColorEstado(personaje.status)}`}>
                                {personaje.status} - {personaje.species}
                            </p>
                            <p className="text-gray-600">
                                Última ubicación conocida:
                                <br />
                                {personaje.location.name}
                            </p>
                        </div>
                    </div>
                ))}
            </div>

            {/* Paginación */}
            <div className="mt-6 flex justify-center gap-4">
                <button
                    onClick={() => setPagina(p => Math.max(1, p - 1))}
                    disabled={pagina === 1}
                    className="px-4 py-2 bg-blue-500 text-white rounded disabled:bg-gray-300"
                >
                    Anterior
                </button>
                <span className="py-2">
                    Página {pagina} de {totalPaginas}
                </span>
                <button
                    onClick={() => setPagina(p => Math.min(totalPaginas, p + 1))}
                    disabled={pagina === totalPaginas}
                    className="px-4 py-2 bg-blue-500 text-white rounded disabled:bg-gray-300"
                >
                    Siguiente
                </button>
            </div>
        </div>
    );
}

export default RickAndMorty;
```

### Explicación del Ejercicio Rick and Morty

#### Estados Utilizados
```javascript
const [personajes, setPersonajes] = useState([]); // Lista de personajes
const [pagina, setPagina] = useState(1);         // Página actual
const [loading, setLoading] = useState(true);    // Estado de carga
const [error, setError] = useState(null);        // Manejo de errores
const [filtroEstado, setFiltroEstado] = useState(''); // Filtro por estado
const [totalPaginas, setTotalPaginas] = useState(0);  // Total de páginas
```

#### Función Principal de Carga
```javascript
const cargarPersonajes = async () => {
    try {
        setLoading(true);
        const url = `https://rickandmortyapi.com/api/character/?page=${pagina}${
            filtroEstado ? `&status=${filtroEstado}` : ''
        }`;
        
        const response = await fetch(url);
        if (!response.ok) throw new Error('Error al cargar datos');
        
        const data = await response.json();
        setPersonajes(data.results);
        setTotalPaginas(data.info.pages);
        setLoading(false);
    } catch (error) {
        setError(error.message);
        setLoading(false);
    }
};
```

### Puntos Clave del Ejercicio

1. **Manejo de Estado**:
   - Uso de múltiples estados para controlar diferentes aspectos de la aplicación
   - Estado para la paginación y filtros

2. **useEffect**:
   - Se ejecuta cuando cambia la página o el filtro
   - Maneja la carga inicial y actualizaciones

3. **Manejo de Errores**:
   - Try/catch para manejar errores en las peticiones
   - Estado dedicado para mostrar errores

4. **Componentes Condicionales**:
   - Muestra diferentes contenidos según el estado de la aplicación
   - Loading state, error state, y contenido principal

5. **Filtrado y Paginación**:
   - Implementación de filtros con select
   - Paginación con botones anterior/siguiente
   - Actualización de URL con parámetros de consulta

## Conclusión

Estos ejercicios proporcionan práctica en:
- Fetching de datos anidado
- Manejo de estados complejos
- Implementación de filtros y paginación
- Manejo de errores
- Uso de useEffect para efectos secundarios
- Renderizado condicional

Para practicar, intenta:
1. Agregar más filtros (por especie, género)
2. Implementar búsqueda por nombre
3. Agregar una vista detallada de cada personaje
4. Mejorar el manejo de errores
5. Agregar animaciones de carga
6. Implementar caché de resultados

## Recursos Adicionales

Para profundizar en estos ejercicios y ver más ejemplos, puedes consultar:

1. [Ejercicios de React y Fetch Anidado](https://v0.dev/chat/react-exercises-needed-XLzJq0iekQG) - Ejemplos y ejercicios adicionales sobre fetch anidado y manejo de datos.

2. [Ejercicio Completo de Rick and Morty](https://v0.dev/chat/simple-async-exercise-WVrdGaobVVa) - Tutorial detallado sobre cómo construir la aplicación de Rick and Morty paso a paso. 