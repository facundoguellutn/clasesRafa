# Profundizando en Async/Await, Fetch y JSON

## Async/Await en Detalle

### ¿Qué es Async/Await?
Async/await es una forma de escribir código asíncrono que parece y se comporta como código síncrono. Esto hace que sea más fácil de leer y mantener.

- `async`: Declara que una función es asíncrona
- `await`: Pausa la ejecución hasta que una promesa se resuelva

### Ejemplo Básico
```javascript
// Función tradicional vs async
// Tradicional
function obtenerDatos() {
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve("Datos obtenidos");
        }, 2000);
    });
}

// Con async/await
async function obtenerDatosAsync() {
    const datos = await obtenerDatos();
    console.log(datos);
    return datos;
}
```

### Manejo de Errores
```javascript
async function manejoErrores() {
    try {
        const datos = await obtenerDatos();
        return datos;
    } catch (error) {
        console.error("Ocurrió un error:", error);
        throw error; // Re-lanzar el error si es necesario
    } finally {
        // Este código se ejecuta siempre, haya error o no
        console.log("Proceso finalizado");
    }
}
```

## Fetch API en Profundidad

### ¿Qué es Fetch?
Fetch es una API moderna para realizar peticiones HTTP. Devuelve una Promise que se resuelve en un objeto Response.

### Anatomía de una Respuesta Fetch
```javascript
async function analizarRespuestaFetch() {
    const response = await fetch('https://api.ejemplo.com/datos');
    
    console.log(response.status);        // Código de estado HTTP (200, 404, etc.)
    console.log(response.ok);            // true si status está entre 200-299
    console.log(response.headers);       // Headers de la respuesta
    console.log(response.url);           // URL de la petición
    console.log(response.type);          // Tipo de respuesta (basic, cors)
    
    // Los datos reales están en el body, que debe ser parseado
    const datos = await response.json();
    return datos;
}
```

### Verificación Completa de una Respuesta
```javascript
async function obtenerDatosSeguro(url) {
    try {
        const response = await fetch(url);
        
        // Verificar si la respuesta fue exitosa
        if (!response.ok) {
            throw new Error(`Error HTTP: ${response.status} - ${response.statusText}`);
        }

        // Verificar el tipo de contenido
        const contentType = response.headers.get('content-type');
        if (!contentType || !contentType.includes('application/json')) {
            throw new TypeError('La respuesta no es JSON');
        }

        // Parsear la respuesta
        const datos = await response.json();
        return datos;

    } catch (error) {
        if (error instanceof TypeError) {
            console.error('Error de red o problema al parsear JSON:', error);
        } else {
            console.error('Otro tipo de error:', error);
        }
        throw error;
    }
}
```

### Diferentes Tipos de Peticiones
```javascript
// GET con parámetros
async function getPeticion() {
    const response = await fetch('https://api.ejemplo.com/datos?id=1&tipo=usuario');
    return await response.json();
}

// POST con datos
async function postPeticion(datos) {
    const response = await fetch('https://api.ejemplo.com/datos', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer tu-token'
        },
        body: JSON.stringify(datos)
    });
    return await response.json();
}

// PUT para actualizar
async function putPeticion(id, datos) {
    const response = await fetch(`https://api.ejemplo.com/datos/${id}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(datos)
    });
    return await response.json();
}
```

## JSON en Detalle

### ¿Qué es JSON?
JSON (JavaScript Object Notation) es un formato ligero de intercambio de datos. Es fácil de leer para humanos y fácil de parsear y generar para máquinas.

### Ejemplo de JSON
```javascript
// Objeto JavaScript normal
const usuario = {
    nombre: "María",
    edad: 25,
    esActivo: true,
    hobbies: ["lectura", "natación"],
    direccion: {
        calle: "Calle Principal",
        numero: 123,
        ciudad: "Ciudad Ejemplo"
    }
};

// Convertir a JSON (serialización)
const usuarioJSON = JSON.stringify(usuario);
console.log(usuarioJSON);
/* Resultado:
{
    "nombre": "María",
    "edad": 25,
    "esActivo": true,
    "hobbies": ["lectura", "natación"],
    "direccion": {
        "calle": "Calle Principal",
        "numero": 123,
        "ciudad": "Ciudad Ejemplo"
    }
}
*/

// Convertir de JSON a objeto JavaScript (deserialización)
const usuarioObjeto = JSON.parse(usuarioJSON);
```

### ¿Por qué Necesitamos Parsear JSON?
1. **Transporte de datos**: JSON es texto plano, lo que lo hace ideal para enviar datos por la red
2. **Interoperabilidad**: Diferentes lenguajes pueden entender JSON
3. **Seguridad**: Al parsear, validamos que los datos son JSON válido

### Ejemplo Práctico Completo
```javascript
async function gestionarUsuarios() {
    // Crear un nuevo usuario
    const nuevoUsuario = {
        nombre: "Juan",
        email: "juan@ejemplo.com",
        edad: 30
    };

    try {
        // Enviar datos
        const responsePost = await fetch('https://api.ejemplo.com/usuarios', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(nuevoUsuario) // Convertir a JSON
        });

        if (!responsePost.ok) {
            throw new Error('Error al crear usuario');
        }

        const usuarioCreado = await responsePost.json(); // Parsear respuesta
        console.log('Usuario creado:', usuarioCreado);

        // Obtener lista de usuarios
        const responseGet = await fetch('https://api.ejemplo.com/usuarios');
        if (!responseGet.ok) {
            throw new Error('Error al obtener usuarios');
        }

        const usuarios = await responseGet.json(); // Parsear respuesta
        
        // Procesar los datos
        const usuariosFiltrados = usuarios
            .filter(usuario => usuario.edad > 18)
            .map(usuario => ({
                nombre: usuario.nombre,
                email: usuario.email
            }));

        return usuariosFiltrados;

    } catch (error) {
        console.error('Error en la gestión de usuarios:', error);
        throw error;
    }
}
```

## Casos de Uso Avanzados

### Cancelar Peticiones Fetch
```javascript
async function peticionCancelable() {
    const controller = new AbortController();
    const signal = controller.signal;

    // Cancelar después de 5 segundos
    setTimeout(() => controller.abort(), 5000);

    try {
        const response = await fetch('https://api.ejemplo.com/datos', { signal });
        const datos = await response.json();
        return datos;
    } catch (error) {
        if (error.name === 'AbortError') {
            console.log('Petición cancelada');
        } else {
            console.error('Error:', error);
        }
    }
}
```

### Manejo de Timeouts
```javascript
async function fetchConTimeout(url, timeout = 5000) {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), timeout);

    try {
        const response = await fetch(url, { signal: controller.signal });
        const datos = await response.json();
        clearTimeout(timeoutId);
        return datos;
    } catch (error) {
        clearTimeout(timeoutId);
        if (error.name === 'AbortError') {
            throw new Error('La petición excedió el tiempo límite');
        }
        throw error;
    }
}
```

### Reintentos Automáticos
```javascript
async function fetchConReintentos(url, maxIntentos = 3) {
    for (let intento = 1; intento <= maxIntentos; intento++) {
        try {
            const response = await fetch(url);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return await response.json();
        } catch (error) {
            if (intento === maxIntentos) throw error;
            
            // Espera exponencial entre intentos
            const tiempoEspera = Math.pow(2, intento) * 1000;
            await new Promise(resolve => setTimeout(resolve, tiempoEspera));
            
            console.log(`Reintento ${intento + 1} de ${maxIntentos}...`);
        }
    }
}
```

## Mejores Prácticas

1. **Siempre verificar response.ok**
2. **Usar try/catch para manejar errores**
3. **Implementar timeouts para evitar peticiones infinitas**
4. **Validar tipos de contenido**
5. **Usar AbortController para cancelar peticiones largas**
6. **Implementar reintentos para peticiones importantes**
7. **Mantener un manejo consistente de errores**

## Conclusión
La combinación de async/await con fetch y JSON forma la base de la comunicación moderna en aplicaciones web. Entender cómo funcionan juntos y sus mejores prácticas es esencial para desarrollar aplicaciones robustas y eficientes. 